//import 'dart:math' as math;
//import 'package:busk/src/button.dart';
//import 'package:busk/src/icons.dart';
//import 'package:busk/src/raw/raw_button.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/rendering.dart';
//
//import '../theme/colors.dart';
//
//part 'ecommerce.dart';
//
//const double _HGap = 10.0;
//const double _VGap = 10.0;
//
//enum _Slot {
//  image,
//  text1,
//  text2,
//  text3,
//  text4,
//  widget1,
//  widget2,
//}
//
//enum _TileType {
//  productDefault,
//  productHorizontal,
//}
//
//class _TileRenderWidget extends RenderObjectWidget {
//  const _TileRenderWidget({
//    Key key,
//    @required this.image,
//    @required this.text1,
//    @required this.text2,
//    @required this.text3,
//    @required this.text4,
//    @required this.widget1,
//    @required this.widget2,
//    @required this.type,
//  })  : assert(type != null),
//        super(key: key);
//
//  final Widget image;
//  final Widget text1;
//  final Widget text2;
//  final Widget text3;
//  final Widget text4;
//  final Widget widget1;
//  final Widget widget2;
//  final _TileType type;
//
//  @override
//  _TextFieldElement createElement() => _TextFieldElement(this);
//
//  @override
//  BaseRenderBox createRenderObject(BuildContext context) {
//    switch (type) {
//      case _TileType.productDefault:
//        return _ProductDefaultRender();
//        break;
//      case _TileType.productHorizontal:
//        return _ProductHorizontalRender();
//        break;
//      default:
//        throw "Error";
//    }
//  }
//
////  @override
////  void updateRenderObject(BuildContext context, BaseRenderBox renderObject) {
////    renderObject..type = type;
////  }
//}
//
//class _TextFieldElement extends RenderObjectElement {
//  _TextFieldElement(_TileRenderWidget widget) : super(widget);
//
//  final Map<_Slot, Element> slotToChild = <_Slot, Element>{};
//  final Map<Element, _Slot> childToSlot = <Element, _Slot>{};
//
//  @override
//  _TileRenderWidget get widget => super.widget as _TileRenderWidget;
//
//  @override
//  BaseRenderBox get renderObject => super.renderObject as BaseRenderBox;
//
//  @override
//  void visitChildren(ElementVisitor visitor) {
//    slotToChild.values.forEach(visitor);
//  }
//
//  @override
//  void forgetChild(Element child) {
//    assert(slotToChild.values.contains(child));
//    assert(childToSlot.keys.contains(child));
//    final _Slot slot = childToSlot[child];
//    childToSlot.remove(child);
//    slotToChild.remove(slot);
//  }
//
//  void _mountChild(Widget widget, _Slot slot) {
//    final Element oldChild = slotToChild[slot];
//    final Element newChild = updateChild(oldChild, widget, slot);
//    if (oldChild != null) {
//      slotToChild.remove(slot);
//      childToSlot.remove(oldChild);
//    }
//    if (newChild != null) {
//      slotToChild[slot] = newChild;
//      childToSlot[newChild] = slot;
//    }
//  }
//
//  @override
//  void mount(Element parent, dynamic newSlot) {
//    super.mount(parent, newSlot);
//    _mountChild(widget.image, _Slot.image);
//    _mountChild(widget.text1, _Slot.text1);
//    _mountChild(widget.text2, _Slot.text2);
//    _mountChild(widget.text3, _Slot.text3);
//    _mountChild(widget.text4, _Slot.text4);
//    _mountChild(widget.widget1, _Slot.widget1);
//    _mountChild(widget.widget2, _Slot.widget2);
//  }
//
//  void _updateChild(Widget widget, _Slot slot) {
//    final Element oldChild = slotToChild[slot];
//    final Element newChild = updateChild(oldChild, widget, slot);
//    if (oldChild != null) {
//      childToSlot.remove(oldChild);
//      slotToChild.remove(slot);
//    }
//    if (newChild != null) {
//      slotToChild[slot] = newChild;
//      childToSlot[newChild] = slot;
//    }
//  }
//
//  @override
//  void update(_TileRenderWidget newWidget) {
//    super.update(newWidget);
//    assert(widget == newWidget);
//    _updateChild(widget.image, _Slot.image);
//    _updateChild(widget.text1, _Slot.text1);
//    _updateChild(widget.text2, _Slot.text2);
//    _updateChild(widget.text3, _Slot.text3);
//    _updateChild(widget.text4, _Slot.text4);
//    _updateChild(widget.widget1, _Slot.widget1);
//    _updateChild(widget.widget2, _Slot.widget2);
//  }
//
//  void _updateRenderObject(RenderBox child, _Slot slot) {
//    switch (slot) {
//      case _Slot.image:
//        renderObject.image = child;
//        break;
//      case _Slot.text1:
//        renderObject.text1 = child;
//        break;
//      case _Slot.text2:
//        renderObject.text2 = child;
//        break;
//      case _Slot.text3:
//        renderObject.text3 = child;
//        break;
//      case _Slot.text4:
//        renderObject.text4 = child;
//        break;
//      case _Slot.widget1:
//        renderObject.widget1 = child;
//        break;
//      case _Slot.widget2:
//        renderObject.widget2 = child;
//        break;
//    }
//  }
//
//  @override
//  void insertChildRenderObject(RenderObject child, dynamic slotValue) {
//    assert(child is RenderBox);
//    assert(slotValue is _Slot);
//    final _Slot slot = slotValue as _Slot;
//    _updateRenderObject(child as RenderBox, slot);
//    assert(renderObject.childToSlot.keys.contains(child));
//    assert(renderObject.slotToChild.keys.contains(slot));
//  }
//
//  @override
//  void removeChildRenderObject(RenderObject child) {
//    assert(child is RenderBox);
//    assert(renderObject.childToSlot.keys.contains(child));
//    _updateRenderObject(null, renderObject.childToSlot[child]);
//    assert(!renderObject.childToSlot.keys.contains(child));
//    assert(!renderObject.slotToChild.keys.contains(slot));
//  }
//
//  @override
//  void moveChildRenderObject(RenderObject child, dynamic slotValue) {
//    assert(false, 'not reachable');
//  }
//}
//
//abstract class BaseRenderBox extends RenderBox implements IBaseRenderBox {
//  final Map<_Slot, RenderBox> slotToChild = <_Slot, RenderBox>{};
//  final Map<RenderBox, _Slot> childToSlot = <RenderBox, _Slot>{};
//
//  RenderBox _updateChild(RenderBox oldChild, RenderBox newChild, _Slot slot) {
//    if (oldChild != null) {
//      dropChild(oldChild);
//      childToSlot.remove(oldChild);
//      slotToChild.remove(slot);
//    }
//    if (newChild != null) {
//      childToSlot[newChild] = slot;
//      slotToChild[slot] = newChild;
//      adoptChild(newChild);
//    }
//    return newChild;
//  }
//
//  RenderBox _image;
//
//  RenderBox get image => _image;
//
//  set image(RenderBox value) {
//    _image = _updateChild(_image, value, _Slot.image);
//  }
//
//  RenderBox _text1;
//
//  RenderBox get text1 => _text1;
//
//  set text1(RenderBox value) {
//    _text1 = _updateChild(_text1, value, _Slot.text1);
//  }
//
//  RenderBox _text2;
//
//  RenderBox get text2 => _text2;
//
//  set text2(RenderBox value) {
//    _text2 = _updateChild(_text2, value, _Slot.text2);
//  }
//
//  RenderBox _text3;
//
//  RenderBox get text3 => _text3;
//
//  set text3(RenderBox value) {
//    _text3 = _updateChild(_text3, value, _Slot.text3);
//  }
//
//  RenderBox _text4;
//
//  RenderBox get text4 => _text4;
//
//  set text4(RenderBox value) {
//    _text4 = _updateChild(_text4, value, _Slot.text4);
//  }
//
//  RenderBox _widget1;
//
//  RenderBox get widget1 => _widget1;
//
//  set widget1(RenderBox value) {
//    _widget1 = _updateChild(_widget1, value, _Slot.widget1);
//  }
//
//  RenderBox _widget2;
//
//  RenderBox get widget2 => _widget2;
//
//  set widget2(RenderBox value) {
//    _widget2 = _updateChild(_widget2, value, _Slot.widget2);
//  }
//
//  Iterable<RenderBox> get _children sync* {
//    if (widget1 != null) yield widget1;
//    if (widget2 != null) yield widget2;
//    if (image != null) yield image;
//    if (text1 != null) yield text1;
//    if (text2 != null) yield text2;
//    if (text3 != null) yield text3;
//    if (text4 != null) yield text4;
//  }
//
//  @override
//  bool get sizedByParent => isSizedByParent;
//
//  @override
//  double computeMinIntrinsicWidth(double width) => minIntrinsicWidth(width);
//
//  @override
//  double computeMaxIntrinsicWidth(double width) => maxIntrinsicWidth(width);
//
//  @override
//  double computeMinIntrinsicHeight(double width) => minIntrinsicHeight(width);
//
//  @override
//  double computeMaxIntrinsicHeight(double width) => maxIntrinsicHeight(width);
//
//  @override
//  double computeDistanceToActualBaseline(TextBaseline baseline) =>
//      distanceToActualBaseline(baseline);
//
//  @override
//  void attach(PipelineOwner owner) {
//    super.attach(owner);
//    for (RenderBox child in _children) child.attach(owner);
//  }
//
//  @override
//  void detach() {
//    super.detach();
//    for (RenderBox child in _children) child.detach();
//  }
//
//  @override
//  void redepthChildren() {
//    _children.forEach(redepthChild);
//  }
//
//  @override
//  void visitChildren(RenderObjectVisitor visitor) {
//    _children.forEach(visitor);
//  }
//
//  @override
//  List<DiagnosticsNode> debugDescribeChildren() {
//    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
//    void add(RenderBox child, String name) {
//      if (child != null) value.add(child.toDiagnosticsNode(name: name));
//    }
//
//    add(image, 'image');
//    add(text1, 'text1');
//    add(text2, 'text2');
//    add(text3, 'text3');
//    add(text4, 'text4');
//    add(widget1, 'widget1');
//    add(widget2, 'widget2');
//    return value;
//  }
//
//  double minWidth(RenderBox box, double height) {
//    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
//  }
//
//  double maxWidth(RenderBox box, double height) {
//    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
//  }
//
//  double minHeight(RenderBox box, double width) {
//    return box == null ? 0.0 : box.getMinIntrinsicHeight(width);
//  }
//
//  double maxHeight(RenderBox box, double width) {
//    return box == null ? 0.0 : box.getMaxIntrinsicHeight(width);
//  }
//
//  Size layoutBox(RenderBox box, BoxConstraints constraints, [ bool parentUsesSize = true]) {
//    if (box == null) return Size.zero;
//    box.layout(constraints, parentUsesSize: parentUsesSize);
//    return box.size;
//  }
//
//  void positionBox(RenderBox box, Offset offset) {
//    final BoxParentData parentData = box.parentData as BoxParentData;
//    parentData.offset = offset;
//  }
//
//  @override
//  void performLayout() => mountLayout();
//
//  @override
//  void paint(PaintingContext context, Offset offset) {
//    void doPaint(RenderBox child) {
//      if (child != null) {
//        final BoxParentData parentData = child.parentData as BoxParentData;
//        context.paintChild(child, parentData.offset + offset);
//      }
//    }
//
//    if (image != null) doPaint(image);
//    if (text1 != null) doPaint(text1);
//    if (text2 != null) doPaint(text2);
//    if (text3 != null) doPaint(text3);
//    if (text4 != null) doPaint(text4);
//    if (widget1 != null) doPaint(widget1);
//    if (widget2 != null) doPaint(widget2);
//  }
//
//  @override
//  bool hitTestSelf(Offset position) => true;
//
//  @override
//  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
//    assert(position != null);
//    for (RenderBox child in _children) {
//      if (child == null || child.debugNeedsLayout) return false;
//      final BoxParentData parentData = child.parentData as BoxParentData;
//      final bool isHit = result.addWithPaintOffset(
//        offset: parentData.offset,
//        position: position,
//        hitTest: (BoxHitTestResult result, Offset transformed) {
//          assert(transformed == position - parentData.offset);
//          return child.hitTest(result, position: transformed);
//        },
//      );
//      if (isHit) return true;
//    }
//    return false;
//  }
//}
//
//abstract class IBaseRenderBox {
//  bool get isSizedByParent;
//
//  double minIntrinsicWidth(double height);
//
//  double maxIntrinsicWidth(double height);
//
//  double minIntrinsicHeight(double width);
//
//  double maxIntrinsicHeight(double width);
//
//  double distanceToActualBaseline(TextBaseline baseline);
//
//  void mountLayout();
//}


