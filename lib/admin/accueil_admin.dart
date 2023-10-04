import 'dart:ui';

import 'package:as_website/admin/const.dart';
import 'package:as_website/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
      };
}

class AccueilAdmin extends StatefulWidget {
  const AccueilAdmin(this.handleWorking, {super.key});

  final Function handleWorking;

  @override
  State<AccueilAdmin> createState() => _AccueilAdminState();
}

class _AccueilAdminState extends State<AccueilAdmin> {
  List<Photo> photos = [];
  List<Photo> medias = [];
  List<Photo> toDelete = [];
  bool _isWorking = false;

  @override
  void initState() {
    super.initState();
    _getPhotos();
  }

  _getPhotos() async {
    photos = await mediasService.getPortfolio('accueil');
    setState(() {});
    medias = await mediasService.getAllMedias();
  }

  bool _notThere(Photo photo) {
    for (final p in photos) {
      if (p.id == photo.id) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                'Accueil',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: _isWorking ? Colors.blue : Colors.black,
                  ),
                  
                ),
                onPressed: () {
                  widget.handleWorking();
                  setState(() {
                    _isWorking = !_isWorking;
                  });
                  if (!_isWorking) {
                    mediasService.updatePortfolio('accueil', photos, toDelete);
                  }
                },
                child: Text(
                  _isWorking ? 'Terminé' : 'Modifier',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        _isWorking
            ? Expanded(
                child: ReorderableGridView.builder(
                  padding: const EdgeInsets.all(12),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final element = photos.removeAt(oldIndex);
                      photos.insert(newIndex, element);
                    });
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: photos.length,
                  itemBuilder: ((context, index) {
                    final photo = photos[index];
                    return GestureDetector(
                      key: ValueKey(index),
                      onDoubleTap: _isWorking
                          ? () {
                              photos.removeAt(index);
                              if (!toDelete.contains(photo)) {
                                toDelete.add(photo);
                              }
                              setState(() {});
                            }
                          : null,
                      child: Image.network(
                        width: 150,
                        height: 150,
                        photo.url,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              )
            : Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: photos.length,
                itemBuilder: ((context, index) {
                  final photo = photos[index];
                  return Image.network(
                    width: 150,
                    height: 150,
                    photo.url,
                    fit: BoxFit.cover,
                  );
                }),
              )),
        if (_isWorking) const Divider(thickness: 2, color: Colors.black),
        if (_isWorking)
          SizedBox(
            height: 150,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                  itemCount: medias.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    final photo = medias[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (_notThere(photo)) {
                            photos.add(photo);
                            setState(() {});
                          }
                        },
                        child: Image.network(
                          photo.url,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  })),
            ),
          ),
      ],
    );
  }
}
