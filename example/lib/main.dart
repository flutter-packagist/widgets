import 'package:flutter/material.dart';

import 'network_image_demo.dart';

void main() {
  runApp(const MyApp());
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