//class _ProductDefaultRender extends BaseRenderBox {
//  @override
//  bool get isSizedByParent => true;
//
//  @override
//  double minIntrinsicWidth(double height) {
//    return minWidth(image, height);
//  }
//
//  @override
//  double maxIntrinsicWidth(double height) {
//    return maxWidth(image, height);
//  }
//
//  @override
//  double minIntrinsicHeight(double width) {
//    return minHeight(image, width);
//  }
//
//  @override
//  double maxIntrinsicHeight(double width) {
//    return maxHeight(image, width);
//  }
//
//  @override
//  double distanceToActualBaseline(TextBaseline baseline) {
//    assert(image != null);
//    final BoxParentData parentData = image.parentData as BoxParentData;
//    return parentData.offset.dy + image.getDistanceToActualBaseline(baseline);
//  }
//
//  @override
//  void mountLayout() {
//    final BoxConstraints looseConstraints = constraints.loosen();
//
//    final double tileWidth = looseConstraints.maxWidth;
//    final double tileHeight = looseConstraints.maxHeight;
//
//    final BoxConstraints text12Constraints =
//    looseConstraints.tighten(width: tileWidth, height: 20);
//
//    final BoxConstraints text34Constraints =
//    looseConstraints.tighten(width: tileWidth / 2, height: 20);
//
//    final BoxConstraints widget1Constraints =
//    looseConstraints.tighten(width: 30, height: 30);
//
//    final text1Size = layoutBox(text1, text12Constraints);
//    final text2Size = layoutBox(text2, text12Constraints);
//    final text3Size = layoutBox(text3, text34Constraints);
//    layoutBox(text4, text34Constraints);
//    final widget1Size = layoutBox(widget1, widget1Constraints);
////    layoutBox(widget2, allConstraints);
//
//    final bottomHeight = text1Size.height + text2Size.height + text3Size.height;
//
//    final BoxConstraints imageConstraints = looseConstraints.tighten(
//      width: tileWidth,
//      height: tileHeight - bottomHeight - 10.0,
//    );
//
//    layoutBox(image, imageConstraints);
//
//    final priceY = tileHeight - text3Size.height;
//    final subtitleY = priceY - text2Size.height;
//    final titleY = subtitleY - text1Size.height;
//    final buttonStart = tileWidth - widget1Size.width - 12;
//
//    positionBox(image, Offset(0, 0));
//    positionBox(text1, Offset(0, titleY));
//    positionBox(text2, Offset(0, subtitleY));
//    positionBox(text3, Offset(0, priceY));
//    positionBox(text4, Offset(tileWidth / 2, priceY));
//    positionBox(widget1, Offset(buttonStart, 12));
////    positionBox(widget2, Offset(240, 0));
//
////    size = constraints.constrain(Size(tileWidth, tileWidth * 1));
////    assert(size.width == constraints.constrainWidth(tileWidth));
////    assert(size.height == constraints.constrainHeight(40));
//  }
//}