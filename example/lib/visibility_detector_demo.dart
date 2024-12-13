import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class VisibilityDetectorDemo extends StatefulWidget {
  const VisibilityDetectorDemo({super.key});

  @override
  State<VisibilityDetectorDemo> createState() => _VisibilityDetectorDemoState();
}

class _VisibilityDetectorDemoState extends State<VisibilityDetectorDemo> {
  Map<String, Widget> routes = {
    "ListView": const ListViewDemo(),
    "SingleChildScrollView": const SingleScroll(),
    "WaterfallFlow": const WaterfallFlowDemo(),
    "NestedScrollView": const NestedScrollViewDemo(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(titleText: "Visibility Detector Demo"),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor:
                index % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade200,
            title: Text(routes.keys.elementAt(index)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return routes.values.elementAt(index);
              }));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    VisibilityDetectorController.instance.clearShownKeys();
  }
}

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(titleText: "ListViewDemo"),
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return VisibilityDetector(
              visibleFraction: 0.8,
              triggerOnce: true,
              key: Key('list_item_$index'),
              child: Container(
                height: 1000,
                color:
                    index.isEven ? Colors.blue.shade100 : Colors.red.shade100,
                alignment: Alignment.center,
                child: Text('Item $index'),
              ),
              onVisibilityChanged: (info) {
                print('Item $index is ${info.visibleFraction * 100}% visible');
              },
            );
          },
        ),
      ),
    );
  }
}

class SingleScroll extends StatelessWidget {
  const SingleScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(titleText: "SingleChildScrollView"),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(10, (index) {
            return VisibilityDetector(
              visibleFraction: 0.8,
              triggerOnce: true,
              key: Key('single_item_$index'),
              child: Container(
                height: 1000,
                color:
                    index.isEven ? Colors.blue.shade100 : Colors.red.shade100,
                alignment: Alignment.center,
                child: Text('Item $index'),
              ),
              onVisibilityChanged: (info) {
                print('Item $index is ${info.visibleFraction * 100}% visible');
              },
            );
          }),
        ),
      ),
    );
  }
}

class WaterfallFlowDemo extends StatelessWidget {
  const WaterfallFlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(titleText: "ListViewDemo"),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: WaterfallFlow.builder(
          gridDelegate:
              const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return VisibilityDetector(
              visibleFraction: 0.8,
              triggerOnce: true,
              key: Key('water_item_$index'),
              child: Container(
                height: 200 + (index % 3) * 300,
                color:
                    index.isEven ? Colors.blue.shade100 : Colors.red.shade100,
                alignment: Alignment.center,
                child: Text('Item $index'),
              ),
              onVisibilityChanged: (info) {
                print('Item $index is ${info.visibleFraction * 100}% visible');
              },
            );
          },
        ),
      ),
    );
  }
}

class NestedScrollViewDemo extends StatelessWidget {
  const NestedScrollViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(titleText: "ListViewDemo"),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
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
              child: Container(
                height: 200,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text('Header'),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return VisibilityDetector(
              visibleFraction: 0.8,
              triggerOnce: true,
              key: Key('nested_item_$index'),
              child: Container(
                height: 1000,
                color:
                    index.isEven ? Colors.blue.shade100 : Colors.red.shade100,
                alignment: Alignment.center,
                child: Text('Item $index'),
              ),
              onVisibilityChanged: (info) {
                print('Item $index is ${info.visibleFraction * 100}% visible');
              },
            );
          },
        ),
      ),
    );
  }
}
