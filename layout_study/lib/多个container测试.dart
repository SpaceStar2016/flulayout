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
          // MyBox(),
          MyBox(),
          MyBox(),
        ],
      ),
    );
  }
}

class MyBox extends StatefulWidget {
  const MyBox({super.key});

  @override
  State<MyBox> createState() => _MyBoxState();
}

class _MyBoxState extends State<MyBox> {
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
          color: Colors.primaries[0],
          child: Text(textDirection: TextDirection.rtl,'${count}')),
    );
  }
}
