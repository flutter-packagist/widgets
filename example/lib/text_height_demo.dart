import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: TextHeightDemo()));
}

class TextHeightDemo extends StatefulWidget {
  const TextHeightDemo({super.key});

  @override
  State<TextHeightDemo> createState() => _TextHeightDemoState();
}

class _TextHeightDemoState extends State<TextHeightDemo> {
  final GlobalKey _textKey = GlobalKey();
  double? _widgetHeight;
  double? _painterHeight;

  final String text = "Flutter 获取文本高度示例。"
      "这一段文字会比较长，用来验证 TextPainter 和实际 Text widget 的高度是否一致。";

  @override
  void initState() {
    super.initState();
    // 延迟到下一帧获取 widget 高度
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeights());
  }

  void _updateHeights() {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _widgetHeight = renderBox.size.height;
        _painterHeight = _measureTextHeight(
          context: context,
          text: text,
          maxWidth: 200,
          style: const TextStyle(fontSize: 16, height: 1.5),
          maxLines: null,
          overflow: TextOverflow.clip,
        );
      });
    }
  }

  double _measureTextHeight({
    required BuildContext context,
    required String text,
    required double maxWidth,
    required TextStyle style,
    int? maxLines,
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.clip,
    StrutStyle? strutStyle,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: textAlign,
      textDirection: Directionality.of(context), // 与 Text 保持一致
      maxLines: maxLines,
      ellipsis: overflow == TextOverflow.ellipsis ? '…' : null,
      strutStyle: strutStyle,
      textScaler: MediaQuery.of(context).textScaler, // 同步文字缩放
    );

    textPainter.layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TextPainter vs Widget 高度对比")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左边: TextPainter 算出来的高度
            Container(
              width: 200,
              height: _painterHeight ?? 0,
              color: Colors.blue.withOpacity(0.2),
              child: const Center(child: Text("TextPainter高度")),
            ),
            const SizedBox(width: 20),
            // 右边: 实际 Text 渲染出来的高度
            Container(
              width: 200,
              color: Colors.red.withOpacity(0.2),
              child: Text(
                text,
                key: _textKey,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
