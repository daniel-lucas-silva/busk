part of 'raw_section.dart';

class _CellsRenderWidget extends MultiChildRenderObjectWidget {
  _CellsRenderWidget({
    Key key,
    @required List<Widget> children,
    double dividerThickness = 0.0,
  })  : _dividerThickness = dividerThickness,
        super(key: key, children: children);

  final double _dividerThickness;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSectionCells(
      dividerThickness: _dividerThickness,
      dividerColor: Colors.divider.resolveFrom(context),
      backgroundColor: DynamicColor.resolve(_kBackgroundColor, context),
      pressedColor: DynamicColor.resolve(_kPressedColor, context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSectionCells renderObject) {
    renderObject
      ..dividerThickness = _dividerThickness
      ..dividerColor = Colors.divider.resolveFrom(context)
      ..backgroundColor = DynamicColor.resolve(_kBackgroundColor, context)
      ..pressedColor = DynamicColor.resolve(_kPressedColor, context);
  }
}

class RenderSectionCells extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderSectionCells({
    List<RenderBox> children,
    double dividerThickness = 0.0,
    @required Color dividerColor,
    @required Color backgroundColor,
    @required Color pressedColor,
  })  : _dividerThickness = dividerThickness,
        _buttonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        _pressedButtonBackgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = pressedColor,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill {
    addAll(children);
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


  final Paint _buttonBackgroundPaint;
  final Paint _pressedButtonBackgroundPaint;
  final Paint _dividerPaint;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CellParentData)
      child.parentData = _CellParentData();
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
    if (childCount == 0) return 0.0;
    if (childCount == 1)
      return firstChild.computeMaxIntrinsicHeight(width) + dividerThickness;
    return _computeMinIntrinsicHeight(width);
  }


  double _computeMinIntrinsicHeight(double width) {
    assert(childCount >= 2);
    return firstChild.getMinIntrinsicHeight(width) +
        dividerThickness +
        (0.5 * childAfter(firstChild).getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) return 0.0;
    if (childCount == 1)
      return firstChild.computeMaxIntrinsicHeight(width) + dividerThickness;
    return _computeMaxIntrinsicHeightStacked(width);
  }

  double _computeMaxIntrinsicHeightStacked(double width) {
    assert(childCount >= 2);

    final double allDividersHeight = (childCount - 1) * dividerThickness;
    double heightAccumulation = allDividersHeight;
    RenderBox button = firstChild;
    while (button != null) {
      heightAccumulation += button.getMaxIntrinsicHeight(width);
      button = childAfter(button);
    }
    return heightAccumulation;
  }

  @override
  void performLayout() {
    final BoxConstraints perButtonConstraints = constraints.copyWith(
      minHeight: 0.0,
      maxHeight: double.infinity,
    );

    RenderBox child = firstChild;
    int index = 0;
    double verticalOffset = 0.0;
    while (child != null) {
      child.layout(
        perButtonConstraints,
        parentUsesSize: true,
      );

      assert(child.parentData is MultiChildLayoutParentData);
      final MultiChildLayoutParentData parentData = child.parentData;
      parentData.offset = Offset(0.0, verticalOffset);

      verticalOffset += child.size.height;
      if (index < childCount - 1) {
        verticalOffset += dividerThickness;
      }

      index += 1;
      child = childAfter(child);
    }

    size = constraints.constrain(Size(constraints.maxWidth, verticalOffset));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _drawButtonBackgroundsAndDividersStacked(canvas, offset);
    _drawButtons(context, offset);
  }

  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final Offset dividerOffset = Offset(0.0, dividerThickness);

    final Path backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    final Path pressedBackgroundFillPath = Path();

    final Path dividersPath = Path();

    Offset accumulatingOffset = offset;

    RenderBox child = firstChild;
    RenderBox prevChild;
    while (child != null) {
      assert(child.parentData is _CellParentData);
      final _CellParentData currentButtonParentData = child.parentData;
      final bool isButtonPressed = currentButtonParentData.isPressed;

      bool isPrevButtonPressed = false;
      if (prevChild != null) {
        assert(prevChild.parentData is _CellParentData);
        final _CellParentData previousButtonParentData =
            prevChild.parentData;
        isPrevButtonPressed = previousButtonParentData.isPressed;
      }

      final bool isDividerPresent = child != firstChild;
      final bool isDividerPainted =
          isDividerPresent && !(isButtonPressed || isPrevButtonPressed);
      final Rect dividerRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy,
        size.width,
        _dividerThickness,
      );

      final Rect buttonBackgroundRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy + (isDividerPresent ? dividerThickness : 0.0),
        size.width,
        child.size.height,
      );

      if (isButtonPressed) {
        backgroundFillPath.addRect(buttonBackgroundRect);
        pressedBackgroundFillPath.addRect(buttonBackgroundRect);
      }

      if (isDividerPainted) {
        backgroundFillPath.addRect(dividerRect);
        dividersPath.addRect(dividerRect);
      }

      accumulatingOffset += (isDividerPresent ? dividerOffset : Offset.zero) +
          Offset(0.0, child.size.height);

      prevChild = child;
      child = childAfter(child);
    }

    canvas.drawPath(backgroundFillPath, _buttonBackgroundPaint);
    canvas.drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint);
    canvas.drawPath(dividersPath, _dividerPaint);
  }

  void _drawButtons(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    while (child != null) {
      final MultiChildLayoutParentData childParentData = child.parentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}