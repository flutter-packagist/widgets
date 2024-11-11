import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WrapperVisibilityDetector extends StatelessWidget {
  final Key key;
  final Widget child;
  final double visibleFraction; // 出发可见性变化的阈值
  final bool onceAfterBuild; // build组件之后，可见性是否需要重复调用多次，默认true，表示不需要
  final VisibilityChangedCallback? onVisibilityChanged;

  const WrapperVisibilityDetector({
    required this.key,
    required this.child,
    this.visibleFraction = 0.8,
    this.onceAfterBuild = true,
    this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool visibility = false;
    return VisibilityDetector(
      key: key,
      onVisibilityChanged: (VisibilityInfo info) {
        if (onceAfterBuild && visibility) return;
        visibility = true;
        if (info.visibleFraction >= visibleFraction) {
          onVisibilityChanged?.call(info);
        }
      },
      child: child,
    );
  }
}
