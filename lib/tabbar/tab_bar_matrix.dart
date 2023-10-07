import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class WrapperTabBar extends TabBar {
  final bool textScale;

  const WrapperTabBar.scale({
    Key? key,
    this.textScale = true,
    required List<Widget> tabs,
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    bool automaticIndicatorColorAdjustment = true,
    double indicatorWeight = 2.0,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    MaterialStateProperty<Color?>? overlayColor,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    ValueChanged<int>? onTap,
    ScrollPhysics? physics,
    InteractiveInkFeatureFactory? splashFactory,
    BorderRadius? splashBorderRadius,
    TabAlignment? tabAlignment,
  }) : super(
          key: key,
          tabs: tabs,
          controller: controller,
          isScrollable: isScrollable,
          padding: padding,
          indicatorColor: indicatorColor,
          automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
          indicatorWeight: indicatorWeight,
          indicatorPadding: indicatorPadding,
          indicator: indicator,
          indicatorSize: indicatorSize,
          dividerColor: dividerColor,
          labelColor: labelColor,
          labelStyle: labelStyle,
          labelPadding: labelPadding,
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          dragStartBehavior: dragStartBehavior,
          overlayColor: overlayColor,
          mouseCursor: mouseCursor,
          enableFeedback: enableFeedback,
          onTap: onTap,
          physics: physics,
          splashFactory: splashFactory,
          splashBorderRadius: splashBorderRadius,
          tabAlignment: tabAlignment,
        );

  @override
  // ignore: no_logic_in_create_state
  State<TabBar> createState() {
    if (textScale) {
      return _WrapperTabBarState();
    } else {
      return super.createState();
    }
  }
}

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;
const double _kStartOffset = 52.0;

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.isSelected,
    required this.isPrimary,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.defaults,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isSelected;
  final bool isPrimary;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TabBarTheme defaults;
  final Widget child;

  MaterialStateColor _resolveWithLabelColor(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // labelStyle.color (and tabBarTheme.labelStyle.color) is not considered
    // as it'll be a breaking change without a possible migration plan. for
    // details: https://github.com/flutter/flutter/pull/109541#issuecomment-1294241417
    Color selectedColor =
        labelColor ?? tabBarTheme.labelColor ?? defaults.labelColor!;

    final Color unselectedColor;

    if (selectedColor is MaterialStateColor) {
      unselectedColor = selectedColor.resolve(const <MaterialState>{});
      selectedColor =
          selectedColor.resolve(const <MaterialState>{MaterialState.selected});
    } else {
      // unselectedLabelColor and tabBarTheme.unselectedLabelColor are ignored
      // when labelColor is a MaterialStateColor.
      unselectedColor = unselectedLabelColor ??
          tabBarTheme.unselectedLabelColor ??
          (themeData.useMaterial3
              ? defaults.unselectedLabelColor!
              : selectedColor.withAlpha(0xB2)); // 70% alpha
    }

    return MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Color.lerp(selectedColor, unselectedColor, animation.value)!;
      }
      return Color.lerp(unselectedColor, selectedColor, animation.value)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    final Set<MaterialState> states = isSelected
        ? const <MaterialState>{MaterialState.selected}
        : const <MaterialState>{};

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle defaultStyle =
        (labelStyle ?? tabBarTheme.labelStyle ?? defaults.labelStyle!)
            .copyWith(inherit: true);
    final TextStyle defaultUnselectedStyle = (unselectedLabelStyle ??
            tabBarTheme.unselectedLabelStyle ??
            labelStyle ??
            defaults.unselectedLabelStyle!)
        .copyWith(inherit: true);
    final TextStyle textStyle = isSelected
        ? TextStyle.lerp(defaultStyle, defaultUnselectedStyle, animation.value)!
        : TextStyle.lerp(
            defaultUnselectedStyle, defaultStyle, animation.value)!;
    final Color color = _resolveWithLabelColor(context).resolve(states);

    final TextStyle textStyleScale =
        isSelected ? defaultStyle : defaultUnselectedStyle;
    final double? beginFontSize =
        isSelected ? defaultStyle.fontSize : defaultUnselectedStyle.fontSize;
    final double? endFontSize =
        isSelected ? defaultUnselectedStyle.fontSize : defaultStyle.fontSize;
    final double beginPercent = textStyleScale.fontSize! / beginFontSize!;
    final double endPercent = endFontSize! / textStyleScale.fontSize!;

    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: Transform(
          transform: Matrix4.diagonal3(
            Vector3.all(
              Tween<double>(
                end: endPercent,
                begin: beginPercent,
              ).evaluate(animation),
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

typedef _LayoutCallback = void Function(
    List<double> xOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
        break;
      case TextDirection.ltr:
        xOffsets.add(size.width);
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  const _TabLabelBar({
    super.children,
    required this.onPerformLayout,
    required super.mainAxisSize,
  }) : super(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
        );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
    required this.labelPaddings,
    this.dividerColor,
  }) : super(repaint: controller.animation) {
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;
  final Color? dividerColor;
  final List<EdgeInsetsGeometry> labelPaddings;

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;

  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] is the offset of the start edge of the tab at index, and
  // _currentTabOffsets[_currentTabOffsets.length] is the end edge of the last tab.
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) /
        2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    switch (_currentTextDirection!) {
      case TextDirection.rtl:
        tabLeft = _currentTabOffsets![tabIndex + 1];
        tabRight = _currentTabOffsets![tabIndex];
        break;
      case TextDirection.ltr:
        tabLeft = _currentTabOffsets![tabIndex];
        tabRight = _currentTabOffsets![tabIndex + 1];
    }

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth = tabKeys[tabIndex].currentContext!.size!.width;
      final EdgeInsetsGeometry labelPadding = labelPaddings[tabIndex];
      final EdgeInsets insets = labelPadding.resolve(_currentTextDirection);
      final double delta =
          ((tabRight - tabLeft) - (tabWidth + insets.horizontal)) / 2.0;
      tabLeft += delta + insets.left;
      tabRight = tabLeft + tabWidth;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    final Rect rect =
        Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarSize.height);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final double index = controller.index.toDouble();
    final double value = controller.animation!.value;
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil())
        .clamp(0, maxTabIndex); // ignore_clamp_double_lint
    final int to = (ltr ? from + 1 : from - 1)
        .clamp(0, maxTabIndex); // ignore_clamp_double_lint
    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    _currentRect = Rect.lerp(fromRect, toRect, (value - from).abs());
    assert(_currentRect != null);

    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
    );
    if (dividerColor != null) {
      final Paint dividerPaint = Paint()
        ..color = dividerColor!
        ..strokeWidth = 1;
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height),
          dividerPaint);
    }
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return _needsPaint ||
        controller != old.controller ||
        indicator != old.indicator ||
        tabKeys.length != old.tabKeys.length ||
        (!listEquals(_currentTabOffsets, old._currentTabOffsets)) ||
        _currentTextDirection != old._currentTextDirection;
  }
}

