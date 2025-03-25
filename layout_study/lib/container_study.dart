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

    Widget testWidget00 = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 50,
          height: 50,
          child: ColoredBox(
            color: Colors.yellow,
          )
        ),
      ),
    );
    Widget testWidget01 = Center(
      child: Expanded(
        child: Container(
            width: 50,
            height: 50,
            child: ColoredBox(
              color: Colors.yellow,
            )
        ),
      ),
    );

    Widget testWidget02 = Center(
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Container(
              width: 50,
              height: 50,
              child: ColoredBox(
                color: Colors.yellow,
              )
          ),
          Container(
              width: 50,
              height: 50,
              child: ColoredBox(
                color: Colors.blue,
              )
          ),
        ],
      ),
    );
    return con02;
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
  @override
  void paint(PaintingContext context, Offset offset) {
    print('--paint---');
    super.paint(context, offset);
  }
}


// abstract class ABC {
//   paint();
// }
//
// abstract class Man extends ABC {
//
// }
//
// class Body extends Man {
//   @override
//   paint() {
//     // TODO: implement paint
//     throw UnimplementedError();
//   }
//
// }

