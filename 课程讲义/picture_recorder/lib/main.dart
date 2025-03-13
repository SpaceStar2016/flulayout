import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  // 一、创建第一个正方形
  // 使用PictureRecorder创建一个画板
  PictureRecorder recorder = PictureRecorder();
  Canvas canvas = Canvas(recorder);

  // canvas绘制
  // 从100，100坐标开始绘制
  Offset offset = Offset(0, 0);
  // 绘制区域是100x100的区域
  Size size = Size(300, 300);
  canvas.drawRect(offset & size, Paint()..color = Colors.red);

  // 通过recorder.endRecording结束节点绘制并返回一个Picture
  Picture picture = recorder.endRecording();

  // 三、初始化一个SceneBuilder
  SceneBuilder sceneBuilder = SceneBuilder();
  // 通过SceneBuilder上的方法将上诉canvas生成的Picture添加到engine
  sceneBuilder.pushOffset(0, 0);
  sceneBuilder.addPicture( Offset(0, 0), picture);
  sceneBuilder.pop();
  // 四、通过sceneBuilder.build生成scene
  Scene scene = sceneBuilder.build();
  PlatformDispatcher.instance.onDrawFrame = () {
    // 五、调用window.render, 它只能在onDrawFrame或onBeginFrame中调用
    PlatformDispatcher.instance.views.first.render(scene);
    scene.dispose();
  };
  // 触发一个VSync信号，在下一帧触发onDrawFrame回调
  PlatformDispatcher.instance.scheduleFrame();
}
