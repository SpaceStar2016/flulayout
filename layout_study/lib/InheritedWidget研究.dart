// 1. 定义共享数据容器
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterInherited extends InheritedWidget {
  final int count;

  final VoidCallback increment;

  const CounterInherited({
    super.key,
    required this.count,
    required this.increment,
    required super.child,
  });

  // 2. 提供便捷访问方法
  static CounterInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterInherited>();
  }

  // 3. 定义更新条件
  @override
  bool updateShouldNotify(CounterInherited oldWidget) {
    return oldWidget.count  != count;
  }
}

// 4. 父级组件封装
class CounterWrapper extends StatefulWidget {
  const CounterWrapper({super.key});

  @override
  State<CounterWrapper> createState() => _CounterWrapperState();
}

class _CounterWrapperState extends State<CounterWrapper> {
  int _count = 0;

  void _increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) {
    return CounterInherited(
      count: _count,
      increment: _increment,
      child: const CounterDisplay(),
    );
  }
}

// 5. 子组件消费数据
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = CounterInherited.of(context)!;
    return Column(
      children: [
        Text('点击次数: ${counter.count}'),
        ElevatedButton(
          onPressed: counter.increment,
          child: const Text('增加'),
        )
      ],
    );
  }
}