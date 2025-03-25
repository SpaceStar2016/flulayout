import 'package:flutter/material.dart';

void main() {
  // runApp(
  //   Container(
  //     width: 50,
  //     height: 50,
  //     color: Colors.yellow,
  //   ),
  // );

  // runApp(
  //   ConstrainedBox(
  //     constraints: BoxConstraints.tight(Size(50,50)),
  //     child : ColoredBox(color: Colors.yellow)
  //   ),
  // );

  // runApp(
  //   ConstrainedBox(
  //       constraints: BoxConstraints.loose(Size(50,50)),
  //       child : ColoredBox(color: Colors.yellow)
  //   ),
  // );

  runApp(
    Center(
      child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size(50,50)),
          child : ColoredBox(color: Colors.yellow)
      ),
    ),
  );

  // runApp(
  //   OverflowBox(
  //     minWidth: 50,
  //     maxWidth: 50,
  //     maxHeight: 50,
  //     minHeight: 50,
  //     child: ConstrainedBox(
  //         constraints: BoxConstraints.loose(Size(50,50)),
  //         child : ColoredBox(color: Colors.yellow)
  //     ),
  //   ),
  // );

  // runApp(
  //   CustomSingleChildLayout(
  //     delegate: _CustomDelegate(),
  //     child: ConstrainedBox(
  //         constraints: BoxConstraints.loose(Size(50,50)),
  //         child : ColoredBox(color: Colors.yellow)
  //     ),
  //   ),
  // );

}

class _CustomDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // 限制子组件最大尺寸为父容器的一半
    return BoxConstraints.tight(Size(50,50));
  }
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0,0);
  }

  @override
  bool shouldRelayout(_CustomDelegate oldDelegate) => false; // 无需重新布局
}