import 'dart:typed_data';

import 'package:as_website/admin/const.dart';
import 'package:as_website/models/photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';

final _db = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class MediasService {
  Stream<List<Photo>> getMediasStream() {
    return _db
        .collection('medias')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Photo.fromJson(doc.id, doc.data()))
            .toList());
  }

  Future<List<Photo>> getAllMedias() {
    return _db
        .collection('medias')
        .orderBy('created_at', descending: true)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map((doc) => Photo.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  Future<List<Photo>> getPortfolio(String name) {
    return _db
        .collection('medias')
        .where(name, isGreaterThanOrEqualTo: 0)
        .orderBy(name)
        .get()
        .then((snapshot) {
          return snapshot.docs
            .map((doc) => Photo.fromJson(doc.id, doc.data()))
            .toList();
    });
  }

  Future<void> updatePortfolio(String name, List<Photo> photos, List<Photo> toDelete) async {
    final batch = _db.batch();
    for (final photo in toDelete) {
      batch.update(_db.collection('medias').doc(photo.id), {name: FieldValue.delete()});
    }
    for (var i = 0; i < photos.length; i++) {
      final photo = photos[i];
      batch.update(_db.collection('medias').doc(photo.id),
          {name: i});
    }
    await batch.commit();
  }

  Future<void> addPhoto(Uint8List fileBytes, String fileName) async {
    final rawImage = decodeJpg(fileBytes);
    if (rawImage != null) {
      final now = DateTime.now();
      final image = copyResize(rawImage, height: 910);
      final name = fileName.split('.').first;
      final storageRef = _storage.ref(
          'photos/${now.year}/${now.month}/$name-${image.width}x${image.height}.jpg');
      await storageRef.putData(encodeJpg(image, quality: 80));
      final url = await storageRef.getDownloadURL();
      await _db
          .collection('medias')
          .doc(uuid.v4())
          .set({'created_at': FieldValue.serverTimestamp(), 'url': url});
    }
  }

  Future<void> deletePhoto(Photo photo) async {
    await _db.collection('medias').doc(photo.id).delete();
    await _storage.refFromURL(photo.url).delete();
  }
}
