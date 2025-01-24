import 'package:flutter/rendering.dart';

Size renderSize(
  String text, {
  TextStyle? textStyle, //  文字样式
  TextScaler? textScaler,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: textStyle),
    textDirection: TextDirection.ltr,
    textScaler: textScaler ?? TextScaler.noScaling,
  );
  textPainter.layout();
  return textPainter.size;
}