class _ChangeAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue =
        clampDouble(controller.animation!.value, 0.0, controllerMaxValue);
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

// This class, and TabBarScrollController, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex. In that case we can
// only compute the scroll position's initial scroll offset (the "correct"
// pixels value) after the TabBar viewport width and scroll limits are known.
class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.tabBar,
  }) : super(
          initialPixels: null,
        );

  final _WrapperTabBarState tabBar;

  bool _viewportDimensionWasNonZero = false;

  // The scroll position should be adjusted at least once.
  bool _needsPixelsCorrection = true;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (!_viewportDimensionWasNonZero) {
      _viewportDimensionWasNonZero = viewportDimension != 0.0;
    }
    // If the viewport never had a non-zero dimension, we just want to jump
    // to the initial scroll position to avoid strange scrolling effects in
    // release mode: the viewport temporarily may have a dimension of zero
    // before the actual dimension is calculated. In that scenario, setting
    // the actual dimension would cause a strange scroll effect without this
    // guard because the super call below would start a ballistic scroll activity.
    if (!_viewportDimensionWasNonZero || _needsPixelsCorrection) {
      _needsPixelsCorrection = false;
      correctPixels(tabBar._initialScrollOffset(
          viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) &&
        result;
  }

  void markNeedsPixelsCorrection() {
    _needsPixelsCorrection = true;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _WrapperTabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}

class _WrapperTabBarState extends State<TabBar> {
  ScrollController? _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  late List<EdgeInsetsGeometry> _labelPaddings;
  bool _debugHasScheduledValidTabsCountCheck = false;
  List<TextPainter>? _textPainters;

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(
        widget.tabs.length, EdgeInsets.zero,
        growable: true);
    _initTextPainterList();
  }

  void _initTextPainterList() {
    final bool isOnlyTabText = widget.tabs
        .map<bool>(
            (Widget tab) => tab is Tab && tab.icon == null && tab.child == null)
        .toList()
        .reduce((bool value, bool element) => value && element);
    if (isOnlyTabText) {
      final TextStyle defaultLabelStyle = widget.labelStyle!;
      final TextStyle defaultUnselectedLabelStyle =
          widget.unselectedLabelStyle!;
      final TextStyle defaultStyle =
          defaultLabelStyle.fontSize! >= defaultUnselectedLabelStyle.fontSize!
              ? defaultLabelStyle
              : defaultUnselectedLabelStyle;

      _textPainters = widget.tabs.map<TextPainter>((Widget tab) {
        return TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: tab is Tab ? tab.text ?? '' : '',
            style: defaultStyle,
          ),
        );
      }).toList();
    } else {
      _textPainters = null;
    }
  }

  TabBarTheme get _defaults {
    if (Theme.of(context).useMaterial3) {
      return _TabsPrimaryDefaultsM3(context, widget.isScrollable);
    } else {
      return _TabsDefaultsM2(context, widget.isScrollable);
    }
  }

  Decoration _getIndicator(TabBarIndicatorSize indicatorSize) {
    final ThemeData theme = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);

    if (widget.indicator != null) {
      return widget.indicator!;
    }
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    Color color = widget.indicatorColor ??
        (theme.useMaterial3
            ? tabBarTheme.indicatorColor ?? _defaults.indicatorColor!
            : Theme.of(context).indicatorColor);
    // ThemeData tries to avoid this by having indicatorColor avoid being the
    // primaryColor. However, it's possible that the tab bar is on a
    // Material that isn't the primaryColor. In that case, if the indicator
    // color ends up matching the material's color, then this overrides it.
    // When that happens, automatic transitions of the theme will likely look
    // ugly as the indicator color suddenly snaps to white at one end, but it's
    // not clear how to avoid that any further.
    //
    // The material's color might be null (if it's a transparency). In that case
    // there's no good way for us to find out what the color is so we don't.
    //
    // TODO(xu-baolin): Remove automatic adjustment to white color indicator
    // with a better long-term solution.
    // https://github.com/flutter/flutter/pull/68171#pullrequestreview-517753917
    if (widget.automaticIndicatorColorAdjustment &&
        color.value == Material.maybeOf(context)?.color?.value) {
      color = Colors.white;
    }

    final bool primaryWithLabelIndicator =
        indicatorSize == TabBarIndicatorSize.label;
    final double effectiveIndicatorWeight =
        theme.useMaterial3 && primaryWithLabelIndicator
            ? math.max(
                widget.indicatorWeight, _TabsPrimaryDefaultsM3.indicatorWeight)
            : widget.indicatorWeight;
    // Only Material 3 primary TabBar with label indicatorSize should be rounded.
    final BorderRadius? effectiveBorderRadius =
        theme.useMaterial3 && primaryWithLabelIndicator
            ? BorderRadius.only(
                topLeft: Radius.circular(effectiveIndicatorWeight),
                topRight: Radius.circular(effectiveIndicatorWeight),
              )
            : null;
    return UnderlineTabIndicator(
      borderRadius: effectiveBorderRadius,
      borderSide: BorderSide(
        // TODO(tahatesser): Make sure this value matches Material 3 Tabs spec
        // when `preferredSize`and `indicatorWeight` are updated to support Material 3
        // https://m3.material.io/components/tabs/specs#149a189f-9039-4195-99da-15c205d20e30,
        // https://github.com/flutter/flutter/issues/116136
        width: effectiveIndicatorWeight,
        color: color,
      ),
    );
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    final ThemeData theme = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize = widget.indicatorSize ??
        tabBarTheme.indicatorSize ??
        _defaults.indicatorSize!;

    _indicatorPainter = !_controllerIsValid
        ? null
        : _IndicatorPainter(
            controller: _controller!,
            indicator: _getIndicator(indicatorSize),
            indicatorSize: widget.indicatorSize ??
                tabBarTheme.indicatorSize ??
                _defaults.indicatorSize!,
            indicatorPadding: widget.indicatorPadding,
            tabKeys: _tabKeys,
            old: _indicatorPainter,
            dividerColor: theme.useMaterial3
                ? widget.dividerColor ??
                    tabBarTheme.dividerColor ??
                    _defaults.dividerColor
                : null,
            labelPaddings: _labelPaddings,
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
      // Adjust scroll position.
      if (_scrollController != null && _scrollController!.hasClients) {
        final ScrollPosition position = _scrollController!.position;
        if (position is _TabBarScrollPosition) {
          position.markNeedsPixelsCorrection();
        }
      }
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicatorPadding != oldWidget.indicatorPadding ||
        widget.indicator != oldWidget.indicator) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
      _labelPaddings
          .addAll(List<EdgeInsetsGeometry>.filled(delta, EdgeInsets.zero));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
      _labelPaddings.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(
      int index, double viewportWidth, double minExtent, double maxExtent) {
    if (!widget.isScrollable) {
      return 0.0;
    }
    double tabCenter = _indicatorPainter!.centerOf(index);
    double paddingStart;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        paddingStart = widget.padding?.resolve(TextDirection.rtl).right ?? 0;
        tabCenter = _tabStripWidth - tabCenter;
        break;
      case TextDirection.ltr:
        paddingStart = widget.padding?.resolve(TextDirection.ltr).left ?? 0;
    }

    return clampDouble(
        tabCenter + paddingStart - viewportWidth / 2.0, minExtent, maxExtent);
  }

  double _tabCenteredScrollOffset(int index) {
    final ScrollPosition position = _scrollController!.position;
    return _tabScrollOffset(index, position.viewportDimension,
        position.minScrollExtent, position.maxScrollExtent);
  }

  double _initialScrollOffset(
      double viewportWidth, double minExtent, double maxExtent) {
    return _tabScrollOffset(
        _currentIndex!, viewportWidth, minExtent, maxExtent);
  }

  void _scrollToCurrentIndex() {
    final double offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController!
        .animateTo(offset, duration: kTabScrollDuration, curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final double? leadingPosition = _currentIndex! > 0
        ? _tabCenteredScrollOffset(_currentIndex! - 1)
        : null;
    final double middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final double? trailingPosition = _currentIndex! < maxTabIndex
        ? _tabCenteredScrollOffset(_currentIndex! + 1)
        : null;

    final double index = _controller!.index.toDouble();
    final double value = _controller!.animation!.value;
    final double offset;
    if (value == index - 1.0) {
      offset = leadingPosition ?? middlePosition;
    } else if (value == index + 1.0) {
      offset = trailingPosition ?? middlePosition;
    } else if (value == index) {
      offset = middlePosition;
    } else if (value < index) {
      offset = leadingPosition == null
          ? middlePosition
          : lerpDouble(middlePosition, leadingPosition, index - value)!;
    } else {
      offset = trailingPosition == null
          ? middlePosition
          : lerpDouble(middlePosition, trailingPosition, value - index)!;
    }

    _scrollController!.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging && widget.isScrollable) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.isScrollable) {
        _scrollToCurrentIndex();
      }
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // Called each time layout completes.
  void _saveTabOffsets(
      List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  Widget _buildStyledTab(Widget child, bool isSelected,
      Animation<double> animation, TabBarTheme defaults) {
    return _TabStyle(
      animation: animation,
      isSelected: isSelected,
      isPrimary: true,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      defaults: defaults,
      child: child,
    );
  }

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
          );
        }
        return true;
      }());
    });
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  bool _debugTabAlignmentIsValid(TabAlignment tabAlignment) {
    assert(() {
      if (widget.isScrollable && tabAlignment == TabAlignment.fill) {
        throw FlutterError(
          '$tabAlignment is only valid for non-scrollable tab bars.',
        );
      }
      if (!widget.isScrollable &&
          (tabAlignment == TabAlignment.start ||
              tabAlignment == TabAlignment.startOffset)) {
        throw FlutterError(
          '$tabAlignment is only valid for scrollable tab bars.',
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final TabAlignment effectiveTabAlignment = widget.tabAlignment ??
        tabBarTheme.tabAlignment ??
        _defaults.tabAlignment!;
    assert(_debugTabAlignmentIsValid(effectiveTabAlignment));

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return Container(
        height: _kTabHeight + widget.indicatorWeight,
      );
    }

    final List<Widget> wrappedTabs =
        List<Widget>.generate(widget.tabs.length, (int index) {
      const double verticalAdjustment =
          (_kTextAndIconTabHeight - _kTabHeight) / 2.0;
      EdgeInsetsGeometry? adjustedPadding;

      if (widget.tabs[index] is PreferredSizeWidget) {
        final PreferredSizeWidget tab =
            widget.tabs[index] as PreferredSizeWidget;
        if (widget.tabHasTextAndIcon &&
            tab.preferredSize.height == _kTabHeight) {
          if (widget.labelPadding != null || tabBarTheme.labelPadding != null) {
            adjustedPadding = (widget.labelPadding ?? tabBarTheme.labelPadding!)
                .add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
          } else {
            adjustedPadding = const EdgeInsets.symmetric(
                vertical: verticalAdjustment, horizontal: 16.0);
          }
        }
      }

      _labelPaddings[index] = adjustedPadding ??
          widget.labelPadding ??
          tabBarTheme.labelPadding ??
          kTabLabelPadding;

      Widget child = widget.tabs[index];

      if (_textPainters != null) {
        _textPainters![index].layout();
        child = SizedBox(
          width: _textPainters![index].width,
          child: child,
        );
      }

      return Center(
        heightFactor: 1.0,
        child: Padding(
          padding: _labelPaddings[index],
          child: KeyedSubtree(
            key: _tabKeys[index],
            child: child,
          ),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(
            wrappedTabs[_currentIndex!], true, animation, _defaults);
        wrappedTabs[previousIndex] = _buildStyledTab(
            wrappedTabs[previousIndex], false, animation, _defaults);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation =
            _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(
            wrappedTabs[tabIndex], true, centerAnimation, _defaults);
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation =
              ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(
              wrappedTabs[tabIndex], false, previousAnimation, _defaults);
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation =
              ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(
              wrappedTabs[tabIndex], false, nextAnimation, _defaults);
        }
      }
    }

    // Add the tap handler to each tab. If the tab bar is not scrollable,
    // then give all of the tabs equal flexibility so that they each occupy
    // the same share of the tab bar's overall width.
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      final Set<MaterialState> selectedState = <MaterialState>{
        if (index == _currentIndex) MaterialState.selected,
      };

      final MouseCursor effectiveMouseCursor =
          MaterialStateProperty.resolveAs<MouseCursor?>(
                  widget.mouseCursor, selectedState) ??
              tabBarTheme.mouseCursor?.resolve(selectedState) ??
              MaterialStateMouseCursor.clickable.resolve(selectedState);

      final MaterialStateProperty<Color?> defaultOverlay =
          MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          final Set<MaterialState> effectiveStates = selectedState
            ..addAll(states);
          return _defaults.overlayColor?.resolve(effectiveStates);
        },
      );
      wrappedTabs[index] = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: () {
          _handleTap(index);
        },
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor:
            widget.overlayColor ?? tabBarTheme.overlayColor ?? defaultOverlay,
        splashFactory: widget.splashFactory ??
            tabBarTheme.splashFactory ??
            _defaults.splashFactory,
        borderRadius: widget.splashBorderRadius,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.indicatorWeight),
          child: Stack(
            children: <Widget>[
              wrappedTabs[index],
              Semantics(
                selected: index == _currentIndex,
                label: localizations.tabLabel(
                    tabIndex: index + 1, tabCount: tabCount),
              ),
            ],
          ),
        ),
      );
      if (!widget.isScrollable && effectiveTabAlignment == TabAlignment.fill) {
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
      }
    }

    Widget tabBar = CustomPaint(
      painter: _indicatorPainter,
      child: _TabStyle(
        animation: kAlwaysDismissedAnimation,
        isSelected: false,
        isPrimary: true,
        labelColor: widget.labelColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        defaults: _defaults,
        child: _TabLabelBar(
          onPerformLayout: _saveTabOffsets,
          mainAxisSize: effectiveTabAlignment == TabAlignment.fill
              ? MainAxisSize.max
              : MainAxisSize.min,
          children: wrappedTabs,
        ),
      ),
    );

    if (widget.isScrollable) {
      final EdgeInsetsGeometry? effectivePadding =
          effectiveTabAlignment == TabAlignment.startOffset
              ? const EdgeInsetsDirectional.only(start: _kStartOffset)
                  .add(widget.padding ?? EdgeInsets.zero)
              : widget.padding;
      _scrollController ??= _TabBarScrollController(this);
      tabBar = ScrollConfiguration(
        // The scrolling tabs should not show an overscroll indicator.
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          padding: effectivePadding,
          physics: widget.physics,
          child: tabBar,
        ),
      );
    } else if (widget.padding != null) {
      tabBar = Padding(
        padding: widget.padding!,
        child: tabBar,
      );
    }

    return tabBar;
  }
}

// Hand coded defaults based on Material Design 2.
class _TabsDefaultsM2 extends TabBarTheme {
  const _TabsDefaultsM2(this.context, this.isScrollable)
      : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  final bool isScrollable;

  @override
  Color? get indicatorColor => Theme.of(context).indicatorColor;

  @override
  Color? get labelColor => Theme.of(context).primaryTextTheme.bodyLarge!.color!;

  @override
  TextStyle? get labelStyle => Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  TextStyle? get unselectedLabelStyle =>
      Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment =>
      isScrollable ? TabAlignment.start : TabAlignment.fill;
}

// BEGIN GENERATED TOKEN PROPERTIES - Tabs

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _TabsPrimaryDefaultsM3 extends TabBarTheme {
  _TabsPrimaryDefaultsM3(this.context, this.isScrollable)
      : super(indicatorSize: TabBarIndicatorSize.label);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  @override
  Color? get dividerColor => _colors.surfaceVariant;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.primary;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  MaterialStateProperty<Color?> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary.withOpacity(0.12);
        }
        return null;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.primary.withOpacity(0.12);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment =>
      isScrollable ? TabAlignment.start : TabAlignment.fill;

  static double indicatorWeight = 3.0;
}
