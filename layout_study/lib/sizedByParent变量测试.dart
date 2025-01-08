import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MySizeBox extends SingleChildRenderObjectWidget {
  double width;
  double height;
  MySizeBox(
      {required this.width, required this.height, super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MySizeBoxRender(width, height);
  }
}

class MySizeBoxRender extends RenderProxyBox {
  MySizeBoxRender(this.width, this.height);

  double width;
  double height;

  // 当前组件的大小只取决于父组件传递的约束
  @override
  bool get sizedByParent => true;

  // performResize 中会调用
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    //设置当前元素宽高，遵守父组件的约束
    return constraints.constrain(Size(width, height));
  }

  // 这个是renderBox 的默认实现
  // @override
  // void performResize() {
  //   // default behavior for subclasses that have sizedByParent = true
  //   size = computeDryLayout(constraints);
  //   assert(size.isFinite);
  // }

  @override
  void performLayout() {
    child!.layout(
      BoxConstraints.tight(
          Size(min(size.width, width), min(size.height, height))),
      // 父容器是固定大小，子元素大小改变时不影响父元素
      // parentUseSize为false时，子组件的布局边界会是它自身，子组件布局发生变化后不会影响当前组件
      parentUsesSize: false,
    );
  }
}

class NewRender extends RenderObject {
  @override
  void debugAssertDoesMeetConstraints() {
    // TODO: implement debugAssertDoesMeetConstraints
  }

  @override
  // TODO: implement paintBounds
  Rect get paintBounds => throw UnimplementedError();

  @override
  void performLayout() {
    // TODO: implement performLayout
  }

  @override
  void performResize() {
    // TODO: implement performResize
  }

  @override
  // TODO: implement semanticBounds
  Rect get semanticBounds => throw UnimplementedError();

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // TODO: implement layout
    super.layout(constraints);
  }
}
