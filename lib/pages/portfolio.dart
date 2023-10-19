import 'package:as_website/admin/const.dart';
import 'package:as_website/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../widgets/viewer.dart';

class Portfolio extends StatelessWidget {
  const Portfolio(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final count = (MediaQuery.of(context).size.width / 300).floor();
    late List<Photo> photos;

    showViewer(int index) {
      showDialog(
        context: context,
        builder: (context) => Viewer(photos: photos, startIndex: index),
      );
    }

    return FutureBuilder(
      future: mediasService.getPortfolio(name),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Beurk, une erreur !'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        photos = snapshot.data as List<Photo>;
        return MasonryGridView.count(
            crossAxisCount: count,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return PhotoTile(
                photo: photos[index],
                index: index,
                handleTap: showViewer,
              );
            });
      },
    );
  }
}

class PhotoTile extends StatefulWidget {
  const PhotoTile({
    super.key,
    required this.photo,
    required this.index,
    required this.handleTap,
  });

  final Photo photo;
  final int index;
  final Function(int) handleTap;

  @override
  State<PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.handleTap(widget.index),
      child: MouseRegion(
        onEnter: (_) => setState(() {
          isHovering = true;
          _controller.forward();
        }),
        onExit: (_) => setState(() {
          isHovering = false;
          _controller.reverse();
        }),
        child: Stack(alignment: Alignment.center, children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.photo.url,
          ),
          if (isHovering)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.scale(
                    scale: _controller.value,
                    child: SvgPicture.asset(
                      'assets/eye.svg',
                      height: 30,
                      width: 30,
                    ),
                  )),
        ]),
      ),
    );
  }
}
