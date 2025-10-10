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
  List tagsRenderList = [];

  @override
  Widget build(BuildContext context) {
    if (widget.tags.isEmpty) return const SizedBox.shrink();
    tagsRenderList = getTagsRenderList();
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
        padding: WidgetStatePropertyAll(widget.itemPadding),
        backgroundColor: WidgetStatePropertyAll(widget.itemColor),
        side: WidgetStatePropertyAll(widget.itemBorderSide),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: widget.itemBorderRadius ?? BorderRadius.zero,
          ),
        ),
        splashFactory: widget.splashFactory,
        tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStatePropertyAll(widget.minimumSize ?? Size.zero),
      ),
      child: Text(
        tagsRenderList[index],
        style: widget.itemStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  List getTagsRenderList() {
    if (widget.maxLines == null) return widget.tags;
    // 布局宽度
    var layoutWidth = MediaQuery.of(context).size.width -
        (widget.margin?.horizontal ?? 0) -
        (widget.padding?.horizontal ?? 0);
    var maxLines = widget.maxLines!; // 最大行数
    var tagsInLine = 0; // 当前行的 tag 数量
    var tagsWidth = 0.0; // 当前行的 tag 宽度
    var tagsRenderList = []; // 渲染的 tag 列表
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
      if (tagsWidth > 0) tagsWidth += widget.spacing;
      tagsWidth += renderParagraph.textSize.width;
      tagsWidth += widget.itemPadding?.horizontal ?? 0;
      tagsInLine++;
      if (tagsWidth > layoutWidth) {
        // 如果当前行只有一个 tag，直接渲染
        if (tagsInLine == 1) {
          tagsRenderList.add(tag);
          ++i;
        }
        // 超出最大行数，结束循环
        if (--maxLines < 1) break;
        tagsWidth = 0.0;
        tagsInLine = 0;
        --i;
        continue;
      }
      tagsRenderList.add(tag);
    }
    return tagsRenderList;
  }
}
