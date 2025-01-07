import 'package:flutter/material.dart';
import 'package:layout_study/%E6%B5%8B%E8%AF%95initState%E8%B0%83%E7%94%A8%E6%97%B6%E6%9C%BA.dart';
import 'package:layout_study/%E8%BE%B9%E7%95%8C%E5%B8%83%E5%B1%80%E6%B5%8B%E8%AF%95.dart';
import 'package:layout_study/sizedByParent%E5%8F%98%E9%87%8F%E6%B5%8B%E8%AF%95.dart';

import 'container_study.dart';

void main() {
  // runApp(MaterialApp(home: MyRelayoutBoundary()));

  // final GlobalKey parentKey = GlobalKey();
  // runApp(TestInitSCall(key: parentKey,));


  runApp(ConstrainedBox(
    constraints: BoxConstraints.loose(Size( 50, 50)),
    child: ColoredBox(
      color: Colors.yellow,
    ),
  ),);

  // runApp(SizedBox(
  //   width: 50,
  //   height: 50,
  //   child: ColoredBox(
  //     color: Colors.yellow,
  //   ),
  // ),);


}
