# Widgets

+ [Example](https://github.com/flutter-packagist/widgets)

## WrapperEasyRefresh

### Example

#### 1. Model

``` dart
class RefreshModel extends BaseModel {
  final RefreshNotifier<ItemModel> refreshNotifier =
      RefreshNotifier<ItemModel>();
}

class ItemModel {
  String title;
  String subTitle;
  String route;

  ItemModel(this.title, this.subTitle, this.route);

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        asString(json, 'title'),
        asString(json, 'title'),
        asString(json, 'title'),
      );
}
```

#### 2. Controller

``` dart
class RefreshController extends BaseController<RefreshModel> {
  @override
  RefreshModel model = RefreshModel();

  @override
  void onReady() {
    super.onReady();
    setupRefresh();
  }
}

extension Data on RefreshController {
  RefreshNotifier get refreshNotifier => model.refreshNotifier;
}

extension Network on RefreshController {
  Future<void> setupRefresh() async {
    refreshNotifier.setup(
      requestUrl: "list",
      requestParams: {
        "limit": "10",
      },
      pageSize: 10,
      jsonParse: (json) =>
          asList(json, "data").map((e) => ItemModel.fromJson(e)).toList(),
      onBegin: (loadMore) {},
      onSuccess: (data, loadMore) {
        logW(data);
        update();
      },
      onFailed: (code, error, loadMore) {},
    );
    await refreshNotifier.refresh();
  }
}
```

#### 3. Page

``` dart
class RefreshPage extends BasePage<RefreshController, RefreshModel> {
  const RefreshPage({super.key});

  @override
  RefreshController putController() => Get.put(RefreshController());

  @override
  Widget? get appBar => AppBar(
    title: const Text('下拉刷新和上拉加载更多'),
  );

  @override
  Widget get body {
    logW(controller.refreshNotifier.listSize);
    return WrapperEasyRefresh(
      refreshNotifier: controller.refreshNotifier,
      child: ListView.builder(
        itemCount: controller.refreshNotifier.listSize,
        itemBuilder: (context, index) {
          var itemData = controller.refreshNotifier.listData[index];
          return ListTile(
            tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200],
            title: Text("当前Item序号： ${itemData.title}\n"
                "当前Item序号： ${itemData.title}\n"
                "当前Item序号： ${itemData.title}\n"
                "当前Item序号： ${itemData.title}"),
          );
        },
      ),
    );
  }
}
```
