import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart';

class Collection extends StatelessWidget {
  const Collection({super.key});

  _addFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        final fileBytes = file.bytes;
        if (fileBytes != null) {
          final rawImage = decodeJpg(fileBytes);
          if (rawImage != null) {
            final image = copyResize(rawImage, height: 910);
            await FirebaseStorage.instance
                .ref(
                    'uploads/${file.name.split('.').first}-${image.width}x${image.height}.jpg')
                .putData(encodeJpg(image, quality: 80));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Medias',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: _addFiles,
                  child: Text(
                    'Ajouter',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
            ],
          ),
        ),
        const Expanded(
          child: Placeholder(),
        ),
      ],
    );
  }
}
