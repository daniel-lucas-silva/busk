import 'dart:async';
import 'dart:math' as math;

import 'package:busk/src/raw/raw_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import '../feedback.dart';
import '../icons.dart';
import '../utils/extensions.dart';
import '../rating_bar.dart';
import '../theme/colors.dart';
import '../theme/theme.dart';

export 'package:flutter/services.dart'
    show
        TextInputType,
        TextInputAction,
        TextCapitalization,
        SmartQuotesType,
        SmartDashesType;

enum CellType {
  DEFAULT,
  SUBTITLE,
  MESSAGE,
  MAIL,
  VOUCHER,
  ACTION,
  PROFILE,
  DETAIL,
  PRODUCT,
  FIELD,
  REVIEW,
}

class Cell extends RawCell {
  const Cell._({
    Key key,
    @required Widget title,
    @required Widget subtitle,
    @required Widget text,
    @required Widget after,
    @required Widget leading,
    @required Widget trailing,
    @required VoidCallback onTap,
    @required VoidCallback onLongPress,
    @required CellType type,
    @required EdgeInsets padding,
    @required bool enabled,
    @required bool checked,
    @required bool disclosure,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          text: text,
          after: after,
          leading: leading,
          trailing: trailing,
          onTap: onTap,
          onLongPress: onLongPress,
          type: type,
          padding: padding,
          enabled: enabled,
          checked: checked,
          disclosure: disclosure,
        );

  factory Cell({
    Key key,
    @required Widget child,
    Widget leading,
    Widget trailing,
    Widget detail,
    VoidCallback onTap,
    VoidCallback onLongPress,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
    bool checked,
    bool disclosure,
  }) =>
      Cell._(
        key: key,
        title: child,
        subtitle: null,
        text: null,
        after: detail,
        leading: leading,
        trailing: trailing,
        type: CellType.DEFAULT,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: padding,
        enabled: enabled,
        checked: checked,
        disclosure: disclosure,
      );

  factory Cell.subtitle({
    Key key,
    @required Widget title,
    @required Widget subtitle,
    Widget detail,
    Widget leading,
    Widget trailing,
    VoidCallback onTap,
    VoidCallback onLongPress,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
    bool checked,
    bool disclosure,
  }) =>
      Cell._(
        key: key,
        title: title,
        subtitle: subtitle,
        text: null,
        after: detail,
        leading: leading,
        trailing: trailing,
        type: CellType.SUBTITLE,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: padding,
        enabled: enabled,
        checked: checked,
        disclosure: disclosure,
      );

  factory Cell.field({
    Key key,
    @required Widget title,
    String error,
    Widget detail,
    Widget leading,
    Widget trailing,
    VoidCallback onTap,
    VoidCallback onLongPress,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
    bool checked,
    bool disclosure,
  }) =>
      Cell._(
        key: key,
        title: title,
        subtitle: error.toText(null, _kErrorStyle),
        text: null,
        after: detail,
        leading: leading,
        trailing: trailing,
        type: CellType.FIELD,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: padding,
        enabled: enabled,
        checked: false,
        disclosure: disclosure,
      );

  factory Cell.message({
    Key key,
    @required String from,
    @required String message,
    @required String time,
    @required Widget avatar,
    @required bool read,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled: true,
  }) =>
      Cell._(
        key: key,
        title: Text(from, maxLines: 1),
        subtitle: Text(message, maxLines: 2),
        text: null,
        after: Text(time, maxLines: 1),
        leading: avatar,
        trailing: null,
        type: CellType.MESSAGE,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        enabled: enabled,
        checked: false,
        disclosure: true,
      );

  factory Cell.mail({
    Key key,
    @required String from,
    @required String subject,
    @required String message,
    @required String time,
    @required bool read,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled: true,
  }) =>
      Cell._(
        key: key,
        title: Text(from, maxLines: 1),
        subtitle: Text(subject, maxLines: 1),
        text: Text(message, maxLines: 2),
        after: Text(time, maxLines: 1),
        leading: null,
        trailing: null,
        type: CellType.MAIL,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        enabled: enabled,
        checked: false,
        disclosure: true,
      );

  factory Cell.review({
    Key key,
    @required String message,
    @required String name,
    @required String time,
    @required Widget avatar,
    @required double rate,
    VoidCallback onTap,
  }) =>
      Cell._(
        key: key,
        title: Text(message, overflow: TextOverflow.visible),
        subtitle: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              style: _kSubheadlineStyle.copyWith(height: 1.0),
              children: [
                TextSpan(text: name),
                _spaceSpan,
                TextSpan(text: time),
              ]),
        ),
        text: null,
        after: null,
        leading: RatingBarIndicator(
          itemCount: 5,
          rating: rate ?? 0,
          itemSize: 14,
          itemBuilder: (context, i) => Icon(CupertinoIcons.star_filled),
        ),
        trailing: avatar,
        type: CellType.REVIEW,
        onTap: onTap,
        onLongPress: null,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        enabled: true,
        checked: false,
        disclosure: false,
      );

  factory Cell.voucher({
    Key key,
    Widget child,
    VoidCallback onTap,
    VoidCallback onLongPress,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
    bool checked,
    bool disclosure,
  }) =>
      Cell._(
        key: key,
        title: child,
        subtitle: null,
        text: null,
        after: null,
        leading: null,
        trailing: null,
        type: CellType.VOUCHER,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: padding,
        enabled: enabled,
        checked: checked,
        disclosure: disclosure,
      );

  factory Cell.action({
    Key key,
    @required Widget child,
    @required VoidCallback onTap,
    IconData icon,
    bool destructive: false,
    bool center: false,
    bool loading: false,
    bool enabled: true,
    VoidCallback onLongPress,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
  }) =>
      Cell._(
        key: key,
        title: DefaultTextStyle(
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: _kTitleStyle.copyWith(
            color: onTap != null
                ? (destructive ? _kDanger : _kPrimary)
                : _kSecondaryLabel,
            height: 1.0,
          ),
          child: child,
        ),
        subtitle: null,
        text: null,
        after: null,
        leading: null,
        trailing: icon == null
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: Color(0xFF444444),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: destructive ? _kDanger : _kPrimary,
                  size: 22,
                ),
              ),
        type: CellType.ACTION,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: padding,
        enabled: enabled,
        disclosure: false,
        checked: false,
      );

  factory Cell.detail({
    Key key,
    Widget header,
    Widget content,
    Widget status,
    Widget after,
    Widget trailing,
    VoidCallback onTap,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
  }) =>
      Cell._(
        key: key,
        title: header,
        subtitle: content,
        text: status,
        after: after,
        leading: null,
        trailing: trailing,
        type: CellType.DETAIL,
        onTap: onTap,
        onLongPress: null,
        padding: padding,
        enabled: true,
        checked: false,
        disclosure: false,
      );

  factory Cell.profile({
    Key key,
    Widget child,
    VoidCallback onChange,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
  }) =>
      Cell._(
        key: key,
        title: child,
        subtitle: null,
        text: null,
        after: null,
        leading: null,
        trailing: null,
        type: CellType.PROFILE,
        onTap: onChange,
        onLongPress: null,
        padding: padding,
        enabled: enabled,
        checked: false,
        disclosure: false,
      );

  factory Cell.product({
    Key key,
    Widget child,
    VoidCallback onChange,
    EdgeInsets padding: const EdgeInsets.symmetric(horizontal: 16.0),
    bool enabled: true,
  }) =>
      Cell._(
        key: key,
        title: child,
        subtitle: null,
        text: null,
        after: null,
        leading: null,
        trailing: null,
        type: CellType.PRODUCT,
        onTap: onChange,
        onLongPress: null,
        padding: padding,
        enabled: enabled,
        checked: false,
        disclosure: false,
      );
}

