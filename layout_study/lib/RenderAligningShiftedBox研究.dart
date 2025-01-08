import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyRenderAligningShiftedBoxWidgetTest {
  static Widget makeWidget() {
    return Center(
      child: MyRenderAligningShiftedBoxWidget(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.yellow,
        ),
      ),
    );
  }
}

class MyRenderAligningShiftedBoxWidget extends SingleChildRenderObjectWidget {
  const MyRenderAligningShiftedBoxWidget({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyRenderAligningShiftedBoxRender(textDirection: TextDirection.rtl);
  }
}

class MyRenderAligningShiftedBoxRender extends RenderAligningShiftedBox {
  MyRenderAligningShiftedBoxRender({required super.textDirection});

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
      size = child!.size;
      alignChild();
    } else {
      size = constraints.constrain(Size(0,0));
    }
  }
  @override
  void paint(PaintingContext context, Offset offset) {

  }

}
