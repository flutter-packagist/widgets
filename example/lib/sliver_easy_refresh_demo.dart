import 'package:flutter/material.dart';
import 'package:widgets/refresh/ball/footer/ball_pulse_footer.dart';
import 'package:widgets/refresh/ball/header/ball_pulse_header.dart';
import 'package:widgets/widgets.dart';

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
      body: nestedScrollView,
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
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: SliverPersistentHeaderBuilder(
            min: 0,
            max: 200,
            builder: (BuildContext context, double offset) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.red,
              );
            },
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: SliverPersistentHeaderBuilder(
            min: MediaQuery.of(context).padding.top + kToolbarHeight,
            max: 500,
            builder: (BuildContext context, double offset) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
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
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.blue.shade50,
                    ),
                  ],
                ),
              );
            },
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
            (context, index) => ListTile(
              title: Text('Item $index'),
            ),
            childCount: 100,
          ),
        ),
      ],
    );
  }
}
