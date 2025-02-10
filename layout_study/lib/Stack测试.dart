import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStackTest {
  static Widget makeWidget() {
    return Center(
      child: Stack(
        textDirection: TextDirection.rtl,
        children: [
          // 使用 CustomPositioned 定位
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
