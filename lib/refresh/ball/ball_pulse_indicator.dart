import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class BallPulseIndicator extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// Ball color.
  final Color? color;

  /// Background color.
  final Color? backgroundColor;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  const BallPulseIndicator({
    Key? key,
    required this.state,
    this.color,
    this.backgroundColor,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  State<BallPulseIndicator> createState() => BallPulseIndicatorState();
}

class BallPulseIndicatorState extends State<BallPulseIndicator> {
  Axis get _axis => widget.state.axis;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  double get _triggerOffset => widget.state.triggerOffset;

  double get _safeOffset => widget.state.safeOffset;

  IndicatorMode get _mode => widget.state.mode;

  IndicatorResult get _result => widget.state.result;

  // 球大小
  double _ballSize1 = 0.0, _ballSize2 = 0.0, _ballSize3 = 0.0;

  // 动画阶段
  int animationPhase = 1;

  // 动画过渡时间
  final Duration _ballSizeDuration = const Duration(milliseconds: 200);

  // 是否运行动画
  bool _isAnimated = false;

  // 循环动画
  void _loopAnimated() {
    Future.delayed(_ballSizeDuration, () {
      if (!mounted) return;
      if (_isAnimated) {
        setState(() {
          if (animationPhase == 1) {
            _ballSize1 = 13.0;
            _ballSize2 = 6.0;
            _ballSize3 = 13.0;
          } else if (animationPhase == 2) {
            _ballSize1 = 20.0;
            _ballSize2 = 13.0;
            _ballSize3 = 6.0;
          } else if (animationPhase == 3) {
            _ballSize1 = 13.0;
            _ballSize2 = 20.0;
            _ballSize3 = 13.0;
          } else {
            _ballSize1 = 6.0;
            _ballSize2 = 13.0;
            _ballSize3 = 20.0;
          }
        });
        animationPhase++;
        animationPhase = animationPhase >= 5 ? 1 : animationPhase;
        _loopAnimated();
      } else {
        setState(() {
          _ballSize1 = 0.0;
          _ballSize2 = 0.0;
          _ballSize3 = 0.0;
        });
        animationPhase = 1;
      }
    });
  }

  /// When the list direction is vertically.
  Widget _buildVerticalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: _offset < _actualTriggerOffset
              ? -(_actualTriggerOffset - _offset - _safeOffset) / 2
              : _safeOffset,
          bottom: _offset < _actualTriggerOffset ? null : 0,
          height: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
          child: Center(
            child: _buildVerticalBody(),
          ),
        ),
      ],
    );
  }

  /// The body when the list is vertically direction.
  Widget _buildVerticalBody() {
    return Container(
      alignment: Alignment.center,
      height: _offset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize1,
                  width: _ballSize1,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5.0),
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize2,
                  width: _ballSize2,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5.0),
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize3,
                  width: _ballSize3,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        Positioned(
          left: _offset < _actualTriggerOffset
              ? -(_actualTriggerOffset - _offset - _safeOffset) / 2
              : _safeOffset,
          right: _offset < _actualTriggerOffset ? null : 0,
          top: 0,
          bottom: 0,
          width: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
          child: Center(
            child: _buildHorizontalBody(),
          ),
        ),
      ],
    );
  }

  /// The body when the list is horizontal direction.
  Widget _buildHorizontalBody() {
    return Container(
      alignment: Alignment.center,
      height: _triggerOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize1,
                  width: _ballSize1,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize2,
                  width: _ballSize2,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Center(
              child: ClipOval(
                child: AnimatedContainer(
                  color: widget.color,
                  height: _ballSize3,
                  width: _ballSize3,
                  duration: _ballSizeDuration,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 开启动画
    if (_mode == IndicatorMode.done || _mode == IndicatorMode.inactive) {
      _isAnimated = false;
    } else if (!_isAnimated) {
      _isAnimated = true;
      setState(() {
        _ballSize1 = 6.0;
        _ballSize2 = 13.0;
        _ballSize3 = 20.0;
      });
      _loopAnimated();
    }
    double offset = _offset;
    if (widget.state.indicator.infiniteOffset != null &&
        widget.state.indicator.position == IndicatorPosition.locator &&
        (_mode != IndicatorMode.inactive ||
            _result == IndicatorResult.noMore)) {
      offset = _actualTriggerOffset;
    }
    if (_result == IndicatorResult.fail) {
      offset = 0;
    }
    return Container(
      color: widget.backgroundColor,
      width: _axis == Axis.vertical ? double.infinity : offset,
      height: _axis == Axis.horizontal ? double.infinity : offset,
      child: _axis == Axis.vertical
          ? _buildVerticalWidget()
          : _buildHorizontalWidget(),
    );
  }
}
