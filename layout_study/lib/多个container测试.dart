import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DuoGeContainerTest {
  static Widget makeWidget(){
    return const MultiContainerTest();
  }
}

class MultiContainerTest extends StatefulWidget {
  const MultiContainerTest({super.key});

  @override
  State<MultiContainerTest> createState() => _MultiContainerTestState();
}

class _MultiContainerTestState extends State<MultiContainerTest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          MyBox(color: Color(0xFFd1f1d1),tex: '1'),
          MyBox(color: Color(0xFFd2f2F2),tex:'2'),
          MyBox(color: Color(0xFFd3f3F3),tex: '3'),
        ],
      ),
    );
  }
}

class MyBox extends StatefulWidget {

  final String tex;
  final Color color;
  const MyBox({super.key, required this.color, required this.tex});

  @override
  State<MyBox> createState() => _MyBoxState();
}

class _MyBoxState extends State<MyBox> {

  @override
  void initState() {
    super.initState();
    print('~~initState');
  }
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          count++;
        });
      },
      child: Container(
          width: 30,
          height: 30,
          color: widget.color,
          child: Text(textDirection: TextDirection.rtl,'${widget.tex}')),
    );
  }
}
