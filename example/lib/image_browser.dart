import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

typedef DoubleClickAnimationListener = void Function();

class ImageBrowser extends StatefulWidget {
  final ExtendedPageController? controller;
  final int index;
  final List<ImageBlock> images;
  final ValueChanged<int>? onPageChanged;
  final bool enableSlideOutPage;
  final String? heroTag;

  const ImageBrowser({
    super.key,
    this.controller,
    this.index = 0,
    required this.images,
    this.onPageChanged,
    this.enableSlideOutPage = true,
    this.heroTag,
  });

  @override
  State<ImageBrowser> createState() => _ImageBrowserState();
}

class _ImageBrowserState extends State<ImageBrowser>
    with TickerProviderStateMixin {
  final GlobalKey<ExtendedImageSlidePageState> slidePageKey =
      GlobalKey<ExtendedImageSlidePageState>();
  Animation<double>? bgAnimation;
  AnimationController? bgAnimationController;
  double bgOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    bgAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(bgAnimationController!)
          ..addListener(() {
            bgOpacity = bgAnimation!.value;
            setState(() {});
          });
    bgAnimationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return imageSlidePage;
  }

  Widget get imageSlidePage {
    return ExtendedImageSlidePage(
      key: slidePageKey,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: bgOpacity),
        child: imagePageView,
      ),
      slidePageBackgroundHandler: (Offset offset, Size size) {
        return Colors.transparent;
      },
      slideOffsetHandler: (
        Offset offset, {
        ExtendedImageSlidePageState? state,
      }) {
        if (offset.dy.abs() < offset.dx.abs() * 1.5) return Offset.zero;
        double height = MediaQuery.of(context).size.height;
        bgOpacity = (height - offset.dy.abs()) / height;
        if (bgOpacity > 1) bgOpacity = 1;
        if (bgOpacity < 0) bgOpacity = 0;
        setState(() {});
        return null;
      },
      slideEndHandler: (
        Offset offset, {
        ScaleEndDetails? details,
        ExtendedImageSlidePageState? state,
      }) {
        bgOpacity = 1;
        setState(() {});
        return null;
      },
    );
  }

  Widget get imagePageView {
    return ExtendedImageGesturePageView.builder(
      controller: widget.controller ??
          ExtendedPageController(initialPage: widget.index),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: widget.images.length,
      itemBuilder: (BuildContext context, int index) {
        Widget child = imageItem(index);
        return child;
      },
      onPageChanged: widget.onPageChanged,
    );
  }

  Widget imageItem(int index) {
    return WrapperLabelImage(
      imageUrl: widget.images[index].image,
      labels: widget.images[index].labels,
      fit: BoxFit.contain,
      slidePageKey: slidePageKey,
      enableSlideOutPage: true,
    );
  }

  @override
  void dispose() {
    bgAnimationController?.dispose();
    super.dispose();
  }
}

class WrapperLabelImage extends StatefulWidget {
  final String imageUrl;
  final List<LabelItem> labels;
  final TextStyle? textStyle;
  final TextScaler? textScaler;
  final Axis labelDirection;
  final BoxBorder? labelBorder;
  final EdgeInsets? labelPadding;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool enableSlideOutPage;
  final String? heroTag;
  final GlobalKey<ExtendedImageSlidePageState> slidePageKey;

  const WrapperLabelImage({
    super.key,
    required this.imageUrl,
    required this.labels,
    required this.slidePageKey,
    this.textStyle,
    this.textScaler = TextScaler.noScaling,
    this.labelDirection = Axis.vertical,
    this.labelBorder,
    this.labelPadding,
    this.width,
    this.height,
    this.fit,
    this.enableSlideOutPage = false,
    this.heroTag,
  });

  @override
  State<WrapperLabelImage> createState() => _WrapperLabelImageState();
}

