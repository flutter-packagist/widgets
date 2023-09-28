import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class NetworkImageDemo extends StatefulWidget {
  const NetworkImageDemo({super.key});

  @override
  State<NetworkImageDemo> createState() => _NetworkImageDemoState();
}

class _NetworkImageDemoState extends State<NetworkImageDemo> {
  List<String> imageList = [
    "https://fastly.picsum.photos/id/741/200/306.jpg?hmac=MsmqX1XqL3Anc0CszL7Y1aDRCXGOV7WYE1Iw718IClU",
    "https://fastly.picsum.photos/id/741/200/306.jpg?hmac=MsmqX1XqL3Anc0CszL7Y1aDRCXGOV7WYE1Iw718IClU",
    "https://fastly.picsum.photos/id/979/200/300.jpg?hmac=VPyKJONiCJZ0uDkMSUYGHAmGqBjjH307k7K8AOmqQSM",
    "https://fastly.picsum.photos/id/496/200/301.jpg?hmac=b294AzkE0TQZ-3kulKIGoNvBe_L1esjN4AqrlzrmrkY",
    "https://images.pexels.com/photos/6506865/pexels-photo-6506865.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
    "https://images.pexels.com/photos/7555440/pexels-photo-7555440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
  ];

  @override
  void initState() {
    super.initState();
    StaticCachedNetworkImage.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WrapperAppBar(
        titleText: "网络图片加载",
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: WrapperCachedNetworkImage(
                width: double.infinity,
                height: 200,
                imageUrl: imageList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
