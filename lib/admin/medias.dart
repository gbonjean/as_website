import 'package:as_website/admin/const.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Medias extends StatelessWidget {
  const Medias({super.key});

  _addFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if (result != null && result.files.isNotEmpty) {
      for (final file in result.files) {
        if (file.bytes != null) {
          imageService.addPhoto(file.bytes!, file.name);
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
        const Expanded(child: Collection()),
      ],
    );
  }
}

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: imageService.photos,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        }
        final photos = snapshot.data!;
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Image.network(
                photo.url,
                fit: BoxFit.cover,
              );
            });
      }),
    );
  }
}
