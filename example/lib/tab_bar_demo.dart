import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({super.key});

  @override
  State<TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with TickerProviderStateMixin {
  final List<String> tabs = ["Tab1", "Tab2", "Tab3"];
  late TabController tabController;
  late List<AnimationController> animationControllers;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(_listener);
    animationControllers = List.generate(
      tabs.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _listener() {
    if (tabController.indexIsChanging) {
      animationControllers[tabController.previousIndex].reverse();
    } else {
      animationControllers[tabController.index].forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController
      ..removeListener(_listener)
      ..dispose();
    for (var ac in animationControllers) {
      ac.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "TabBarDemo",
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        tabBarWrapperScale,
        tabBarWrapper,
        tabBar,
        tabBarAnimation,
        Expanded(child: tabView),
      ]),
    );
  }

  Widget get tabBarWrapperScale {
    return WrapperTabBar.textScale(
      isScrollable: true,
      controller: tabController,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: tabs.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget get tabBarWrapper {
    return WrapperTabBar(
      isScrollable: true,
      controller: tabController,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: tabs.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget get tabBar {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: tabs.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget get tabBarAnimation {
    return TabBar(
      controller: tabController,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: tabs
          .asMap()
          .map(
            (index, e) => MapEntry(
              index,
              AnimatedBuilder(
                animation: animationControllers[index],
                builder: (context, child) {
                  final child = Tab(
                    text: 'tab $index',
                  );
                  final value = animationControllers[index].value;
                  if (animationControllers[index].status ==
                      AnimationStatus.forward) {
                    final angle = sin(4 * pi * value) * pi * 0.3;
                    return Transform.rotate(angle: angle, child: child);
                  } else {
                    final dy = sin(2 * pi * value) * 0.2;
                    return FractionalTranslation(
                        translation: Offset(0, dy), child: child);
                  }
                },
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget get tabView {
    return TabBarView(
      controller: tabController,
      children: tabs.map((e) => Center(child: Text(e.toString()))).toList(),
    );
  }
}
