import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          return const MobileViewer();
        }
      },
    );
  }
}

class DesktopViewer extends StatelessWidget {
  const DesktopViewer(
      {super.key, required this.photos, required this.startIndex});

  final List<Photo> photos;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    List<Widget> photoSlider = photos
        .map(
          (photo) => Image.network(photo.url, fit: BoxFit.cover),
        )
        .toList();
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              initialPage: startIndex,
              viewportFraction: 0.8,
              // enlargeCenterPage: false,
              height: double.infinity,
              // onPageChanged: (index, reason) {
              //   setState(() {
              //     index = index;
              //   });
              // },
            ),
            items: photoSlider,
          ),
        ),
        Container(
          color: Colors.red,
          height: 80,
        )
      ],
    );
  }
}

class MobileViewer extends StatelessWidget {
  const MobileViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