class RawCell extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget text;
  final Widget after;
  final Widget leading;
  final Widget trailing;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final CellType type;
  final bool enabled;
  final bool checked;
  final bool disclosure;

  const RawCell({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.text,
    @required this.after,
    @required this.leading,
    @required this.trailing,
    @required this.type,
    @required this.padding,
    @required this.onTap,
    @required this.onLongPress,
    @required this.enabled,
    @required this.checked,
    @required this.disclosure,
  }) : super(key: key);

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      Feedback.forTap(context);
      onTap();
    }
  }

  void _handleLongPress(BuildContext context) {
    if (onLongPress != null) {
      Feedback.forLongPress(context);
      onLongPress();
    }
  }

  TextStyle _titleTextStyle(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;

    final defaultTextStyle = textTheme.body.copyWith(
      height: 1,
    );

    switch (type) {
      case CellType.MESSAGE:
        return defaultTextStyle.copyWith(fontWeight: FontWeight.w600);
      case CellType.DETAIL:
        return textTheme.subhead.copyWith(
          color: Colors.secondaryLabel.resolveFrom(context),
        );
      case CellType.REVIEW:
        return textTheme.body.copyWith(height: 1.1);
      default:
        return defaultTextStyle;
    }
  }

  TextStyle _subtitleTextStyle(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;
    switch (type) {
      case CellType.DEFAULT:
        return textTheme.caption1.copyWith(
          color: Colors.inactiveGray.resolveFrom(context),
        );
      case CellType.SUBTITLE:
        return textTheme.caption1.copyWith(
            color: Colors.inactiveGray.resolveFrom(context), height: 1.0);
      case CellType.MESSAGE:
        return textTheme.subhead.copyWith(
          color: Colors.secondaryLabel.resolveFrom(context),
        );
      case CellType.MAIL:
        return textTheme.subhead;
      case CellType.DETAIL:
        return textTheme.body.copyWith(height: 1.25);
      case CellType.REVIEW:
        return textTheme.subhead.copyWith(
          color: Colors.secondaryLabel.resolveFrom(context),
        );
      default:
        return _kSubtitleStyle;
    }
  }

  TextStyle _textTextStyle(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;

    switch (type) {
      case CellType.DETAIL:
        return textTheme.body;
      default:
        return textTheme.subhead.copyWith(
          color: Colors.secondaryLabel.resolveFrom(context),
        );
    }
  }

  TextStyle get _afterTextStyle {
    switch (type) {
      case CellType.MESSAGE:
        return _kSubheadlineStyle;
      case CellType.MAIL:
        return _kSubheadlineStyle;
      case CellType.DETAIL:
        return _kSubheadlineStyle.copyWith(
          color: _kPrimary,
        );
      default:
        return _kTitleStyle.copyWith(
          color: _kSecondaryLabel,
        );
    }
  }

  Widget _trailing(
    BuildContext context, [
    bool checked,
    bool disclosure,
  ]) {
    final _checked = checked ?? false;
    final _disclosure = disclosure ?? false;

    if (_checked || _disclosure)
      return RichText(
        text: TextSpan(
          children: [
            if (_checked)
              IconSpan(
                CupertinoIcons.check,
                size: 24,
                color: CupertinoTheme.of(context).primaryColor,
              )
            else if (_disclosure)
              IconSpan(
                CupertinoIcons.right_chevron,
                size: 17,
                color: Colors.disclosure.resolveFrom(context),
                bolder: true,
              ),
          ],
        ),
      );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCallback = onTap != null || onLongPress != null;

    Widget titleWidget;
    if (title != null) {
      titleWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        style: _titleTextStyle(context),
        child: title,
      );
    }

    Widget subtitleWidget;
    if (subtitle != null) {
      subtitleWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        style: _subtitleTextStyle(context),
        child: subtitle,
      );
    }

    Widget textWidget;
    if (text != null) {
      textWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        style: _textTextStyle(context),
        child: text,
      );
    }

    Widget afterWidget;
    if (after != null) {
      afterWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.right,
        style: _afterTextStyle,
        child: after,
      );
    }

    Widget trailingWidget;
    if (trailing != null) {
      trailingWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.right,
        style: _kTitleStyle.copyWith(color: _kSecondaryLabel),
        child: trailing,
      );
    }

