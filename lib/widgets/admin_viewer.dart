import 'package:as_website/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminViewer extends StatefulWidget {
  const AdminViewer(this.photos, this.startIndex, {super.key});

  final List<Photo> photos;
  final int startIndex;

  @override
  State<AdminViewer> createState() => _AdminViewerState();
}

class _AdminViewerState extends State<AdminViewer> {
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
