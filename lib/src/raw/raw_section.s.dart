part of 'raw_section.dart';

enum _Slot {
  header,
  cells,
  footer,
}

class _SectionRenderWidget extends RenderObjectWidget {
  const _SectionRenderWidget({
    Key key,
    @required this.header,
    @required this.cells,
    @required this.footer,
  }) : super(key: key);

  final Widget header;
  final Widget cells;
  final Widget footer;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSection(
      dividerThickness:
          kDividerThickness / MediaQuery.of(context).devicePixelRatio,
      dividerColor: Colors.divider.resolveFrom(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSection renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.dividerColor =
        Colors.divider.resolveFrom(context);
  }

  @override
  RenderObjectElement createElement() {
    return _SectionRenderElement(this);
  }
}

class _SectionRenderElement extends RenderObjectElement {
  _SectionRenderElement(_SectionRenderWidget widget)
      : super(widget);

  Element _header;
  Element _cells;
  Element _footer;

  @override
  _SectionRenderWidget get widget => super.widget;

  @override
  _RenderSection get renderObject => super.renderObject;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_header != null) visitor(_header);
    if (_cells != null) visitor(_cells);
    if (_footer != null) visitor(_footer);
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _header = updateChild(_header, widget.header, _Slot.header);
    _cells = updateChild(_cells, widget.cells, _Slot.cells);
    _footer = updateChild(_footer, widget.footer, _Slot.footer);
  }

  @override
  void insertChildRenderObject(RenderObject child, _Slot slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void moveChildRenderObject(RenderObject child, _Slot slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    _header = updateChild(_header, widget.header, _Slot.header);
    _cells = updateChild(_cells, widget.cells, _Slot.cells);
    _footer = updateChild(_footer, widget.footer, _Slot.footer);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _header || child == _cells || child == _footer);
    if (_header == child)
      _header = null;
    else if (_cells == child)
      _cells = null;
    else if (_footer == child) _footer = null;
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(child == renderObject.header ||
        child == renderObject.cells ||
        child == renderObject.footer);
    if (renderObject.header == child)
      renderObject.header = null;
    else if (renderObject.cells == child)
      renderObject.cells = null;
    else if (renderObject.footer == child) renderObject.footer = null;
  }

  void _placeChildInSlot(RenderObject child, _Slot slot) {
    assert(slot != null);
    switch (slot) {
      case _Slot.header:
        renderObject.header = child;
        break;
      case _Slot.cells:
        renderObject.cells = child;
        break;
      case _Slot.footer:
        renderObject.footer = child;
        break;
    }
  }
}

class _RenderSection extends RenderBox {
  _RenderSection({
    RenderBox header,
    RenderBox cells,
    RenderBox footer,
    double dividerThickness = 0.0,
    @required Color dividerColor,
  })  : assert(dividerColor != null),
        _header = header,
        _footer = footer,
        _cells = cells,
        _dividerThickness = dividerThickness,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  RenderBox get header => _header;
  RenderBox _header;

  set header(RenderBox newHeader) {
    if (newHeader != _header) {
      if (null != _header) dropChild(_header);
      _header = newHeader;
      if (null != _header) adoptChild(_header);
    }
  }

  RenderBox get footer => _footer;
  RenderBox _footer;

  set footer(RenderBox newFooter) {
    if (newFooter != _footer) {
      if (null != _footer) dropChild(_footer);
      _footer = newFooter;
      if (null != _footer) adoptChild(_footer);
    }
  }

  RenderBox get cells => _cells;
  RenderBox _cells;

  set cells(RenderBox newCells) {
    if (newCells != _cells) {
      if (null != _cells) dropChild(_cells);
      _cells = newCells;
      if (null != _cells) adoptChild(_cells);
    }
  }

  Color get dividerColor => _dividerPaint.color;

  set dividerColor(Color value) {
    if (value == _dividerPaint.color) return;
    _dividerPaint.color = value;
    markNeedsPaint();
  }

  final double _dividerThickness;

  final Paint _dividerPaint;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (null != header) header.attach(owner);

    if (null != cells) cells.attach(owner);

    if (null != footer) footer.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (null != header) header.detach();

    if (null != cells) cells.detach();

