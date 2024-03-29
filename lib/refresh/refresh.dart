import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'ball/footer/ball_pulse_footer.dart';
import 'ball/header/ball_pulse_header.dart';
import 'refresh_notifier.dart';

typedef EasyRefreshIndicator = Indicator? Function(
    bool clamping, Color? backgroundColor);

class WrapperEasyRefresh extends EasyRefresh {
  static EasyRefreshIndicator? _header;
  static EasyRefreshIndicator? _footer;

  static void init({
    EasyRefreshIndicator? header,
    EasyRefreshIndicator? footer,
  }) {
    _header = header;
    _footer = footer;
  }

  WrapperEasyRefresh({
    Key? key,
    required Widget? child,
    EasyRefreshController? controller,
    Header? header,
    Footer? footer,
    NotRefreshHeader? notRefreshHeader,
    NotLoadFooter? notLoadFooter,
    ERChildBuilder? childBuilder,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
    SpringDescription? spring,
    FrictionFactor? frictionFactor,
    bool simultaneously = false,
    bool canRefreshAfterNoMore = false,
    bool canLoadAfterNoMore = false,
    bool resetAfterRefresh = false,
    bool refreshOnStart = false,
    Header? refreshOnStartHeader,
    double callRefreshOverOffset = 20,
    double callLoadOverOffset = 20,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    ERScrollBehaviorBuilder? scrollBehaviorBuilder,
    ScrollController? scrollController,
    Axis? triggerAxis,
    bool headerClamping = false,
    bool footerClamping = false,
    Color? headerBackgroundColor,
    Color? footerBackgroundColor,
    RefreshNotifier? refreshNotifier,
  }) : super(
          key: key,
          child: child,
          controller: controller ?? refreshNotifier?.easyRefreshController,
          header: header ??
              _header?.call(headerClamping, headerBackgroundColor) as Header? ??
              BallPulseHeader(
                clamping: headerClamping,
                backgroundColor: headerBackgroundColor,
              ),
          footer: footer ??
              _footer?.call(footerClamping, footerBackgroundColor) as Footer? ??
              BallPulseFooter(
                clamping: footerClamping,
                backgroundColor: footerBackgroundColor,
              ),
          notRefreshHeader: notRefreshHeader,
          notLoadFooter: notLoadFooter,
          onRefresh: onRefresh ?? refreshNotifier?.refresh,
          onLoad: onLoad ?? refreshNotifier?.loadMore,
          spring: spring,
          frictionFactor: frictionFactor,
          simultaneously: simultaneously,
          canRefreshAfterNoMore: canRefreshAfterNoMore,
          canLoadAfterNoMore: canLoadAfterNoMore,
          resetAfterRefresh: resetAfterRefresh,
          refreshOnStart: refreshOnStart,
          refreshOnStartHeader: refreshOnStartHeader,
          callRefreshOverOffset: callRefreshOverOffset,
          callLoadOverOffset: callLoadOverOffset,
          fit: fit,
          clipBehavior: clipBehavior,
          scrollBehaviorBuilder: scrollBehaviorBuilder,
          scrollController: scrollController,
          triggerAxis: triggerAxis,
        );

  WrapperEasyRefresh.builder({
    Key? key,
    required ERChildBuilder? childBuilder,
    EasyRefreshController? controller,
    Header? header,
    Footer? footer,
    NotRefreshHeader? notRefreshHeader,
    NotLoadFooter? notLoadFooter,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
    SpringDescription? spring,
    FrictionFactor? frictionFactor,
    bool simultaneously = false,
    bool canRefreshAfterNoMore = false,
    bool canLoadAfterNoMore = false,
    bool resetAfterRefresh = false,
    bool refreshOnStart = false,
    Header? refreshOnStartHeader,
    double callRefreshOverOffset = 20,
    double callLoadOverOffset = 20,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    ERScrollBehaviorBuilder? scrollBehaviorBuilder,
    ScrollController? scrollController,
    Axis? triggerAxis,
    bool headerClamping = false,
    bool footerClamping = false,
    Color? headerBackgroundColor,
    Color? footerBackgroundColor,
    RefreshNotifier? refreshNotifier,
  }) : super.builder(
          key: key,
          childBuilder: childBuilder,
          controller: controller ?? refreshNotifier?.easyRefreshController,
          header: header ??
              _header?.call(headerClamping, headerBackgroundColor) as Header? ??
              BallPulseHeader(
                clamping: headerClamping,
                backgroundColor: headerBackgroundColor,
              ),
          footer: footer ??
              _footer?.call(footerClamping, footerBackgroundColor) as Footer? ??
              BallPulseFooter(
                clamping: footerClamping,
                backgroundColor: footerBackgroundColor,
              ),
          onRefresh: onRefresh ?? refreshNotifier?.refresh,
          onLoad: onLoad ?? refreshNotifier?.loadMore,
          spring: spring,
          frictionFactor: frictionFactor,
          simultaneously: simultaneously,
          canRefreshAfterNoMore: canRefreshAfterNoMore,
          canLoadAfterNoMore: canLoadAfterNoMore,
          resetAfterRefresh: resetAfterRefresh,
          refreshOnStart: refreshOnStart,
          refreshOnStartHeader: refreshOnStartHeader,
          callRefreshOverOffset: callRefreshOverOffset,
          callLoadOverOffset: callLoadOverOffset,
          fit: fit,
          clipBehavior: clipBehavior,
          scrollBehaviorBuilder: scrollBehaviorBuilder,
          scrollController: scrollController,
          triggerAxis: triggerAxis,
        );
}
