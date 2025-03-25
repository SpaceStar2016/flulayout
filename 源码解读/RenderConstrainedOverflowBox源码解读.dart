class RenderConstrainedOverflowBox extends RenderAligningShiftedBox {
  /// Creates a render object that lets its child overflow itself.
  RenderConstrainedOverflowBox({
    super.child,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    OverflowBoxFit fit = OverflowBoxFit.max,
    super.alignment,
    super.textDirection,
  }) : _minWidth = minWidth,
       _maxWidth = maxWidth,
       _minHeight = minHeight,
       _maxHeight = maxHeight,
       _fit = fit;

  /// The minimum width constraint to give the child. Set this to null (the
  /// default) to use the constraint from the parent instead.
  double? get minWidth => _minWidth;
  double? _minWidth;
  set minWidth(double? value) {
    if (_minWidth == value) {
      return;
    }
    _minWidth = value;
    markNeedsLayout();
  }

  /// The maximum width constraint to give the child. Set this to null (the
  /// default) to use the constraint from the parent instead.
  double? get maxWidth => _maxWidth;
  double? _maxWidth;
  set maxWidth(double? value) {
    if (_maxWidth == value) {
      return;
    }
    _maxWidth = value;
    markNeedsLayout();
  }

  /// The minimum height constraint to give the child. Set this to null (the
  /// default) to use the constraint from the parent instead.
  double? get minHeight => _minHeight;
  double? _minHeight;
  set minHeight(double? value) {
    if (_minHeight == value) {
      return;
    }
    _minHeight = value;
    markNeedsLayout();
  }

  /// The maximum height constraint to give the child. Set this to null (the
  /// default) to use the constraint from the parent instead.
  double? get maxHeight => _maxHeight;
  double? _maxHeight;
  set maxHeight(double? value) {
    if (_maxHeight == value) {
      return;
    }
    _maxHeight = value;
    markNeedsLayout();
  }

  /// The way to size the render object.
  ///
  /// This only affects scenario when the child does not indeed overflow.
  /// If set to [OverflowBoxFit.deferToChild], the render object will size
  /// itself to match the size of its child within the constraints of its
  /// parent, or as small as the parent allows if no child is set.
  /// If set to [OverflowBoxFit.max] (the default), the
  /// render object will size itself to be as large as the parent allows.
  OverflowBoxFit get fit => _fit;
  OverflowBoxFit _fit;
  set fit(OverflowBoxFit value) {
    if (_fit == value) {
      return;
    }
    _fit = value;
    markNeedsLayoutForSizedByParentChange();
  }

  BoxConstraints _getInnerConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: _minWidth ?? constraints.minWidth,
      maxWidth: _maxWidth ?? constraints.maxWidth,
      minHeight: _minHeight ?? constraints.minHeight,
      maxHeight: _maxHeight ?? constraints.maxHeight,
    );
  }

  @override
  bool get sizedByParent => switch (fit) {
    OverflowBoxFit.max => true,
    // If deferToChild, the size will be as small as its child when non-overflowing,
    // thus it cannot be sizedByParent.
    OverflowBoxFit.deferToChild => false,
  };

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return switch (fit) {
      OverflowBoxFit.max => constraints.biggest,
      OverflowBoxFit.deferToChild => child?.getDryLayout(constraints) ?? constraints.smallest,
    };
  }

  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final BoxConstraints childConstraints = _getInnerConstraints(constraints);
    final double? result = child.getDryBaseline(childConstraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(childConstraints);
    final Size size = getDryLayout(constraints);
    return result + resolvedAlignment.alongOffset(size - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(_getInnerConstraints(constraints), parentUsesSize: true);
      switch (fit) {
        case OverflowBoxFit.max:
          assert(sizedByParent);
        case OverflowBoxFit.deferToChild:
          size = constraints.constrain(child!.size);
      }
      alignChild();
    } else {
      switch (fit) {
        case OverflowBoxFit.max:
          assert(sizedByParent);
        case OverflowBoxFit.deferToChild:
          size = constraints.smallest;
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('minWidth', minWidth, ifNull: 'use parent minWidth constraint'));
    properties.add(DoubleProperty('maxWidth', maxWidth, ifNull: 'use parent maxWidth constraint'));
    properties.add(
      DoubleProperty('minHeight', minHeight, ifNull: 'use parent minHeight constraint'),
    );
    properties.add(
      DoubleProperty('maxHeight', maxHeight, ifNull: 'use parent maxHeight constraint'),
    );
    properties.add(EnumProperty<OverflowBoxFit>('fit', fit));
  }
}