import 'package:flutter/material.dart';

void main() {
  runApp(ABC());
}

class ABC extends StatelessWidget {
  const ABC({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: LayoutBuilder(builder: (context, con) {
            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 2000),
              child: Row(
                children: [
                  ColoredBox(
                    color: Colors.yellow,
                    child: SizedBox(
                      width: 1040,
                      height: 40,
                    ),
                  ),
                  Spacer(),
                  ColoredBox(
                    color: Colors.red,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
