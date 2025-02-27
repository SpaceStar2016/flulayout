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

    // Position all children in visual order: starting from the top-left child and
    // work towards the child that's farthest away from the origin.
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

    // Determine used flex factor, size inflexible items, calculate free space.
    final double maxMainSize = _getMainSize(constraints.biggest);
    final bool canFlex = maxMainSize.isFinite;
    final BoxConstraints nonFlexChildConstraints = _constraintsForNonFlexChild(constraints);
    // Null indicates the children are not baseline aligned.
    final TextBaseline? textBaseline = _isBaselineAligned
      ? (this.textBaseline ?? (throw FlutterError('To use CrossAxisAlignment.baseline, you must also specify which baseline to use using the "textBaseline" argument.')))
      : null;

    // The first pass lays out non-flex children and computes total flex.
    int totalFlex = 0;
    RenderBox? firstFlexChild;
    _AscentDescent accumulatedAscentDescent = _AscentDescent.none;
    // Initially, accumulatedSize is the sum of the spaces between children in the main axis.
    _AxisSize accumulatedSize = _AxisSize._(Size(spacing * (childCount - 1), 0.0));
    for (RenderBox? child = firstChild; child != null; child = childAfter(child)) {
      final int flex;
      if (canFlex && (flex = _getFlex(child)) > 0) {
        totalFlex += flex;
        firstFlexChild ??= child;
      } else {
        final _AxisSize childSize = _AxisSize.fromSize(size: layoutChild(child, nonFlexChildConstraints), direction: direction);
        accumulatedSize += childSize;
        // Baseline-aligned children contributes to the cross axis extent separately.
        final double? baselineOffset = textBaseline == null ? null : getBaseline(child, nonFlexChildConstraints, textBaseline);
        accumulatedAscentDescent += _AscentDescent(baselineOffset: baselineOffset, crossSize: childSize.crossAxisExtent);
      }
    }

    assert((totalFlex == 0) == (firstFlexChild == null));
    assert(firstFlexChild == null || canFlex); // If we are given infinite space there's no need for this extra step.

    // The second pass distributes free space to flexible children.
    final double flexSpace = math.max(0.0, maxMainSize - accumulatedSize.mainAxisExtent);
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
      final BoxConstraints childConstraints = _constraintsForFlexChild(child, constraints, maxChildExtent);
      final _AxisSize childSize = _AxisSize.fromSize(size: layoutChild(child, childConstraints), direction: direction);
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

    final double idealMainSize = switch (mainAxisSize) {
      MainAxisSize.max when maxMainSize.isFinite => maxMainSize,
      MainAxisSize.max || MainAxisSize.min => accumulatedSize.mainAxisExtent,
    };

    final _AxisSize constrainedSize = _AxisSize(mainAxisExtent: idealMainSize, crossAxisExtent: accumulatedSize.crossAxisExtent)
      .applyConstraints(constraints, direction);
    return _LayoutSizes(
      axisSize: constrainedSize,
      mainAxisFreeSpace: constrainedSize.mainAxisExtent - accumulatedSize.mainAxisExtent,
      baselineOffset: accumulatedAscentDescent.baselineOffset,
      spacePerFlex: firstFlexChild == null ? null : spacePerFlex,
    );
  }