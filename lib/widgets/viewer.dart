import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/photo.dart';

class Viewer extends StatelessWidget {
  const Viewer({super.key, required this.photos, required this.startIndex});

  final List<Photo> photos;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return DesktopViewer(
            photos: photos,
            startIndex: startIndex,
          );
        } else {
          return MobileViewer(
            photos: photos,
            startIndex: startIndex,
          );
        }
      },
    );
  }
}

class DesktopViewer extends StatefulWidget {
  const DesktopViewer(
      {super.key, required this.photos, required this.startIndex});

  final List<Photo> photos;
  final int startIndex;

  @override
  State<DesktopViewer> createState() => _DesktopViewerState();
}

class _DesktopViewerState extends State<DesktopViewer> {
  late PageController _controller;
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
    _controller = PageController(initialPage: index);
    _controller.addListener(() => setState(() {
          index = _controller.page!.round();
        }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final half = MediaQuery.of(context).size.width / 2;

    return Stack(alignment: Alignment.center, children: [
      Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
      ),
      if (index != 0)
        const Positioned(
          left: 10,
          child: Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.black,
          ),
        ),
      const Positioned(
        right: 10,
        child: Icon(
          Icons.chevron_right,
          size: 30,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: PageView.builder(
          controller: _controller,
          itemBuilder: (context, index) => Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                widget.photos[index % widget.photos.length].url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn),
                    child: Container(
                      color: Colors.transparent,
                      width: half,
                      height: double.infinity,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn),
                    child: Container(
                      color: Colors.transparent,
                      width: half,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.close,
            size: 30,
            color: Colors.black,
          ),
        ),
      )
    ]);
  }
}

class MobileViewer extends StatelessWidget {
  const MobileViewer(
      {super.key, required this.photos, required this.startIndex});

  final List<Photo> photos;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          // height: double.infinity,
          viewportFraction: 1,
          initialPage: startIndex,
          enableInfiniteScroll: false,
          scrollDirection: Axis.horizontal,
        ),
        items: photos
            .map(
              (photo) => Image.network(
                photo.url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
