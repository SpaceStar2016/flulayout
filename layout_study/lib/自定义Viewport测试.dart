// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// /// 自定义滚动视口组件
// class CustomScrollViewDemo extends SingleChildRenderObjectWidget {
//   const CustomScrollViewDemo({super.key});
//
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     // 创建 ScrollController 管理滚动位置
//     final ScrollController controller = ScrollController();
//
//     return RenderViewport(
//       axisDirection: AxisDirection.down, // 垂直滚动
//       offset: controller.position, // 绑定滚动控制器
//       cacheExtent: 200.0, // 预渲染200像素区域
//       children: [
//         // 列表内容
//         _buildSliverList(),
//       ], crossAxisDirection: AxisDirection.right,
//     );
//   }
// }
//
//
//
// /// 视差头部代理类
// class _ParallaxHeaderDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       height: 200,
//       color: Colors.blue,
//       alignment: Alignment.center,
//       child: Transform.translate(
//         offset: Offset(0, -shrinkOffset * 0.5), // 视差效果
//         child: const Text(
//           'Parallax Header',
//           style: TextStyle(color: Colors.white, fontSize: 24),
//         ),
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => 200; // 最大高度
//
//   @override
//   double get minExtent => 100; // 最小高度
//
//   @override
//   bool shouldRebuild(_ParallaxHeaderDelegate oldDelegate) => true;
// }
//
// /// 构建列表 Sliver
// RenderSliverList _buildSliverList() {
//   return RenderSliverList(
//     childManager: SliverChildListDelegate(
//       List.generate(
//         // 生成50个列表项
//         50,
//         (index) => Container(
//           height: 80,
//           color: index.isEven ? Colors.grey[200] : Colors.white,
//           alignment: Alignment.center,
//           child: Text('Item $index'),
//         ),
//       ),
//     ),
//   );
// }
//
