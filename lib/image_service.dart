
import 'package:as_website/models/photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _db = FirebaseFirestore.instance;


class MediasService {
  Future<List<Photo>> getLeads() {
    return _db
        .collection('medias')
        .orderBy('lead')
        // .orderBy('created_at', descending: true)
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
}
