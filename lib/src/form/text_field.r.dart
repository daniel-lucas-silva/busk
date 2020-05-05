part of "text_field.dart";

enum TextFieldType {
  DEFAULT,
  ROUNDED,
  CHAT,
}

enum _Slot {
  child,
  placeholder,
  error,
  prefix,
  suffix,
}

class TextFieldRender extends RenderObjectWidget {
  const TextFieldRender({
    Key key,
    @required this.child,
    @required this.placeholder,
    @required this.prefix,
    @required this.suffix,
    @required this.error,
    @required this.type,
  }) : super(key: key);

  final Widget child;
  final Widget placeholder;
  final Widget prefix;
  final Widget suffix;
  final Widget error;
  final TextFieldType type;

  @override
  _TextFieldElement createElement() => _TextFieldElement(this);

  @override
  _RenderTextField createRenderObject(BuildContext context) {
    return _RenderTextField(
      type: type,
      dividerThickness: kDividerThickness / MediaQuery.of(context).devicePixelRatio,
      dividerColor: Colors.divider.resolveFrom(context),
      backgroundColor: Colors.secondarySystemGroupedBackground.resolveFrom(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderTextField renderObject) {
    renderObject..type = type
      ..dividerThickness = kDividerThickness / MediaQuery.of(context).devicePixelRatio
      ..dividerColor = Colors.divider.resolveFrom(context)
      ..backgroundColor = Colors.secondarySystemGroupedBackground.resolveFrom(context);
  }
}

class _TextFieldElement extends RenderObjectElement {
  _TextFieldElement(TextFieldRender widget) : super(widget);

  final Map<_Slot, Element> slotToChild = <_Slot, Element>{};
  final Map<Element, _Slot> childToSlot = <Element, _Slot>{};

  @override
  TextFieldRender get widget => super.widget as TextFieldRender;

  @override
  _RenderTextField get renderObject => super.renderObject as _RenderTextField;

  @override
  void visitChildren(ElementVisitor visitor) {
    slotToChild.values.forEach(visitor);
  }

  @override
  void forgetChild(Element child) {
    assert(slotToChild.values.contains(child));
    assert(childToSlot.keys.contains(child));
    final _Slot slot = childToSlot[child];
    childToSlot.remove(child);
    slotToChild.remove(slot);
  }

  void _mountChild(Widget widget, _Slot slot) {
    final Element oldChild = slotToChild[slot];
    final Element newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      slotToChild.remove(slot);
      childToSlot.remove(oldChild);
    }
    if (newChild != null) {
      slotToChild[slot] = newChild;
      childToSlot[newChild] = slot;
    }
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _mountChild(widget.prefix, _Slot.prefix);
    _mountChild(widget.child, _Slot.child);
    _mountChild(widget.placeholder, _Slot.placeholder);
    _mountChild(widget.suffix, _Slot.suffix);
    _mountChild(widget.error, _Slot.error);
  }

  void _updateChild(Widget widget, _Slot slot) {
    final Element oldChild = slotToChild[slot];
    final Element newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      slotToChild[slot] = newChild;
      childToSlot[newChild] = slot;
    }
  }

