import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:layout_study/utils.dart';

class MyRelayoutBoundary extends StatefulWidget {
  const MyRelayoutBoundary({super.key});

  @override
  State<MyRelayoutBoundary> createState() => _MyRelayoutBoundaryState();
}

class _MyRelayoutBoundaryState extends State<MyRelayoutBoundary> {
  int number = 1;
  bool change = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        number++;
        setState(() {});
      },
      child: Row(
        children: [
          const MyRelayoutBCusView00(
            child: Text('Column00',style: TextStyle(
              fontSize: 16,
            ),),
          ),
          const Spacer(),
          SizedBox(
            height: 50,
            width: 100,
            child: MyRelayoutBCusView01(
              child: Text('Column00--$number',style: TextStyle(
                fontSize: 16,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}

class MyRelayoutBCusView00 extends SingleChildRenderObjectWidget {
  const MyRelayoutBCusView00({super.key, super.child});
  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyRelayoutBCusViewRe00();
  }
}

class MyRelayoutBCusViewRe00 extends RenderProxyBox {
  @override
  void performLayout() {
    print('performLayout -- MyRelayoutBCusViewRe00');
    super.performLayout();
  }
}


class MyRelayoutBCusView01 extends SingleChildRenderObjectWidget {
  const MyRelayoutBCusView01({super.key, super.child});
  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyRelayoutBCusViewRe01();
  }
}

class MyRelayoutBCusViewRe01 extends RenderProxyBox {
  @override
  void performLayout() {
    print('performLayout -- MyRelayoutBCusViewRe01');
    super.performLayout();
  }
}

// class LeftRightParentData extends ContainerBoxParentData<RenderBox> {}
// //
// class RenderLeftRight extends RenderBox
//     with
//         ContainerRenderObjectMixin<RenderBox, LeftRightParentData>,
//         RenderBoxContainerDefaultsMixin<RenderBox, LeftRightParentData> {
//
//   // 初始化每一个child的parentData
//   @override
//   void setupParentData(RenderBox child) {
//     if (child.parentData is! LeftRightParentData)
//       child.parentData = LeftRightParentData();
//   }
//
//   @override
//   void performLayout() {
//     final BoxConstraints constraints = this.constraints;
//     RenderBox leftChild = firstChild!;
//
//     LeftRightParentData childParentData =
//     leftChild.parentData! as LeftRightParentData;
//
//     RenderBox rightChild = childParentData.nextSibling!;
//
//     //我们限制右孩子宽度不超过总宽度一半
//     rightChild.layout(
//       constraints.copyWith(maxWidth: constraints.maxWidth / 2),
//       parentUsesSize: true,
//     );
//
//     //调整右子节点的offset
//     childParentData = rightChild.parentData! as LeftRightParentData;
//     childParentData.offset = Offset(
//       constraints.maxWidth - rightChild.size.width,
//       0,
//     );
//
//     // layout left child
//     // 左子节点的offset默认为（0，0），为了确保左子节点始终能显示，我们不修改它的offset
//     leftChild.layout(
//       //左侧剩余的最大宽度
//       constraints.copyWith(
//         maxWidth: constraints.maxWidth - rightChild.size.width,
//       ),
//       parentUsesSize: true,
//     );
//
//     //设置LeftRight自身的size
//     size = Size(
//       constraints.maxWidth,
//       max(leftChild.size.height, rightChild.size.height),
//     );
//   }
//
//   @override
//   void paint(PaintingContext context, Offset offset) {
//     defaultPaint(context, offset);
//   }
//
//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     return defaultHitTestChildren(result, position: position);
//   }
// }
