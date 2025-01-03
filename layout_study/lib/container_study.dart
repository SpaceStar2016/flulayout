import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:layout_study/common.dart';


class ContainerStudy {
  static Widget makeWidget(){
    final con00 = Container(
      height: 50,
      width: 50,
      color: Colors.yellow,
    );
    final con01 = ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 50,height: 50),
      child: ColoredBox(color: Colors.yellow,),
    );

    const con02 = ConRenderObjectWidget(
      constraints: BoxConstraints.tightFor(width: 50,height: 50),
      child: ColoredBox(color: Colors.yellow,),
    );

    const size00 = SizedBox(
      height: 50,
      width: 50,
      child: ColoredBox(
        color: Colors.yellow,
      ),
    );

    Widget testWidget = Center(
      child: Container(
        width: 50,
        height: 50,
        child: ColoredBox(
          color: Colors.yellow,
        )
      ),
    );
    return testWidget;
  }
}


class ConRenderObjectWidget extends SingleChildRenderObjectWidget {

  final BoxConstraints constraints;
  const ConRenderObjectWidget({required this.constraints, super.key,super.child});
  @override
  RenderObject createRenderObject(BuildContext context) {
    return ConRenderObjectRenderBox();
  }
}

class ConRenderObjectRenderBox extends RenderProxyBox {
  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints);
      BoxParentData boxData = child!.parentData as BoxParentData;
      boxData.offset = const Offset(30, 120);
      size = child!.size;
    }  else {
      size = const Size(50, 50);
    }
  }
}

