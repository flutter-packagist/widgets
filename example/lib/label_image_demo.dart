import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';

class LabelImageDemo extends StatefulWidget {
  const LabelImageDemo({super.key});

  @override
  State<LabelImageDemo> createState() => _LabelImageDemoState();
}

class _LabelImageDemoState extends State<LabelImageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "网络图片附加标签",
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          WrapperLabelImage(
            imageUrl:
                "https://cp4.100.com.tw/images/works/202505/16/api_2012032_1747362772_TBECTIDzJt.jpg!10309t1500-v2.jpg",
            labels: [
              LabelItem(name: "吊頂燈帶", percentX: 0.3, percentY: 0.3),
              LabelItem(name: "電視墻", percentX: 0.4, percentY: 0.5),
              LabelItem(name: "沙發", percentX: 0.7, percentY: 0.7),
            ],
          ),
          const SizedBox(height: 20),
          WrapperLabelImage(
            width: 300,
            imageUrl:
                "https://cp4.100.com.tw/images/works/202505/16/api_2012032_1747362772_TBECTIDzJt.jpg!10309t1500-v2.jpg",
            labels: [
              LabelItem(name: "吊頂燈帶", percentX: 0.3, percentY: 0.3),
              LabelItem(name: "電視墻", percentX: 0.4, percentY: 0.5),
              LabelItem(name: "沙發", percentX: 0.7, percentY: 0.7),
            ],
          ),
          const SizedBox(height: 20),
          WrapperLabelImage(
            width: 300,
            height: 300,
            imageUrl:
                "https://cp4.100.com.tw/images/works/202505/16/api_2012032_1747362772_TBECTIDzJt.jpg!10309t1500-v2.jpg",
            labels: [
              LabelItem(name: "吊頂燈帶", percentX: 0.3, percentY: 0.3),
              LabelItem(name: "電視墻", percentX: 0.4, percentY: 0.5),
              LabelItem(name: "沙發", percentX: 0.7, percentY: 0.7),
            ],
          ),
          const SizedBox(height: 20),
          WrapperLabelImage(
            imageUrl:
                "https://cp4.100.com.tw/images/works/202301/03/api_2114251_1672736564_sk5rc5Iy49.jpg!t1000.webp",
            labels: [
              LabelItem(name: "壁櫃", percentX: 0.53, percentY: 0.47),
              LabelItem(name: "冰箱", percentX: 0.69, percentY: 0.6),
              LabelItem(name: "燃氣灶", percentX: 0.2, percentY: 0.8),
            ],
          ),
          const SizedBox(height: 20),
          WrapperLabelImage(
            width: 200,
            imageUrl:
                "https://cp4.100.com.tw/images/works/202301/03/api_2114251_1672736564_sk5rc5Iy49.jpg!t1000.webp",
            labels: [
              LabelItem(name: "壁櫃", percentX: 0.53, percentY: 0.47),
              LabelItem(name: "冰箱", percentX: 0.69, percentY: 0.6),
              LabelItem(name: "燃氣灶", percentX: 0.2, percentY: 0.8),
            ],
          ),
          const SizedBox(height: 20),
          WrapperLabelImage(
            width: 200,
            height: 200,
            imageUrl:
                "https://cp4.100.com.tw/images/works/202301/03/api_2114251_1672736564_sk5rc5Iy49.jpg!t1000.webp",
            labels: [
              LabelItem(name: "壁櫃", percentX: 0.53, percentY: 0.47),
              LabelItem(name: "冰箱", percentX: 0.69, percentY: 0.6),
              LabelItem(name: "燃氣灶", percentX: 0.2, percentY: 0.8),
            ],
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
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

class WrapperLabelImage extends StatefulWidget {
  final String imageUrl;
  final List<LabelItem> labels;
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
  bool _imageTap = false;
  bool _isLoading = true;
  final Map<String, Size> _labelWidths = {};
  final Map<String, bool> _labelVisible = {};
  final Map<String, bool> _labelLeftToRight = {};
  final Map<String, Offset> _labelPositions = {};
  final Map<String, double> _labelDotAnimations = {};
  final Map<String, double> _labelAnimations = {};
  final Map<String, bool> _loadingImage = {};

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

  void _loadImage() {
    _labelWidths.clear();
    _labelLeftToRight.clear();
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
      Size imageSize = Size(
        imageInfo.image.width.toDouble(),
        imageInfo.image.height.toDouble(),
      );
      _isLoading = false;
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Size boundSize = context.size ?? Size.zero;
        if (widget.fit == BoxFit.cover) {
          double imageAspectRatio = imageSize.width / imageSize.height;
          double boundAspectRatio = boundSize.width / boundSize.height;
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
              label.name, const TextStyle(color: Colors.white, fontSize: 14));
          Size labelSize = Size(textSize.width + 44, textSize.height + 6);

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

          _labelWidths[label.name] = Size(
            textSize.width + 20,
            textSize.height + 4,
          );
          _labelVisible[label.name] = true;
          _labelLeftToRight[label.name] = leftToRight;
          _labelDotAnimations[label.name] = 0;
          _labelAnimations[label.name] = 0;
          _labelPositions[label.name] = Offset(
            left - minLeft - (leftToRight ? 10 : labelSize.width - 14),
            top - minTop - labelSize.height / 2,
          );
          _loadingImage[label.name] = true;
        }
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), onImageTap);
        });
      });
    });
    imageStream.addListener(listener);
  }

  Widget labelWidget(LabelItem label, bool leftToRight) {
    Widget dot = AnimatedScale(
      scale: _labelDotAnimations[label.name] ?? 0,
      duration: const Duration(milliseconds: 200),
      onEnd: () {
        if (_imageTap) return;
        if (_labelDotAnimations[label.name] == 1) {
          _labelAnimations[label.name] =
              _labelAnimations[label.name] == 1 ? 0 : 1;
        }
        _labelDotAnimations[label.name] = 1;
        setState(() {});
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(6),
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
        offset: Offset(leftToRight ? -10 : -26, 0),
        child: Container(
          width: 16,
          height: 1,
          color: Colors.white,
        ),
      ),
    );

    Widget text = AnimatedContainer(
      width: (_labelAnimations[label.name] ?? 0) *
          (_labelWidths[label.name]?.width ?? 0),
      duration: const Duration(milliseconds: 250),
      child: Transform.translate(
        offset: Offset(leftToRight ? -10 : -6, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _labelAnimations[label.name] == 1
                ? Colors.black38
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Text(
            label.name,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
          ),
        ),
      ),
    );

    Widget placeholder = AnimatedContainer(
      width: (1 - (_labelAnimations[label.name] ?? 1)) *
          (_labelWidths[label.name]?.width ?? 0),
      duration: const Duration(milliseconds: 250),
      child: const SizedBox(),
    );

    return GestureDetector(
      onTap: () {
        _labelDotAnimations[label.name] = 0;
        setState(() {});
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
      bool leftToRight = _labelLeftToRight[label.name] ?? true;
      double offsetX = _labelPositions[label.name]?.dx ?? 0;
      double offsetY = _labelPositions[label.name]?.dy ?? 0;
      labelWidgets.add(Positioned(
        left: offsetX,
        top: offsetY,
        child: labelWidget(label, leftToRight),
      ));
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
    )..layout(maxWidth: maxWidth); // 进行布局计算

    // 获取计算结果
    final double textWidth = textPainter.size.width;
    final double textHeight = textPainter.size.height;

    return Size(textWidth, textHeight);
  }

  void onImageTap() {
    _imageTap = true;
    bool allZero = _labelDotAnimations.values.every((e) => e == 0);
    for (var label in widget.labels) {
      _labelDotAnimations[label.name] = allZero ? 1 : 0;
      _labelAnimations[label.name] = allZero ? 1 : 0;
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 300), () {
      _imageTap = false;
    });
  }
}
