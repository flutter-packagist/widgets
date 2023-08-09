import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' as physics;

import '../ball_pulse_indicator.dart';

/// 球脉冲Footer
class BallPulseFooter extends Footer {
  /// Key
  final Key? key;

  /// 颜色
  final Color? color;

  /// 背景颜色
  final Color? backgroundColor;

  const BallPulseFooter({
    this.key,
    double triggerOffset = 70,
    bool clamping = false,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = Duration.zero,
    physics.SpringDescription? spring,
    SpringBuilder? readySpringBuilder,
    bool springRebound = true,
    FrictionFactor? frictionFactor,
    bool safeArea = true,
    double? infiniteOffset = 70,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
    bool triggerWhenRelease = false,
    double maxOverOffset = double.infinity,
    this.color = Colors.black,
    this.backgroundColor = Colors.transparent,
  }) : super(
          triggerOffset: triggerOffset,
          clamping: clamping,
          processedDuration: processedDuration,
          spring: spring,
          readySpringBuilder: readySpringBuilder,
          springRebound: springRebound,
          frictionFactor: frictionFactor,
          safeArea: safeArea,
          infiniteOffset: infiniteOffset,
          hitOver: hitOver,
          infiniteHitOver: infiniteHitOver,
          position: position,
          hapticFeedback: hapticFeedback,
          triggerWhenRelease: triggerWhenRelease,
          maxOverOffset: maxOverOffset,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return BallPulseIndicator(
      key: key,
      state: state,
      color: color,
      backgroundColor: backgroundColor,
    );
  }
}
