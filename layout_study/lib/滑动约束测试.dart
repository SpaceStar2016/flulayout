

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollVVV extends StatelessWidget {
  const ScrollVVV({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
            ListTile(title: Text('Item 3')),
            ListTile(title: Text('Item 4')),
            ListTile(title: Text('Item 5')),
            ListTile(title: Text('Item 6')),
            ListTile(title: Text('Item 7')),
            ListTile(title: Text('Item 8')),
            ListTile(title: Text('Item 9')),
            ListTile(title: Text('Item 10')),
          ],
        );
  }
}
