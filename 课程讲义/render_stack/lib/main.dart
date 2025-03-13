import 'package:flutter/material.dart';

void main() {
  runApp(
    HotReloadWidget(),
  );
}

class HotReloadWidget extends StatelessWidget {
  const HotReloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
              left: 120,
              child: Container(width: 50, height: 50, color: Colors.red))
        ],
      ),
    );
  }
}
