import 'package:as_website/admin/const.dart';
import 'package:as_website/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/admin_viewer.dart';

class MediasAdmin extends StatefulWidget {
  const MediasAdmin({super.key});

  @override
  State<MediasAdmin> createState() => _MediasAdminState();
}

class _MediasAdminState extends State<MediasAdmin> {
  Stream<List<Photo>> mediasStream = mediasService.getMediasStream();
  List<Photo> photos = [];
  bool _isDeleting = false;
  bool _showViewer = false;
  int _viewerIndex = 0;

  _addFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _isDeleting = false;
      });
      for (final file in result.files) {
        if (file.bytes != null) {
          mediasService.addPhoto(file.bytes!, file.name);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () => setState(() => _isDeleting = !_isDeleting),
                    icon: Icon(
                      _isDeleting ? Icons.delete_outline : Icons.collections,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: StreamBuilder(
                  stream: mediasStream,
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
                    photos = snapshot.data!;
                    return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (_isDeleting) {
                                mediasService.deletePhoto(photo);
                              } else {
                                _showViewer = true;
                                _viewerIndex = index;
                              }
                            }),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  width: 150,
                                  height: 150,
                                  photo.url,
                                  fit: BoxFit.cover,
                                ),
                                if (_isDeleting)
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  )
                              ],
                            ),
                          );
                        });
                  }),
                ),
              ),
            ),
          ],
        ),
        if (_showViewer)
          GestureDetector(
            onTap: () => setState(() => _showViewer = false),
            child: AdminViewer(photos, _viewerIndex),
          )
      ],
    );
  }
}