//    final _cell = _Cell(
//      title: Container(child: titleWidget, color: Color(0xFF777777)),
//      subtitle: Container(child: subtitleWidget, color: Color(0xFF444444)),
//      text: Container(child: textWidget, color: Color(0xFF555555)),
//      after: afterWidget,
//      leading: leading,
//      trailing:
//          trailing ?? _trailing(context, checked, disclosure ?? onTap != null),
//      type: type,
//    );

    final _cell = _Cell(
      title: titleWidget,
      subtitle: subtitleWidget,
      text: textWidget,
      after: afterWidget,
      leading: leading,
      trailing: trailingWidget ??
          _trailing(context, checked, disclosure ?? onTap != null),
      type: type,
    );

    if (hasCallback) {
      return _Tappable(
        onTap: enabled && onTap != null ? onTap : null,
        onLongPress: onLongPress != null ? onLongPress : null,
        child: _Cell(
          title: titleWidget,
          subtitle: subtitleWidget,
          text: textWidget,
          after: afterWidget,
          leading: leading,
          trailing: trailingWidget ??
              _trailing(context, checked, disclosure ?? onTap != null),
          type: type,
        ),
      );
    }

    return RepaintBoundary(child: _cell);
  }
}

class _Tappable extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget child;

  const _Tappable({
    Key key,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : super(key: key);

  @override
  _TappableState createState() => _TappableState();
}

class _TappableState extends State<_Tappable> {
  Timer _timer;

  bool isPressed = false;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(_Tappable oldWidget) {
    if (_timer?.isActive ?? false) {
      _timer.cancel();
      if (isPressed) isPressed = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  void onTap() {
    if (widget.onTap != null) {
      Feedback.forTap(context);
      widget.onTap();
    }
  }

  void onLongPress() {
    if (widget.onLongPress != null) {
      Feedback.forLongPress(context);
      widget.onLongPress();
    }
  }

  onTapDown(TapDownDetails _) {
    if (!isPressed) {
      setState(() {
        isPressed = true;
      });
    }
  }

  onTapUp(TapUpDetails _) {
    if (isPressed) {
      _timer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          isPressed = false;
        });
      });
    }
  }

  void onTapCancel() {
    if (isPressed) {
      setState(() {
        isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );

    if (context.findAncestorRenderObjectOfType<RenderSectionCells>() != null)
      return CellParentDataWidget(
        isPressed: isPressed,
        child: child,
      );

    return child;
  }
}

//double get _minHeight {
//  switch (type) {
//    case CellType.MESSAGE:
//      return 76.0;
//    case CellType.MAIL:
//      return 98.0;
//    case CellType.VOUCHER:
//      return 58.0;
//    case CellType.SWITCHER:
//      return 44.0;
//    case CellType.PROFILE:
//      return 80.0;
//    case CellType.DETAIL:
//      return 66.0;
//    case CellType.PRODUCT:
//      return 94.0;
//    case CellType.REVIEW:
//      return 44.0;
//    default:
//      return 0.0;
//  }
//}

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
  }) : super(key: key);

  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget text;
  final Widget after;
  final Widget trailing;
  final CellType type;

  @override
  _CellElement createElement() => _CellElement(this);

  @override
  _RenderCell createRenderObject(BuildContext context) {
    return _RenderCell(type: type);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCell renderObject) {
    renderObject..type = type;
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
    @required CellType type,
  })  : assert(type != null),
        _type = type;

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
        _maxHeight(text, width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return math.max(_maxHeight(title, width), _maxHeight(subtitle, width)) +
        _maxHeight(text, width);
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

    if (hasSubtitle) {
      _positionBox(title, Offset(titleStart, topStart));
      _positionBox(
        subtitle,
        Offset(titleStart, topStart + titleSize.height + 2.0),
      );
    } else {
      _positionBox(
          title, Offset(titleStart, (tileHeight - titleSize.height) / 2.0));
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

const Color _kPrimaryLabel = Color.fromRGBO(255, 255, 255, 1.0);
const Color _kSecondaryLabel = Color.fromRGBO(235, 235, 245, 0.6);
const Color _kPrimary = Color(0xFFFBC02D);
const Color _kDanger = Color(0xFFFD5739);

const Color _kBackgroundColor = Color.fromARGB(255, 26, 26, 28);
const Color _kDividerColor = Color.fromARGB(255, 54, 54, 58);
const Color _kPressedColor = Color(0xFF2E2E2E);

const _spaceSpan = TextSpan(
  text: " • ",
  style: TextStyle(
    fontSize: 10.0,
    inherit: false,
  ),
);

const TextStyle _kTitleStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  height: 1,
  fontWeight: FontWeight.w400,
  color: _kPrimaryLabel,
  decoration: TextDecoration.none,
);

const TextStyle _kSubtitleStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 12.0,
  letterSpacing: 0.0,
  height: 1,
  color: Colors.inactiveGray,
  decoration: TextDecoration.none,
);

