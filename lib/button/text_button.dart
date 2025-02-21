import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../extension/render_ext.dart';
import '../extension/string_ext.dart';

enum IconPosition { left, right, top, bottom }

class WrapperTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final WidgetStatesController? statesController;
  final bool? isSemanticButton;
  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final Color textColor;
  final double textSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? overlayColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final double radius;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color? borderColor;
  final double? borderWidth;
  final BorderStyle? borderStyle;
  final double? elevation;
  final IconPosition? iconPosition;
  final Widget? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? gap;
  final double? width;
  final double? height;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final bool enable;
  final FlexFit flexFit;
  final bool shrinkWrap;

  const WrapperTextButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.isSemanticButton,
    this.child,
    this.text,
    this.textStyle,
    this.textColor = Colors.black,
    this.textSize = 14,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor = Colors.transparent,
    this.shadowColor,
    this.surfaceTintColor,
    this.alignment,
    this.padding,
    this.shape,
    this.radius = 0,
    this.borderRadius,
    this.borderSide,
    this.borderColor = Colors.transparent,
    this.borderWidth,
    this.borderStyle,
    this.elevation,
    this.iconPosition = IconPosition.left,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.gap = 4,
    this.width,
    this.height,
    this.minimumSize,
    this.tapTargetSize,
    this.enable = true,
    this.flexFit = FlexFit.loose,
    this.shrinkWrap = false,
  }) : assert(child != null || text != null);

  @override
  Widget build(BuildContext context) {
    String text = this.text ?? "";
    TextStyle textStyle = this.textStyle ??
        TextStyle(
          color: textColor.enable(enable),
          fontSize: textSize,
        );
    Widget child = Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );

    // 解决Android与iOS平台下字体对齐问题
    // https://docs.google.com/spreadsheets/d/1864hy_1r4vxf1I864gIlj8m3tgZeijG-BwhghSm5OJQ/edit?gid=0#gid=0
    bool shrinkWrap = this.shrinkWrap;
    Size size = renderSize(
      text,
      textStyle: textStyle,
      textScaler: MediaQuery.of(context).textScaler,
    );
    if (Platform.isAndroid) {
      Offset? offset;
      double textHeight = size.height;
      // 如果是英文或数字，增加高度（由于计算出来的高度比实际高度小）
      if (text.isEnglishOrDigits) {
        textHeight += 4;
      }
      TextScaler textScaler = MediaQuery.of(context).textScaler;
      String scaleText = textScaler.toString();
      double scaleFactor = scaleText.getScaleFactor;
      EdgeInsetsGeometry padding = scaledPadding(context);
      // 如果文本高度大于按钮设定的高度，向上偏移文本
      if (height != null && textHeight > height!) {
        shrinkWrap = true;
        offset = Offset(0, (height! - textHeight) * 0.8);
      } else if (height != null && textHeight > height! - padding.vertical) {
        shrinkWrap = true;
        if (!text.isChinese) {
          offset = Offset(0, (0.4 * log(pow(scaleFactor, 2) * 12)));
          if (text.isContainChinese) {
            offset = Offset(0, (0.1 * log(pow(scaleFactor, 2) * 10)));
          }
        } else {
          offset = Offset(0, -(0.1 * log(pow(scaleFactor, 2) * 10)));
        }
      } else if (text.isContainChinese) {
        // 如果是中文，向下偏移文本（随着字体大小的增加，增速变快）
        offset = Offset(0, -(0.1 + 0.2 * pow(scaleFactor, 5)));
        if (text.isChinese) {
          offset = offset.translate(0, -(0.7 * log(pow(scaleFactor, 2) * 4)));
        }
      } else if (text.isEnglishOrDigits) {
        // 如果是中文，向上偏移文本（随着字体大小的增加，增速变慢）
        offset = Offset(0, (0.1 * log(pow(scaleFactor, 2) * 12)));
      }
      if (offset != null) {
        child = Transform.translate(offset: offset, child: child);
      }
    } else if (Platform.isIOS) {
      if (height != null && size.height > height!) {
        double percent = 0.1;
        if (text.isEnglishOrDigits) percent = 0.3;
        child = Transform.translate(
          offset: Offset(0, (height! - size.height) * percent),
          child: SizedBox(
            width: size.width + 6,
            child: OverflowBox(
              maxHeight: size.height,
              child: child,
            ),
          ),
        );
      }
    }
    if (this.child != null) {
      child = this.child!;
    }

    // 设置图标及位置
    if (icon != null) {
      if (iconPosition == IconPosition.left) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon!,
            SizedBox(width: gap),
            Flexible(child: child, fit: flexFit),
          ],
        );
      } else if (iconPosition == IconPosition.right) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: child, fit: flexFit),
            SizedBox(width: gap),
            icon!
          ],
        );
      } else if (iconPosition == IconPosition.top) {
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon!,
            SizedBox(height: gap),
            Flexible(child: child, fit: flexFit),
          ],
        );
      } else if (iconPosition == IconPosition.bottom) {
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: child, fit: flexFit),
            SizedBox(height: gap),
            icon!
          ],
        );
      }
    }

    Size? minimumSize = this.minimumSize;
    EdgeInsetsGeometry? padding = this.padding;
    MaterialTapTargetSize? tapTargetSize = this.tapTargetSize;
    if (shrinkWrap) {
      if (padding == null) padding = EdgeInsets.zero;
      minimumSize = Size.zero;
      tapTargetSize = MaterialTapTargetSize.shrinkWrap;
    }
    child = TextButton(
      onPressed: () {
        if (enable) onPressed.call();
      },
      onLongPress: () {
        if (enable) onLongPress?.call();
      },
      onHover: onHover,
      onFocusChange: onFocusChange,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      statesController: statesController,
      isSemanticButton: isSemanticButton,
      style: style ??
          ButtonStyle(
            backgroundColor: resolve<Color?>(backgroundColor?.enable(enable)),
            foregroundColor: resolve<Color?>(foregroundColor?.enable(enable)),
            overlayColor: resolve<Color?>(overlayColor),
            shadowColor: resolve<Color?>(shadowColor),
            surfaceTintColor: resolve<Color?>(surfaceTintColor),
            shape: resolve<OutlinedBorder?>(shape ??
                RoundedRectangleBorder(
                  borderRadius:
                      borderRadius ?? BorderRadius.all(Radius.circular(radius)),
                  side: borderSide ??
                      BorderSide(
                        color: borderColor ?? const Color(0xFF000000),
                        width: borderWidth ?? 1,
                        style: borderStyle ?? BorderStyle.solid,
                      ),
                )),
            side: resolve<BorderSide?>(borderSide ??
                BorderSide(
                  color: borderColor ?? const Color(0xFF000000),
                  width: borderWidth ?? 1,
                  style: borderStyle ?? BorderStyle.solid,
                )),
            padding: resolve<EdgeInsetsGeometry?>(padding),
            elevation: resolve<double?>(elevation),
            iconColor: resolve<Color?>(iconColor?.enable(enable)),
            iconSize: resolve<double?>(iconSize),
            alignment: alignment,
            minimumSize: resolve<Size?>(minimumSize),
            tapTargetSize: tapTargetSize,
          ),
      child: child,
    );
    if (width != null || height != null) {
      child = SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }
    return child;
  }

  WidgetStateProperty<T>? resolve<T>(T value) {
    return value == null ? null : WidgetStateProperty.all<T>(value);
  }

  EdgeInsetsGeometry scaledPadding(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double defaultFontSize = theme.textTheme.labelLarge?.fontSize ?? 14.0;
    final double effectiveTextScale =
        MediaQuery.textScalerOf(context).scale(defaultFontSize) / 14.0;
    return ButtonStyleButton.scaledPadding(
      theme.useMaterial3
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
          : const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsets.symmetric(horizontal: 4),
      effectiveTextScale,
    );
  }
}

extension ColorExtension on Color? {
  Color? enable(bool enable) {
    if (this == Colors.transparent) return this;
    return enable ? this : this?.withOpacity(0.5);
  }
}
