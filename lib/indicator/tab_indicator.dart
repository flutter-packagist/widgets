import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnRadiusChanged = BorderRadius Function(double offsetIndex);

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

  const TabIndicator({
    required this.height,
    required this.width,
    this.color,
    this.relativeOffsetX,
    this.relativeOffsetY,
    this.borderRadius,
    this.alignment,
    this.onRadiusChanged,
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
