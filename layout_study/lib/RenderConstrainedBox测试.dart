// RenderConstrainedBox:
// SizeBox  = 》 SingleChildRenderObjectWidget =》 RenderConstrainedBox =》 RenderProxyBox =》 RenderBox
//
// 布局规则：
// 他有一个属性additionalConstraints 属性，这个属性是用于提供额外的约束信息的
// 在布局阶段，他会根据additionalConstraints 和 父控件传递的约束信息(constraints)执行自身的布局算法
// 布局算法如下：
// 调用additionalConstraints 的 enforce 方法把 constraints 传入把 最大最小宽高限制在constraints的最大最小宽高里面。
// 比如传入的additionalConstraints 是紧约束，最大最小的宽高
//
// 属于 RenderConstrainedBox 的组件有
// SizeBox
// ConstrainedBox
// 虽然SizeBox 和 ConstrainedBox 都继承自 RenderConstrainedBox 但是他们有着本质的区别
// 1.SizeBox, 只能向下传递紧约束
// 2.ConstrainedBox 松紧约束都可以


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyRenderConstrainedBoxWidgetTest {
  static Widget makeWidget() {
    return Center(
      child: MyRenderConstrainedBoxWidget(
        constrained: const BoxConstraints.tightFor(width: 20,height: 20),
        child: Container(
          width: 150,
          height: 150,
          color: Colors.yellow,
        ),
      ),
    );
  }
}


class MyRenderConstrainedBoxWidget extends SingleChildRenderObjectWidget {

  final BoxConstraints constrained;
  const MyRenderConstrainedBoxWidget({super.key,super.child,required this.constrained});
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderConstrainedBox(additionalConstraints: constrained);
  }
}
