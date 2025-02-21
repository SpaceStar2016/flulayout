import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyViewport extends StatelessWidget {
  MyViewport({Key? key}) : super(key: key);

  final List<int> data = List.generate(60, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scrollable+Viewport 测试'),
        ),
        body: Scrollable(
          viewportBuilder: _buildViewPort,
        ),
      ),
    );
  }

  Widget _buildViewPort(BuildContext context, ViewportOffset position) {
    return Viewport(
      offset: position,
      slivers: [_buildSliverGrid(),_buildSliverList()],
    );
  }

  Widget _buildSliverList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      _buildItemByIndex,
      childCount: data.length,
    ));
  }

  Widget _buildItemByIndex(BuildContext context, int index) {
    return Container(
      width: 200,
        height: 200,
        color: Colors.amber,
        child: Text('${data[index]}'));
  }

  Widget _buildSliverGrid() {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          _buildItemByIndex,
          childCount: data.length,
        ),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5));
  }

  // test(){
  //   SliverConstraints();
  // }
}