  @override
  void update(TextFieldRender newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.prefix, _Slot.prefix);
    _updateChild(widget.child, _Slot.child);
    _updateChild(widget.placeholder, _Slot.placeholder);
    _updateChild(widget.suffix, _Slot.suffix);
    _updateChild(widget.error, _Slot.error);
  }

  void _updateRenderObject(RenderBox child, _Slot slot) {
    switch (slot) {
      case _Slot.prefix:
        renderObject.prefix = child;
        break;
      case _Slot.child:
        renderObject.child = child;
        break;
      case _Slot.placeholder:
        renderObject.placeholder = child;
        break;
      case _Slot.suffix:
        renderObject.suffix = child;
        break;
      case _Slot.error:
        renderObject.error = child;
        break;
    }
  }

  @override
  void insertChildRenderObject(RenderObject child, dynamic slotValue) {
    assert(child is RenderBox);
    assert(slotValue is _Slot);
    final _Slot slot = slotValue as _Slot;
    _updateRenderObject(child as RenderBox, slot);
    assert(renderObject.childToSlot.keys.contains(child));
    assert(renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(child is RenderBox);
    assert(renderObject.childToSlot.keys.contains(child));
    _updateRenderObject(null, renderObject.childToSlot[child]);
    assert(!renderObject.childToSlot.keys.contains(child));
    assert(!renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void moveChildRenderObject(RenderObject child, dynamic slotValue) {
    assert(false, 'not reachable');
  }
}

class _RenderTextField extends RenderBox {
  _RenderTextField({
    @required TextFieldType type,
    @required double dividerThickness,
    @required Color dividerColor,
    @required Color backgroundColor,
  })  : assert(type != null),
        _type = type,
        _dividerThickness = dividerThickness,
        _buttonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  static const double _kDGap = 10.0;

  final Paint _buttonBackgroundPaint;
  final Paint _dividerPaint;

  Color get backgroundColor => _buttonBackgroundPaint.color;
  set backgroundColor(Color newValue) {
    if (newValue == _buttonBackgroundPaint.color) {
      return;
    }
    _buttonBackgroundPaint.color = newValue;
    markNeedsPaint();
  }

  Color get dividerColor => _dividerPaint.color;
  set dividerColor(Color value) {
    if (value == _dividerPaint.color) {
      return;
    }
    _dividerPaint.color = value;
    markNeedsPaint();
  }

  double get dividerThickness => _dividerThickness;
  double _dividerThickness;

  set dividerThickness(double newValue) {
    if (newValue == _dividerThickness) {
      return;
    }

    _dividerThickness = newValue;
    markNeedsLayout();
  }

  final Map<_Slot, RenderBox> slotToChild = <_Slot, RenderBox>{};
  final Map<RenderBox, _Slot> childToSlot = <RenderBox, _Slot>{};

  RenderBox _updateChild(RenderBox oldChild, RenderBox newChild, _Slot slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      childToSlot[newChild] = slot;
      slotToChild[slot] = newChild;
      adoptChild(newChild);
    }
    return newChild;
  }

  RenderBox _child;

  RenderBox get child => _child;

  set child(RenderBox value) {
    _child = _updateChild(_child, value, _Slot.child);
  }

  RenderBox _placeholder;

  RenderBox get placeholder => _placeholder;

  set placeholder(RenderBox value) {
    _placeholder = _updateChild(_placeholder, value, _Slot.placeholder);
  }

  RenderBox _prefix;

  RenderBox get prefix => _prefix;

  set prefix(RenderBox value) {
    _prefix = _updateChild(_prefix, value, _Slot.prefix);
  }

  RenderBox _suffix;

  RenderBox get suffix => _suffix;

  set suffix(RenderBox value) {
    _suffix = _updateChild(_suffix, value, _Slot.suffix);
  }

  RenderBox _error;

  RenderBox get error => _error;

  set error(RenderBox value) {
    _error = _updateChild(_error, value, _Slot.error);
  }

  Iterable<RenderBox> get _children sync* {
    if (child != null) yield child;
    if (placeholder != null) yield placeholder;
    if (prefix != null) yield prefix;
    if (suffix != null) yield suffix;
    if (error != null) yield error;
  }

  TextFieldType get type => _type;
  TextFieldType _type;

  set type(TextFieldType value) {
    assert(value != null);
    if (_type == value) return;
    _type = value;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    for (RenderBox child in _children) child.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    for (RenderBox child in _children) child.detach();
  }

  @override
  void redepthChildren() {
    _children.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _children.forEach(visitor);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
    void add(RenderBox child, String name) {
      if (child != null) value.add(child.toDiagnosticsNode(name: name));
    }

    add(child, 'child');
    add(placeholder, 'placeholder');
    add(prefix, 'prefix');
    add(suffix, 'suffix');
    add(error, 'error');
    return value;
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  static double _minHeight(RenderBox box, double width) {
    return box == null ? 0.0 : box.getMinIntrinsicHeight(width);
  }

  static double _maxHeight(RenderBox box, double width) {
    return box == null ? 0.0 : box.getMaxIntrinsicHeight(width);
  }

//  @override
//  double computeMinIntrinsicWidth(double height) {
//    return _minWidth(child, height);
//  }
//
//  @override
//  double computeMaxIntrinsicWidth(double height) {
//    return _maxWidth(child, height);
//  }
//
//  @override
//  double computeMinIntrinsicHeight(double width) {
//    return _minHeight(child, width);
//  }
//
//  @override
//  double computeMaxIntrinsicHeight(double width) {
//    return _maxHeight(child, width);
//  }

//
//  @override
//  double computeDistanceToActualBaseline(TextBaseline baseline) {
//    assert(title != null);
//    final BoxParentData parentData = title.parentData as BoxParentData;
//    return parentData.offset.dy + title.getDistanceToActualBaseline(baseline);
//  }

  static Size _layoutBox(RenderBox box, BoxConstraints constraints) {
    if (box == null) return Size.zero;
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData as BoxParentData;
    parentData.offset = offset;
  }

  @override
  void performLayout() {
    switch (type) {
      case TextFieldType.CHAT:
        chatLayout();
        break;
      default:
        defaultLayout();
        break;
    }
  }

  chatLayout() {
    final bool hasPlaceholder = placeholder != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final double tileWidth = looseConstraints.maxWidth;

    final Size suffixSize = _layoutBox(suffix, looseConstraints);

    final BoxConstraints textConstraints = BoxConstraints(
      maxWidth: tileWidth - suffixSize.width - _kDGap - 10.0,
    );

    final childSize = _layoutBox(child, textConstraints);
    final placeholderSize = _layoutBox(placeholder, textConstraints);

    final tileHeight = math.max(suffixSize.height, childSize.height) + 6.0;

    final childOffset = Offset(
      10.0,
      tileHeight - childSize.height - 5.0,
    );

    _positionBox(
        suffix,
        Offset(
          tileWidth - suffixSize.width - 3.0,
          tileHeight - suffixSize.height - 3.0,
        ));
    _positionBox(child, childOffset);
    if (hasPlaceholder) _positionBox(placeholder, childOffset);

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  defaultLayout() {
    final bool hasPrefix = prefix != null;
    final bool hasSuffix = suffix != null;
    final bool hasPlaceholder = placeholder != null;
    final bool hasError = error != null;

    final BoxConstraints looseConstraints = constraints.loosen();

    final double tileWidth = looseConstraints.maxWidth;

    final BoxConstraints prefixConstraints = BoxConstraints(
      maxWidth: tileWidth * 0.6,
    );

    final BoxConstraints suffixConstraints =
    looseConstraints.enforce(BoxConstraints(
      maxWidth: 36.0,
    ));

    final Size prefixSize = _layoutBox(prefix, prefixConstraints);
    final Size suffixSize = _layoutBox(suffix, suffixConstraints);
    final Size errorSize = _layoutBox(error, looseConstraints);

    double contentGap = 0;
    if (hasPrefix) contentGap += _kDGap;
    if (hasSuffix) contentGap += _kDGap;

    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - prefixSize.width - suffixSize.width - contentGap,
    );

    final childSize = _layoutBox(child, textConstraints);
    final placeholderSize = _layoutBox(placeholder, textConstraints);

    final iconHeight = math.max(prefixSize.height, suffixSize.height);
    final itemsHeight = math.max(iconHeight, childSize.height);

    double contentHeight = math.max(itemsHeight, 44.0);

    double prefixX;
    double prefixY;
    double suffixX;
    double suffixY;
    double contentX;
    double contentY;
    double errorY;
    double tileHeight = math.max(36.0, childSize.height);

    final double childStart = hasPrefix ? prefixSize.width + _kDGap : 0.0;

    prefixX = 0.0;
    prefixY = (tileHeight - prefixSize.height) / 2.0;
    suffixX = tileWidth - suffixSize.width;
    suffixY = (tileHeight - suffixSize.height) / 2.0;
    contentX = childStart;
    contentY = (tileHeight - childSize.height) / 2.0;

    if (hasError) {
      errorY = tileHeight - 7.0;
      prefixY = prefixY - 3.0;
      suffixX = suffixX - 3.0;
      contentY = contentY - 3.0;
    }

    if (hasPrefix) _positionBox(prefix, Offset(prefixX, prefixY));
    if (hasSuffix) _positionBox(suffix, Offset(suffixX, suffixY));
    if (hasPlaceholder) _positionBox(placeholder, Offset(contentX, contentY));
    if (hasError) _positionBox(error, Offset(0.0, errorY));
    _positionBox(child, Offset(contentX, contentY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _drawButtonBackgroundsAndDividersStacked(canvas, offset);

    void doPaint(RenderBox child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(child);
    doPaint(placeholder);
    doPaint(prefix);
    doPaint(suffix);
    doPaint(error);
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final bool hasError = error != null;

    final Path backgroundFillPath = Path()
//      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(
        0.0,
        0.0,
        size.width + 30.0,
        size.height + (hasError ? 14.0 : 8.0),
      ));

    final Path dividersPath = Path();

    Offset accumulatingOffset = offset;

    final Rect dividerRect = Rect.fromLTWH(
      accumulatingOffset.dx,
      size.height + (hasError ? 14.0 : 8.0) - dividerThickness,
      size.width + 15.0,
      dividerThickness,
    );

    backgroundFillPath.addRect(dividerRect);
    dividersPath.addRect(dividerRect);

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, { @required Offset position }) {
    assert(position != null);
    for (RenderBox child in _children) {
      final BoxParentData parentData = child.parentData as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit)
        return true;
    }
    return false;
  }
}