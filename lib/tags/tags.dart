import 'package:flutter/material.dart';

typedef TagsItemTap = Function(int index);

class WrapperTags extends StatefulWidget {
  /// 内容数据列表
  final List tags;

  /// 自定义 Tag Item
  final IndexedWidgetBuilder? builder;

  final Color? backgroundColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double spacing;
  final double runSpacing;

  final TextStyle? itemStyle;
  final EdgeInsets? itemPadding;
  final Color? itemColor;
  final BorderSide? itemBorderSide;
  final BorderRadiusGeometry? itemBorderRadius;
  final TagsItemTap? onItemTap;

  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final InteractiveInkFeatureFactory? splashFactory;

  const WrapperTags({
    super.key,
    required this.tags,
    this.builder,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.spacing = 10,
    this.runSpacing = 10,
    this.itemStyle,
    this.itemPadding,
    this.itemColor,
    this.itemBorderSide,
    this.itemBorderRadius,
    this.onItemTap,
    this.minimumSize,
    this.tapTargetSize,
    this.splashFactory,
  });

  @override
  State<WrapperTags> createState() => _WrapperTagsState();
}

class _WrapperTagsState extends State<WrapperTags> {
  @override
  Widget build(BuildContext context) {
    if (widget.tags.isEmpty) return const SizedBox.shrink();
    return Container(
      color: widget.backgroundColor,
      margin: widget.margin,
      padding: widget.padding,
      child: Wrap(
        spacing: widget.spacing,
        runSpacing: widget.runSpacing,
        children: List.generate(
          widget.tags.length,
          (index) {
            if (widget.tags.isNotEmpty &&
                widget.tags.first is String &&
                widget.builder == null) {
              return _defaultBuilder(context, index);
            }
            if (widget.builder == null) {
              throw Exception(
                  'builder should be provided when tags is not String');
            }
            return widget.builder!(context, index);
          },
        ),
      ),
    );
  }

  Widget _defaultBuilder(BuildContext context, int index) {
    return TextButton(
      onPressed: () => widget.onItemTap?.call(index),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(widget.itemPadding),
        backgroundColor: MaterialStateProperty.all(widget.itemColor),
        side: MaterialStateProperty.all(widget.itemBorderSide),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: widget.itemBorderRadius ?? BorderRadius.zero,
          ),
        ),
        splashFactory: widget.splashFactory,
        tapTargetSize: widget.tapTargetSize,
        minimumSize: MaterialStateProperty.all(widget.minimumSize ?? Size.zero),
      ),
      child: Text(
        widget.tags[index],
        style: widget.itemStyle,
      ),
    );
  }
}
