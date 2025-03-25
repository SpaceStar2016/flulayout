abstract class RenderBox extends RenderObject {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  final _LayoutCacheStorage _layoutCacheStorage = _LayoutCacheStorage();

  static int _debugIntrinsicsDepth = 0;
  Output _computeIntrinsics<Input extends Object, Output>(
    _CachedLayoutCalculation<Input, Output> type,
    Input input,
    Output Function(Input) computer,
  ) {
    assert(
      RenderObject.debugCheckingIntrinsics || !debugDoingThisResize,
    ); // performResize should not depend on anything except the incoming constraints
    bool shouldCache = true;
    assert(() {
      // we don't want the debug-mode intrinsic tests to affect
      // who gets marked dirty, etc.
      shouldCache = !RenderObject.debugCheckingIntrinsics;
      return true;
    }());
    return shouldCache ? _computeWithTimeline(type, input, computer) : computer(input);
  }

  Output _computeWithTimeline<Input extends Object, Output>(
    _CachedLayoutCalculation<Input, Output> type,
    Input input,
    Output Function(Input) computer,
  ) {
    Map<String, String>? debugTimelineArguments;
    assert(() {
      final Map<String, String> arguments =
          debugEnhanceLayoutTimelineArguments
              ? toDiagnosticsNode().toTimelineArguments()!
              : <String, String>{};
      debugTimelineArguments = type.debugFillTimelineArguments(arguments, input);
      return true;
    }());
    if (!kReleaseMode) {
      if (debugProfileLayoutsEnabled || _debugIntrinsicsDepth == 0) {
        FlutterTimeline.startSync(type.eventLabel(this), arguments: debugTimelineArguments);
      }
      _debugIntrinsicsDepth += 1;
    }
    final Output result = type.memoize(_layoutCacheStorage, input, computer);
    if (!kReleaseMode) {
      _debugIntrinsicsDepth -= 1;
      if (debugProfileLayoutsEnabled || _debugIntrinsicsDepth == 0) {
        FlutterTimeline.finishSync();
      }
    }
    return result;
  }

  /// Returns the minimum width that this box could be without failing to
  /// correctly paint its contents within itself, without clipping.
  ///
  /// The height argument may give a specific height to assume. The given height
  /// can be infinite, meaning that the intrinsic width in an unconstrained
  /// environment is being requested. The given height should never be negative
  /// or null.
  ///
  /// This function should only be called on one's children. Calling this
  /// function couples the child with the parent so that when the child's layout
  /// changes, the parent is notified (via [markNeedsLayout]).
  ///
  /// Calling this function is expensive as it can result in O(N^2) behavior.
  ///
  /// Do not override this method. Instead, implement [computeMinIntrinsicWidth].
  @mustCallSuper
  double getMinIntrinsicWidth(double height) {
    assert(() {
      if (height < 0.0) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('The height argument to getMinIntrinsicWidth was negative.'),
          ErrorDescription('The argument to getMinIntrinsicWidth must not be negative or null.'),
          ErrorHint(
            'If you perform computations on another height before passing it to '
            'getMinIntrinsicWidth, consider using math.max() or double.clamp() '
            'to force the value into the valid range.',
          ),
        ]);
      }
      return true;
    }());
    return _computeIntrinsics(_IntrinsicDimension.minWidth, height, computeMinIntrinsicWidth);
  }

  /// Computes the value returned by [getMinIntrinsicWidth]. Do not call this
  /// function directly, instead, call [getMinIntrinsicWidth].
  ///
  /// Override in subclasses that implement [performLayout]. This method should
  /// return the minimum width that this box could be without failing to
  /// correctly paint its contents within itself, without clipping.
  ///
  /// If the layout algorithm is independent of the context (e.g. it always
  /// tries to be a particular size), or if the layout algorithm is
  /// width-in-height-out, or if the layout algorithm uses both the incoming
  /// width and height constraints (e.g. it always sizes itself to
  /// [BoxConstraints.biggest]), then the `height` argument should be ignored.
  ///
  /// If the layout algorithm is strictly height-in-width-out, or is
  /// height-in-width-out when the width is unconstrained, then the height
  /// argument is the height to use.
  ///
  /// The `height` argument will never be negative or null. It may be infinite.
  ///
  /// If this algorithm depends on the intrinsic dimensions of a child, the
  /// intrinsic dimensions of that child should be obtained using the functions
  /// whose names start with `get`, not `compute`.
  ///
  /// This function should never return a negative or infinite value.
  ///
  /// Be sure to set [debugCheckIntrinsicSizes] to true in your unit tests if
  /// you do override this method, which will add additional checks to help
  /// validate your implementation.
  ///
  /// ## Examples
  ///
  /// ### Text
  ///
  /// English text is the canonical example of a width-in-height-out algorithm.
  /// The `height` argument is therefore ignored.
  ///
  /// Consider the string "Hello World". The _maximum_ intrinsic width (as
  /// returned from [computeMaxIntrinsicWidth]) would be the width of the string
  /// with no line breaks.
  ///
  /// The minimum intrinsic width would be the width of the widest word, "Hello"
  /// or "World". If the text is rendered in an even narrower width, however, it
  /// might still not overflow. For example, maybe the rendering would put a
  /// line-break half-way through the words, as in "Hel⁞lo⁞Wor⁞ld". However,
  /// this wouldn't be a _correct_ rendering, and [computeMinIntrinsicWidth] is
  /// defined as returning the minimum width that the box could be without
  /// failing to _correctly_ paint the contents within itself.
  ///
  /// The minimum intrinsic _height_ for a given width _smaller_ than the
  /// minimum intrinsic width could therefore be greater than the minimum
  /// intrinsic height for the minimum intrinsic width.
  ///
  /// ### Viewports (e.g. scrolling lists)
  ///
  /// Some render boxes are intended to clip their children. For example, the
  /// render box for a scrolling list might always size itself to its parents'
  /// size (or rather, to the maximum incoming constraints), regardless of the
  /// children's sizes, and then clip the children and position them based on
  /// the current scroll offset.
  ///
  /// The intrinsic dimensions in these cases still depend on the children, even
  /// though the layout algorithm sizes the box in a way independent of the
  /// children. It is the size that is needed to paint the box's contents (in
  /// this case, the children) _without clipping_ that matters.
  ///
  /// ### When the intrinsic dimensions cannot be known
  ///
  /// There are cases where render objects do not have an efficient way to
  /// compute their intrinsic dimensions. For example, it may be prohibitively
  /// expensive to reify and measure every child of a lazy viewport (viewports
  /// generally only instantiate the actually visible children), or the
  /// dimensions may be computed by a callback about which the render object
  /// cannot reason.
  ///
  /// In such cases, it may be impossible (or at least impractical) to actually
  /// return a valid answer. In such cases, the intrinsic functions should throw
  /// when [RenderObject.debugCheckingIntrinsics] is false and asserts are
  /// enabled, and return 0.0 otherwise.
  ///
  /// See the implementations of [LayoutBuilder] or [RenderViewportBase] for
  /// examples (in particular,
  /// [RenderViewportBase.debugThrowIfNotCheckingIntrinsics]).
  ///
  /// ### Aspect-ratio-driven boxes
  ///
  /// Some boxes always return a fixed size based on the constraints. For these
  /// boxes, the intrinsic functions should return the appropriate size when the
  /// incoming `height` or `width` argument is finite, treating that as a tight
  /// constraint in the respective direction and treating the other direction's
  /// constraints as unbounded. This is because the definitions of
  /// [computeMinIntrinsicWidth] and [computeMinIntrinsicHeight] are in terms of
  /// what the dimensions _could be_, and such boxes can only be one size in
  /// such cases.
  ///
  /// When the incoming argument is not finite, then they should return the
  /// actual intrinsic dimensions based on the contents, as any other box would.
  ///
  /// See also:
  ///
  ///  * [computeMaxIntrinsicWidth], which computes the smallest width beyond
  ///    which increasing the width never decreases the preferred height.
  @protected
  double computeMinIntrinsicWidth(double height) {
    return 0.0;
  }

  /// Returns the smallest width beyond which increasing the width never
  /// decreases the preferred height. The preferred height is the value that
  /// would be returned by [getMinIntrinsicHeight] for that width.
  ///
  /// The height argument may give a specific height to assume. The given height
  /// can be infinite, meaning that the intrinsic width in an unconstrained
  /// environment is being requested. The given height should never be negative
  /// or null.
  ///
  /// This function should only be called on one's children. Calling this
  /// function couples the child with the parent so that when the child's layout
  /// changes, the parent is notified (via [markNeedsLayout]).
  ///
  /// Calling this function is expensive as it can result in O(N^2) behavior.
  ///
  /// Do not override this method. Instead, implement
  /// [computeMaxIntrinsicWidth].
  @mustCallSuper
  double getMaxIntrinsicWidth(double height) {
    assert(() {
      if (height < 0.0) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('The height argument to getMaxIntrinsicWidth was negative.'),
          ErrorDescription('The argument to getMaxIntrinsicWidth must not be negative or null.'),
          ErrorHint(
            'If you perform computations on another height before passing it to '
            'getMaxIntrinsicWidth, consider using math.max() or double.clamp() '
            'to force the value into the valid range.',
          ),
        ]);
      }
      return true;
    }());
    return _computeIntrinsics(_IntrinsicDimension.maxWidth, height, computeMaxIntrinsicWidth);
  }

  /// Computes the value returned by [getMaxIntrinsicWidth]. Do not call this
  /// function directly, instead, call [getMaxIntrinsicWidth].
  ///
  /// Override in subclasses that implement [performLayout]. This should return
  /// the smallest width beyond which increasing the width never decreases the
  /// preferred height. The preferred height is the value that would be returned
  /// by [computeMinIntrinsicHeight] for that width.
  ///
  /// If the layout algorithm is strictly height-in-width-out, or is
  /// height-in-width-out when the width is unconstrained, then this should
  /// return the same value as [computeMinIntrinsicWidth] for the same height.
  ///
  /// Otherwise, the height argument should be ignored, and the returned value
  /// should be equal to or bigger than the value returned by
  /// [computeMinIntrinsicWidth].
  ///
  /// The `height` argument will never be negative or null. It may be infinite.
  ///
  /// The value returned by this method might not match the size that the object
  /// would actually take. For example, a [RenderBox] subclass that always
  /// exactly sizes itself using [BoxConstraints.biggest] might well size itself
  /// bigger than its max intrinsic size.
  ///
  /// If this algorithm depends on the intrinsic dimensions of a child, the
  /// intrinsic dimensions of that child should be obtained using the functions
  /// whose names start with `get`, not `compute`.
  ///
  /// This function should never return a negative or infinite value.
  ///
  /// Be sure to set [debugCheckIntrinsicSizes] to true in your unit tests if
  /// you do override this method, which will add additional checks to help
  /// validate your implementation.
  ///
  /// See also:
  ///
  ///  * [computeMinIntrinsicWidth], which has usage examples.
  @visibleForOverriding
  @protected
  double computeMaxIntrinsicWidth(double height) {
    return 0.0;
  }

  /// Returns the minimum height that this box could be without failing to
  /// correctly paint its contents within itself, without clipping.
  ///
  /// The width argument may give a specific width to assume. The given width
  /// can be infinite, meaning that the intrinsic height in an unconstrained
  /// environment is being requested. The given width should never be negative
  /// or null.
  ///
  /// This function should only be called on one's children. Calling this
  /// function couples the child with the parent so that when the child's layout
  /// changes, the parent is notified (via [markNeedsLayout]).
  ///
  /// Calling this function is expensive as it can result in O(N^2) behavior.
  ///
  /// Do not override this method. Instead, implement
  /// [computeMinIntrinsicHeight].
  @mustCallSuper
  double getMinIntrinsicHeight(double width) {
    assert(() {
      if (width < 0.0) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('The width argument to getMinIntrinsicHeight was negative.'),
          ErrorDescription('The argument to getMinIntrinsicHeight must not be negative or null.'),
          ErrorHint(
            'If you perform computations on another width before passing it to '
            'getMinIntrinsicHeight, consider using math.max() or double.clamp() '
            'to force the value into the valid range.',
          ),
        ]);
      }
      return true;
    }());
    return _computeIntrinsics(_IntrinsicDimension.minHeight, width, computeMinIntrinsicHeight);
  }

  /// Computes the value returned by [getMinIntrinsicHeight]. Do not call this
  /// function directly, instead, call [getMinIntrinsicHeight].
  ///
  /// Override in subclasses that implement [performLayout]. Should return the
  /// minimum height that this box could be without failing to correctly paint
  /// its contents within itself, without clipping.
  ///
  /// If the layout algorithm is independent of the context (e.g. it always
  /// tries to be a particular size), or if the layout algorithm is
  /// height-in-width-out, or if the layout algorithm uses both the incoming
  /// height and width constraints (e.g. it always sizes itself to
  /// [BoxConstraints.biggest]), then the `width` argument should be ignored.
  ///
  /// If the layout algorithm is strictly width-in-height-out, or is
  /// width-in-height-out when the height is unconstrained, then the width
  /// argument is the width to use.
  ///
  /// The `width` argument will never be negative or null. It may be infinite.
  ///
  /// If this algorithm depends on the intrinsic dimensions of a child, the
  /// intrinsic dimensions of that child should be obtained using the functions
  /// whose names start with `get`, not `compute`.
  ///
  /// This function should never return a negative or infinite value.
  ///
  /// Be sure to set [debugCheckIntrinsicSizes] to true in your unit tests if
  /// you do override this method, which will add additional checks to help
  /// validate your implementation.
  ///
  /// See also:
  ///
  ///  * [computeMinIntrinsicWidth], which has usage examples.
  ///  * [computeMaxIntrinsicHeight], which computes the smallest height beyond
  ///    which increasing the height never decreases the preferred width.
  @visibleForOverriding
  @protected
  double computeMinIntrinsicHeight(double width) {
    return 0.0;
  }

  /// Returns the smallest height beyond which increasing the height never
  /// decreases the preferred width. The preferred width is the value that
  /// would be returned by [getMinIntrinsicWidth] for that height.
  ///
  /// The width argument may give a specific width to assume. The given width
  /// can be infinite, meaning that the intrinsic height in an unconstrained
  /// environment is being requested. The given width should never be negative
  /// or null.
  ///
  /// This function should only be called on one's children. Calling this
  /// function couples the child with the parent so that when the child's layout
  /// changes, the parent is notified (via [markNeedsLayout]).
  ///
  /// Calling this function is expensive as it can result in O(N^2) behavior.
  ///
  /// Do not override this method. Instead, implement
  /// [computeMaxIntrinsicHeight].
  @mustCallSuper
  double getMaxIntrinsicHeight(double width) {
    assert(() {
      if (width < 0.0) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('The width argument to getMaxIntrinsicHeight was negative.'),
          ErrorDescription('The argument to getMaxIntrinsicHeight must not be negative or null.'),
          ErrorHint(
            'If you perform computations on another width before passing it to '
            'getMaxIntrinsicHeight, consider using math.max() or double.clamp() '
            'to force the value into the valid range.',
          ),
        ]);
      }
      return true;
    }());
    return _computeIntrinsics(_IntrinsicDimension.maxHeight, width, computeMaxIntrinsicHeight);
  }

  /// Computes the value returned by [getMaxIntrinsicHeight]. Do not call this
  /// function directly, instead, call [getMaxIntrinsicHeight].
  ///
  /// Override in subclasses that implement [performLayout]. Should return the
  /// smallest height beyond which increasing the height never decreases the
  /// preferred width. The preferred width is the value that would be returned
  /// by [computeMinIntrinsicWidth] for that height.
  ///
  /// If the layout algorithm is strictly width-in-height-out, or is
  /// width-in-height-out when the height is unconstrained, then this should
  /// return the same value as [computeMinIntrinsicHeight] for the same width.
  ///
  /// Otherwise, the width argument should be ignored, and the returned value
  /// should be equal to or bigger than the value returned by
  /// [computeMinIntrinsicHeight].
  ///
  /// The `width` argument will never be negative or null. It may be infinite.
  ///
  /// The value returned by this method might not match the size that the object
  /// would actually take. For example, a [RenderBox] subclass that always
  /// exactly sizes itself using [BoxConstraints.biggest] might well size itself
  /// bigger than its max intrinsic size.
  ///
  /// If this algorithm depends on the intrinsic dimensions of a child, the
  /// intrinsic dimensions of that child should be obtained using the functions
  /// whose names start with `get`, not `compute`.
  ///
  /// This function should never return a negative or infinite value.
  ///
  /// Be sure to set [debugCheckIntrinsicSizes] to true in your unit tests if
  /// you do override this method, which will add additional checks to help
  /// validate your implementation.
  ///
  /// See also:
  ///
  ///  * [computeMinIntrinsicWidth], which has usage examples.
  @visibleForOverriding
  @protected
  double computeMaxIntrinsicHeight(double width) {
    return 0.0;
  }

  /// Returns the [Size] that this [RenderBox] would like to be given the
  /// provided [BoxConstraints].
  ///
  /// The size returned by this method is guaranteed to be the same size that
  /// this [RenderBox] computes for itself during layout given the same
  /// constraints.
  ///
  /// This function should only be called on one's children. Calling this
  /// function couples the child with the parent so that when the child's layout
  /// changes, the parent is notified (via [markNeedsLayout]).
  ///
  /// This layout is called "dry" layout as opposed to the regular "wet" layout
  /// run performed by [performLayout] because it computes the desired size for
  /// the given constraints without changing any internal state.
  ///
  /// Calling this function is expensive as it can result in O(N^2) behavior.
  ///
  /// Do not override this method. Instead, implement [computeDryLayout].
  @mustCallSuper
  Size getDryLayout(covariant BoxConstraints constraints) {
    return _computeIntrinsics(_CachedLayoutCalculation.dryLayout, constraints, _computeDryLayout);
  }

  bool _computingThisDryLayout = false;
  Size _computeDryLayout(BoxConstraints constraints) {
    assert(() {
      assert(!_computingThisDryLayout);
      _computingThisDryLayout = true;
      return true;
    }());
    final Size result = computeDryLayout(constraints);
    assert(() {
      assert(_computingThisDryLayout);
      _computingThisDryLayout = false;
      return true;
    }());
    return result;
  }

  /// Computes the value returned by [getDryLayout]. Do not call this
  /// function directly, instead, call [getDryLayout].
  ///
  /// Override in subclasses that implement [performLayout] or [performResize]
  /// or when setting [sizedByParent] to true without overriding
  /// [performResize]. This method should return the [Size] that this
  /// [RenderBox] would like to be given the provided [BoxConstraints].
  ///
  /// The size returned by this method must match the [size] that the
  /// [RenderBox] will compute for itself in [performLayout] (or
  /// [performResize], if [sizedByParent] is true).
  ///
  /// If this algorithm depends on the size of a child, the size of that child
  /// should be obtained using its [getDryLayout] method.
  ///
  /// This layout is called "dry" layout as opposed to the regular "wet" layout
  /// run performed by [performLayout] because it computes the desired size for
  /// the given constraints without changing any internal state.
  ///
  /// ### When the size cannot be known
  ///
  /// There are cases where render objects do not have an efficient way to
  /// compute their size. For example, the size may computed by a callback about
  /// which the render object cannot reason.
  ///
  /// In such cases, it may be impossible (or at least impractical) to actually
  /// return a valid answer. In such cases, the function should call
  /// [debugCannotComputeDryLayout] from within an assert and return a dummy
  /// value of `const Size(0, 0)`.
  @visibleForOverriding
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    assert(
      debugCannotComputeDryLayout(
        error: FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'The ${objectRuntimeType(this, 'RenderBox')} class does not implement "computeDryLayout".',
          ),
          ErrorHint(
            'If you are not writing your own RenderBox subclass, then this is not\n'
            'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
          ),
        ]),
      ),
    );
    return Size.zero;
  }

  /// Returns the distance from the top of the box to the first baseline of the
  /// box's contents for the given `constraints`, or `null` if this [RenderBox]
  /// does not have any baselines.
  ///
  /// This method calls [computeDryBaseline] under the hood and caches the result.
  /// [RenderBox] subclasses typically don't overridden [getDryBaseline]. Instead,
  /// consider overriding [computeDryBaseline] such that it returns a baseline
  /// location that is consistent with [getDistanceToActualBaseline]. See the
  /// documentation for the [computeDryBaseline] method for more details.
  ///
  /// This method is usually called by the [computeDryBaseline] or the
  /// [computeDryLayout] implementation of a parent [RenderBox] to get the
  /// baseline location of a [RenderBox] child. Unlike [getDistanceToBaseline],
  /// this method takes a [BoxConstraints] as an argument and computes the
  /// baseline location as if the [RenderBox] was laid out by the parent using
  /// that [BoxConstraints].
  ///
  /// The "dry" in the method name means this method, like [getDryLayout], has
  /// no observable side effects when called, as opposed to "wet" layout methods
  /// such as [performLayout] (which changes this [RenderBox]'s [size], and the
  /// offsets of its children if any). Since this method does not depend on the
  /// current layout, unlike [getDistanceToBaseline], it's ok to call this method
  /// when this [RenderBox]'s layout is outdated.
  ///
  /// Similar to the intrinsic width/height and [getDryLayout], calling this
  /// function in [performLayout] is expensive, as it can result in O(N^2) layout
  /// performance, where N is the number of render objects in the render subtree.
  /// Typically this method should be only called by the parent [RenderBox]'s
  /// [computeDryBaseline] or [computeDryLayout] implementation.
  double? getDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    final double? baselineOffset =
        _computeIntrinsics(_CachedLayoutCalculation.baseline, (
          constraints,
          baseline,
        ), _computeDryBaseline).offset;
    // This assert makes sure computeDryBaseline always gets called in debug mode,
    // in case the computeDryBaseline implementation invokes debugCannotComputeDryLayout.
    // This check should be skipped when debugCheckingIntrinsics is true to avoid
    // slowing down the app significantly.
    assert(
      RenderObject.debugCheckingIntrinsics ||
          baselineOffset == computeDryBaseline(constraints, baseline),
    );
    return baselineOffset;
  }

  bool _computingThisDryBaseline = false;
  BaselineOffset _computeDryBaseline((BoxConstraints, TextBaseline) pair) {
    assert(() {
      assert(!_computingThisDryBaseline);
      _computingThisDryBaseline = true;
      return true;
    }());
    final BaselineOffset result = BaselineOffset(computeDryBaseline(pair.$1, pair.$2));
    assert(() {
      assert(_computingThisDryBaseline);
      _computingThisDryBaseline = false;
      return true;
    }());
    return result;
  }

  /// Computes the value returned by [getDryBaseline].
  ///
  /// This method is for overriding only and shouldn't be called directly. To
  /// get this [RenderBox]'s speculative baseline location for the given
  /// `constraints`, call [getDryBaseline] instead.
  ///
  /// The "dry" in the method name means the implementation must not produce
  /// observable side effects when called. For example, it must not change the
  /// [size] of the [RenderBox], or its children's paint offsets, otherwise that
  /// would results in UI changes when [paint] is called, or hit-testing behavior
  /// changes when [hitTest] is called. Moreover, accessing the current layout
  /// of this [RenderBox] or child [RenderBox]es (including accessing [size], or
  /// `child.size`) usually indicates a bug in the implementation, as the current
  /// layout is typically calculated using a set of [BoxConstraints] that's
  /// different from the `constraints` given as the first parameter. To get the
  /// size of this [RenderBox] or a child [RenderBox] in this method's
  /// implementation, use the [getDryLayout] method instead.
  ///
  /// The implementation must return a value that represents the distance from
  /// the top of the box to the first baseline of the box's contents, for the
  /// given `constraints`, or `null` if the [RenderBox] has no baselines. It's
  /// the same exact value [RenderBox.computeDistanceToActualBaseline] would
  /// return, when this [RenderBox] was laid out at `constraints` in the same
  /// exact state.
  ///
  /// Not all [RenderBox]es support dry baseline computation. For example, to
  /// compute the dry baseline of a [LayoutBuilder], its `builder` may have to
  /// be called with different constraints, which may have side effects such as
  /// updating the widget tree, violating the "dry" contract. In such cases the
  /// [RenderBox] must call [debugCannotComputeDryLayout] in an assert, and
  /// return a dummy baseline offset value (such as `null`).
  @visibleForOverriding
  @protected
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) {
    assert(
      debugCannotComputeDryLayout(
        error: FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'The ${objectRuntimeType(this, 'RenderBox')} class does not implement "computeDryBaseline".',
          ),
          ErrorHint(
            'If you are not writing your own RenderBox subclass, then this is not\n'
            'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
          ),
        ]),
      ),
    );
    return null;
  }

  static bool _debugDryLayoutCalculationValid = true;

  /// Called from [computeDryLayout] or [computeDryBaseline] within an assert if
  /// the given [RenderBox] subclass does not support calculating a dry layout.
  ///
  /// When asserts are enabled and [debugCheckingIntrinsics] is not true, this
  /// method will either throw the provided [FlutterError] or it will create and
  /// throw a [FlutterError] with the provided `reason`. Otherwise, it will
  /// return true.
  ///
  /// One of the arguments has to be provided.
  ///
  /// See also:
  ///
  ///  * [computeDryLayout], which lists some reasons why it may not be feasible
  ///    to compute the dry layout.
  bool debugCannotComputeDryLayout({String? reason, FlutterError? error}) {
    assert((reason == null) != (error == null));
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        if (reason != null) {
          assert(error == null);
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              'The ${objectRuntimeType(this, 'RenderBox')} class does not support dry layout.',
            ),
            if (reason.isNotEmpty) ErrorDescription(reason),
          ]);
        }
        assert(error != null);
        throw error!;
      }
      _debugDryLayoutCalculationValid = false;
      return true;
    }());
    return true;
  }

  /// Whether this render object has undergone layout and has a [size].
  bool get hasSize => _size != null;

  /// The size of this render box computed during layout.
  ///
  /// This value is stale whenever this object is marked as needing layout.
  /// During [performLayout], do not read the size of a child unless you pass
  /// true for parentUsesSize when calling the child's [layout] function.
  ///
  /// The size of a box should be set only during the box's [performLayout] or
  /// [performResize] functions. If you wish to change the size of a box outside
  /// of those functions, call [markNeedsLayout] instead to schedule a layout of
  /// the box.
  Size get size {
    assert(hasSize, 'RenderBox was not laid out: $this');
    assert(() {
      final Size? size = _size;
      if (size is _DebugSize) {
        assert(size._owner == this);
        final RenderObject? parent = this.parent;
        // Whether the size getter is accessed during layout (but not in a
        // layout callback).
        final bool doingRegularLayout =
            !(RenderObject.debugActiveLayout?.debugDoingThisLayoutWithCallback ?? true);
        final bool sizeAccessAllowed =
            !doingRegularLayout ||
            debugDoingThisResize ||
            debugDoingThisLayout ||
            _computingThisDryLayout ||
            RenderObject.debugActiveLayout == parent && size._canBeUsedByParent;
        assert(
          sizeAccessAllowed,
          'RenderBox.size accessed beyond the scope of resize, layout, or '
          'permitted parent access. RenderBox can always access its own size, '
          'otherwise, the only object that is allowed to read RenderBox.size '
          'is its parent, if they have said they will. It you hit this assert '
          'trying to access a child\'s size, pass "parentUsesSize: true" to '
          "that child's layout() in ${objectRuntimeType(this, 'RenderBox')}.performLayout.",
        );
        final RenderBox? renderBoxDoingDryBaseline =
            _computingThisDryBaseline
                ? this
                : (parent is RenderBox && parent._computingThisDryBaseline ? parent : null);
        assert(
          renderBoxDoingDryBaseline == null,
          'RenderBox.size accessed in '
          '${objectRuntimeType(renderBoxDoingDryBaseline, 'RenderBox')}.computeDryBaseline.'
          'The computeDryBaseline method must not access '
          '${renderBoxDoingDryBaseline == this ? "the RenderBox's own size" : "the size of its child"},'
          "because it's established in performLayout or performResize using different BoxConstraints.",
        );
        assert(size == _size);
      }
      return true;
    }());
    return _size ??
        (throw StateError('RenderBox was not laid out: $runtimeType#${shortHash(this)}'));
  }

  Size? _size;

  /// Setting the size, in debug mode, triggers some analysis of the render box,
  /// as implemented by [debugAssertDoesMeetConstraints], including calling the intrinsic
  /// sizing methods and checking that they meet certain invariants.
  @protected
  set size(Size value) {
    assert(!(debugDoingThisResize && debugDoingThisLayout));
    assert(sizedByParent || !debugDoingThisResize);
    assert(() {
      if ((sizedByParent && debugDoingThisResize) || (!sizedByParent && debugDoingThisLayout)) {
        return true;
      }
      assert(!debugDoingThisResize);
      final List<DiagnosticsNode> information = <DiagnosticsNode>[
        ErrorSummary('RenderBox size setter called incorrectly.'),
      ];
      if (debugDoingThisLayout) {
        assert(sizedByParent);
        information.add(
          ErrorDescription('It appears that the size setter was called from performLayout().'),
        );
      } else {
        information.add(
          ErrorDescription(
            'The size setter was called from outside layout (neither performResize() nor performLayout() were being run for this object).',
          ),
        );
        if (owner != null && owner!.debugDoingLayout) {
          information.add(
            ErrorDescription(
              'Only the object itself can set its size. It is a contract violation for other objects to set it.',
            ),
          );
        }
      }
      if (sizedByParent) {
        information.add(
          ErrorDescription(
            'Because this RenderBox has sizedByParent set to true, it must set its size in performResize().',
          ),
        );
      } else {
        information.add(
          ErrorDescription(
            'Because this RenderBox has sizedByParent set to false, it must set its size in performLayout().',
          ),
        );
      }
      throw FlutterError.fromParts(information);
    }());
    assert(() {
      value = debugAdoptSize(value);
      return true;
    }());
    _size = value;
    assert(() {
      debugAssertDoesMeetConstraints();
      return true;
    }());
  }

  /// Claims ownership of the given [Size].
  ///
  /// In debug mode, the [RenderBox] class verifies that [Size] objects obtained
  /// from other [RenderBox] objects are only used according to the semantics of
  /// the [RenderBox] protocol, namely that a [Size] from a [RenderBox] can only
  /// be used by its parent, and then only if `parentUsesSize` was set.
  ///
  /// Sometimes, a [Size] that can validly be used ends up no longer being valid
  /// over time. The common example is a [Size] taken from a child that is later
  /// removed from the parent. In such cases, this method can be called to first
  /// check whether the size can legitimately be used, and if so, to then create
  /// a new [Size] that can be used going forward, regardless of what happens to
  /// the original owner.
  Size debugAdoptSize(Size value) {
    Size result = value;
    assert(() {
      if (value is _DebugSize) {
        if (value._owner != this) {
          if (value._owner.parent != this) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('The size property was assigned a size inappropriately.'),
              describeForError('The following render object'),
              value._owner.describeForError('...was assigned a size obtained from'),
              ErrorDescription(
                'However, this second render object is not, or is no longer, a '
                'child of the first, and it is therefore a violation of the '
                'RenderBox layout protocol to use that size in the layout of the '
                'first render object.',
              ),
              ErrorHint(
                'If the size was obtained at a time where it was valid to read '
                'the size (because the second render object above was a child '
                'of the first at the time), then it should be adopted using '
                'debugAdoptSize at that time.',
              ),
              ErrorHint(
                'If the size comes from a grandchild or a render object from an '
                'entirely different part of the render tree, then there is no '
                'way to be notified when the size changes and therefore attempts '
                'to read that size are almost certainly a source of bugs. A different '
                'approach should be used.',
              ),
            ]);
          }
          if (!value._canBeUsedByParent) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary("A child's size was used without setting parentUsesSize."),
              describeForError('The following render object'),
              value._owner.describeForError('...was assigned a size obtained from its child'),
              ErrorDescription(
                'However, when the child was laid out, the parentUsesSize argument '
                'was not set or set to false. Subsequently this transpired to be '
                'inaccurate: the size was nonetheless used by the parent.\n'
                'It is important to tell the framework if the size will be used or not '
                'as several important performance optimizations can be made if the '
                'size will not be used by the parent.',
              ),
            ]);
          }
        }
      }
      result = _DebugSize(value, this, debugCanParentUseSize);
      return true;
    }());
    return result;
  }

  @override
  Rect get semanticBounds => Offset.zero & size;

  @override
  void debugResetSize() {
    // updates the value of size._canBeUsedByParent if necessary
    size = size; // ignore: no_self_assignments
  }

  static bool _debugDoingBaseline = false;
  static bool _debugSetDoingBaseline(bool value) {
    _debugDoingBaseline = value;
    return true;
  }

  /// Returns the distance from the y-coordinate of the position of the box to
  /// the y-coordinate of the first given baseline in the box's contents.
  ///
  /// Used by certain layout models to align adjacent boxes on a common
  /// baseline, regardless of padding, font size differences, etc. If there is
  /// no baseline, this function returns the distance from the y-coordinate of
  /// the position of the box to the y-coordinate of the bottom of the box
  /// (i.e., the height of the box) unless the caller passes true
  /// for `onlyReal`, in which case the function returns null.
  ///
  /// Only call this function after calling [layout] on this box. You
  /// are only allowed to call this from the parent of this box during
  /// that parent's [performLayout] or [paint] functions.
  ///
  /// When implementing a [RenderBox] subclass, to override the baseline
  /// computation, override [computeDistanceToActualBaseline].
  ///
  /// See also:
  ///
  ///  * [getDryBaseline], which returns the baseline location of this
  ///    [RenderBox] at a certain [BoxConstraints].
  double? getDistanceToBaseline(TextBaseline baseline, {bool onlyReal = false}) {
    assert(
      !_debugDoingBaseline,
      'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.',
    );
    assert(!debugNeedsLayout || RenderObject.debugCheckingIntrinsics);
    assert(
      RenderObject.debugCheckingIntrinsics ||
          switch (owner!) {
            PipelineOwner(debugDoingLayout: true) =>
              RenderObject.debugActiveLayout == parent && parent!.debugDoingThisLayout,
            PipelineOwner(debugDoingPaint: true) =>
              RenderObject.debugActivePaint == parent && parent!.debugDoingThisPaint ||
                  (RenderObject.debugActivePaint == this && debugDoingThisPaint),
            PipelineOwner() => false,
          },
    );
    assert(_debugSetDoingBaseline(true));
    final double? result;
    try {
      result = getDistanceToActualBaseline(baseline);
    } finally {
      assert(_debugSetDoingBaseline(false));
    }
    if (result == null && !onlyReal) {
      return size.height;
    }
    return result;
  }

  /// Calls [computeDistanceToActualBaseline] and caches the result.
  ///
  /// This function must only be called from [getDistanceToBaseline] and
  /// [computeDistanceToActualBaseline]. Do not call this function directly from
  /// outside those two methods.
  @protected
  @mustCallSuper
  double? getDistanceToActualBaseline(TextBaseline baseline) {
    assert(
      _debugDoingBaseline,
      'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.',
    );
    return _computeIntrinsics(
      _CachedLayoutCalculation.baseline,
      (constraints, baseline),
      ((BoxConstraints, TextBaseline) pair) =>
          BaselineOffset(computeDistanceToActualBaseline(pair.$2)),
    ).offset;
  }

  /// Returns the distance from the y-coordinate of the position of the box to
  /// the y-coordinate of the first given baseline in the box's contents, if
  /// any, or null otherwise.
  ///
  /// Do not call this function directly. If you need to know the baseline of a
  /// child from an invocation of [performLayout] or [paint], call
  /// [getDistanceToBaseline].
  ///
  /// Subclasses should override this method to supply the distances to their
  /// baselines. When implementing this method, there are generally three
  /// strategies:
  ///
  ///  * For classes that use the [ContainerRenderObjectMixin] child model,
  ///    consider mixing in the [RenderBoxContainerDefaultsMixin] class and
  ///    using
  ///    [RenderBoxContainerDefaultsMixin.defaultComputeDistanceToFirstActualBaseline].
  ///
  ///  * For classes that define a particular baseline themselves, return that
  ///    value directly.
  ///
  ///  * For classes that have a child to which they wish to defer the
  ///    computation, call [getDistanceToActualBaseline] on the child (not
  ///    [computeDistanceToActualBaseline], the internal implementation, and not
  ///    [getDistanceToBaseline], the public entry point for this API).
  @visibleForOverriding
  @protected
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(
      _debugDoingBaseline,
      'Please see the documentation for computeDistanceToActualBaseline for the required calling conventions of this method.',
    );
    return null;
  }

  /// The box constraints most recently received from the parent.
  @override
  BoxConstraints get constraints => super.constraints as BoxConstraints;

  @override
  void debugAssertDoesMeetConstraints() {
    assert(() {
      if (!hasSize) {
        final DiagnosticsNode contract;
        if (sizedByParent) {
          contract = ErrorDescription(
            'Because this RenderBox has sizedByParent set to true, it must set its size in performResize().',
          );
        } else {
          contract = ErrorDescription(
            'Because this RenderBox has sizedByParent set to false, it must set its size in performLayout().',
          );
        }
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('RenderBox did not set its size during layout.'),
          contract,
          ErrorDescription(
            'It appears that this did not happen; layout completed, but the size property is still null.',
          ),
          DiagnosticsProperty<RenderBox>(
            'The RenderBox in question is',
            this,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
        ]);
      }
      // verify that the size is not infinite
      if (!_size!.isFinite) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('$runtimeType object was given an infinite size during layout.'),
          ErrorDescription(
            'This probably means that it is a render object that tries to be '
            'as big as possible, but it was put inside another render object '
            'that allows its children to pick their own size.',
          ),
        ];
        if (!constraints.hasBoundedWidth) {
          RenderBox node = this;
          while (!node.constraints.hasBoundedWidth && node.parent is RenderBox) {
            node = node.parent! as RenderBox;
          }

          information.add(
            node.describeForError(
              'The nearest ancestor providing an unbounded width constraint is',
            ),
          );
        }
        if (!constraints.hasBoundedHeight) {
          RenderBox node = this;
          while (!node.constraints.hasBoundedHeight && node.parent is RenderBox) {
            node = node.parent! as RenderBox;
          }

          information.add(
            node.describeForError(
              'The nearest ancestor providing an unbounded height constraint is',
            ),
          );
        }
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ...information,
          DiagnosticsProperty<BoxConstraints>(
            'The constraints that applied to the $runtimeType were',
            constraints,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
          DiagnosticsProperty<Size>(
            'The exact size it was given was',
            _size,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
          ErrorHint('See https://flutter.dev/to/unbounded-constraints for more information.'),
        ]);
      }
      // verify that the size is within the constraints
      if (!constraints.isSatisfiedBy(_size!)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType does not meet its constraints.'),
          DiagnosticsProperty<BoxConstraints>(
            'Constraints',
            constraints,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
          DiagnosticsProperty<Size>('Size', _size, style: DiagnosticsTreeStyle.errorProperty),
          ErrorHint(
            'If you are not writing your own RenderBox subclass, then this is not '
            'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
          ),
        ]);
      }
      if (debugCheckIntrinsicSizes) {
        // verify that the intrinsics are sane
        assert(!RenderObject.debugCheckingIntrinsics);
        RenderObject.debugCheckingIntrinsics = true;
        final List<DiagnosticsNode> failures = <DiagnosticsNode>[];

        double testIntrinsic(
          double Function(double extent) function,
          String name,
          double constraint,
        ) {
          final double result = function(constraint);
          if (result < 0) {
            failures.add(
              ErrorDescription(' * $name($constraint) returned a negative value: $result'),
            );
          }
          if (!result.isFinite) {
            failures.add(
              ErrorDescription(' * $name($constraint) returned a non-finite value: $result'),
            );
          }
          return result;
        }

        void testIntrinsicsForValues(
          double Function(double extent) getMin,
          double Function(double extent) getMax,
          String name,
          double constraint,
        ) {
          final double min = testIntrinsic(getMin, 'getMinIntrinsic$name', constraint);
          final double max = testIntrinsic(getMax, 'getMaxIntrinsic$name', constraint);
          if (min > max) {
            failures.add(
              ErrorDescription(
                ' * getMinIntrinsic$name($constraint) returned a larger value ($min) than getMaxIntrinsic$name($constraint) ($max)',
              ),
            );
          }
        }

        try {
          testIntrinsicsForValues(
            getMinIntrinsicWidth,
            getMaxIntrinsicWidth,
            'Width',
            double.infinity,
          );
          testIntrinsicsForValues(
            getMinIntrinsicHeight,
            getMaxIntrinsicHeight,
            'Height',
            double.infinity,
          );
          if (constraints.hasBoundedWidth) {
            testIntrinsicsForValues(
              getMinIntrinsicWidth,
              getMaxIntrinsicWidth,
              'Width',
              constraints.maxHeight,
            );
          }
          if (constraints.hasBoundedHeight) {
            testIntrinsicsForValues(
              getMinIntrinsicHeight,
              getMaxIntrinsicHeight,
              'Height',
              constraints.maxWidth,
            );
          }
          // TODO(ianh): Test that values are internally consistent in more ways than the above.
        } finally {
          RenderObject.debugCheckingIntrinsics = false;
        }

        if (failures.isNotEmpty) {
          // TODO(jacobr): consider nesting the failures object so it is collapsible.
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              'The intrinsic dimension methods of the $runtimeType class returned values that violate the intrinsic protocol contract.',
            ),
            ErrorDescription(
              'The following ${failures.length > 1 ? "failures" : "failure"} was detected:',
            ), // should this be tagged as an error or not?
            ...failures,
            ErrorHint(
              'If you are not writing your own RenderBox subclass, then this is not\n'
              'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
            ),
          ]);
        }

        // Checking that getDryLayout computes the same size.
        _debugDryLayoutCalculationValid = true;
        RenderObject.debugCheckingIntrinsics = true;
        final Size dryLayoutSize;
        try {
          dryLayoutSize = getDryLayout(constraints);
        } finally {
          RenderObject.debugCheckingIntrinsics = false;
        }
        if (_debugDryLayoutCalculationValid && dryLayoutSize != size) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              'The size given to the ${objectRuntimeType(this, 'RenderBox')} class differs from the size computed by computeDryLayout.',
            ),
            ErrorDescription(
              'The size computed in ${sizedByParent ? 'performResize' : 'performLayout'} '
              'is $size, which is different from $dryLayoutSize, which was computed by computeDryLayout.',
            ),
            ErrorDescription('The constraints used were $constraints.'),
            ErrorHint(
              'If you are not writing your own RenderBox subclass, then this is not\n'
              'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
            ),
          ]);
        }
      }
      return true;
    }());
  }

  void _debugVerifyDryBaselines() {
    assert(() {
      final List<DiagnosticsNode> messages = <DiagnosticsNode>[
        ErrorDescription('The constraints used were $constraints.'),
        ErrorHint(
          'If you are not writing your own RenderBox subclass, then this is not\n'
          'your fault. Contact support: https://github.com/flutter/flutter/issues/new?template=2_bug.yml',
        ),
      ];

      for (final TextBaseline baseline in TextBaseline.values) {
        assert(!RenderObject.debugCheckingIntrinsics);
        RenderObject.debugCheckingIntrinsics = true;
        _debugDryLayoutCalculationValid = true;
        final double? dryBaseline;
        final double? realBaseline;
        try {
          dryBaseline = getDryBaseline(constraints, baseline);
          realBaseline = getDistanceToBaseline(baseline, onlyReal: true);
        } finally {
          RenderObject.debugCheckingIntrinsics = false;
        }
        assert(!RenderObject.debugCheckingIntrinsics);
        if (!_debugDryLayoutCalculationValid || dryBaseline == realBaseline) {
          continue;
        }
        if ((dryBaseline == null) != (realBaseline == null)) {
          final (String methodReturnedNull, String methodReturnedNonNull) =
              dryBaseline == null
                  ? ('computeDryBaseline', 'computeDistanceToActualBaseline')
                  : ('computeDistanceToActualBaseline', 'computeDryBaseline');
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              'The $baseline location returned by ${objectRuntimeType(this, 'RenderBox')}.computeDistanceToActualBaseline '
              'differs from the baseline location computed by computeDryBaseline.',
            ),
            ErrorDescription(
              'The $methodReturnedNull method returned null while the $methodReturnedNonNull returned a non-null $baseline of ${dryBaseline ?? realBaseline}. '
              'Did you forget to implement $methodReturnedNull for ${objectRuntimeType(this, 'RenderBox')}?',
            ),
            ...messages,
          ]);
        } else {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              'The $baseline location returned by ${objectRuntimeType(this, 'RenderBox')}.computeDistanceToActualBaseline '
              'differs from the baseline location computed by computeDryBaseline.',
            ),
            DiagnosticsProperty<RenderObject>('The RenderBox was', this),
            ErrorDescription(
              'The computeDryBaseline method returned $dryBaseline,\n'
              'while the computeDistanceToActualBaseline method returned $realBaseline.\n'
              'Consider checking the implementations of the following methods on the ${objectRuntimeType(this, 'RenderBox')} class and make sure they are consistent:\n'
              ' * computeDistanceToActualBaseline\n'
              ' * computeDryBaseline\n'
              ' * performLayout\n',
            ),
            ...messages,
          ]);
        }
      }
      return true;
    }());
  }

  @override
  void markNeedsLayout() {
    // If `_layoutCacheStorage.clear` returns true, then this [RenderBox]'s layout
    // is used by the parent's layout algorithm (it's possible that the parent
    // only used the intrinsics for paint, but there's no good way to detect that
    // so we conservatively assume it's a layout dependency).
    //
    // A render object's performLayout implementation may depend on the baseline
    // location or the intrinsic dimensions of a descendant, even when there are
    // relayout boundaries between them. The `_layoutCacheStorage` being non-empty
    // indicates that the parent depended on this RenderBox's baseline location,
    // or intrinsic sizes, and thus may need relayout, regardless of relayout
    // boundaries.
    //
    // Some calculations may fail (dry baseline, for example). The layout
    // dependency is still established, but only from the RenderBox that failed
    // to compute the dry baseline to the ancestor that queried the dry baseline.
    if (_layoutCacheStorage.clear() && parent != null) {
      markParentNeedsLayout();
      return;
    }
    super.markNeedsLayout();
  }

  /// {@macro flutter.rendering.RenderObject.performResize}
  ///
  /// By default this method sets [size] to the result of [computeDryLayout]
  /// called with the current [constraints]. Instead of overriding this method,
  /// consider overriding [computeDryLayout].
  @override
  void performResize() {
    // default behavior for subclasses that have sizedByParent = true
    size = computeDryLayout(constraints);
    assert(size.isFinite);
  }

  @override
  void performLayout() {
    assert(() {
      if (!sizedByParent) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType did not implement performLayout().'),
          ErrorHint(
            'RenderBox subclasses need to either override performLayout() to '
            'set a size and lay out any children, or, set sizedByParent to true '
            'so that performResize() sizes the render object.',
          ),
        ]);
      }
      return true;
    }());
  }

  /// Determines the set of render objects located at the given position.
  ///
  /// Returns true, and adds any render objects that contain the point to the
  /// given hit test result, if this render object or one of its descendants
  /// absorbs the hit (preventing objects below this one from being hit).
  /// Returns false if the hit can continue to other objects below this one.
  ///
  /// The caller is responsible for transforming [position] from global
  /// coordinates to its location relative to the origin of this [RenderBox].
  /// This [RenderBox] is responsible for checking whether the given position is
  /// within its bounds.
  ///
  /// If transforming is necessary, [BoxHitTestResult.addWithPaintTransform],
  /// [BoxHitTestResult.addWithPaintOffset], or
  /// [BoxHitTestResult.addWithRawTransform] need to be invoked by the caller
  /// to record the required transform operations in the [HitTestResult]. These
  /// methods will also help with applying the transform to `position`.
  ///
  /// Hit testing requires layout to be up-to-date but does not require painting
  /// to be up-to-date. That means a render object can rely upon [performLayout]
  /// having been called in [hitTest] but cannot rely upon [paint] having been
  /// called. For example, a render object might be a child of a [RenderOpacity]
  /// object, which calls [hitTest] on its children when its opacity is zero
  /// even though it does not [paint] its children.
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    assert(() {
      if (!hasSize) {
        if (debugNeedsLayout) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('Cannot hit test a render box that has never been laid out.'),
            describeForError('The hitTest() method was called on this RenderBox'),
            ErrorDescription(
              "Unfortunately, this object's geometry is not known at this time, "
              'probably because it has never been laid out. '
              'This means it cannot be accurately hit-tested.',
            ),
            ErrorHint(
              'If you are trying '
              'to perform a hit test during the layout phase itself, make sure '
              "you only hit test nodes that have completed layout (e.g. the node's "
              'children, after their layout() method has been called).',
            ),
          ]);
        }
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('Cannot hit test a render box with no size.'),
          describeForError('The hitTest() method was called on this RenderBox'),
          ErrorDescription(
            'Although this node is not marked as needing layout, '
            'its size is not set.',
          ),
          ErrorHint(
            'A RenderBox object must have an '
            'explicit size before it can be hit-tested. Make sure '
            'that the RenderBox in question sets its size during layout.',
          ),
        ]);
      }
      return true;
    }());
    if (_size!.contains(position)) {
      if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }

  /// Override this method if this render object can be hit even if its
  /// children were not hit.
  ///
  /// Returns true if the specified `position` should be considered a hit
  /// on this render object.
  ///
  /// The caller is responsible for transforming [position] from global
  /// coordinates to its location relative to the origin of this [RenderBox].
  /// This [RenderBox] is responsible for checking whether the given position is
  /// within its bounds.
  ///
  /// Used by [hitTest]. If you override [hitTest] and do not call this
  /// function, then you don't need to implement this function.
  @protected
  bool hitTestSelf(Offset position) => false;

  /// Override this method to check whether any children are located at the
  /// given position.
  ///
  /// Subclasses should return true if at least one child reported a hit at the
  /// specified position.
  ///
  /// Typically children should be hit-tested in reverse paint order so that
  /// hit tests at locations where children overlap hit the child that is
  /// visually "on top" (i.e., paints later).
  ///
  /// The caller is responsible for transforming [position] from global
  /// coordinates to its location relative to the origin of this [RenderBox].
  /// Likewise, this [RenderBox] is responsible for transforming the position
  /// that it passes to its children when it calls [hitTest] on each child.
  ///
  /// If transforming is necessary, [BoxHitTestResult.addWithPaintTransform],
  /// [BoxHitTestResult.addWithPaintOffset], or
  /// [BoxHitTestResult.addWithRawTransform] need to be invoked by subclasses to
  /// record the required transform operations in the [BoxHitTestResult]. These
  /// methods will also help with applying the transform to `position`.
  ///
  /// Used by [hitTest]. If you override [hitTest] and do not call this
  /// function, then you don't need to implement this function.
  @protected
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => false;

  /// Multiply the transform from the parent's coordinate system to this box's
  /// coordinate system into the given transform.
  ///
  /// This function is used to convert coordinate systems between boxes.
  /// Subclasses that apply transforms during painting should override this
  /// function to factor those transforms into the calculation.
  ///
  /// The [RenderBox] implementation takes care of adjusting the matrix for the
  /// position of the given child as determined during layout and stored on the
  /// child's [parentData] in the [BoxParentData.offset] field.
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child.parent == this);
    assert(() {
      if (child.parentData is! BoxParentData) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType does not implement applyPaintTransform.'),
          describeForError('The following $runtimeType object'),
          child.describeForError(
            '...did not use a BoxParentData class for the parentData field of the following child',
          ),
          ErrorDescription('The $runtimeType class inherits from RenderBox.'),
          ErrorHint(
            'The default applyPaintTransform implementation provided by RenderBox assumes that the '
            'children all use BoxParentData objects for their parentData field. '
            'Since $runtimeType does not in fact use that ParentData class for its children, it must '
            'provide an implementation of applyPaintTransform that supports the specific ParentData '
            'subclass used by its children (which apparently is ${child.parentData.runtimeType}).',
          ),
        ]);
      }
      return true;
    }());
    final BoxParentData childParentData = child.parentData! as BoxParentData;
    final Offset offset = childParentData.offset;
    transform.translate(offset.dx, offset.dy);
  }

  /// Convert the given point from the global coordinate system in logical pixels
  /// to the local coordinate system for this box.
  ///
  /// This method will un-project the point from the screen onto the widget,
  /// which makes it different from [MatrixUtils.transformPoint].
  ///
  /// If the transform from global coordinates to local coordinates is
  /// degenerate, this function returns [Offset.zero].
  ///
  /// If `ancestor` is non-null, this function converts the given point from the
  /// coordinate system of `ancestor` (which must be an ancestor of this render
  /// object) instead of from the global coordinate system.
  ///
  /// This method is implemented in terms of [getTransformTo].
  Offset globalToLocal(Offset point, {RenderObject? ancestor}) {
    // We want to find point (p) that corresponds to a given point on the
    // screen (s), but that also physically resides on the local render plane,
    // so that it is useful for visually accurate gesture processing in the
    // local space. For that, we can't simply transform 2D screen point to
    // the 3D local space since the screen space lacks the depth component |z|,
    // and so there are many 3D points that correspond to the screen point.
    // We must first unproject the screen point onto the render plane to find
    // the true 3D point that corresponds to the screen point.
    // We do orthogonal unprojection after undoing perspective, in local space.
    // The render plane is specified by renderBox offset (o) and Z axis (n).
    // Unprojection is done by finding the intersection of the view vector (d)
    // with the local X-Y plane: (o-s).dot(n) == (p-s).dot(n), (p-s) == |z|*d.
    final Matrix4 transform = getTransformTo(ancestor);
    final double det = transform.invert();
    if (det == 0.0) {
      return Offset.zero;
    }
    final Vector3 n = Vector3(0.0, 0.0, 1.0);
    final Vector3 i = transform.perspectiveTransform(Vector3(0.0, 0.0, 0.0));
    final Vector3 d = transform.perspectiveTransform(Vector3(0.0, 0.0, 1.0)) - i;
    final Vector3 s = transform.perspectiveTransform(Vector3(point.dx, point.dy, 0.0));
    final Vector3 p = s - d * (n.dot(s) / n.dot(d));
    return Offset(p.x, p.y);
  }

  /// Convert the given point from the local coordinate system for this box to
  /// the global coordinate system in logical pixels.
  ///
  /// If `ancestor` is non-null, this function converts the given point to the
  /// coordinate system of `ancestor` (which must be an ancestor of this render
  /// object) instead of to the global coordinate system.
  ///
  /// This method is implemented in terms of [getTransformTo]. If the transform
  /// matrix puts the given `point` on the line at infinity (for instance, when
  /// the transform matrix is the zero matrix), this method returns (NaN, NaN).
  Offset localToGlobal(Offset point, {RenderObject? ancestor}) {
    return MatrixUtils.transformPoint(getTransformTo(ancestor), point);
  }

  /// Returns a rectangle that contains all the pixels painted by this box.
  ///
  /// The paint bounds can be larger or smaller than [size], which is the amount
  /// of space this box takes up during layout. For example, if this box casts a
  /// shadow, that shadow might extend beyond the space allocated to this box
  /// during layout.
  ///
  /// The paint bounds are used to size the buffers into which this box paints.
  /// If the box attempts to paints outside its paint bounds, there might not be
  /// enough memory allocated to represent the box's visual appearance, which
  /// can lead to undefined behavior.
  ///
  /// The returned paint bounds are in the local coordinate system of this box.
  @override
  Rect get paintBounds => Offset.zero & size;

  /// Override this method to handle pointer events that hit this render object.
  ///
  /// For [RenderBox] objects, the `entry` argument is a [BoxHitTestEntry]. From this
  /// object you can determine the [PointerDownEvent]'s position in local coordinates.
  /// (This is useful because [PointerEvent.position] is in global coordinates.)
  ///
  /// Implementations of this method should call [debugHandleEvent] as follows,
  /// so that they support [debugPaintPointersEnabled]:
  ///
  /// ```dart
  /// class RenderFoo extends RenderBox {
  ///   // ...
  ///
  ///   @override
  ///   void handleEvent(PointerEvent event, HitTestEntry entry) {
  ///     assert(debugHandleEvent(event, entry));
  ///     // ... handle the event ...
  ///   }
  ///
  ///   // ...
  /// }
  /// ```
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
  }

  int _debugActivePointers = 0;

  /// Implements the [debugPaintPointersEnabled] debugging feature.
  ///
  /// [RenderBox] subclasses that implement [handleEvent] should call
  /// [debugHandleEvent] from their [handleEvent] method, as follows:
  ///
  /// ```dart
  /// class RenderFoo extends RenderBox {
  ///   // ...
  ///
  ///   @override
  ///   void handleEvent(PointerEvent event, HitTestEntry entry) {
  ///     assert(debugHandleEvent(event, entry));
  ///     // ... handle the event ...
  ///   }
  ///
  ///   // ...
  /// }
  /// ```
  ///
  /// If you call this for a [PointerDownEvent], make sure you also call it for
  /// the corresponding [PointerUpEvent] or [PointerCancelEvent].
  bool debugHandleEvent(PointerEvent event, HitTestEntry entry) {
    assert(() {
      if (debugPaintPointersEnabled) {
        if (event is PointerDownEvent) {
          _debugActivePointers += 1;
        } else if (event is PointerUpEvent || event is PointerCancelEvent) {
          _debugActivePointers -= 1;
        }
        markNeedsPaint();
      }
      return true;
    }());
    return true;
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      // Only perform the baseline checks after `PipelineOwner.flushLayout` completes.
      // We can't run this check in the same places we run other intrinsics checks
      // (in the `RenderBox.size` setter, or after `performResize`), because
      // `getDistanceToBaseline` may depend on the layout of the child so it's
      // the safest to only call `getDistanceToBaseline` after the entire tree
      // finishes doing layout.
      //
      // Descendant `RenderObject`s typically call `debugPaint` before their
      // parents do. This means the baseline implementations are checked from
      // descendants to ancestors, allowing us to spot the `RenderBox` with an
      // inconsistent implementation, instead of its ancestors that only reported
      // inconsistent baseline values because one of its ancestors has an
      // inconsistent implementation.
      if (debugCheckIntrinsicSizes) {
        _debugVerifyDryBaselines();
      }
      if (debugPaintSizeEnabled) {
        debugPaintSize(context, offset);
      }
      if (debugPaintBaselinesEnabled) {
        debugPaintBaselines(context, offset);
      }
      if (debugPaintPointersEnabled) {
        debugPaintPointers(context, offset);
      }
      return true;
    }());
  }

  /// In debug mode, paints a border around this render box.
  ///
  /// Called for every [RenderBox] when [debugPaintSizeEnabled] is true.
  @protected
  @visibleForTesting
  void debugPaintSize(PaintingContext context, Offset offset) {
    assert(() {
      final Paint paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = const Color(0xFF00FFFF);
      context.canvas.drawRect((offset & size).deflate(0.5), paint);
      return true;
    }());
  }

  /// In debug mode, paints a line for each baseline.
  ///
  /// Called for every [RenderBox] when [debugPaintBaselinesEnabled] is true.
  @protected
  void debugPaintBaselines(PaintingContext context, Offset offset) {
    assert(() {
      final Paint paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.25;
      Path path;
      // ideographic baseline
      final double? baselineI = getDistanceToBaseline(TextBaseline.ideographic, onlyReal: true);
      if (baselineI != null) {
        paint.color = const Color(0xFFFFD000);
        path = Path();
        path.moveTo(offset.dx, offset.dy + baselineI);
        path.lineTo(offset.dx + size.width, offset.dy + baselineI);
        context.canvas.drawPath(path, paint);
      }
      // alphabetic baseline
      final double? baselineA = getDistanceToBaseline(TextBaseline.alphabetic, onlyReal: true);
      if (baselineA != null) {
        paint.color = const Color(0xFF00FF00);
        path = Path();
        path.moveTo(offset.dx, offset.dy + baselineA);
        path.lineTo(offset.dx + size.width, offset.dy + baselineA);
        context.canvas.drawPath(path, paint);
      }
      return true;
    }());
  }

  /// In debug mode, paints a rectangle if this render box has counted more
  /// pointer downs than pointer up events.
  ///
  /// Called for every [RenderBox] when [debugPaintPointersEnabled] is true.
  ///
  /// By default, events are not counted. For details on how to ensure that
  /// events are counted for your class, see [debugHandleEvent].
  @protected
  void debugPaintPointers(PaintingContext context, Offset offset) {
    assert(() {
      if (_debugActivePointers > 0) {
        final Paint paint = Paint()..color = Color(0x00BBBB | ((0x04000000 * depth) & 0xFF000000));
        context.canvas.drawRect(offset & size, paint);
      }
      return true;
    }());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('size', _size, missingIfNull: true));
  }
}