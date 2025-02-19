import 'package:flutter/material.dart';

class CustomScrollViewExample extends StatelessWidget {
  final sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomScrollView(
        slivers: <Widget>[
          // 创建一个 SliverAppBar，带有滚动效果

          // 创建一个 SliverList 用于显示一系列列表项
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Text('Item $index');
              },
              childCount: 20, // 设置列表项数量
            ),
          ),

          // 创建一个 SliverGrid 用于显示网格
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  color: index.isEven ? Colors.blue : Colors.orange,
                  child: Center(child: Text('Grid Item $index')),
                );
              },
              childCount: 20, // 设置网格项数量
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 每行显示 2 项
              crossAxisSpacing: 10.0, // 水平间距
              mainAxisSpacing: 10.0, // 垂直间距
            ),
          ),

          // 使用 SliverToBoxAdapter 添加一个普通 Widget
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.red,
              child: Center(child: Text('Some other content')),
            ),
          ),

          // 填充剩余空间
          SliverFillRemaining(
            hasScrollBody: false, // 不允许滚动
            child: Container(
              color: Colors.amber,
              child: Center(child: Text('Fill remaining space')),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomScrollViewExample11 extends StatelessWidget {
  final sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: sc,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: <Widget>[
            // 创建一个 SliverAppBar，带有滚动效果

            // 创建一个 SliverList 用于显示一系列列表项
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Text('Item $index');
                },
                childCount: 20, // 设置列表项数量
              ),
            ),

            // 创建一个 SliverGrid 用于显示网格
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Card(
                    color: index.isEven ? Colors.blue : Colors.orange,
                    child: Center(child: Text('Grid Item $index')),
                  );
                },
                childCount: 20, // 设置网格项数量
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 每行显示 2 项
                crossAxisSpacing: 10.0, // 水平间距
                mainAxisSpacing: 10.0, // 垂直间距
              ),
            ),

            // 使用 SliverToBoxAdapter 添加一个普通 Widget
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.red,
                child: Center(child: Text('Some other content')),
              ),
            ),

            // 填充剩余空间
            SliverFillRemaining(
              hasScrollBody: false, // 不允许滚动
              child: Container(
                color: Colors.amber,
                child: Center(child: Text('Fill remaining space')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}