class _WrapperLabelImageState extends State<WrapperLabelImage>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool _imageTap = false;
  bool _isLoading = true;
  Size _imageSize = Size.zero;
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

  final List<double> doubleClickScales = <double>[1.0, 2.0, 3.0];
  Animation<double>? doubleClickAnimation;
  AnimationController? doubleClickAnimationController;
  DoubleClickAnimationListener? doubleClickAnimationListener;

  @override
  void initState() {
    super.initState();
    doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
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
    doubleClickAnimationController?.dispose();
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
    final imageProvider = ExtendedNetworkImageProvider(widget.imageUrl);
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
      _imageSize = imageSize;
      _isLoading = false;
      setState(() {});
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
        setState(() {});
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
        setState(() {});
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
        setState(() {});
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
        setState(() {});
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
      height: _labelSize[label.name]?.height,
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
    Widget image = GestureDetector(
      onTap: onImageTap,
      child: ExtendedImage.network(
        widget.imageUrl,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            minScale: 1.0,
            animationMinScale: 0.5,
            maxScale: 5.0,
            animationMaxScale: 5.0,
            initialScale: 1.0,
            inPageView: true,
            initialAlignment: InitialAlignment.center,
            // gestureDetailsIsChanged: calculateLabelPosition,
          );
        },
        onDoubleTap: (ExtendedImageGestureState state) {
          Offset? pointerDownPosition = state.pointerDownPosition;
          double? beginScale = state.gestureDetails!.totalScale;
          double? endScale = beginScale;

          // 移除之前的动画监听
          if (doubleClickAnimationListener != null) {
            doubleClickAnimation?.removeListener(doubleClickAnimationListener!);
          }
          // 重置动画
          doubleClickAnimationController?.stop();
          doubleClickAnimationController?.reset();

          // 根据当前缩放比例，切换到下一个缩放比例
          if (beginScale == doubleClickScales[0]) {
            endScale = doubleClickScales[1];
          } else if (beginScale == doubleClickScales[1]) {
            endScale = doubleClickScales[2];
          } else {
            endScale = doubleClickScales[0];
          }

          // 开始执行动画
          doubleClickAnimation = doubleClickAnimationController
              ?.drive(Tween<double>(begin: beginScale, end: endScale));
          doubleClickAnimationListener = () {
            state.handleDoubleTap(
              scale: doubleClickAnimation?.value,
              doubleTapPosition: pointerDownPosition,
            );
          };
          doubleClickAnimation?.addListener(doubleClickAnimationListener!);
          doubleClickAnimationController?.forward();
        },
        enableSlideOutPage: widget.enableSlideOutPage,
        heroBuilderForSlidingPage: (Widget child) {
          return HeroWidget(
            tag: (widget.heroTag ?? "") + widget.imageUrl,
            slidePageKey: widget.slidePageKey,
            slideType: SlideType.onlyImage,
            child: child,
          );
        },
      ),
    );
    Widget child = Stack(
      fit: StackFit.expand,
      children: [
        image,
        Center(
          child: AspectRatio(
            aspectRatio: _imageSize.aspectRatio,
            child: Stack(
              children: labelWidgets,
            ),
          ),
        ),
      ],
    );
    return child;
  }

  void calculateLabelPosition(GestureDetails? details) {
    print("scale: ${details?.totalScale}  ${details?.destinationRect}");
    double scale = details?.totalScale ?? 1;
    Size boundSize = details?.destinationRect?.size ?? Size.zero;
    double imageAspectRatio = _imageSize.aspectRatio;
    double boundAspectRatio = boundSize.width / boundSize.height;
    Size imageSize = _imageSize;
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
    _labelPositions.updateAll((label, offset) {
      var item = widget.labels.where((e) => e.name == label).firstOrNull;
      if (item == null) return offset;
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
      double left = imageSize.width * item.percentX;
      double top = imageSize.height * item.percentY;

      // Calculate the size of the label text
      Size textSize = calculateTextSize(
        item.name,
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
          return offset; // Skip labels that are out of bounds
        }

        // Adjust the position of the label
        bool topToBottom = true;
        if (top > imageSize.height / 2) {
          topToBottom = false;
        }

        return Offset(
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
          return offset; // Skip labels that are out of bounds
        }

        // Adjust the position of the label
        bool leftToRight = true;
        if (left > imageSize.width / 2) {
          leftToRight = false;
        }

        return Offset(
          left - minLeft - (leftToRight ? 9 : labelSize.width - 14),
          top - minTop - labelSize.height / 2,
        );
      }
    });
    setState(() {});
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
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(milliseconds: 200), () {
        bool allZero = _labelAnimations.values.every((e) => e == 0);
        for (var label in widget.labels) {
          _labelDotAnimations[label.name] = 1;
          _labelAnimations[label.name] = allZero ? 1 : 0;
        }
        setState(() {});
        _timer = Timer(const Duration(milliseconds: 300), () {
          _imageTap = false;
        });
      });
    });
  }
}

/// make hero better when slide out
class HeroWidget extends StatefulWidget {
  const HeroWidget({
    required this.child,
    required this.tag,
    required this.slidePageKey,
    this.slideType = SlideType.onlyImage,
  });

  final Widget child;
  final SlideType slideType;
  final Object tag;
  final GlobalKey<ExtendedImageSlidePageState> slidePageKey;

  @override
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  RectTween? _rectTween;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      createRectTween: (Rect? begin, Rect? end) {
        _rectTween = RectTween(begin: begin, end: end);
        return _rectTween!;
      },
      // make hero better when slide out
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        // make hero more smoothly
        final Hero hero = (flightDirection == HeroFlightDirection.pop
            ? fromHeroContext.widget
            : toHeroContext.widget) as Hero;
        if (_rectTween == null) {
          return hero;
        }

        if (flightDirection == HeroFlightDirection.pop) {
          final bool fixTransform = widget.slideType == SlideType.onlyImage &&
              (widget.slidePageKey.currentState!.offset != Offset.zero ||
                  widget.slidePageKey.currentState!.scale != 1.0);

          final Widget toHeroWidget = (toHeroContext.widget as Hero).child;
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext buildContext, Widget? child) {
              Widget animatedBuilderChild = hero.child;

              // make hero more smoothly
              animatedBuilderChild = Stack(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 1 - animation.value,
                    child: SizedBox(
                      width: _rectTween!.begin!.width,
                      height: _rectTween!.begin!.height,
                      child: toHeroWidget,
                    ),
                  ),
                  Opacity(
                    opacity: animation.value,
                    child: animatedBuilderChild,
                  )
                ],
              );

              // fix transform when slide out
              if (fixTransform) {
                final Tween<Offset> offsetTween = Tween<Offset>(
                    begin: Offset.zero,
                    end: widget.slidePageKey.currentState!.offset);

                final Tween<double> scaleTween = Tween<double>(
                    begin: 1.0, end: widget.slidePageKey.currentState!.scale);
                animatedBuilderChild = Transform.translate(
                  offset: offsetTween.evaluate(animation),
                  child: Transform.scale(
                    scale: scaleTween.evaluate(animation),
                    child: animatedBuilderChild,
                  ),
                );
              }

              return animatedBuilderChild;
            },
          );
        }
        return hero.child;
      },
      child: widget.child,
    );
  }
}

class ImageBlock {
  final String image;
  final BoxFit fit;
  final List<LabelItem> labels;

  ImageBlock({
    required this.image,
    required this.fit,
    required this.labels,
  });
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
