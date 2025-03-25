class RenderConstrainedBox extends RenderProxyBox {
    
  RenderConstrainedBox({RenderBox? child, required BoxConstraints additionalConstraints})
    : assert(additionalConstraints.debugAssertIsValid()),
      _additionalConstraints = additionalConstraints,
      super(child);

  /// Additional constraints to apply to [child] during layout.
  BoxConstraints get additionalConstraints => _additionalConstraints;
  BoxConstraints _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    assert(value.debugAssertIsValid());
    if (_additionalConstraints == value) {
      return;
    }
    _additionalConstraints = value;
    markNeedsLayout();
  }
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child!.layout(_additionalConstraints.enforce(constraints), parentUsesSize: true);
      size = child!.size;
    } else {
      size = _additionalConstraints.enforce(constraints).constrain(Size.zero);
    }
  }
}