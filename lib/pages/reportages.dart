import 'package:as_website/admin/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/photo.dart';

class Reportages extends StatelessWidget {
  const Reportages({super.key, required this.handlePageChange});

  final Function(String) handlePageChange;

  @override
  Widget build(BuildContext context) {
    final count = (MediaQuery.of(context).size.width / 300).floor();
    late List<Photo> photos;

    return FutureBuilder(
        future: mediasService.getLeads(),
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
                return PortfolioTile(
                  photo: photos[index],
                  handlePageChange: handlePageChange,
                );
              });
          // return GridView.builder(
          //     padding: const EdgeInsets.all(16),
          //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //       maxCrossAxisExtent: 300,
          //       childAspectRatio: 1.5,
          //       // mainAxisSpacing: 10,
          //       // crossAxisSpacing: 10,
          //     ),
          //     itemCount: photos.length,
          //     itemBuilder: (context, index) => PortfolioTile(
          //           photo: photos[index],
          //           handlePageChange: handlePageChange,
          //         ));
        });
  }
}

class PortfolioTile extends StatefulWidget {
  const PortfolioTile(
      {super.key, required this.photo, required this.handlePageChange});

  final Photo photo;
  final Function(String) handlePageChange;

  @override
  State<PortfolioTile> createState() => _PortfolioTileState();
}

class _PortfolioTileState extends State<PortfolioTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.handlePageChange(widget.photo.lead!);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() {
          isHovering = true;
        }),
        onExit: (_) => setState(() {
          isHovering = false;
        }),
        child: Stack(alignment: Alignment.center, children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.photo.url,
          ),
          if (isHovering)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.7),
                child: Text(widget.photo.lead!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
        ]),
      ),
    );
  }
}