    if (null != footer) footer.detach();
  }

  @override
  void redepthChildren() {
    if (null != header) redepthChild(header);

    if (null != cells) redepthChild(cells);

    if (null != footer) redepthChild(footer);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (header != null) visitor(header);

    if (cells != null) visitor(cells);

    if (footer != null) visitor(footer);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
    if (header != null) value.add(header.toDiagnosticsNode(name: 'header'));

    if (cells != null) value.add(cells.toDiagnosticsNode(name: 'cells'));

    if (footer != null) value.add(footer.toDiagnosticsNode(name: 'footer'));

    return value;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return constraints.minWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double headerHeight = header.getMinIntrinsicHeight(width);
    final double cellsHeight = cells.getMinIntrinsicHeight(width);
    final double footerHeight = footer.getMinIntrinsicHeight(width);
    final bool hasDivider =
        headerHeight > 0.0 && cellsHeight > 0.0 && footerHeight > 0.0;
    double height = headerHeight +
        (hasDivider ? _dividerThickness : 0.0) +
        cellsHeight +
        (hasDivider ? _dividerThickness : 0.0) +
        footerHeight;

    if (cellsHeight > 0 || headerHeight > 0 || footerHeight > 0)
      height -= 2 * _kEdgeVerticalPadding;
    if (height.isFinite) return height;
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double headerHeight = header.getMaxIntrinsicHeight(width);
    final double cellsHeight = cells.getMaxIntrinsicHeight(width);
    final double footerHeight = footer.getMaxIntrinsicHeight(width);
    final bool hasDivider =
        headerHeight > 0.0 && cellsHeight > 0.0 && footerHeight > 0.0;
    double height = headerHeight +
        (hasDivider ? _dividerThickness : 0.0) +
        cellsHeight +
        (hasDivider ? _dividerThickness : 0.0) +
        footerHeight;

    if (cellsHeight > 0 || headerHeight > 0 || footerHeight > 0)
      height -= 2 * _kEdgeVerticalPadding;
    if (height.isFinite) return height;
    return 0.0;
  }

  @override
  void performLayout() {
    final bool hasDivider =
        header.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0 &&
            cells.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0 &&
            footer.getMaxIntrinsicHeight(constraints.maxWidth) > 0.0;
    final double dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final double minCellsHeight = cells.getMinIntrinsicHeight(constraints.maxWidth) + footer.getMinIntrinsicHeight(constraints.maxWidth);

    header.layout(
      constraints.deflate(
        EdgeInsets.only(bottom: minCellsHeight + dividerThickness),
      ),
      parentUsesSize: true,
    );
    final Size headerSize = header.size;

    cells.layout(
      constraints.deflate(
        EdgeInsets.only(top: headerSize.height + dividerThickness),
      ),
      parentUsesSize: true,
    );

    final Size cellsSize = cells.size;

    footer.layout(
      constraints.deflate(
        EdgeInsets.only(
          top: headerSize.height +
              dividerThickness +
              cellsSize.height +
              dividerThickness,
        ),
      ),
      parentUsesSize: true,
    );

    final Size footerSize = footer.size;

    final double cellsHeight = headerSize.height +
        dividerThickness +
        cellsSize.height +
        dividerThickness +
        footerSize.height;

    size = Size(constraints.maxWidth, cellsHeight);

    assert(cells.parentData is MultiChildLayoutParentData);

    final MultiChildLayoutParentData cellParentData = cells.parentData;
    cellParentData.offset = Offset(0.0, headerSize.height + dividerThickness);

    final MultiChildLayoutParentData footerParentData = footer.parentData;
    footerParentData.offset = Offset(0.0, headerSize.height + dividerThickness + cellsSize.height + dividerThickness);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final MultiChildLayoutParentData headerParentData = header.parentData;
    header.paint(context, offset + headerParentData.offset);

    final bool hasDivider = header.size.height > 0.0 &&
        cells.size.height > 0.0 &&
        footer.size.height > 0.0;

    if (hasDivider) {
      _paintDividerBetweenContentAndActions(context.canvas, offset);
    }

    final MultiChildLayoutParentData cellsParentData = cells.parentData;
    cells.paint(context, offset + cellsParentData.offset);

    final MultiChildLayoutParentData footerParentData = footer.parentData;
    footer.paint(context, offset + footerParentData.offset);
  }

  void _paintDividerBetweenContentAndActions(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + header.size.height,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + cells.size.height + header.size.height + _dividerThickness,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    final MultiChildLayoutParentData headerParentData = header.parentData;
    final MultiChildLayoutParentData cellsParentData = cells.parentData;
    final MultiChildLayoutParentData footerParentData = footer.parentData;
    return result.addWithPaintOffset(
          offset: headerParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - headerParentData.offset);
            return header.hitTest(result, position: transformed);
          },
        ) ||
        result.addWithPaintOffset(
          offset: cellsParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - cellsParentData.offset);
            return cells.hitTest(result, position: transformed);
          },
        ) ||
        result.addWithPaintOffset(
          offset: footerParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            assert(transformed == position - footerParentData.offset);
            return footer.hitTest(result, position: transformed);
          },
        );
  }
}
