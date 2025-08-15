import 'package:example/visibility_detector_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bubble_box_demo.dart';
import 'easy_refresh_demo.dart';
import 'label_image_demo.dart';
import 'network_image_demo.dart';
import 'sliver_demo.dart';
import 'sliver_easy_refresh_demo.dart';
import 'tab_bar_demo.dart';
import 'tags_demo.dart';
import 'text_button_demo.dart';
import 'text_field_demo.dart';
import 'text_height_demo.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: true,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

Map<String, Widget> routes = {
  "网络图片加载": const NetworkImageDemo(),
  "TextButton": const TextButtonDemo(),
  "TextField": const TextFieldDemo(),
  "EasyRefresh": const EasyRefreshDemo(),
  "TabBar": const TabBarDemo(),
  "Sliver": const SliverDemo(),
  "Sliver EasyRefresh": const SliverEasyRefreshDemo(),
  "Tags": const TagsDemo(),
  "气泡框": const BubbleBoxDemo(),
  "可见性": const VisibilityDetectorDemo(),
  "文本高度对比": const TextHeightDemo(),
  "网络图片附加标签": const LabelImageDemo(),
};

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
        elevation: 1,
      ),
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
}
