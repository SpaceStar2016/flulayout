import 'package:flutter/cupertino.dart';
import 'package:layout_study/utils.dart';

class TestInitSCall extends StatefulWidget {

  TestInitSCall({super.key});

  @override
  State<TestInitSCall> createState() => _TestInitSCallState();
}

class _TestInitSCallState extends State<TestInitSCall> {
  // final GlobalKey _parentKey => widget.parentKey;

  List<GlobalKey> _itemKeys = [];

  List<Rect> itemSize = [];

  @override
  void initState() {
    super.initState();
    _getItemInfo();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   _getItemInfo();
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: getRandomColor(),
        ),
        Container(
          width: 50,
          height: 50,
          color: getRandomColor(),
        ),
        Container(
          width: 50,
          height: 50,
          color: getRandomColor(),
        ),
      ],
    );
  }

  void _getItemInfo() {
  //   itemSize.clear();
  //   RenderBox parentRenderBox =
  //   (widget.key as GlobalKey).currentContext!.findRenderObject() as RenderBox;
  //   for (var key in _itemKeys) {
  //     final RenderBox? renderBox =
  //     key.currentContext?.findRenderObject() as RenderBox?;
  //     if (renderBox != null) {
  //       final position =
  //       renderBox.localToGlobal(Offset.zero, ancestor: parentRenderBox);
  //       final size = renderBox.size;
  //       Rect childRect = Rect.fromLTWH(
  //         position.dx, // left
  //         position.dy, // top
  //         size.width, // width
  //         size.height, // height
  //       );
  //       itemSize.add(childRect);
  //       print('Y Position: ${position.dy}, Height: ${size.height}');
  //     }
  //   }
  }
}
