import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';

class TagsDemo extends StatefulWidget {
  const TagsDemo({super.key});

  @override
  State<TagsDemo> createState() => _TagsDemoState();
}

class _TagsDemoState extends State<TagsDemo> {
  final List<String> tags = ["标签1", "标签2", "标签3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "TagsDemo",
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // WrapperTags(tags: tags),
            // WrapperTags(
            //   tags: tags,
            //   itemStyle: const TextStyle(color: Colors.blue, fontSize: 20),
            //   itemColor: Colors.grey.shade200,
            //   itemBorderRadius: BorderRadius.circular(30),
            //   itemPadding: const EdgeInsets.symmetric(
            //     horizontal: 20,
            //     vertical: 10,
            //   ),
            //   minimumSize: Size.zero,
            //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // ),
            // WrapperTags(
            //   tags: tags,
            //   builder: (context, index) => const Text("自定义标签"),
            // ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 379.42857142857144,
              height: 10,
              color: Colors.red,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 102.0,
                height: 10,
                color: Colors.red,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 204.0,
                height: 10,
                color: Colors.red,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 306.0,
                height: 10,
                color: Colors.red,
              ),
            ),
            WrapperTags(
              margin: const EdgeInsets.only(left: 16, top: 22, right: 16),
              // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              tags: const [
                "标签1",
                "标签2",
                "标签3",
                "iiii",
                "标签4",
                "标签5",
                "标签6",
                "iiiii",
                "标签7",
                "标签8",
                "标签9",
                "iiiiii",
                "标签7",
                "标签8",
                "标签9",
                "iiiiiii",
                "自定义标签",
                "自定义标签",
                "标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4",
                "标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4",
                "自定义标签",
                "iiiiiii",
                "自定义标签",
                "自定义标签",
              ],
              itemStyle: const TextStyle(color: Colors.blue, fontSize: 20),
              itemColor: Colors.grey.shade200,
              itemBorderRadius: BorderRadius.circular(30),
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              maxLines: 7,
            ),
          ],
        ),
      ),
    );
  }
}
