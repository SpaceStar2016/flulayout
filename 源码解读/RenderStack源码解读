  void performLayout() {
    // 获取上级传递下来的约束(通过layout方法传递下来的)
    final BoxConstraints constraints = this.constraints;
    // 和绘制相关的内容
    _hasVisualOverflow = false;
    // 调用_computeSize 获取没有尺寸，如果是没有Postioned 组件，那么该尺寸就是最小的宽高
    // 如果有Postioned 组件，那么该尺寸就是上级也是的最大值
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );

    final Alignment resolvedAlignment = _resolvedAlignment;
    RenderBox? child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData! as StackParentData;
      // 计算没有被Positioned 组件 包裹着的孩子组件的偏移量(注意了，这个判断是通过top,left,bottom等是否为空判断,如果只是简单地被Postioned 包裹着，没设置任何属性的值，那么也相当于没有被Positioned 包裹着。)
      if (!childParentData.isPositioned) {
        childParentData.offset = resolvedAlignment.alongOffset(size - child.size as Offset);
      } else {
        // 调用layoutPositionedChild 单独计算Positioned 组件的布局
        _hasVisualOverflow = layoutPositionedChild(child, childParentData, size, resolvedAlignment) || _hasVisualOverflow;
      }

      assert(child.parentData == childParentData);
      //计算下一个孩子组件的约束，偏移
      child = childParentData.nextSibling;
    }
  }




Size _computeSize({required BoxConstraints constraints, required ChildLayouter layoutChild}) {
    // 用于判断是否有Positioned 组件  
    bool hasNonPositionedChildren = false;
    // 如果没有 孩子组件，那么返回上级约束的最大或者最小尺寸(根据onstraints.biggest.isFinite 判断。)
    if (childCount == 0) {
      return (constraints.biggest.isFinite) ? constraints.biggest : constraints.smallest;
    }
    // 获取上级约束的最小宽高
    double width = constraints.minWidth;
    double height = constraints.minHeight;
    // 根据fit 变量生成没有被Postitioned 组件包裹着的孩子组件的约束。
    final BoxConstraints nonPositionedConstraints = switch (fit) {
        // 对于loosen(默认情况),会直接把上级约束搞成松约束传递下去(这不就和Center 的作用类似吗？)，上才艺。
      StackFit.loose => constraints.loosen(),
      // 对于expand，会把上级约束直接变成紧约束传递到孩子组件
      StackFit.expand => BoxConstraints.tight(constraints.biggest),
      // 不做任何修改传递上级约束
      StackFit.passthrough => constraints,
    };
    // 获取孩子组件
    RenderBox? child = firstChild;
    // 遍历孩子组件
    while (child != null) {
      final StackParentData childParentData = child.parentData! as StackParentData;
      // 根据isPositioned 判断孩子组件是否是被Postioned 组件包裹着。
      if (!childParentData.isPositioned) {
        hasNonPositionedChildren = true;
        // 调用RenderObject 的 layoutChild 方法生成孩子组件的size(尺寸)
        final Size childSize = layoutChild(child, nonPositionedConstraints);
        //更新最小宽高
        width = math.max(width, childSize.width);
        height = math.max(height, childSize.height);
      }

      child = childParentData.nextSibling;
    }

    final Size size;
    // 如果包含没有被 Postioned 包裹着的孩子组件，(就是进入了while 循环的第一个判断)
    if (hasNonPositionedChildren) {
        // 返回最小的宽高。
      size = Size(width, height);
      assert(size.width == constraints.constrainWidth(width));
      assert(size.height == constraints.constrainHeight(height));
    } else {
        // 返回上级也是的最大值
      size = constraints.biggest;
    }

    assert(size.isFinite);
    return size;
}


static bool layoutPositionedChild(RenderBox child, StackParentData childParentData, Size size, Alignment alignment) {

    assert(childParentData.isPositioned);
    assert(child.parentData == childParentData);
    // 根据Postioned 的属性(top,bottom,left,right 等)计算需要传递到孩子组件的约束条件,规则如下：
    // 如果同时存在left  和 right ，那么在_computeSize 计算到的Size  减去left 和 right ，高度不变，再变成紧约束(注意这里只是宽度变成紧约束)传递到子组件，
    // 对于top 和 bottom 同理。简单来说就是，如果同时设置了left 和 right 或者top 和 bottom，子组件的宽度或者高度会获得紧约束，同时设置，那么就同时获得紧约束。
    // 都没有设置或者只设置一对中的其中一个，那么子组件获得的约束就是(0 ~ double.infinity)
    final BoxConstraints childConstraints = childParentData.positionedChildConstraints(size);
    // 调用RenderObject 的布局方法，传入约束
    child.layout(childConstraints, parentUsesSize: true);
    // 根据Positioned 组件的属性，计算偏移量x轴的偏移量
    final double x = switch (childParentData) {
      StackParentData(:final double left?) => left,
      StackParentData(:final double right?) => size.width - right - child.size.width,
      StackParentData() => alignment.alongOffset(size - child.size as Offset).dx,
    };
    // 根据Positioned 的属性，计算偏移量y轴的偏移量，
    final double y = switch (childParentData) {
      StackParentData(:final double top?) => top,
      StackParentData(:final double bottom?) => size.height - bottom - child.size.height,
      StackParentData() => alignment.alongOffset(size - child.size as Offset).dy,
    };
    // 把偏移量保存在ParentData 中，在绘制阶段使用
    childParentData.offset = Offset(x, y);
    return x < 0.0 || x + child.size.width > size.width
        || y < 0.0 || y + child.size.height > size.height;
}
