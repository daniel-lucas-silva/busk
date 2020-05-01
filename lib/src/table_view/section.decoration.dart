part of 'section.dart';

enum _Position { top, bottom }

enum _Slot {
  child,
  after,
}

class _Widget extends RenderObjectWidget {
  const _Widget({
    Key key,
    @required this.child,
    @required this.after,
    @required this.padding,
    @required this.position,
  }) : super(key: key);

  final Widget child;
  final Widget after;
  final EdgeInsets padding;
  final _Position position;

  @override
  _WidgetElement createElement() => _WidgetElement(this);

  @override
  _Object createRenderObject(BuildContext context) {
    return _Object(
      padding: padding,
      position: position,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _Object renderObject) {
    renderObject
      ..padding = padding
      ..position = position;
  }
}

class _WidgetElement extends RenderObjectElement {
  _WidgetElement(_Widget widget) : super(widget);

  final Map<_Slot, Element> slotToChild = <_Slot, Element>{};
  final Map<Element, _Slot> childToSlot = <Element, _Slot>{};

  @override
  _Widget get widget => super.widget as _Widget;

  @override
  _Object get renderObject => super.renderObject as _Object;

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
    _mountChild(widget.child, _Slot.child);
    _mountChild(widget.after, _Slot.after);
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
  void update(_Widget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.child, _Slot.child);
    _updateChild(widget.after, _Slot.after);
  }

  void _updateRenderObject(RenderBox child, _Slot slot) {
    switch (slot) {
      case _Slot.child:
        renderObject.child = child;
        break;
      case _Slot.after:
        renderObject.after = child;
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

class _Object extends RenderBox {
  _Object({
    @required _Position position,
    @required EdgeInsets padding,
  })  : assert(position != null),
        assert(padding != null),
        _padding = padding,
        _position = position,
        _dividerPaint = Paint()
          ..color = _kDividerColor
          ..style = PaintingStyle.fill;

  final Paint _dividerPaint;

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

  RenderBox _after;
  RenderBox get after => _after;
  set after(RenderBox value) {
    _after = _updateChild(_after, value, _Slot.after);
  }

  Iterable<RenderBox> get _children sync* {
    if (child != null) yield child;
    if (after != null) yield after;
  }

  _Position get position => _position;
  _Position _position;
  set position(_Position value) {
    assert(value != null);
    if (_position == value) return;
    _position = value;
    markNeedsLayout();
  }

  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    assert(value != null);
    if (_padding == value) return;
    _padding = value;
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
    add(after, 'after');
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

  @override
  double computeMinIntrinsicWidth(double height) {
    return _minWidth(child, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _maxWidth(child, height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _minHeight(child, width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _maxHeight(child, width);
  }

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
    final bool hasChild = child != null;
    final bool hasAfter = after != null;

    final BoxConstraints looseConstraints = constraints.loosen();

    final double tileWidth = looseConstraints.maxWidth;

    final afterSize = _layoutBox(after, looseConstraints);

    final BoxConstraints childConstraints = looseConstraints.tighten(
      width: tileWidth - afterSize.width - padding.horizontal - (hasAfter ? 10.0 : 0.0),
    );

    final childSize = _layoutBox(child, childConstraints);

    double tileHeight = math.max(afterSize.height, childSize.height) + padding.vertical;
    tileHeight = position == _Position.top ? tileHeight + 1 : tileHeight;

    final double afterX = tileWidth - afterSize.width - padding.right;
    final double afterY = tileHeight - afterSize.height - padding.bottom;
    final double childY = tileHeight - childSize.height - padding.bottom;

    if (hasAfter) _positionBox(after, Offset(afterX, afterY));
    if (hasChild) _positionBox(child, Offset(padding.left, childY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {

    final Path dividersPath = Path();

    final Rect dividerRect = Rect.fromLTWH(
      offset.dx,
      position == _Position.top ? size.height - 1 : - 1,
      size.width,
      1.0,
    );

    dividersPath.addRect(dividerRect);
    context.canvas.drawPath(dividersPath, _dividerPaint);

    void doPaint(RenderBox child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(child);
    doPaint(after);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  bool isHit(RenderBox child, BoxHitTestResult result, Offset position) {
    if (child == null) return false;
    final BoxParentData parentData = child.parentData as BoxParentData;
    return result.addWithPaintOffset(
      offset: parentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - parentData.offset);
        return child.hitTest(result, position: transformed);
      },
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
    for (RenderBox c in [child, after]) {
      if (isHit(c, result, position)) return true;
    }
    return false;
  }
}
