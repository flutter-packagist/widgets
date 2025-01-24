import 'package:flutter/material.dart';

class TextHeightDemo extends StatelessWidget {
  const TextHeightDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Height Demo'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello, World',
              style: TextStyle(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '12345678990',
              style: TextStyle(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '!!!!!!!!!!',
              style: TextStyle(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '你好',
              style: TextStyle(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hello,!!!!!!!!!!你好1234590',
              style: TextStyle(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hello,!!!!!!!!!!你好1234590',
              style: TextStyle(
                backgroundColor: Colors.red,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
