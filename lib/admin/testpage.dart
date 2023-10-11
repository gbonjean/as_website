import 'package:flutter/material.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MouseRegion(
          onEnter: (value) => setState(() => isHovering = true),
          onExit: (event) => setState(() => isHovering = false),
          // onHover: (value) => setState(() => isHovering = !isHovering),
          child: Container(
            height: 100,
            width: 100,
            color: isHovering ? Colors.green : Colors.red,
          ),
        ),),
    );
  }
}
