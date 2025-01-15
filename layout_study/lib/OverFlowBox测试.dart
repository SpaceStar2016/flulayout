import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyOverFlowBoxTest {
  static Widget makeWidget() {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    const ww = Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32,vertical: 100),
        child: OverflowBox(
          minWidth: 360,
          maxWidth: 360,
          child: SizedBox(
            width: 360,
            height: 400,
            child: ColoredBox(
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
    return ww;
  }
}
