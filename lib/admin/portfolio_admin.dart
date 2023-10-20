import 'dart:ui';
import 'package:collection/collection.dart';

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

class PortfolioAdmin extends StatefulWidget {
  const PortfolioAdmin(this.name, this.handleWorking, {super.key});

  final String name;
  final Function handleWorking;

  @override
  State<PortfolioAdmin> createState() => _PortfolioAdminState();
}

class _PortfolioAdminState extends State<PortfolioAdmin> {
  List<Photo> photos = [];
  Photo? lead;
  List<Photo> medias = [];
  List<Photo> toDelete = [];
  bool _isWorking = false;

  @override
  void initState() {
    super.initState();
    _getPhotos();
  }

  _getPhotos() async {
    photos = await mediasService.getPortfolio(widget.name);
    lead = photos.firstWhereOrNull((e) => e.lead.isNotEmpty);
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
                widget.name,
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
                    mediasService.updatePortfolio(
                        widget.name, photos, toDelete, lead);
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
                      onDoubleTap: () {
                        photos.removeAt(index);
                        if (!toDelete.contains(photo)) {
                          toDelete.add(photo);
                        }
                        setState(() {});
                      },
                      onTap: () {
                        setState(() {
                          lead = photo;
                        });
                      },
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
          Row(
            children: [
              Expanded(
                child: SizedBox(
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
              ),
              Container(
                color: Colors.black,
                height: 150,
                width: 2,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text('COUVERTURE',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Container(
                      height: 140,
                      width: 140,
                      color: Colors.white,
                      child: lead == null
                          ? null
                          : Image.network(
                              lead!.url,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
