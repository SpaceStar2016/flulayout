import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStackTest {
  static Widget makeWidget() {
    return Center(
      child: Stack(
        textDirection: TextDirection.ltr,
        children: [
          // Container(width: 150, height: 150, color: Colors.yellow),
          // Container(width: 75, height: 75, color: Colors.cyan),
          // 使用 CustomPositioned 定位
          Positioned(
            left: 20,
            right: 20,// 0弧度 = 右侧
            child: ColoredBox(color: Colors.amber),
          ),
          Positioned(
            top: 100,
            left: 0, // 0弧度 = 右侧
            child: Container(width: 50, height: 50, color: Colors.red),
          ),
          Positioned(
            top: 200,
            left: 0, // 90度 = 下方
            child: Container(width: 50, height: 50, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
