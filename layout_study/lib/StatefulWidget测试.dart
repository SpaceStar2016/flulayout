

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  @override
  void initState() {
    super.initState();
    print('initState');
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColoredBox(color: Colors.yellow,),
    );
  }
}
