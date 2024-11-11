import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';

class SliverDemo extends StatefulWidget {
  const SliverDemo({super.key});

  @override
  State<SliverDemo> createState() => _SliverDemoState();
}

class _SliverDemoState extends State<SliverDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WrapperAppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        titleText: 'Sliver Demo',
      ),
      body: nestedScrollView,
    );
  }

  Widget get nestedScrollView {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext ctx, bool innerBoxIsScrolled) {
        return [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SliverPersistentHeaderBuilder(
              min: MediaQuery.of(context).padding.top + kToolbarHeight,
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
      body: Scaffold(
        body: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.pink,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 100,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item $index'),
                ),
              ),
            ),
          ],
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
