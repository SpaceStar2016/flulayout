  @override
  void performLayout() {
    //获取上级传递下来的约束
    final BoxConstraints constraints = this.constraints;
    assert(() {
      final FlutterError? constraintsError = _debugCheckConstraints(
        constraints: constraints,
        reportParentConstraints: true,
      );
      if (constraintsError != null) {
        throw constraintsError;
      }
      return true;
    }());
    // 调用_computeSizes 方法计算布局大小
    final _LayoutSizes sizes = _computeSizes(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
      getBaseline: ChildLayoutHelper.getBaseline,
    );

    final double crossAxisExtent = sizes.axisSize.crossAxisExtent;
    size = sizes.axisSize.toSize(direction);
    _overflow = math.max(0.0, -sizes.mainAxisFreeSpace);

    final double remainingSpace = math.max(0.0, sizes.mainAxisFreeSpace);
    final bool flipMainAxis = _flipMainAxis;
    final bool flipCrossAxis = _flipCrossAxis;
    final (double leadingSpace, double betweenSpace) = mainAxisAlignment._distributeSpace(remainingSpace, childCount, flipMainAxis, spacing);
    final (_NextChild nextChild, RenderBox? topLeftChild) = flipMainAxis ? (childBefore, lastChild) : (childAfter, firstChild);
    final double? baselineOffset = sizes.baselineOffset;
    assert(baselineOffset == null || (crossAxisAlignment == CrossAxisAlignment.baseline && direction == Axis.horizontal));

    // 根据_computeSizes 计算子组件的偏移量
    double childMainPosition = leadingSpace;
    for (RenderBox? child = topLeftChild; child != null; child = nextChild(child)) {
      final double? childBaselineOffset;
      final bool baselineAlign = baselineOffset != null
        && (childBaselineOffset = child.getDistanceToBaseline(textBaseline!, onlyReal: true)) != null;
      final double childCrossPosition = baselineAlign
        ? baselineOffset - childBaselineOffset!
        : crossAxisAlignment._getChildCrossAxisOffset(crossAxisExtent - _getCrossSize(child.size), flipCrossAxis);
      final FlexParentData childParentData = child.parentData! as FlexParentData;
      childParentData.offset = switch (direction) {
        Axis.horizontal => Offset(childMainPosition, childCrossPosition),
        Axis.vertical => Offset(childCrossPosition, childMainPosition),
      };
      childMainPosition += _getMainSize(child.size) + betweenSpace;
    }
  }




