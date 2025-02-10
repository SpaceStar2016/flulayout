import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColumnTest{
  static Widget makeWidget() {
    final con00 = Center(
      child: Column(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            key: const ValueKey('A'),
            height: 50,
            width: 50,
            color: Colors.yellow,
          ),
          const Spacer(),
          Container(
            key: const ValueKey('B'),
            height: 50,
            width: 50,
            color: Colors.blue,
          ),
        ],
      ),
    );
    return con00;
  }
}