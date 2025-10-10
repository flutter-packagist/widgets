import 'package:flutter/material.dart';
import 'package:packagist_widgets/widgets.dart';

class LabelImageBrowserDemo extends StatefulWidget {
  const LabelImageBrowserDemo({super.key});

  @override
  State<LabelImageBrowserDemo> createState() => _LabelImageBrowserDemoState();
}

class _LabelImageBrowserDemoState extends State<LabelImageBrowserDemo> {
  List<ImageBlock> images = [
    ImageBlock(
      image:
          "https://cp4.100.com.tw/images/works/202408/20/api_2131628_1724146396_Uw3N5p3p0l.jpg!10961t1500-v2.jpg",
      labels: [
        LabelItem(name: "吊柜", percentX: 0.75, percentY: 0.4),
        LabelItem(name: "艺术画", percentX: 0.45, percentY: 0.5),
        LabelItem(name: "沙发", percentX: 0.35, percentY: 0.7),
      ],
    ),
    ImageBlock(
      image:
          "https://cp4.100.com.tw/images/works/202408/20/api_2131628_1724146396_Uw3N5p3p0l.jpg!10961t1500-v2.jpg",
      labels: [
        LabelItem(name: "吊柜", percentX: 0.75, percentY: 0.4),
        LabelItem(name: "艺术画", percentX: 0.45, percentY: 0.5),
        LabelItem(name: "沙发", percentX: 0.35, percentY: 0.7),
      ],
    ),
    ImageBlock(
      image:
          "https://cp4.100.com.tw/images/works/202408/20/api_2131628_1724146315_T14buIm3xY.jpg!10961t1500-v2.jpg",
      labels: [
        LabelItem(name: "吊灯", percentX: 0.55, percentY: 0.17),
        LabelItem(name: "花瓶", percentX: 0.55, percentY: 0.5),
        LabelItem(name: "柜子", percentX: 0.4, percentY: 0.7),
      ],
    ),
    ImageBlock(
      image:
          "https://cp4.100.com.tw/images/works/202505/16/api_2012032_1747362772_TBECTIDzJt.jpg!10309t1500-v2.jpg",
      labels: [
        LabelItem(name: "吊頂燈帶", percentX: 0.3, percentY: 0.3),
        LabelItem(name: "電視墻", percentX: 0.4, percentY: 0.5),
        LabelItem(name: "沙發", percentX: 0.7, percentY: 0.7),
      ],
    ),
    ImageBlock(
      image:
          "https://cp4.100.com.tw/images/works/202301/03/api_2114251_1672736564_sk5rc5Iy49.jpg!t1000.webp",
      labels: [
        LabelItem(name: "壁櫃", percentX: 0.53, percentY: 0.47),
        LabelItem(name: "冰箱", percentX: 0.69, percentY: 0.6),
        LabelItem(name: "燃氣灶", percentX: 0.2, percentY: 0.8),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WrapperAppBar(
        titleText: "网络图片附加标签",
        backgroundColor: Colors.white,
      ),
      body: LabelImageBrowser(
        images: images,
      ),
    );
  }
}