_LayoutSizes _computeSizes({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
    required ChildBaselineGetter getBaseline,
  }) {
    assert(_debugHasNecessaryDirections);

    //获取最大允许的尺寸(注意Row 是获取横向尺寸，Column 是获取纵向尺寸)
    final double maxMainSize = _getMainSize(constraints.biggest);
    // 判断是否可以动态调整尺寸(因为约束是上级传递下来的，除非上级的约束是double.infinity,但是如果是double.infinity，并且包含Flexible组件会前置报错了，所以这个变量永远都是true)
    // 经典错误演示(RenderFlex children have non-zero flex but incoming width constraints are unbounded.)
    final bool canFlex = maxMainSize.isFinite;
    //获取不是Flex 孩子的 约束，注意，这段代码非常重要，会返回一个带double.infinity 的约束，对于Row 来说，这个约束是横向的，对于Column 来说，这个约束是纵向的。
    final BoxConstraints nonFlexChildConstraints = _constraintsForNonFlexChild(constraints);
    // 处理baseLine 的情况，baseLine 的内容单独讲解，这里先忽略
    final TextBaseline? textBaseline = _isBaselineAligned
      ? (this.textBaseline ?? (throw FlutterError('To use CrossAxisAlignment.baseline, you must also specify which baseline to use using the "textBaseline" argument.')))
      : null;

    //统计Flex 的数量
    int totalFlex = 0;
    RenderBox? firstFlexChild;
    _AscentDescent accumulatedAscentDescent = _AscentDescent.none;
    // Initially, accumulatedSize is the sum of the spaces between children in the main axis.
    _AxisSize accumulatedSize = _AxisSize._(Size(spacing * (childCount - 1), 0.0));
    // 遍历孩子组件
    for (RenderBox? child = firstChild; child != null; child = childAfter(child)) {
      final int flex;
      // 通过_getFlex 方法判断孩子组件是不是Flexible 组件，如果是，进入这个if 语句
      // 注意，这个是通过parent data 的 flex 是否为空判断的，我们将会在Stack 布局原理中详细讲解parentData，因为讲解Stack 的 Positioned 会让你们更加深入理解Parent Data
      if (canFlex && (flex = _getFlex(child)) > 0) {
        totalFlex += flex;
        firstFlexChild ??= child;
      } else {
        //调用child 的layout 方法，获取child 的尺寸，这里可以看到，传递给孩子组件的约束是nonFlexChildConstraints
        // 也就是上面我们说的，宽度或者高度是double.infinity 的约束，这里你就知道为什么在Row 或者 Column 中
        // 如果你的孩子组件不是被Flexible 包裹着的，那么你的孩子组件的在主轴的约束可以是无穷大的原因了。(请思考如何解决这个问题)
        final _AxisSize childSize = _AxisSize.fromSize(size: layoutChild(child, nonFlexChildConstraints), direction: direction);
        // 统计所有不是被Flexible 包裹这的组件的大小
        accumulatedSize += childSize;
        // Baseline-aligned children contributes to the cross axis extent separately.
        final double? baselineOffset = textBaseline == null ? null : getBaseline(child, nonFlexChildConstraints, textBaseline);
        accumulatedAscentDescent += _AscentDescent(baselineOffset: baselineOffset, crossSize: childSize.crossAxisExtent);
      }
    }

    assert((totalFlex == 0) == (firstFlexChild == null));
    assert(firstFlexChild == null || canFlex); // If we are given infinite space there's no need for this extra step.

    // 计算还剩下的可以分配给Flexible 组件的空间。
    final double flexSpace = math.max(0.0, maxMainSize - accumulatedSize.mainAxisExtent);
    // 计算每一份Flex 占据的空间大小
    final double spacePerFlex = flexSpace / totalFlex;
    for (RenderBox? child = firstFlexChild; child != null && totalFlex > 0; child = childAfter(child)) {
      final int flex = _getFlex(child);
      if (flex == 0) {
        continue;
      }
      totalFlex -= flex;
      assert(spacePerFlex.isFinite);
      final double maxChildExtent = spacePerFlex * flex;
      assert(_getFit(child) == FlexFit.loose || maxChildExtent < double.infinity);
      // 生成Flexible 子组件的约束，这里的maxChildExtent 就是子组件能够占用到最大空间，也就是 flex * spacePerFlex
      final BoxConstraints childConstraints = _constraintsForFlexChild(child, constraints, maxChildExtent);
      // 布局Flexible 组件
      final _AxisSize childSize = _AxisSize.fromSize(size: layoutChild(child, childConstraints), direction: direction);
      // 计算已经占用的空间
      accumulatedSize += childSize;
      final double? baselineOffset = textBaseline == null ? null : getBaseline(child, childConstraints, textBaseline);
      accumulatedAscentDescent += _AscentDescent(baselineOffset: baselineOffset, crossSize: childSize.crossAxisExtent);
    }
    assert(totalFlex == 0);

    // The overall height of baseline-aligned children contributes to the cross axis extent.
    accumulatedSize += switch (accumulatedAscentDescent) {
      null => _AxisSize.empty,
      (final double ascent, final double descent) => _AxisSize(mainAxisExtent: 0, crossAxisExtent: ascent + descent),
    };
    // 如果是MainAxisSize.max 并且主轴约束不是无穷大，返回maxMainSize，也就是上级传递下来的也是的最大值
    // 反之，返回所有孩子组件占用的空间大小。注意了，并不是所有MainAxisSize.max 都会返回上级约束的最大值。
    // 考虑下面情况复杂的布局情况,比如Row - Column -> Row 这种符合布局，这个时候Row 的 maxMainSize.isFinite 为 false。
    // 所以Row 自身的大小还是accumulatedSize，而不是整个屏幕。
    // 所以 在一般情况下Row 中 同时又包含Row，那么第二Row 的尺寸默认就是MainAxisSize.min，不需要再手动设置这个属性。Column 包含 Column 也是同理
    final double idealMainSize = switch (mainAxisSize) {
      MainAxisSize.max when maxMainSize.isFinite => maxMainSize,
      MainAxisSize.max || MainAxisSize.min => accumulatedSize.mainAxisExtent,
    };

    final _AxisSize constrainedSize = _AxisSize(mainAxisExtent: idealMainSize, crossAxisExtent: accumulatedSize.crossAxisExtent)
      .applyConstraints(constraints, direction);
    // 返回 _LayoutSizes
    return _LayoutSizes(
      axisSize: constrainedSize,
      mainAxisFreeSpace: constrainedSize.mainAxisExtent - accumulatedSize.mainAxisExtent,
      baselineOffset: accumulatedAscentDescent.baselineOffset,
      spacePerFlex: firstFlexChild == null ? null : spacePerFlex,
    );
  }



double _getMainSize(Size size) {
  return switch (_direction) {
    Axis.horizontal => size.width,
    Axis.vertical => size.height,
  };
}

BoxConstraints _constraintsForNonFlexChild(BoxConstraints constraints) {
  final bool fillCrossAxis = switch (crossAxisAlignment) {
    CrossAxisAlignment.stretch  => true,
    CrossAxisAlignment.start ||
    CrossAxisAlignment.center ||
    CrossAxisAlignment.end ||
    CrossAxisAlignment.baseline => false,
  };
  // 返回一个，如果不是stretch 那么就会返回一个double.infinity 的约束(BoxConstraints(maxWidth||maxHeight: constraints.maxWidth)) 方法生成的。前面介绍过这个方法
  return switch (_direction) {
    Axis.horizontal => fillCrossAxis
      ? BoxConstraints.tightFor(height: constraints.maxHeight)
      : BoxConstraints(maxHeight: constraints.maxHeight),
    Axis.vertical => fillCrossAxis
      ? BoxConstraints.tightFor(width: constraints.maxWidth)
      : BoxConstraints(maxWidth: constraints.maxWidth),
  };
}