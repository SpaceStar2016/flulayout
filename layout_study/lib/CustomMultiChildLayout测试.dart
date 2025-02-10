import 'package:flutter/material.dart';


class MyCustomMultiChildLayoutTest{
  static Widget makeWidget() {
    return CustomMultiChildLayoutExample();
  }
}

class CustomMultiChildLayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomMultiChildLayout(
        delegate: MyLayoutDelegate(),
        children: [
          LayoutId(
            id: 1,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
          LayoutId(
            id: 2,
            child: Container(
              width: 80,
              height: 80,
              color: Colors.blue,
            ),
          ),
          LayoutId(
            id: 3,
            child: Container(
              width: 60,
              height: 60,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class MyLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // 获取第一个子元素的位置
    if (hasChild(1)) {
      final box1 = layoutChild(1, BoxConstraints.loose(size));
      positionChild(1, Offset(0, 0));
    }

    // 获取第二个子元素的位置
    if (hasChild(2)) {
      final box2 = layoutChild(2, BoxConstraints.loose(size));
      positionChild(2, Offset(100, 0)); // 将第二个子元素放在第一个子元素的右边
    }

    // 获取第三个子元素的位置
    if (hasChild(3)) {
      final box3 = layoutChild(3, BoxConstraints.loose(size));
      positionChild(3, Offset(200, 0)); // 将第三个子元素放在第二个子元素的右边
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
