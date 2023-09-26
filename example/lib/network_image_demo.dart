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
    StaticCachedNetworkImage.init();
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
            imageUrl: "https://fastly.picsum.photos/id/741/200/306.jpg?hmac=MsmqX1XqL3Anc0CszL7Y1aDRCXGOV7WYE1Iw718IClU",
          ),
        ],
      ),
    );
  }
}
