import 'package:flutter/material.dart';

void main() {
  runApp(
    VisitorWidget(),
  );
}

class MyStateLsWidget extends StatelessWidget {
  const MyStateLsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          width: 50,
          height: 50,
          color: Colors.yellow,
        ),
      ),
    );
  }
}


class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Child 1'),
        Text('Child 2'),
        Text('Child 3'),
      ],
    );
  }
}

class VisitorWidget extends StatelessWidget {
  const VisitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('visitChildElements Demo')),
        body: Builder(
          builder: (context) {
            // 在构建完成后遍历子元素
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.visitChildElements((element) {
                print('Child Element: $element');
              });
            });
            return const MyWidget();
          },
        ),
      ),
    );
  }
}