const TextStyle _kSubheadlineStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 15.0,
  letterSpacing: -0.24,
  height: 1.2,
  color: _kSecondaryLabel,
  decoration: TextDecoration.none,
);

const TextStyle _kAfterStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  color: Colors.detailGray,
  decoration: TextDecoration.none,
);

const TextStyle _kErrorStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: _kDanger,
);

class ActionIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class IconSpan extends TextSpan {
  IconSpan(IconData icon, {Color color, double size, bool bolder: false})
      : super(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            inherit: false,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            height: 1,
            fontSize: size,
            color: color,
            fontWeight: bolder ? FontWeight.bold : FontWeight.normal,
          ),
        );
}

class LinkSpan extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool subheading;

  const LinkSpan(
    this.title, {
    Key key,
    @required this.onTap,
    this.subheading: false,
  }) : super(key: key);

  @override
  _LinkSpanState createState() => _LinkSpanState();
}

class _LinkSpanState extends State<LinkSpan> {
  Timer _timer;

  double opacity = 1.0;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  onTap() {
    Feedback.forTap(context);
    widget.onTap();
  }

  onTapDown(TapDownDetails _) {
    setState(() {
      opacity = 0.7;
    });
  }

  onTapUp(TapUpDetails _) {
    _timer = Timer(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  void onTapCancel() {
    setState(() {
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 50),
      child: GestureDetector(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTap: onTap,
        onTapCancel: onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: Text(
          widget.title,
          style: !widget.subheading
              ? _kTitleStyle
              : _kSubheadlineStyle.copyWith(color: _kPrimary),
        ),
      ),
    );
  }
}

enum TestCellAction {
  enabled,
  disabled,
  delete,
  insert,
  selected,
  unselected,
}

Icon getCellActionIcon(TestCellAction action) {
  IconData icon;
  Color color;

  switch (action) {
    case TestCellAction.delete:
      icon = CupertinoIcons.minus_circled_filled;
      color = const Color(0xFFFF453A);
      break;
    case TestCellAction.insert:
      icon = CupertinoIcons.add_circled_solid;
      color = const Color(0xFF32D74B);
      break;
    case TestCellAction.selected:
      icon = CupertinoIcons.check_mark_circled_solid;
      color = const Color(0xFF0A84FF);
      break;
    case TestCellAction.unselected:
      icon = CupertinoIcons.circle;
      color = const Color(0xFF48484A);
      break;
    case TestCellAction.enabled:
      icon = Icons.fiber_manual_record;
      color = const Color(0xFF32D74B);
      break;
    case TestCellAction.disabled:
      icon = Icons.fiber_manual_record;
      color = const Color(0xFFFF453A);
      break;
  }

  return Icon(
    icon,
    color: color,
    size: 22.0,
  );
}
