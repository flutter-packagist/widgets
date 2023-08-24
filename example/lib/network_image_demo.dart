import 'package:flutter/material.dart';
import 'package:widgets/image/cached_image_widget.dart';

class NetworkImageDemo extends StatefulWidget {
  const NetworkImageDemo({super.key});

  @override
  State<NetworkImageDemo> createState() => _NetworkImageDemoState();
}

class _NetworkImageDemoState extends State<NetworkImageDemo> {
  @override
  void initState() {
    super.initState();
    StaticCachedNetworkImage.init(
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error, controller) {
        return IconButton(
          onPressed: () => controller.refresh(),
          icon: const Icon(Icons.error),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("网络图片加载"),
        elevation: 1,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WrapperCachedNetworkImage(
            width: 200,
            height: 200,
            imageUrl: "https://picsum.photos/250?image=122222",
          ),
        ],
      ),
    );
  }
}
