import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  final AlignmentGeometry? alignment;
  final int? maxLines;

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
    this.alignment = Alignment.centerLeft,
    this.maxLines,
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
      alignment: widget.alignment,
      child: Wrap(
        spacing: widget.spacing,
        runSpacing: widget.runSpacing,
        children: List.generate(
          tagsRenderList.length,
          (index) {
            if (tagsRenderList.isNotEmpty &&
                tagsRenderList.first is String &&
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
        tagsRenderList[index],
        style: widget.itemStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  List get tagsRenderList {
    if (widget.maxLines == null) return widget.tags;
    var layoutWidth = MediaQuery.of(context).size.width -
        (widget.margin?.horizontal ?? 0) -
        (widget.padding?.horizontal ?? 0);
    var maxLines = widget.maxLines!;
    var tagsWidth = 0.0;
    var tagsRenderList = [];
    for (int i = 0; i < widget.tags.length; i++) {
      var tag = widget.tags[i];
      if (tag is! String) return widget.tags;
      var renderParagraph = RenderParagraph(
        TextSpan(text: tag, style: widget.itemStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
      renderParagraph.layout(BoxConstraints(maxWidth: layoutWidth));
      tagsWidth += renderParagraph.textSize.width;
      tagsWidth += widget.itemPadding?.horizontal ?? 0;
      if (tagsWidth > layoutWidth) {
        if (--maxLines <= 0) break;
        tagsWidth = 0.0;
        --i;
      }
      tagsRenderList.add(tag);
    }
    return tagsRenderList;
  }
}
