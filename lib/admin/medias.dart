import 'package:as_website/admin/const.dart';
import 'package:as_website/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class Medias extends StatefulWidget {
  const Medias({super.key});

  @override
  State<Medias> createState() => _MediasState();
}

class _MediasState extends State<Medias> {
  bool _isUploading = false;

  _addFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _isUploading = true);
      for (final file in result.files) {
        if (file.bytes != null) {
          await imageService.addPhoto(file.bytes!, file.name);
        }
      }
      setState(() => _isUploading = false);
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
              _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : ElevatedButton(
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
  bool _showViewer = false;
  int _viewerIndex = 0;

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
        return Stack(
          alignment: Alignment.center,
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                      _showViewer = true;
                      _viewerIndex = index;
                    }),
                    child: Image.network(
                      photo.url,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
            if (_showViewer)
              GestureDetector(
                onTap: () => setState(() => _showViewer = false),
                child: Viewer(photos, _viewerIndex),
              )
          ],
        );
      }),
    );
  }
}

class Viewer extends StatefulWidget {
  const Viewer(this.photos, this.startIndex, {super.key});

  final List<Photo> photos;
  final int startIndex;

  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          setState(() {
            index = index == 0 ? index : index - 1;
          });
        } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          setState(() {
            index = index == widget.photos.length - 1
                ? widget.photos.length - 1
                : index + 1;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              widthFactor: 0.9,
              child: Image.network(
                widget.photos[index].url,
              ),
            ),
          )
        ],
      ),
    );
  }
}
