import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WrapperCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final ImageWidgetBuilder? imageBuilder;
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

  const WrapperCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
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
  State<WrapperCachedNetworkImage> createState() =>
      _WrapperCachedNetworkImageState();
}

class _WrapperCachedNetworkImageState extends State<WrapperCachedNetworkImage> {
  final WrapperImageController controller = WrapperImageController();

  @override
  void initState() {
    super.initState();
    controller._bind(this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      httpHeaders: widget.httpHeaders,
      imageBuilder: widget.imageBuilder,
      placeholder: widget.placeholder ?? placeholder,
      progressIndicatorBuilder:
          widget.progressIndicatorBuilder ?? progressIndicatorBuilder,
      errorWidget: widget.errorWidget ?? errorWidget,
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
    );
  }

  PlaceholderWidgetBuilder? get placeholder {
    if (!widget.usePlaceholder) return null;
    if (StaticCachedNetworkImage._placeholder != null) {
      return StaticCachedNetworkImage._placeholder!;
    }
    return (context, url) => Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey.shade200,
        );
  }

  ProgressIndicatorBuilder? get progressIndicatorBuilder {
    if (widget.usePlaceholder) return null;
    if (StaticCachedNetworkImage._progressIndicatorBuilder != null) {
      return StaticCachedNetworkImage._progressIndicatorBuilder;
    }
    return (context, url, downloadProgress) => Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          color: Colors.grey.shade200,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: Colors.grey,
          ),
        );
  }

  LoadingErrorWidgetBuilder get errorWidget {
    if (StaticCachedNetworkImage._errorWidget != null) {
      return (context, url, error) => StaticCachedNetworkImage._errorWidget!(
            context,
            widget.imageUrl,
            error,
            controller,
          );
    }
    return (context, url, error) => GestureDetector(
          onTap: () => controller.refresh(),
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Text("点击重新加載"),
          ),
        );
  }
}

class WrapperImageController {
  _WrapperCachedNetworkImageState? _state;

  void _bind(_WrapperCachedNetworkImageState state) {
    _state = state;
  }

  void refresh() {
    // ignore: invalid_use_of_protected_member
    _state?.setState(() {});
  }

  /// Unbind.
  void dispose() {
    _state = null;
  }
}

typedef WrapperLoadingErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
  dynamic error,
  WrapperImageController controller,
);

class StaticCachedNetworkImage {
  static PlaceholderWidgetBuilder? _placeholder;
  static ProgressIndicatorBuilder? _progressIndicatorBuilder;
  static WrapperLoadingErrorWidgetBuilder? _errorWidget;

  static void init({
    PlaceholderWidgetBuilder? placeholder,
    ProgressIndicatorBuilder? progressIndicatorBuilder,
    WrapperLoadingErrorWidgetBuilder? errorWidget,
  }) {
    StaticCachedNetworkImage._placeholder = placeholder;
    StaticCachedNetworkImage._progressIndicatorBuilder =
        progressIndicatorBuilder;
    StaticCachedNetworkImage._errorWidget = errorWidget;
  }
}