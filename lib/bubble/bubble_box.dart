import 'package:flutter/material.dart';

const double DEFAULT_OFFSET = 4;

/// 气泡视图
class BubbleBox extends StatelessWidget {
  /// 背景颜色
  final Color color;

  /// 气泡圆角
  final Radius radius;

  /// 内部间距
  final EdgeInsetsGeometry? padding;

  /// 三角形显示位置
  final ArrowDirection arrowDirection;

  /// 三角形与内容对齐方式
  final ArrowAlignment arrowAlignment;

  /// 三角形大小
  final double arrowSize;

  /// 三角形偏移量
  final double arrowOffset;

  /// 阴影大小
  final double elevation;

  /// 内容大小装饰器
  final BoxConstraints? constraints;

  /// 内容
  final Widget child;

  BubbleBox({
    Key? key,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.color = Colors.blue,
    this.radius = Radius.zero,
    this.padding,
    this.arrowDirection = ArrowDirection.left,
    this.arrowAlignment = ArrowAlignment.start,
    this.arrowSize = 6,
    this.arrowOffset = 0,
    this.elevation = 0,
    required this.child,
  })  : assert(constraints == null || constraints.debugAssertIsValid()),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        color: color,
        radius: radius,
        arrowDirection: arrowDirection,
        arrowSize: arrowSize,
        arrowOffset: arrowOffset,
        arrowAlignment: arrowAlignment,
        elevation: elevation,
      ),
      child: Padding(
        padding: getChildOffset(),
        child: Container(
          padding: padding ?? EdgeInsets.all(8),
          constraints: constraints,
          child: child,
        ),
      ),
    );
  }

  EdgeInsets getChildOffset() {
    switch (arrowDirection) {
      case ArrowDirection.left:
        return EdgeInsets.only(left: arrowSize);
      case ArrowDirection.right:
        return EdgeInsets.only(right: arrowSize);
      case ArrowDirection.top:
        return EdgeInsets.only(top: arrowSize);
      case ArrowDirection.bottom:
        return EdgeInsets.only(bottom: arrowSize);
    }
  }
}

class BubblePainter extends CustomPainter {
  final Color? color;
  final Radius? radius;
  final ArrowDirection arrowDirection;
  final ArrowAlignment arrowAlignment;
  final double? arrowSize;
  final double? arrowOffset;
  final double? elevation;

  const BubblePainter({
    this.color,
    this.radius,
    this.arrowDirection = ArrowDirection.left,
    this.arrowAlignment = ArrowAlignment.start,
    this.arrowSize,
    this.arrowOffset,
    this.elevation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color!;

    drawBox(canvas, size, paint);
  }

  void drawBox(Canvas canvas, Size size, Paint paint) {
    switch (arrowDirection) {
      case ArrowDirection.left:
        drawLeft(canvas, size, paint);
        break;
      case ArrowDirection.right:
        drawRight(canvas, size, paint);
        break;
      case ArrowDirection.top:
        drawTop(canvas, size, paint);
        break;
      case ArrowDirection.bottom:
        drawBottom(canvas, size, paint);
        break;
    }
  }

  void drawLeft(Canvas canvas, Size size, Paint paint) {
    RRect rect = RRect.fromLTRBR(
        0, 0, size.width - arrowSize! + elevation! / 2, size.height, radius!);
    Path path = Path()..addRRect(rect.shift(Offset(arrowSize!, 0)));
    canvas.drawShadow(path, Colors.grey.shade50, elevation!, true);
    canvas.drawRRect(
      RRect.fromLTRBR(arrowSize!, 0, size.width, size.height, radius!),
      paint,
    );

    double offset = arrowSize! + DEFAULT_OFFSET + arrowOffset!;
    if (arrowAlignment == ArrowAlignment.center) {
      offset = size.height / 2 + arrowOffset!;
    }
    if (arrowAlignment == ArrowAlignment.end) {
      offset = size.height - arrowSize! - DEFAULT_OFFSET - arrowOffset!;
    }

    path = Path()
      ..moveTo(0, offset)
      ..lineTo(arrowSize!, offset - arrowSize! / 3 * 2)
      ..lineTo(arrowSize!, offset + arrowSize! / 3 * 2);
    canvas.drawPath(path, paint);
  }

  void drawRight(Canvas canvas, Size size, Paint paint) {
    RRect rect = RRect.fromLTRBR(
        0, 0, size.width - arrowSize! + elevation! / 2, size.height, radius!);
    Path path = Path()..addRRect(rect.shift(Offset(-elevation! / 2, 0)));
    canvas.drawShadow(path, Colors.grey.shade50, elevation!, true);
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width - arrowSize!, size.height, radius!),
      paint,
    );

    double offset = arrowSize! + DEFAULT_OFFSET + arrowOffset!;
    if (arrowAlignment == ArrowAlignment.center) {
      offset = size.height / 2 + arrowOffset!;
    }
    if (arrowAlignment == ArrowAlignment.end) {
      offset = size.height - arrowSize! - DEFAULT_OFFSET - arrowOffset!;
    }
    path = Path()
      ..moveTo(size.width, offset)
      ..lineTo(size.width - arrowSize!, offset - arrowSize! / 3 * 2)
      ..lineTo(size.width - arrowSize!, offset + arrowSize! / 3 * 2);
    canvas.drawPath(path, paint);
  }

  void drawTop(Canvas canvas, Size size, Paint paint) {
    RRect rect = RRect.fromLTRBR(
        0, arrowSize!, size.width + elevation!, size.height, radius!);
    Path path = Path()..addRRect(rect.shift(Offset(-elevation! / 2, 0)));
    canvas.drawShadow(path, Colors.grey.shade50, elevation!, true);
    canvas.drawRRect(
      RRect.fromLTRBR(0, arrowSize!, size.width, size.height, radius!),
      paint,
    );

    double offset = arrowSize! + DEFAULT_OFFSET + arrowOffset!;
    if (arrowAlignment == ArrowAlignment.center) {
      offset = size.width / 2 + arrowOffset!;
    }
    if (arrowAlignment == ArrowAlignment.end) {
      offset = size.width - arrowSize! - DEFAULT_OFFSET - arrowOffset!;
    }

    path = Path()
      ..moveTo(offset, 0)
      ..lineTo(offset - arrowSize! / 3 * 2, arrowSize!)
      ..lineTo(offset + arrowSize! / 3 * 2, arrowSize!);
    canvas.drawPath(path, paint);
  }

  void drawBottom(Canvas canvas, Size size, Paint paint) {
    RRect rect =
        RRect.fromLTRBR(0, 0, size.width, size.height - arrowSize!, radius!);
    Path path = Path()..addRRect(rect.shift(Offset(elevation! / 2, 0)));
    canvas.drawShadow(path, Colors.grey.shade50, elevation!, true);
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height - arrowSize!, radius!),
      paint,
    );

    double offset = arrowSize! + DEFAULT_OFFSET + arrowOffset!;
    if (arrowAlignment == ArrowAlignment.center) {
      offset = size.width / 2 + arrowOffset!;
    }
    if (arrowAlignment == ArrowAlignment.end) {
      offset = size.width - arrowSize! - DEFAULT_OFFSET - arrowOffset!;
    }

    var dy = size.height - arrowSize!;
    path = Path()
      ..moveTo(offset, size.height)
      ..lineTo(offset - arrowSize! / 3 * 2, dy)
      ..lineTo(offset + arrowSize! / 3 * 2, dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum ArrowDirection { left, right, top, bottom }

enum ArrowAlignment { start, center, end }
