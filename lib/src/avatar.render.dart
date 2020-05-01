part of 'avatar.dart';

enum _Slot {
  child,
  badge,
}

class _Avatar extends RenderObjectWidget {
  const _Avatar({
    Key key,
    @required this.child,
    @required this.badge,
    @required this.size,
    @required this.shape,
  }) : super(key: key);

  final Widget child;
  final Widget badge;
  final AvatarSize size;
  final AvatarShape shape;

  @override
  _AvatarElement createElement() => _AvatarElement(this);

  @override
  _RenderCell createRenderObject(BuildContext context) {
    return _RenderCell(
      size: size,
      shape: shape,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCell renderObject) {
    renderObject
      ..avatarSize = size
      ..avatarShape = shape;
  }
}

class _AvatarElement extends RenderObjectElement {
  _AvatarElement(_Avatar widget) : super(widget);

  final Map<_Slot, Element> slotToChild = <_Slot, Element>{};
  final Map<Element, _Slot> childToSlot = <Element, _Slot>{};

  @override
  _Avatar get widget => super.widget as _Avatar;

  @override
  _RenderCell get renderObject => super.renderObject as _RenderCell;

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
    _mountChild(widget.badge, _Slot.badge);
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
  void update(_Avatar newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.child, _Slot.child);
    _updateChild(widget.badge, _Slot.badge);
  }

  void _updateRenderObject(RenderBox child, _Slot slot) {
    switch (slot) {
      case _Slot.child:
        renderObject.child = child;
        break;
      case _Slot.badge:
        renderObject.badge = child;
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

class _RenderCell extends RenderBox {
  _RenderCell({
    @required AvatarSize size,
    @required AvatarShape shape,
  })  : assert(shape != null),
        _avatarSize = size,
        _avatarShape = shape;

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

  RenderBox _badge;

  RenderBox get badge => _badge;

  set badge(RenderBox value) {
    _badge = _updateChild(_badge, value, _Slot.badge);
  }

  Iterable<RenderBox> get _children sync* {
    if (child != null) yield child;
    if (badge != null) yield badge;
  }

  AvatarSize get avatarSize => _avatarSize;
  AvatarSize _avatarSize;
  set avatarSize(AvatarSize value) {
    if (_avatarSize == value) return;
    _avatarSize = value;
    markNeedsLayout();
  }

  AvatarShape get avatarShape => _avatarShape;
  AvatarShape _avatarShape;

  set avatarShape(AvatarShape value) {
    assert(value != null);
    if (_avatarShape == value) return;
    _avatarShape = value;
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
    add(badge, 'badge');
    return value;
  }

  @override
  bool get sizedByParent => false;

  @override
  double computeMinIntrinsicWidth(double height) {
    return _defaultSize;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _defaultSize;
  }

  double get _defaultSize {
    switch (avatarSize) {
      case AvatarSize.small:
        return 28.0;
      case AvatarSize.normal:
        return 42.0;
      case AvatarSize.large:
        return 64.0;
      default:
        return 36.0;
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _defaultSize;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _defaultSize;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(badge != null);
    final BoxParentData parentData = badge.parentData as BoxParentData;
    return parentData.offset.dy + badge.getDistanceToActualBaseline(baseline);
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
    final bool hasBadge = badge != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints childConstraints = looseConstraints.tighten(
      width: _defaultSize,
      height: _defaultSize,
    );

    final double tileWidth = looseConstraints.maxWidth;
    double tileHeight = _defaultSize;

    _layoutBox(child, childConstraints);
    if (hasBadge) _layoutBox(badge, looseConstraints);

    _positionBox(child, Offset(0.0, 0.0));
    if (hasBadge) _positionBox(badge, Offset(_defaultSize, 0.0));

    size = constraints.constrain(Size(_defaultSize, _defaultSize));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(child);
    doPaint(badge);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
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
      if (isHit) return true;
    }
    return false;
  }
}
