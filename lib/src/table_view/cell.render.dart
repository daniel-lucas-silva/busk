part of 'cell.dart';



enum _Slot {
  title,
  subtitle,
  text,
  after,
  leading,
  trailing,
}

class _Cell extends RenderObjectWidget {
  const _Cell({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.subtitle,
    @required this.text,
    @required this.after,
    @required this.trailing,
    @required this.type,
    this.isPressed: false,
    this.hasBackground: false,
    this.hasDivider: false,
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget text;
  final Widget after;
  final Widget trailing;
  final CellType type;
  final bool isPressed;
  final bool hasBackground;
  final bool hasDivider;

  @override
  _CellElement createElement() => _CellElement(this);

  @override
  _RenderCell createRenderObject(BuildContext context) {
    return _RenderCell(
      type: type,
      isPressed: isPressed,
      hasBackground: hasBackground,
      hasDivider: hasDivider,
      dividerThickness: kDividerThickness / MediaQuery.of(context).devicePixelRatio,
      dividerColor: Colors.divider.resolveFrom(context),
      backgroundColor: Colors.secondarySystemGroupedBackground.resolveFrom(context),
      pressedColor: Colors.tertiarySystemGroupedBackground.resolveFrom(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCell renderObject) {
    renderObject..type = type
      ..isPressed = isPressed
      ..hasBackground = hasBackground
      ..hasDivider = hasDivider
      ..dividerThickness = kDividerThickness / MediaQuery.of(context).devicePixelRatio
      ..dividerColor = Colors.divider.resolveFrom(context)
      ..backgroundColor = Colors.secondarySystemGroupedBackground.resolveFrom(context)
      ..pressedColor = Colors.tertiarySystemGroupedBackground.resolveFrom(context);
  }
}

class _CellElement extends RenderObjectElement {
  _CellElement(_Cell widget) : super(widget);

  final Map<_Slot, Element> slotToChild = <_Slot, Element>{};
  final Map<Element, _Slot> childToSlot = <Element, _Slot>{};

  @override
  _Cell get widget => super.widget as _Cell;

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
    _mountChild(widget.leading, _Slot.leading);
    _mountChild(widget.title, _Slot.title);
    _mountChild(widget.subtitle, _Slot.subtitle);
    _mountChild(widget.text, _Slot.text);
    _mountChild(widget.after, _Slot.after);
    _mountChild(widget.trailing, _Slot.trailing);
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
  void update(_Cell newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.leading, _Slot.leading);
    _updateChild(widget.title, _Slot.title);
    _updateChild(widget.subtitle, _Slot.subtitle);
    _updateChild(widget.text, _Slot.text);
    _updateChild(widget.after, _Slot.after);
    _updateChild(widget.trailing, _Slot.trailing);
  }

  void _updateRenderObject(RenderBox child, _Slot slot) {
    switch (slot) {
      case _Slot.leading:
        renderObject.leading = child;
        break;
      case _Slot.title:
        renderObject.title = child;
        break;
      case _Slot.subtitle:
        renderObject.subtitle = child;
        break;
      case _Slot.text:
        renderObject.text = child;
        break;
      case _Slot.after:
        renderObject.after = child;
        break;
      case _Slot.trailing:
        renderObject.trailing = child;
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
    @required double dividerThickness,
    @required CellType type,
    @required bool hasBackground,
    @required bool hasDivider,
    @required bool isPressed,
    @required Color dividerColor,
    @required Color backgroundColor,
    @required Color pressedColor,
  })  : assert(type != null),
        _type = type,
        _hasBackground = hasBackground,
        _hasDivider = hasDivider,
        _isPressed = isPressed,
        _dividerThickness = dividerThickness,
        _buttonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        _pressedButtonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = pressedColor,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  final Paint _buttonBackgroundPaint;
  final Paint _pressedButtonBackgroundPaint;
  final Paint _dividerPaint;

  double get dividerThickness => _dividerThickness;
  double _dividerThickness;

  set dividerThickness(double newValue) {
    if (newValue == _dividerThickness) {
      return;
    }

    _dividerThickness = newValue;
    markNeedsLayout();
  }

  Color get backgroundColor => _buttonBackgroundPaint.color;
  set backgroundColor(Color newValue) {
    if (newValue == _buttonBackgroundPaint.color) {
      return;
    }
    _buttonBackgroundPaint.color = newValue;
    markNeedsPaint();
  }

  Color get pressedColor => _pressedButtonBackgroundPaint.color;
  set pressedColor(Color newValue) {
    if (newValue == _pressedButtonBackgroundPaint.color) {
      return;
    }
    _pressedButtonBackgroundPaint.color = newValue;
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

  static const double _kGap = 15.0;
  static const double _kDGap = 12.0;

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

  RenderBox _title;

  RenderBox get title => _title;

  set title(RenderBox value) {
    _title = _updateChild(_title, value, _Slot.title);
  }

  RenderBox _subtitle;

  RenderBox get subtitle => _subtitle;

  set subtitle(RenderBox value) {
    _subtitle = _updateChild(_subtitle, value, _Slot.subtitle);
  }

  RenderBox _text;

  RenderBox get text => _text;

  set text(RenderBox value) {
    _text = _updateChild(_text, value, _Slot.text);
  }

  RenderBox _after;

  RenderBox get after => _after;

  set after(RenderBox value) {
    _after = _updateChild(_after, value, _Slot.after);
  }

  RenderBox _leading;

  RenderBox get leading => _leading;

  set leading(RenderBox value) {
    _leading = _updateChild(_leading, value, _Slot.leading);
  }

  RenderBox _trailing;

  RenderBox get trailing => _trailing;

  set trailing(RenderBox value) {
    _trailing = _updateChild(_trailing, value, _Slot.trailing);
  }

  Iterable<RenderBox> get _children sync* {
    if (title != null) yield title;
    if (subtitle != null) yield subtitle;
    if (text != null) yield text;
    if (leading != null) yield leading;
    if (after != null) yield after;
    if (trailing != null) yield trailing;
  }

  CellType get type => _type;
  CellType _type;

  set type(CellType value) {
    assert(value != null);
    if (_type == value) return;
    _type = value;
    markNeedsLayout();
  }

  bool get hasBackground => _hasBackground;
  bool _hasBackground;

  set hasBackground(bool value) {
    assert(value != null);
    if (_hasBackground == value) return;
    _hasBackground = value;
    markNeedsLayout();
  }

  bool get hasDivider => _hasDivider;
  bool _hasDivider;

  set hasDivider(bool value) {
    assert(value != null);
    if (_hasDivider == value) return;
    _hasDivider = value;
    markNeedsLayout();
  }

  bool get isPressed => _isPressed;
  bool _isPressed;

  set isPressed(bool value) {
    assert(value != null);
    if (_isPressed == value) return;
    _isPressed = value;
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

    add(leading, 'leading');
    add(title, 'title');
    add(subtitle, 'subtitle');
    add(after, 'after');
    add(text, 'text');
    add(trailing, 'trailing');
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
    return math.max(_minWidth(title, height), _minWidth(subtitle, height)) +
        _maxWidth(text, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) +
        _maxWidth(text, height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return math.max(_minHeight(title, width), _minHeight(subtitle, width)) +
        _maxHeight(text, width) + dividerThickness;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return math.max(_maxHeight(title, width), _maxHeight(subtitle, width)) +
        _maxHeight(text, width) + dividerThickness;
  }

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
      case CellType.DEFAULT:
        defaultLayout();
        break;
      case CellType.SUBTITLE:
        subtitleLayout();
        break;
      case CellType.MESSAGE:
        messageLayout();
        break;
      case CellType.MAIL:
        mailLayout();
        break;
      case CellType.VOUCHER:
        voucherLayout();
        break;
      case CellType.ACTION:
        actionLayout();
        break;
      case CellType.FIELD:
        fieldLayout();
        break;
      case CellType.PROFILE:
        profileLayout();
        break;
      case CellType.DETAIL:
        detailLayout();
        break;
      case CellType.PRODUCT:
        productLayout();
        break;
      case CellType.REVIEW:
        reviewLayout();
        break;
      default:
        break;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _drawButtonBackgroundsAndDividersStacked(context.canvas, offset);

    void doPaint(RenderBox child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(title);
    doPaint(subtitle);
    doPaint(text);
    doPaint(after);
    doPaint(leading);
    doPaint(trailing);
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final Path backgroundFillPath = Path()
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Path pressedBackgroundFillPath = Path();
    final Path dividersPath = Path();
    final Offset accumulatingOffset = offset;
    final bool isButtonPressed = isPressed;
    final bool isDividerPresent = true;
    final bool isDividerPainted = isDividerPresent && !(isButtonPressed);

    final Rect dividerRect = Rect.fromLTWH(
      accumulatingOffset.dx + 15.0,
      size.height - dividerThickness,
      size.width - 15.0,
      dividerThickness,
    );

    final Rect buttonBackgroundRect = Rect.fromLTWH(
      accumulatingOffset.dx,
      accumulatingOffset.dy - dividerThickness,
      size.width,
      size.height + (dividerThickness * 2),
    );

    if (isPressed) {
      backgroundFillPath.addRect(buttonBackgroundRect);
      pressedBackgroundFillPath.addRect(buttonBackgroundRect);
    }

    if (isDividerPainted) {
      backgroundFillPath.addRect(dividerRect);
      dividersPath.addRect(dividerRect);
    }

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  bool isHit(
      List<RenderBox> children, BoxHitTestResult result, Offset position) {
    bool isHit = false;
    for (RenderBox c in children) {
      if (c != null) {
        final BoxParentData parentData = c.parentData as BoxParentData;
        isHit = result.addWithPaintOffset(
          offset: parentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - parentData.offset);
            return c.hitTest(result, position: transformed);
          },
        );
      }
    }

    return isHit;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
    switch (type) {
      case CellType.DETAIL:
        return isHit([subtitle, after], result, position);
      case CellType.FIELD:
        return isHit([title, trailing, leading], result, position);
      default:
        return isHit([title, trailing], result, position);
    }
  }

  void defaultLayout() {
    final double _padding = 15.0;

    final bool hasLeading = leading != null;
    final bool hasTrailing = trailing != null;
    final bool hasAfter = after != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints leadingConstraints = BoxConstraints.tightFor(
      height: 28.0,
      width: 28.0,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, leadingConstraints);
    final Size trailingSize = _layoutBox(trailing, looseConstraints);

    final double titleStart =
        (hasLeading ? leadingSize.width + _kGap : 0.0) + _padding;

    final double leadingWidth = hasLeading ? leadingSize.width : 0.0;
    final double trailingWidth = hasTrailing ? trailingSize.width : 0.0;

    double contentGap = 0;
    if (hasLeading) contentGap += _kGap;
    if (hasTrailing) contentGap += _kDGap;
    if (hasAfter) contentGap += _kGap;

    final double containerWidth =
        tileWidth - leadingWidth - trailingWidth - contentGap - (_padding * 2);

    final BoxConstraints textConstraints = BoxConstraints(
      maxWidth: containerWidth,
    );

    final titleSize = _layoutBox(title, textConstraints);

    final BoxConstraints afterConstraints =
    looseConstraints.tighten(width: containerWidth - titleSize.width);

    final Size afterSize = _layoutBox(after, afterConstraints);

    double tileHeight = 44.0;

    double leadingY = (tileHeight - leadingSize.height) / 2.0;
    double trailingY = (tileHeight - trailingSize.height) / 2.0;
    double trailingX = tileWidth - trailingSize.width - _padding;
    double afterY = (tileHeight - afterSize.height) / 2.0;
    double afterX = tileWidth - trailingSize.width - afterSize.width - _padding;
    if (hasTrailing) afterX -= _kDGap;

    final double topStart = (tileHeight - titleSize.height) / 2.0;

    if (hasLeading) _positionBox(leading, Offset(_padding, leadingY));
    if (hasTrailing) _positionBox(trailing, Offset(trailingX, trailingY));
    _positionBox(title, Offset(titleStart, topStart));
    if (hasAfter) _positionBox(after, Offset(afterX, afterY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void subtitleLayout() {
    final double _padding = 15.0;

    final bool hasLeading = leading != null;
    final bool hasTrailing = trailing != null;
    final bool hasAfter = after != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints leadingConstraints = looseConstraints.tighten(
      width: 36.0,
      height: 36.0,
    );

    final BoxConstraints iconConstraints = BoxConstraints(
      maxHeight: 36.0,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);

    final double titleStart =
        (hasLeading ? leadingSize.width + _kGap : 0.0) + _padding;

    final double leadingWidth = hasLeading ? leadingSize.width : 0.0;
    final double trailingWidth = hasTrailing ? trailingSize.width : 0.0;

    double contentGap = 0;
    if (hasLeading) contentGap += _kGap;
    if (hasTrailing) contentGap += _kDGap;
    if (hasAfter) contentGap += _kGap;

    final double containerWidth =
        tileWidth - leadingWidth - trailingWidth - contentGap - (_padding * 2);

    final BoxConstraints textConstraints = BoxConstraints(
      maxWidth: containerWidth,
    );

    final titleSize = _layoutBox(title, textConstraints);
    final subtitleSize = _layoutBox(subtitle, textConstraints);

    final BoxConstraints afterConstraints = looseConstraints.tighten(
      width: containerWidth - math.max(titleSize.width, subtitleSize.width),
    );

    final Size afterSize = _layoutBox(after, afterConstraints);

    double tileHeight = 50.0;

    double leadingY = (tileHeight - leadingSize.height) / 2.0;
    double trailingY = (tileHeight - trailingSize.height) / 2.0;
    double trailingX = tileWidth - trailingWidth - _padding;
    double afterY = (tileHeight - afterSize.height) / 2.0;
    double afterX = tileWidth - trailingWidth - afterSize.width - _padding;
    if (hasTrailing) afterX -= _kDGap;

    final double topStart = 9.0;

    if (hasLeading) _positionBox(leading, Offset(_padding, leadingY));
    if (hasTrailing) _positionBox(trailing, Offset(trailingX, trailingY));
    _positionBox(title, Offset(titleStart, topStart));
    _positionBox(
      subtitle,
      Offset(titleStart, topStart + titleSize.height + 5),
    );
    if (hasAfter) _positionBox(after, Offset(afterX, afterY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void messageLayout() {
    const _padding = 15.0;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints leadingConstraints = BoxConstraints.tightFor(
      height: 45.0,
      width: 45.0,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, leadingConstraints);
    final Size trailingSize = _layoutBox(trailing, looseConstraints);
    final Size afterSize = _layoutBox(after, looseConstraints);

    final double leadingWidth = leadingSize.width;
    final double titleStart = leadingSize.width + _kGap + _padding;
    final double trailingWidth = trailingSize.width;
    final double afterWidth = afterSize.width;

    final BoxConstraints titleConstraints = looseConstraints.tighten(
      width: tileWidth -
          titleStart -
          trailingWidth -
          afterWidth -
          (13.0 * 2) -
          _padding,
    );
    final BoxConstraints subtitleConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - _padding,
    );

    final titleSize = _layoutBox(title, titleConstraints);
    final subtitleSize = _layoutBox(subtitle, subtitleConstraints);

    final double contentHeight = titleSize.height + subtitleSize.height;
    double tileHeight = math.max(leadingSize.height, contentHeight) + 23.0;

    const double topY = 11.0;
    final double subtitleX = titleStart;
    final double subtitleY = topY + titleSize.height + 2;
    const double leadingX = 16.0;
    final double leadingY = (tileHeight - leadingSize.height) / 2.0;
    final double trailingX = tileWidth - trailingWidth - _padding;

    final double afterX =
        tileWidth - trailingWidth - afterSize.width - _padding - 13.0;

    _positionBox(leading, Offset(leadingX, leadingY));
    _positionBox(trailing, Offset(trailingX, topY));
    _positionBox(title, Offset(titleStart, topY));
    _positionBox(subtitle, Offset(subtitleX, subtitleY));
    _positionBox(after, Offset(afterX, topY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void voucherLayout() {}

  void mailLayout() {
    const _padding = 15.0;

    final BoxConstraints looseConstraints = constraints.loosen();

    final double tileWidth = looseConstraints.maxWidth;
    final Size trailingSize = _layoutBox(trailing, looseConstraints);
    final Size afterSize = _layoutBox(after, looseConstraints);

    final double titleStart = _padding;
    final double trailingWidth = trailingSize.width;
    final double afterWidth = afterSize.width;

    final BoxConstraints titleConstraints = looseConstraints.tighten(
      width: tileWidth -
          titleStart -
          trailingWidth -
          afterWidth -
          (13.0 * 2) -
          _padding,
    );
    final BoxConstraints subtitleConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - _padding,
    );

    final titleSize = _layoutBox(title, titleConstraints);
    final subtitleSize = _layoutBox(subtitle, subtitleConstraints);
    final textSize = _layoutBox(text, subtitleConstraints);

    final double contentHeight =
        titleSize.height + subtitleSize.height + textSize.height;
    double tileHeight = contentHeight + 27.0;

    const double topY = 11.0;
    final double subtitleY = topY + titleSize.height + 2;
    final double textY = subtitleY + subtitleSize.height + 2;
    final double trailingX = tileWidth - trailingWidth - _padding;
    final double afterX =
        tileWidth - trailingWidth - afterSize.width - _padding - 13.0;

    _positionBox(trailing, Offset(trailingX, topY));
    _positionBox(title, Offset(titleStart, topY));
    _positionBox(subtitle, Offset(titleStart, subtitleY));
    _positionBox(text, Offset(titleStart, textY));
    _positionBox(after, Offset(afterX, topY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void fieldLayout() {
    final double _padding = 15.0;

    final bool hasLeading = leading != null;
    final bool hasTrailing = trailing != null;
    final bool hasAfter = after != null;
    final bool hasSubtitle = subtitle != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints leadingConstraints = looseConstraints.tighten(
      width: 36.0,
      height: 36.0,
    );

    final BoxConstraints iconConstraints = BoxConstraints(
      maxHeight: 36.0,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);

    final double titleStart =
        (hasLeading ? leadingSize.width + _kGap : 0.0) + _padding;

    final double leadingWidth = hasLeading ? leadingSize.width : 0.0;
    final double trailingWidth = hasTrailing ? trailingSize.width : 0.0;

    double contentGap = 0;
    if (hasLeading) contentGap += _kGap;
    if (hasTrailing) contentGap += _kDGap;
    if (hasAfter) contentGap += _kGap;

    final double containerWidth =
        tileWidth - leadingWidth - trailingWidth - contentGap - (_padding * 2);

    final BoxConstraints textConstraints = BoxConstraints(
      maxWidth: containerWidth,
    );

    final titleSize = _layoutBox(title, textConstraints);
    final subtitleSize = _layoutBox(subtitle, textConstraints);

    final BoxConstraints afterConstraints = looseConstraints.tighten(
      width: containerWidth - math.max(titleSize.width, subtitleSize.width),
    );

    final Size afterSize = _layoutBox(after, afterConstraints);

    final double contentHeight = subtitleSize.height + titleSize.height + 13.0;

    double tileHeight = math.max(36.0, contentHeight) + 8.0;

    double leadingY = (tileHeight - leadingSize.height) / 2.0;
    double trailingY = (tileHeight - trailingSize.height) / 2.0;
    double trailingX = tileWidth - trailingWidth - _padding;
    double afterY = (tileHeight - afterSize.height) / 2.0;
    double afterX = tileWidth - trailingWidth - afterSize.width - _padding;
    if (hasTrailing) afterX -= _kDGap;

    final double topStart = 16.0;

    if (hasLeading) _positionBox(leading, Offset(_padding, leadingY));
    if (hasTrailing) _positionBox(trailing, Offset(trailingX, trailingY));

    if(hasSubtitle) {
      _positionBox(title, Offset(titleStart, topStart));
      _positionBox(
        subtitle,
        Offset(titleStart, topStart + titleSize.height + 2.0),
      );
    } else {
      _positionBox(title, Offset(titleStart, (tileHeight - titleSize.height) / 2.0));
    }

    if (hasAfter) _positionBox(after, Offset(afterX, afterY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void actionLayout() {
    final double _padding = 15.0;

    final bool hasTrailing = trailing != null;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints trailingConstraints = looseConstraints.tighten(
      width: 36.0,
      height: 36.0,
    );

    final double tileWidth = looseConstraints.maxWidth;

    final Size trailingSize = _layoutBox(trailing, trailingConstraints);

    final double trailingWidth = hasTrailing ? trailingSize.width : 0.0;

    double contentGap = 0;
    if (hasTrailing) contentGap += _kDGap;

    final BoxConstraints titleConstraints = looseConstraints.tighten(
      width: tileWidth - trailingWidth - contentGap - (_padding * 2),
    );

    final titleSize = _layoutBox(title, titleConstraints);

    final double tileHeight = 44.0;
    final double trailingY = (tileHeight - trailingSize.height) / 2.0;
    final double trailingX = tileWidth - trailingSize.width - _padding;
    final double topStart = (tileHeight - titleSize.height) / 2.0;

    if (hasTrailing) _positionBox(trailing, Offset(trailingX, trailingY));
    _positionBox(title, Offset(_padding, topStart));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void reviewLayout() {
    final double _padding = 15.0;

    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints trailingConstraints = BoxConstraints.tightFor(
      height: 42.0,
      width: 42.0,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, looseConstraints);
    final Size trailingSize = _layoutBox(trailing, trailingConstraints);

    final double trailingWidth = trailingSize.width;

    final BoxConstraints messageConstraints = looseConstraints.tighten(
      width: tileWidth - trailingSize.width - 9.0 - (_padding * 2),
    );

    final BoxConstraints subtitleConstraints = looseConstraints.tighten(
      width: tileWidth -
          trailingSize.width -
          (8.0 * 2) -
          leadingSize.width -
          (_padding * 2),
    );

    final titleSize = _layoutBox(title, messageConstraints);
    final subtitleSize = _layoutBox(subtitle, subtitleConstraints);

    final double contentHeight = titleSize.height + subtitleSize.height;
    double tileHeight =
        math.max(trailingSize.height, contentHeight) + (14.0 * 2) + 2.0;

    const double topY = 14.0;
    final double subtitleX = leadingSize.width + 7.0 + _padding;
    final double subtitleY = topY + titleSize.height + 2;
    final double trailingX = tileWidth - trailingWidth - _padding;

    _positionBox(leading, Offset(_padding, subtitleY));
    _positionBox(title, Offset(_padding, topY));
    _positionBox(trailing, Offset(trailingX, topY));
    _positionBox(subtitle, Offset(subtitleX, subtitleY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void profileLayout() {}

  void detailLayout() {
    final double _padding = 15.0;

    final bool hasTrailing = trailing != null;
    final bool hasAfter = after != null;
    final bool hasText = text != null;
    final bool hasSubtitle = subtitle != null;

    final BoxConstraints looseConstraints = constraints.loosen();

    final BoxConstraints trailingConstraints =
    looseConstraints.tighten(width: 90, height: 82);

    final double tileWidth = looseConstraints.maxWidth;
    final Size trailingSize = _layoutBox(trailing, trailingConstraints);
    final Size afterSize = _layoutBox(after, looseConstraints);

    final double trailingWidth = trailingSize.width;
    final double afterWidth = afterSize.width;

    double contentGap = 0;
    if (hasAfter || hasTrailing) contentGap += _kDGap;

    final BoxConstraints headerConstraints = looseConstraints.tighten(
      width:
      tileWidth - trailingWidth - afterWidth - contentGap - (_padding * 2),
    );
    final BoxConstraints subtitleConstraints = looseConstraints.tighten(
      width: tileWidth -
          trailingWidth -
          (hasTrailing ? _kDGap : 0) -
          (_padding * 2),
    );

    final titleSize = _layoutBox(title, headerConstraints);
    final subtitleSize = _layoutBox(subtitle, subtitleConstraints);
    final textSize = _layoutBox(text, subtitleConstraints);

    final double contentHeight =
        titleSize.height + subtitleSize.height + textSize.height;

    double tileHeight =
        math.max(contentHeight, trailingSize.height) + (14.0 * 2);

    const double topY = 11.0;
    final double subtitleY = topY + titleSize.height + 2;
    final double textY = subtitleY + subtitleSize.height + 2;
    final double trailingX = tileWidth - trailingWidth - _padding;
    final double afterX = tileWidth - afterSize.width - _padding;

    if (hasTrailing) _positionBox(trailing, Offset(trailingX, 14.0));
    _positionBox(title, Offset(_padding, topY));
    if (hasSubtitle) _positionBox(subtitle, Offset(_padding, subtitleY));
    if (hasText) _positionBox(text, Offset(_padding, textY));
    if (hasAfter) _positionBox(after, Offset(afterX, topY));

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  void productLayout() {}
}
