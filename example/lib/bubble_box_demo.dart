import 'package:flutter/material.dart';
import 'package:widgets/appbar/app_bar.dart';
import 'package:widgets/bubble/bubble_box.dart';

class BubbleBoxDemo extends StatefulWidget {
  const BubbleBoxDemo({super.key});

  @override
  State<BubbleBoxDemo> createState() => _BubbleBoxDemoState();
}

class _BubbleBoxDemoState extends State<BubbleBoxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "BubbleBoxDemo",
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 40),
            child: BubbleBox(
              arrowOffset: 6,
              radius: const Radius.circular(4),
              child: const Text(
                "nice to meet you",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 16),
              child: BubbleBox(
                arrowOffset: 6,
                arrowDirection: ArrowDirection.right,
                radius: const Radius.circular(4),
                child: const Text(
                  "nice to meet you too",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: BubbleBox(
              arrowOffset: 0,
              arrowDirection: ArrowDirection.top,
              arrowAlignment: ArrowAlignment.center,
              arrowSize: 10,
              radius: const Radius.circular(4),
              child: const Text(
                "nice to meet you too",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: BubbleBox(
              arrowOffset: 0,
              arrowDirection: ArrowDirection.bottom,
              arrowAlignment: ArrowAlignment.center,
              arrowSize: 10,
              radius: const Radius.circular(4),
              child: const Text(
                "nice to meet you too",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
