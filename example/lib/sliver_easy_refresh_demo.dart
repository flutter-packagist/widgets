import 'package:flutter/material.dart';
import 'package:packagist_widgets/refresh/ball/footer/ball_pulse_footer.dart';
import 'package:packagist_widgets/refresh/ball/header/ball_pulse_header.dart';
import 'package:packagist_widgets/widgets.dart';

class SliverEasyRefreshDemo extends StatefulWidget {
  const SliverEasyRefreshDemo({super.key});

  @override
  State<SliverEasyRefreshDemo> createState() => _SliverDemoState();
}

class _SliverDemoState extends State<SliverEasyRefreshDemo> {
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final ScrollController listScrollController = ScrollController();
  int count = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        titleText: 'Sliver EasyRefresh Demo',
      ),
      body: customScrollView,
    );
  }

  Widget get nestedScrollView {
    return WrapperEasyRefresh.builder(
      controller: refreshController,
      header: const BallPulseHeader(
        clamping: true,
        position: IndicatorPosition.locator,
      ),
      footer: const BallPulseFooter(
        position: IndicatorPosition.above,
      ),
      onRefresh: () async {
        print('onRefresh');
        await Future.delayed(const Duration(seconds: 1));
        refreshController.finishRefresh(IndicatorResult.success);
        count = 20;
        setState(() {});
      },
      onLoad: () async {
        print('onLoad');
        await Future.delayed(const Duration(seconds: 1));
        refreshController.finishLoad(IndicatorResult.success);
        setState(() {});
        count += 10;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      },
      childBuilder: (ectx, physics) => NestedScrollView(
        physics: physics,
        headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
          return [
            const HeaderLocator.sliver(clearExtent: false),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.blue.shade200,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.blue.shade100,
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: SliverPersistentHeaderBuilder(
                height: 50,
                builder: (BuildContext context, double offset) {
                  return Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.yellow,
                  );
                },
              ),
            ),
          ];
        },
        body: ListView.builder(
          physics: physics,
          // controller: listScrollController,
          padding: EdgeInsets.zero,
          itemCount: count,
          itemBuilder: (context, index) => ListTile(
            title: Text('Item $index'),
          ),
        ),
      ),
    );
  }

  Widget get customScrollView {
    return WrapperEasyRefresh(
      controller: refreshController,
      header: const BallPulseHeader(
        position: IndicatorPosition.locator,
      ),
      footer: const BallPulseFooter(
        position: IndicatorPosition.locator,
        infiniteOffset: 70,
      ),
      onRefresh: () async {
        print('onRefresh');
        await Future.delayed(const Duration(seconds: 1));
        refreshController.finishRefresh(IndicatorResult.success);
        count = 20;
        setState(() {});
      },
      onLoad: () async {
        print('onLoad');
        await Future.delayed(const Duration(seconds: 1));
        refreshController.finishLoad(IndicatorResult.success);
        setState(() {});
        count += 10;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      },
      child: CustomScrollView(
        controller: listScrollController,
        slivers: [
          const HeaderLocator.sliver(),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blue.shade200,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.blue.shade100,
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverPersistentHeaderBuilder(
              height: 50,
              builder: (BuildContext context, double offset) {
                return Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.yellow,
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: count,
            ),
          ),
          const FooterLocator.sliver(),
        ],
      ),
    );
  }
}
