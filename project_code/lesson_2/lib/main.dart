import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  // runApp(
  //   Center(
  //     child: Container(
  //       width: 50,
  //       height: 50,
  //       color: Colors.amber,
  //     ),
  //   ),
  // );

  runApp(
    LimitedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // runApp(
  //   MyCenterWidget()
  // );

  runApp(
    OverflowBox(
      minHeight: 0,
      maxHeight: 100,
      minWidth: 0,
      maxWidth: 100,
      // fit: OverflowBoxFit.deferToChild,
      child: Container(
        width: 30,
        height: 30,
        color: Colors.green,
      ),
    ),
  );
}

class MyCenterWidget extends StatelessWidget {
  const MyCenterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              color: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}
