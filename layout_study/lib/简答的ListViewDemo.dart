
import 'dart:math';

import 'package:flutter/cupertino.dart';

class MyEasyListView extends StatelessWidget {
  const MyEasyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(textDirection: TextDirection.ltr, child: ListView(
        children: [
          SliverLayoutBuilder(
            builder: (context,con) {
              return Container(
                width: 150,
                height: 150,
                color: getRandomColor(),
              );
            }
          ),
          Container(
            width: 150,
            height: 150,
            color: getRandomColor(),
          ),
          Container(
            width: 150,
            height: 150,
            color: getRandomColor(),
          ),
          Container(
            width: 150,
            height: 150,
            color: getRandomColor(),
          ),
          Container(
            width: 150,
            height: 150,
            color: getRandomColor(),
          ),
        ],
      )),
    );
  }
  // 生成随机颜色
  Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // 红色 (0-255)
      random.nextInt(256), // 绿色 (0-255)
      random.nextInt(256), // 蓝色 (0-255)
      1.0, // 不透明度 (1.0 表示完全不透明)
    );
  }
}
