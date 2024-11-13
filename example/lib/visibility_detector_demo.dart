import 'package:flutter/material.dart';
import 'package:packagist_widgets/detector/visibility_detector.dart';

class VisibilityDetectorDemo extends StatefulWidget {
  const VisibilityDetectorDemo({super.key});

  @override
  State<VisibilityDetectorDemo> createState() => _VisibilityDetectorDemoState();
}

class _VisibilityDetectorDemoState extends State<VisibilityDetectorDemo> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return VisibilityDetector(
            key: Key('item_$index'),
            child: ListTile(
              title: Text('Item $index'),
            ),
            onVisibilityChanged: (info) {
              print('Item $index is ${info.visibleFraction * 100}% visible');
            },
          );
        },
      ),
    );
  }
}
