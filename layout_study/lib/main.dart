import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layout_study/%E5%A4%9A%E4%B8%AAcontainer%E6%B5%8B%E8%AF%95.dart';
import 'package:layout_study/%E6%B5%8B%E8%AF%95initState%E8%B0%83%E7%94%A8%E6%97%B6%E6%9C%BA.dart';
import 'package:layout_study/%E7%AE%80%E7%AD%94%E7%9A%84ListViewDemo.dart';
import 'package:layout_study/%E8%87%AA%E5%AE%9A%E4%B9%89Viewport%E6%B5%8B%E8%AF%95.dart';
import 'package:layout_study/%E8%BE%B9%E7%95%8C%E5%B8%83%E5%B1%80%E6%B5%8B%E8%AF%95.dart';
import 'package:layout_study/Stack%E6%B5%8B%E8%AF%95.dart';
import 'package:layout_study/sizedByParent%E5%8F%98%E9%87%8F%E6%B5%8B%E8%AF%95.dart';

import 'CustomMultiChildLayout测试.dart';
import 'CustomScrollView使用Demo.dart';
import 'OverFlowBox测试.dart';
import 'RenderAligningShiftedBox研究.dart';
import 'RenderConstrainedBox测试.dart';
import 'Row测试.dart';
import 'StatefulWidget测试.dart';
import 'container_study.dart';
import 'Stack测试.dart';
import 'MultiChildRenderObjectWidget测试.dart';
void main() {

  // runApp(MyRenderConstrainedBoxWidgetTest.makeWidget());

  // runApp(MyRenderAligningShiftedBoxWidgetTest.makeWidget());
  //

  // runApp(MyStatefulWidget());
  // runApp(ContainerStudy.makeWidget());
  // runApp(MultiChildRenderObjectWidgetTest.makeWidget());
  // runApp(RowTest.makeWidget());
  // runApp(DuoGeContainerTest.makeWidget());
  // runApp(MyStackTest.makeWidget());
  // runApp(CustomScrollViewExample());
  runApp(MyEasyListView());
  // runApp(MyCustomMultiChildLayoutTest.makeWidget());
  // runApp(MaterialApp(home: MyRelayoutBoundary()));

  // final GlobalKey parentKey = GlobalKey();
  // runApp(TestInitSCall(key: parentKey,));


  // runApp(
  //   ConstrainedBox(
  //     constraints: BoxConstraints.loose(Size(50, 50)),
  //     child: ColoredBox(
  //       color: Colors.yellow,
  //     ),
  //   ),
  // );


  // runApp(ConstrainedBox(
  //   constraints: BoxConstraints.loose(Size( 50, 50)),
  //   child: ColoredBox(
  //     color: Colors.yellow,
  //   ),
  // ),);


  // runApp(SizedBox(
  //   width: 50,
  //   height: 50,
  //   child: ColoredBox(
  //     color: Colors.yellow,
  //   ),
  // ),);
}
