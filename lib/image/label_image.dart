import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WrapperLabelImage extends StatefulWidget {
  final String imageUrl;
  final List<LabelItem> labels;
  final TextStyle? textStyle;
  final TextScaler? textScaler;
  final Axis labelDirection;
  final BoxBorder? labelBorder;
  final EdgeInsets? labelPadding;
  final Map<String, String>? httpHeaders;
  final ImageWidgetBuilder? imageBuilder;
  final Widget? defaultPlaceholder;
  final PlaceholderWidgetBuilder? placeholder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Duration? placeholderFadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final bool usePlaceholder;

  const WrapperLabelImage({
    super.key,
    required this.imageUrl,
    required this.labels,
    this.textStyle,
    this.textScaler = TextScaler.noScaling,
    this.labelDirection = Axis.vertical,
    this.labelBorder,
    this.labelPadding,
    this.httpHeaders,
    this.imageBuilder,
    this.defaultPlaceholder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.usePlaceholder = true,
  });

  @override
  State<WrapperLabelImage> createState() => _WrapperLabelImageState();
}

class _WrapperLabelImageState extends State<WrapperLabelImage> {
  Timer? _timer;
  bool _imageTap = false;
  bool _isLoading = true;
  final Map<String, Size> _labelSize = {};
  final Map<String, bool> _labelVisible = {};
  final Map<String, bool> _labelStartToEnd = {};
  final Map<String, Offset> _labelPositions = {};
  final Map<String, double> _labelDotAnimations = {};
  final Map<String, double> _labelAnimations = {};
  final Map<String, bool> _loadingImage = {};
  final Map<String, GlobalKey> _labelKeys = {};
  final TextStyle textStyle =
      const TextStyle(color: Colors.white, fontSize: 14);
  final EdgeInsets labelPadding =
      const EdgeInsets.symmetric(horizontal: 8, vertical: 1);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant WrapperLabelImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl ||
        widget.labels != oldWidget.labels ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _loadImage() {
    _labelSize.clear();
    _labelStartToEnd.clear();
    _labelPositions.clear();
    _labelDotAnimations.clear();
    _labelAnimations.clear();
    final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    ImageStreamListener? listener;
    listener = ImageStreamListener((ImageInfo imageInfo, _) {
      if (listener != null) {
        imageStream.removeListener(listener);
      }
      // Get the real image size
      Size imageSize = Size(
        imageInfo.image.width.toDouble(),
        imageInfo.image.height.toDouble(),
      );
      _isLoading = false;
      if (mounted) setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Get the bound size
        Size boundSize = context.size ?? Size.zero;
        if (widget.fit == BoxFit.contain) {
          double imageAspectRatio = imageSize.width / imageSize.height;
          double boundAspectRatio = boundSize.width / boundSize.height;
          if (imageAspectRatio < boundAspectRatio) {
            imageSize = Size(
              boundSize.height / imageSize.height * imageSize.width,
              boundSize.height,
            );
          } else {
            imageSize = Size(
              boundSize.width,
              boundSize.width / imageSize.width * imageSize.height,
            );
          }
        } else {
          // BoxFit.cover
          // Calculate the image size that showing in the bound
          double imageAspectRatio = imageSize.width / imageSize.height;
          double boundAspectRatio = boundSize.width / boundSize.height;
          // If the image aspect ratio is less than the bound aspect ratio, the image will be scaled to fit the width of the bound
          // Otherwise, the image will be scaled to fit the height of the bound
          if (imageAspectRatio < boundAspectRatio) {
            imageSize = Size(
              boundSize.width,
              boundSize.width / imageSize.width * imageSize.height,
            );
          } else {
            imageSize = Size(
              boundSize.height / imageSize.height * imageSize.width,
              boundSize.height,
            );
          }
        }

        for (final label in widget.labels) {
          double minTop = 0, maxTop = imageSize.height;
          double minLeft = 0, maxLeft = imageSize.width;
          if (widget.height != null) {
            minTop = imageSize.height / 2 - boundSize.height / 2;
            maxTop = minTop + widget.height!;
          }
          if (widget.width != null) {
            minLeft = imageSize.width / 2 - boundSize.width / 2;
            maxLeft = minLeft + imageSize.width;
          }
          double left = imageSize.width * label.percentX;
          double top = imageSize.height * label.percentY;

          _labelVisible[label.name] = false;

          // Calculate the size of the label text
          Size textSize = calculateTextSize(
            label.name,
            widget.textStyle ?? textStyle,
            textScaler: widget.textScaler,
          );
          EdgeInsets padding = widget.labelPadding ?? labelPadding;
          double borderSize = widget.labelBorder?.top.width ?? 1;

          if (widget.labelDirection == Axis.vertical) {
            /// Vertical
            Size labelSize = Size(
              textSize.width + padding.horizontal + borderSize + 3,
              textSize.height + padding.vertical + borderSize + 2,
            );

            if (left - labelSize.width / 2 < minLeft ||
                left + labelSize.width / 2 > maxLeft ||
                top < minTop ||
                top > maxTop) {
              continue; // Skip labels that are out of bounds
            }

            // Adjust the position of the label
            bool topToBottom = true;
            if (top > imageSize.height / 2) {
              topToBottom = false;
            }

            _labelSize[label.name] = labelSize;
            _labelVisible[label.name] = true;
            _labelStartToEnd[label.name] = topToBottom;
            _labelDotAnimations[label.name] = 0;
            _labelAnimations[label.name] = 0;
            _labelPositions[label.name] = Offset(
              left - minLeft - labelSize.width / 2,
              top - minTop - labelSize.height + (topToBottom ? 16 : -10),
            );
          } else {
            /// Horizontal
            Size labelSize = Size(
              textSize.width + padding.horizontal + borderSize + 3,
              textSize.height + padding.vertical + borderSize + 2,
            );

            if (left < minLeft ||
                left > maxLeft ||
                top - labelSize.height / 2 < minTop ||
                top + labelSize.height / 2 > maxTop) {
              continue; // Skip labels that are out of bounds
            }

            // Adjust the position of the label
            bool leftToRight = true;
            if (left > imageSize.width / 2) {
              leftToRight = false;
            }

            _labelSize[label.name] = labelSize;
            _labelVisible[label.name] = true;
            _labelStartToEnd[label.name] = leftToRight;
            _labelDotAnimations[label.name] = 0;
            _labelAnimations[label.name] = 0;
            _labelPositions[label.name] = Offset(
              left - minLeft - (leftToRight ? 9 : labelSize.width - 14),
              top - minTop - labelSize.height / 2,
            );
          }
          _loadingImage[label.name] = true;
        }
        if (mounted) setState(() {});
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _timer = Timer(const Duration(milliseconds: 300), onImageTap);
        });
      });
    });
    imageStream.addListener(listener);
  }

  Widget labelVerticalWidget(LabelItem label, bool topToBottom) {
    Widget dot = AnimatedScale(
      scale: _labelDotAnimations[label.name] ?? 0,
      duration: const Duration(milliseconds: 100),
      onEnd: () {
        if (_imageTap) return;
        if (_labelDotAnimations[label.name] == 1) {
          _labelAnimations[label.name] =
              _labelAnimations[label.name] == 1 ? 0 : 1;
        }
        _labelDotAnimations[label.name] = 1;
        if (mounted) setState(() {});
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            alpha: _labelAnimations[label.name] == 0 ? 0.18 : 0.4,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: _labelAnimations[label.name] == 0 ? 0.42 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );

    Widget line = AnimatedOpacity(
      opacity: _labelAnimations[label.name] ?? 0,
      duration: const Duration(milliseconds: 200),
      child: Transform.translate(
        offset: Offset(0, topToBottom ? -10 : -25),
        child: Container(
          width: 1,
          height: 16,
          color: Colors.white,
        ),
      ),
    );

    Widget text = AnimatedContainer(
      height: (_labelAnimations[label.name] ?? 0) *
          (_labelSize[label.name]?.height ?? 0),
      duration: const Duration(milliseconds: 250),
      child: Transform.translate(
        offset: Offset(0, topToBottom ? -10 : -6),
        child: Container(
          key: _labelKeys[label.name],
          padding: widget.labelPadding ?? labelPadding,
          decoration: BoxDecoration(
            color: _labelAnimations[label.name] == 1
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: widget.labelBorder ?? Border.all(color: Colors.white),
          ),
          child: Text(
            label.name,
            style: widget.textStyle ?? textStyle,
            textScaler: widget.textScaler,
            maxLines: 1,
          ),
        ),
      ),
    );

    Widget placeholder = AnimatedContainer(
      height: (1 - (_labelAnimations[label.name] ?? 1)) *
          (_labelSize[label.name]?.height ?? 0),
      duration: const Duration(milliseconds: 250),
      child: const SizedBox(),
    );

    return GestureDetector(
      onTap: () {
        _labelDotAnimations[label.name] = 0;
        if (mounted) setState(() {});
      },
      child: topToBottom
          ? Column(children: [dot, line, text])
          : Column(children: [placeholder, text, dot, line]),
    );
  }

  Widget labelHorizontalWidget(LabelItem label, bool leftToRight) {
    Widget dot = AnimatedScale(
      scale: _labelDotAnimations[label.name] ?? 0,
      duration: const Duration(milliseconds: 100),
      onEnd: () {
        if (_imageTap) return;
        if (_labelDotAnimations[label.name] == 1) {
          _labelAnimations[label.name] =
              _labelAnimations[label.name] == 1 ? 0 : 1;
        }
        _labelDotAnimations[label.name] = 1;
        if (mounted) setState(() {});
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );

    Widget line = AnimatedOpacity(
      opacity: _labelAnimations[label.name] ?? 0,
      duration: const Duration(milliseconds: 200),
      child: Transform.translate(
        offset: Offset(leftToRight ? -10 : -25, 0),
        child: Container(
          width: 16,
          height: 1,
          color: Colors.white,
        ),
      ),
    );

    Widget text = AnimatedContainer(
      width: (_labelAnimations[label.name] ?? 0) *
          (_labelSize[label.name]?.width ?? 0),
      height: _labelSize[label.name]?.height ?? 0,
      duration: const Duration(milliseconds: 250),
      child: Transform.translate(
        offset: Offset(leftToRight ? -10 : -6, 0),
        child: Container(
          key: _labelKeys[label.name],
          padding: widget.labelPadding ?? labelPadding,
          decoration: BoxDecoration(
            color: _labelAnimations[label.name] == 1
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: widget.labelBorder ?? Border.all(color: Colors.white),
          ),
          child: Text(
            label.name,
            style: widget.textStyle ?? textStyle,
            textScaler: widget.textScaler,
            maxLines: 1,
          ),
        ),
      ),
    );

    Widget placeholder = AnimatedContainer(
      width: (1 - (_labelAnimations[label.name] ?? 1)) *
          (_labelSize[label.name]?.width ?? 0),
      duration: const Duration(milliseconds: 250),
      child: const SizedBox(),
    );

    return GestureDetector(
      onTap: () {
        _labelDotAnimations[label.name] = 0;
        if (mounted) setState(() {});
      },
      child: leftToRight
          ? Row(children: [dot, line, text])
          : Row(children: [placeholder, text, dot, line]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
      );
    }
    List<Widget> labelWidgets = [];
    for (final label in widget.labels) {
      if (_labelVisible[label.name] == false) continue; // Skip invisible labels
      _labelKeys[label.name] = GlobalKey();
      if (widget.labelDirection == Axis.vertical) {
        bool topToBottom = _labelStartToEnd[label.name] ?? true;
        double offsetX = _labelPositions[label.name]?.dx ?? 0;
        double offsetY = _labelPositions[label.name]?.dy ?? 0;
        labelWidgets.add(Positioned(
          left: offsetX,
          top: offsetY,
          child: labelVerticalWidget(label, topToBottom),
        ));
      } else {
        bool leftToRight = _labelStartToEnd[label.name] ?? true;
        double offsetX = _labelPositions[label.name]?.dx ?? 0;
        double offsetY = _labelPositions[label.name]?.dy ?? 0;
        labelWidgets.add(Positioned(
          left: offsetX,
          top: offsetY,
          child: labelHorizontalWidget(label, leftToRight),
        ));
      }
    }
    return GestureDetector(
      onTap: onImageTap,
      child: Stack(children: [
        CachedNetworkImage(
          imageUrl: widget.imageUrl,
          httpHeaders: widget.httpHeaders,
          placeholder: widget.placeholder,
          progressIndicatorBuilder: widget.progressIndicatorBuilder,
          errorWidget: widget.errorWidget,
          fadeOutDuration: widget.fadeOutDuration,
          fadeOutCurve: widget.fadeOutCurve,
          fadeInDuration: widget.fadeInDuration,
          fadeInCurve: widget.fadeInCurve,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          repeat: widget.repeat,
          matchTextDirection: widget.matchTextDirection,
          useOldImageOnUrlChange: widget.useOldImageOnUrlChange,
          color: widget.color,
          filterQuality: widget.filterQuality,
          colorBlendMode: widget.colorBlendMode,
          placeholderFadeInDuration: widget.placeholderFadeInDuration,
          memCacheWidth: widget.memCacheWidth,
          memCacheHeight: widget.memCacheHeight,
          cacheKey: widget.cacheKey,
          maxWidthDiskCache: widget.maxWidthDiskCache,
          maxHeightDiskCache: widget.maxHeightDiskCache,
        ),
        ...labelWidgets,
      ]),
    );
  }

  Size calculateTextSize(
    String text,
    TextStyle textStyle, {
    TextScaler? textScaler,
    double maxWidth = double.infinity,
  }) {
    // 创建文本span
    final TextSpan textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    // 创建TextPainter
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr, // 文本方向
      maxLines: 1, // 最大行数，null表示不限制
      textScaler: textScaler ?? TextScaler.noScaling,
    )..layout(maxWidth: maxWidth); // 进行布局计算

    return textPainter.size;
  }

  void onImageTap() {
    _imageTap = true;
    for (var label in widget.labels) {
      _labelDotAnimations[label.name] = 0;
    }
    if (mounted) setState(() {});
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(milliseconds: 200), () {
        bool allZero = _labelAnimations.values.every((e) => e == 0);
        for (var label in widget.labels) {
          _labelDotAnimations[label.name] = 1;
          _labelAnimations[label.name] = allZero ? 1 : 0;
        }
        if (mounted) setState(() {});
        _timer = Timer(const Duration(milliseconds: 300), () {
          _imageTap = false;
        });
      });
    });
  }
}

class LabelItem {
  final String name;
  final double percentX;
  final double percentY;

  LabelItem({
    required this.name,
    required this.percentX,
    required this.percentY,
  });
}
