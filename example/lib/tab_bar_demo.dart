import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import 'ext/image_ext.dart';

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({super.key});

  @override
  State<TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> with TickerProviderStateMixin {
  final List<String> tabs = ["Tab1", "Tab2", "Tab3"];
  late TabController tabController;
  late List<AnimationController> animationControllers;

  /// Indicator图片
  ui.Image? indicatorImage;

  @override
  void initState() {
    super.initState();
    loadIndicatorImage();
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

  void loadIndicatorImage() async {
    indicatorImage = await ImageExt.getAssetImage(
      "assets/images/indicator.png",
    );
    setState(() {});
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
        tabBarImage,
        tabBarIndicator,
        tabBarIndicator2,
        tabBarIndicator3,
        tabBarIndicator4,
        tabBarIndicator5,
        tabBarIndicator6,
        tabBarIndicator7,
        tabBarIndicator8,
        Expanded(child: tabView),
      ]),
    );
  }

  Widget get tabBarWrapperScale {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      child: WrapperTabBar.textScale(
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
      ),
    );
  }

  Widget get tabBarWrapper {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: WrapperTabBar(
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
      ),
    );
  }

  Widget get tabBar {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: TabBar(
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
        tabAlignment: TabAlignment.start,
      ),
    );
  }

  Widget get tabBarAnimation {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade300,
      child: TabBar(
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
      ),
    );
  }

  Widget get tabBarImage {
    if (indicatorImage == null) {
      return const SizedBox();
    }
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicator: ImageTabIndicator(
          image: indicatorImage!,
          height: 8,
          width: 30,
          alignment: IndicatorAlignment.bottom,
          relativeOffsetY: 15,
        ),
      ),
    );
  }

  Widget get tabBarIndicator {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicator: const TabIndicator(
          width: 50,
          height: 3,
          color: Colors.black,
          relativeOffsetY: 6,
        ),
      ),
    );
  }

  Widget get tabBarIndicator2 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const TabIndicator(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget get tabBarIndicator3 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicator: const TabIndicator(
          width: 4,
          height: 4,
          color: Colors.black,
          relativeOffsetY: 6,
        ),
      ),
    );
  }

  Widget get tabBarIndicator4 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: TabIndicator(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          borderRadius: BorderRadius.circular(80),
        ),
      ),
    );
  }

  Widget get tabBarIndicator5 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.black,
      ),
    );
  }

  Widget get tabBarIndicator6 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: TabIndicator(
          width: 60,
          height: 14,
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
          relativeOffsetY: 10,
        ),
      ),
    );
  }

  Widget get tabBarIndicator7 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: TabIndicator(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          onRadiusChanged: (offsetIndex) {
            if (offsetIndex.toInt() == 0) {
              return BorderRadius.horizontal(
                left: Radius.lerp(
                      const Radius.circular(40),
                      const Radius.circular(0),
                      offsetIndex,
                    ) ??
                    Radius.zero,
              );
            } else if (offsetIndex.toInt() == 1) {
              return BorderRadius.horizontal(
                right: Radius.lerp(
                      const Radius.circular(0),
                      const Radius.circular(40),
                      offsetIndex - 1,
                    ) ??
                    Radius.zero,
              );
            } else {
              return BorderRadius.horizontal(
                right: Radius.lerp(
                      const Radius.circular(40),
                      const Radius.circular(40),
                      offsetIndex - 2,
                    ) ??
                    Radius.zero,
              );
            }
          },
        ),
      ),
    );
  }

  Widget get tabBarIndicator8 {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: WrapperTabBar.textScale(
        controller: tabController,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: TabIndicator(
          width: 40,
          height: 8,
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
          relativeOffsetY: 8,
          onShaderChanged: (index) {
            double fillTabWidth =
                MediaQuery.of(context).size.width / tabs.length;
            return ui.Gradient.linear(
              ui.Offset(fillTabWidth * index + 30, 0),
              ui.Offset(fillTabWidth * index + 90, 0),
              [const Color(0xFFFFEF00), const Color(0xFFFF771F)],
            );
          },
        ),
      ),
    );
  }

  Widget get tabView {
    return TabBarView(
      controller: tabController,
      children: tabs.map((e) => Center(child: Text(e.toString()))).toList(),
    );
  }
}
