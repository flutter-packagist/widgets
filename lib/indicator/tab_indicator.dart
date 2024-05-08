import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnRadiusChanged = BorderRadius Function(double offsetIndex);
typedef OnShaderChanged = Shader? Function(double offsetIndex);

enum IndicatorAlignment { top, center, bottom }

/// 自定义TabBar样式
/// Round Rectangle
class TabIndicator extends Decoration {
  final double height;
  final double width;
  final Color? color;
  final double? relativeOffsetX; // 相对于当前位置的X轴位移，正数向左，负数向右
  final double? relativeOffsetY; // 相对于当前位置的Y轴位移，正数向上，负数向下
  final BorderRadius? borderRadius;
  final IndicatorAlignment? alignment;
  final OnRadiusChanged? onRadiusChanged;
  final OnShaderChanged? onShaderChanged;

  const TabIndicator({
    required this.height,
    required this.width,
    this.color,
    this.relativeOffsetX,
    this.relativeOffsetY,
    this.borderRadius,
    this.alignment,
    this.onRadiusChanged,
    this.onShaderChanged,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
  ) : super(onChanged);

  final TabIndicator decoration;

  Color? get color => decoration.color;

  double get relativeOffsetX => decoration.relativeOffsetX ?? 0;

  double get relativeOffsetY => decoration.relativeOffsetY ?? 0;

  double get width => decoration.width;

  double get height => decoration.height;

  BorderRadius? get borderRadius => decoration.borderRadius;

  IndicatorAlignment? get alignment => decoration.alignment;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = color ?? const Color(0xFF333333);
    paint.style = PaintingStyle.fill;

    double itemWidth = rect.right - rect.left;
    double pWidth = itemWidth > width ? width : itemWidth;
    if (width == 0) pWidth = itemWidth;

    double itemHeight = rect.bottom - rect.top;
    double pHeight = itemHeight > height ? height : itemHeight;
    if (height == 0) pHeight = 2;

    double offsetX = itemWidth / 2 - pWidth / 2;
    double offsetY = getOffsetY(itemHeight, pHeight, rect);

    paint.shader = decoration.onShaderChanged?.call(offset.dx / itemWidth);

    BorderRadius pBorderRadius = borderRadius ?? BorderRadius.circular(5);
    if (decoration.onRadiusChanged != null) {
      pBorderRadius = decoration.onRadiusChanged!(offset.dx / itemWidth);
    }

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          rect.left + offsetX - relativeOffsetX,
          rect.top + offsetY - relativeOffsetY,
          pWidth,
          pHeight,
        ),
        topLeft: pBorderRadius.topLeft,
        topRight: pBorderRadius.topRight,
        bottomLeft: pBorderRadius.bottomLeft,
        bottomRight: pBorderRadius.bottomRight,
      ),
      paint,
    );
  }

  double getOffsetY(double itemHeight, double pHeight, Rect rect) {
    switch (alignment) {
      case IndicatorAlignment.top:
        return rect.top;
      case IndicatorAlignment.center:
        return pHeight < itemHeight
            ? (itemHeight - pHeight) / 2
            : (itemHeight - pHeight);
      case IndicatorAlignment.bottom:
        return itemHeight - pHeight;
      default:
        return itemHeight - pHeight;
    }
  }
}

/// 自定义TabBar样式
/// 图片
class ImageTabIndicator extends Decoration {
  final ui.Image image;
  final double height;
  final double width;
  final IndicatorAlignment? alignment;
  final double? relativeOffsetX; // 相对于当前位置的X轴位移，正数向左，负数向右
  final double? relativeOffsetY; // 相对于当前位置的Y轴位移，正数向上，负数向下

  ImageTabIndicator({
    required this.image,
    required this.height,
    required this.width,
    this.alignment,
    this.relativeOffsetX,
    this.relativeOffsetY,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ImageTabPainter(this, onChanged);
  }
}

class _ImageTabPainter extends BoxPainter {
  _ImageTabPainter(
    this.decoration,
    VoidCallback? onChanged,
  ) : super(onChanged);

  final ImageTabIndicator decoration;

  double get width => decoration.width;

  double get height => decoration.height;

  IndicatorAlignment? get alignment => decoration.alignment;

  double get relativeOffsetX => decoration.relativeOffsetX ?? 0;

  double get relativeOffsetY => decoration.relativeOffsetY ?? 0;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    double itemWidth = rect.right - rect.left;
    double pWidth = itemWidth > width ? width : itemWidth;

    double itemHeight = rect.bottom - rect.top;
    double pHeight = itemHeight > height ? height : itemHeight;

    double offsetX = itemWidth / 2 - pWidth / 2;
    double offsetY = getOffsetY(itemHeight, pHeight, rect);

    canvas.drawImageRect(
      decoration.image,
      Rect.fromLTWH(
        0,
        0,
        decoration.image.width.toDouble(),
        decoration.image.height.toDouble(),
      ),
      Rect.fromLTWH(
        rect.left + offsetX - relativeOffsetX,
        rect.top + offsetY - relativeOffsetY,
        pWidth,
        pHeight,
      ),
      paint,
    );
  }

  double getOffsetY(double itemHeight, double pHeight, Rect rect) {
    switch (alignment) {
      case IndicatorAlignment.top:
        return rect.top;
      case IndicatorAlignment.center:
        return pHeight < itemHeight
            ? (itemHeight - pHeight) / 2
            : (itemHeight - pHeight);
      case IndicatorAlignment.bottom:
        return itemHeight - pHeight;
      default:
        return itemHeight - pHeight;
    }
  }
}
