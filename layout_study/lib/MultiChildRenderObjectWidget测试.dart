import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MultiChildRenderObjectWidgetTest {
  static Widget makeWidget() {
    return Center(
      child: PolarStack(
        children: [
          // 使用 CustomPositioned 定位
          CustomPositioned(
            radius: 100,
            angle: 0, // 0弧度 = 右侧
            child: Container(width: 50, height: 50, color: Colors.red),
          ),
          CustomPositioned(
            radius: 100,
            angle: pi / 2, // 90度 = 下方
            child: Container(width: 50, height: 50, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

// 自定义 ParentData，存储极坐标参数
class CustomPositionedParentData extends ParentData {
  double radius; // 半径
  double angle; // 角度（弧度制）

  CustomPositionedParentData({this.angle = 90, this.radius = 10});
  @override
  String toString() => 'Position(radius: $radius, angle: ${angle}rad)';
}

class CustomPositioned extends ParentDataWidget<PolarStackParentData> {
  const CustomPositioned({
    super.key,
    required this.radius,
    required this.angle,
    required super.child,
  });

  final double radius;
  final double angle;

  // 将数据写入子组件的 ParentData
  @override
  void applyParentData(RenderObject renderObject) {
    // 获取 PolarStackParentData（而非直接转换到 CustomPositionedParentData）
    print('----applyParentData');
    final parentData = renderObject.parentData! as PolarStackParentData;
    // 初始化或更新 customData
    parentData.customData ??= CustomPositionedParentData();
    parentData.customData!
      ..radius = radius
      ..angle = angle;
  }

  // 控制何时需要更新 ParentData
  @override
  bool shouldRebuild(covariant CustomPositioned oldWidget) {
    return radius != oldWidget.radius || angle != oldWidget.angle;
  }

  @override
  Type get debugTypicalAncestorWidgetClass => PolarStack;
}

class PolarStack extends MultiChildRenderObjectWidget {
  const PolarStack({super.key, super.children});

  // 创建 RenderObject 并关联 ParentData 类型
  @override
  RenderObject createRenderObject(BuildContext context) => RenderPolarStack();
}

// 关联 ParentData 类型
class PolarStackParentData extends ContainerBoxParentData<RenderBox> {
  CustomPositionedParentData? customData;
}

// 实现布局逻辑的 RenderObject
class RenderPolarStack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, PolarStackParentData>, // 指定 ParentData 类型
        RenderBoxContainerDefaultsMixin<RenderBox, PolarStackParentData> {

  // 覆盖 setupParentData，初始化自定义 ParentData
  @override
  void setupParentData(RenderBox child) {
    print('----setupParentData');
    if (child.parentData is! PolarStackParentData) {
      child.parentData = PolarStackParentData();
    }
  }

  @override
  void performLayout() {
    final size00 = constraints.biggest;
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as PolarStackParentData; // 直接转换为 PolarStackParentData
      final customData = childParentData.customData!;
      final centerX = size00.width / 2;
      final centerY = size00.height / 2;
      final x = centerX + customData.radius * cos(customData.angle);
      final y = centerY + customData.radius * sin(customData.angle);
      // 这里必须设置为true
      child.layout(constraints.loosen(),parentUsesSize: true);
      childParentData.offset = Offset(x - child.size.width / 2, y - child.size.height / 2);
      child = childParentData.nextSibling;
    }
    size = constraints.constrain(size00);
  }
  @override
  void paint(PaintingContext context, Offset offset) {
    //实现了遍历绘制
    defaultPaint(context, offset);
  }
}
