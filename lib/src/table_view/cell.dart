import 'dart:async';
import 'dart:math' as math;

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

part 'cell.styles.dart';
part 'cell.render.dart';
part 'cell.widgets.dart';

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

  TextStyle get _titleTextStyle {
    switch (type) {
      case CellType.MESSAGE:
        return _kTitleStyle.copyWith(fontWeight: FontWeight.w600);
      case CellType.DETAIL:
        return _kSubheadlineStyle;
      case CellType.REVIEW:
        return _kTitleStyle.copyWith(height: 1.1);
      default:
        return _kTitleStyle;
    }
  }

  TextStyle get _subtitleTextStyle {
    switch (type) {
      case CellType.DEFAULT:
        return _kSubtitleStyle;
      case CellType.SUBTITLE:
        return _kSubtitleStyle;
      case CellType.MESSAGE:
        return _kSubheadlineStyle;
      case CellType.MAIL:
        return _kSubheadlineStyle.copyWith(color: _kPrimaryLabel);
      case CellType.DETAIL:
        return _kTitleStyle.copyWith(height: 1.25);
      case CellType.REVIEW:
        return _kSubheadlineStyle;
      default:
        return _kSubtitleStyle;
    }
  }

  TextStyle get _textTextStyle {
    switch (type) {
      case CellType.DETAIL:
        return _kTitleStyle;
      default:
        return _kSubheadlineStyle;
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
                size: 20,
                color: CupertinoColors.separator.resolveFrom(context),
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
        style: _titleTextStyle,
        child: title,
      );
    }

    Widget subtitleWidget;
    if (subtitle != null) {
      subtitleWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        style: _subtitleTextStyle,
        child: subtitle,
      );
    }

    Widget textWidget;
    if (text != null) {
      textWidget = DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        style: _textTextStyle,
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
      return RepaintBoundary(
        child: _Tappable(
          onTap: enabled && onTap != null ? onTap : null,
          onLongPress: onLongPress != null ? onLongPress : null,
          builder: (context, isPressed) {
            return _Cell(
              isPressed: isPressed,
              title: titleWidget,
              subtitle: subtitleWidget,
              text: textWidget,
              after: afterWidget,
              leading: leading,
              trailing: trailingWidget ??
                  _trailing(context, checked, disclosure ?? onTap != null),
              type: type,
            );
          },
        ),
      );
    }

    return RepaintBoundary(child: _cell);
  }
}

class _Tappable extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget Function(BuildContext, bool) builder;

  const _Tappable({
    Key key,
    this.onTap,
    this.onLongPress,
    this.builder,
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
    if(_timer?.isActive ?? false) {
      _timer.cancel();
      if(isPressed) isPressed = false;
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
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: widget.builder(context, isPressed),
    );
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
