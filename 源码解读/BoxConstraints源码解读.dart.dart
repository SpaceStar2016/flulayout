


class BoxConstraints extends Constraints {


  // 最小宽度
  final double minWidth;

  //最大宽度
  final double maxWidth;

  //最小高度
  final double minHeight;

  // 最大高度
  final double maxHeight;

  // 默认构造函数，构造出来的约束是松约束
  const BoxConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  //根据size 生成一个紧约束
  BoxConstraints.tight(Size size)
    : minWidth = size.width,
      maxWidth = size.width,
      minHeight = size.height,
      maxHeight = size.height;

  //生成单紧约束，如果width 和 height 同时传入，那么作用和tight 一样
  const BoxConstraints.tightFor({double? width, double? height})
    : minWidth = width ?? 0.0,
      maxWidth = width ?? double.infinity,
      minHeight = height ?? 0.0,
      maxHeight = height ?? double.infinity;


  // 生成一个松约束
  BoxConstraints.loose(Size size)
    : minWidth = 0.0,
      maxWidth = size.width,
      minHeight = 0.0,
      maxHeight = size.height;



  //返回一个范围在constraints 之间的约束
  BoxConstraints enforce(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: clampDouble(minWidth, constraints.minWidth, constraints.maxWidth),
      maxWidth: clampDouble(maxWidth, constraints.minWidth, constraints.maxWidth),
      minHeight: clampDouble(minHeight, constraints.minHeight, constraints.maxHeight),
      maxHeight: clampDouble(maxHeight, constraints.minHeight, constraints.maxHeight),
    );
  }


  //传入宽高，生成一个新的约束，新的约束必须同时满足原本的约束。
  BoxConstraints tighten({double? width, double? height}) {
    return BoxConstraints(
      minWidth: width == null ? minWidth : clampDouble(width, minWidth, maxWidth),
      maxWidth: width == null ? maxWidth : clampDouble(width, minWidth, maxWidth),
      minHeight: height == null ? minHeight : clampDouble(height, minHeight, maxHeight),
      maxHeight: height == null ? maxHeight : clampDouble(height, minHeight, maxHeight),
    );
  }

    //返回一个满足当前约束的宽度
  double constrainWidth([double width = double.infinity]) {
    assert(debugAssertIsValid());
    return clampDouble(width, minWidth, maxWidth);
  }

  //返回一个满足当前约束的高度
  double constrainHeight([double height = double.infinity]) {
    assert(debugAssertIsValid());
    return clampDouble(height, minHeight, maxHeight);
  }


  //返回一个满足当前约束的宽度和高度
  Size constrain(Size size) {
    Size result = Size(constrainWidth(size.width), constrainHeight(size.height));
    assert(() {
      result = _debugPropagateDebugSize(size, result);
      return true;
    }());
    return result;
  }
}
