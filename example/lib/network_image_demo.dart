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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://fastly.picsum.photos/id/741/200/306.jpg?hmac=MsmqX1XqL3Anc0CszL7Y1aDRCXGOV7WYE1Iw718IClU",
            ),
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://fastly.picsum.photos/id/741/200/306.jpg?hmac=MsmqX1XqL3Anc0CszL7Y1aDRCXGOV7WYE1Iw718IClU",
            ),
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://fastly.picsum.photos/id/979/200/300.jpg?hmac=VPyKJONiCJZ0uDkMSUYGHAmGqBjjH307k7K8AOmqQSM",
            ),
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://fastly.picsum.photos/id/496/200/301.jpg?hmac=b294AzkE0TQZ-3kulKIGoNvBe_L1esjN4AqrlzrmrkY",
            ),
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://images.pexels.com/photos/6506865/pexels-photo-6506865.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
            ),
            WrapperCachedNetworkImage(
              width: 200,
              height: 200,
              imageUrl:
                  "https://images.pexels.com/photos/7555440/pexels-photo-7555440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
            ),
          ],
        ),
      ),
    );
  }
}
