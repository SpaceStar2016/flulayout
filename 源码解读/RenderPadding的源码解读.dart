  void performLayout() {
    // 上级的约束
    final BoxConstraints constraints = this.constraints;
    // 边距
    final EdgeInsets padding = _resolvedPadding;
    if (child == null) {
      // 利用父级传递的约束，结合容器的内边距值，计算出符合约束的有效尺寸(这个尺寸就是 左右上下边距相加)
      size = constraints.constrain(Size(padding.horizontal, padding.vertical));
      return;
    }
    // 从现有的约束条件中减去指定的边距，从而得到一个新的约束条件innerConstraints
    final BoxConstraints innerConstraints = constraints.deflate(padding);
    // 调用子控件(RenderObject)的layout 方法，生成子控件自身的尺寸
    child!.layout(innerConstraints, parentUsesSize: true);
    // 结合padding，计算子控件相对自身的偏移量，保存在childParentData，在绘制阶段会使用
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(padding.left, padding.top);
    // 利用父级传递的约束，结合容器的内边距值和子控件的宽高，生成自生的宽高
    size = constraints.constrain(Size(
      padding.horizontal + child!.size.width,
      padding.vertical + child!.size.height,
    ));
  }