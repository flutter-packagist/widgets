import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';

class TextButtonDemo extends StatefulWidget {
  const TextButtonDemo({super.key});

  @override
  State<TextButtonDemo> createState() => _TextButtonDemoState();
}

class _TextButtonDemoState extends State<TextButtonDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "TextButtonDemo",
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WrapperTextButton(
              onPressed: () {},
              width: 200,
              height: 40,
              text: "編輯",
              textColor: Colors.black,
              textSize: 16,
              radius: 5,
              icon: const Icon(Icons.ac_unit),
              iconPosition: IconPosition.right,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              text: "編輯",
              textColor: Colors.black,
              textSize: 16,
              radius: 5,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              width: 200,
              height: 40,
              backgroundColor: Colors.black,
              text: "發送需求",
              textColor: Colors.white,
              textSize: 16,
              radius: 5,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              width: 200,
              height: 40,
              backgroundColor: Colors.black,
              text: "发送私讯",
              textColor: Colors.white,
              textSize: 16,
              radius: 5,
              icon: const Icon(Icons.ac_unit),
              iconSize: 20,
              iconColor: Colors.white,
              gap: 8,
              enable: false,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              width: 200,
              height: 40,
              backgroundColor: Colors.black,
              text: "发送私讯",
              textColor: Colors.white,
              textSize: 16,
              textAlign: TextAlign.right,
              radius: 5,
              icon: const Icon(Icons.ac_unit),
              iconSize: 20,
              iconColor: Colors.white,
              gap: 8,
              enable: false,
              flexFit: FlexFit.tight,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              backgroundColor: Colors.black,
              text: "导航",
              textColor: Colors.white,
              textSize: 16,
              iconPosition: IconPosition.top,
              icon: const Icon(Icons.ac_unit),
              iconSize: 30,
              iconColor: Colors.white,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              text: "导航",
              textColor: Colors.blue,
              textSize: 16,
              iconPosition: IconPosition.top,
              icon: const Icon(Icons.ac_unit),
              iconSize: 30,
              iconColor: Colors.blue,
              radius: 5,
            ),
            const SizedBox(height: 16),
            WrapperTextButton(
              onPressed: () {},
              backgroundColor: Colors.black,
              text: "导航",
              textColor: Colors.white,
              textSize: 16,
              iconPosition: IconPosition.top,
              icon: const Icon(Icons.ac_unit),
              iconSize: 30,
              iconColor: Colors.white,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
