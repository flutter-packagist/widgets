import 'package:flutter/material.dart';
import 'package:packagist_network/network.dart';
import 'package:packagist_widgets/widgets.dart';

class EasyRefreshDemo extends StatefulWidget {
  const EasyRefreshDemo({super.key});

  @override
  State<EasyRefreshDemo> createState() => _EasyRefreshDemoState();
}

class _EasyRefreshDemoState extends State<EasyRefreshDemo> {
  final RefreshNotifier<String> _refreshNotifier = RefreshNotifier<String>();

  @override
  void initState() {
    super.initState();
    HttpRequest().init(HttpRequestSetting());
    _refreshNotifier.setup(
      requestUrl: "https://www.baidu.com",
      jsonParse: (data) {
        return List.generate(10, (index) => "Item $index");
      },
      onSuccess: (data, loadMore) {
        _refreshNotifier.easyRefreshController
            .finishLoad(IndicatorResult.noMore);
      },
      onFailed: (code, error, loadMore) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: WrapperAppBar(
        titleText: "EasyRefresh",
        backgroundColor: Colors.white,
      ),
      body: WrapperEasyRefresh(
        refreshNotifier: _refreshNotifier,
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Item $index"),
            );
          },
        ),
      ),
    );
  }
}
