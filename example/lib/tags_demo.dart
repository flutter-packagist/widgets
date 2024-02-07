import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
            WrapperTags(tags: tags),
            WrapperTags(
              tags: tags,
              itemStyle: const TextStyle(color: Colors.blue, fontSize: 20),
              itemColor: Colors.grey.shade200,
              itemBorderRadius: BorderRadius.circular(30),
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            WrapperTags(
              tags: tags,
              builder: (context, index) => const Text("自定义标签"),
            ),
            WrapperTags(
              tags: const [
                "标签1",
                "标签2",
                "标签3",
                "标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4标签4",
                "自定义标签"
              ],
              itemStyle: const TextStyle(color: Colors.blue, fontSize: 20),
              itemColor: Colors.grey.shade200,
              itemBorderRadius: BorderRadius.circular(30),
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
