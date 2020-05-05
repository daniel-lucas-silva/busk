import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'icon_theme_data.dart';
import 'text_theme.dart';

export 'package:flutter/services.dart' show Brightness;

const _CupertinoThemeDefaults _kDefaultTheme = _CupertinoThemeDefaults(
  null,
  Colors.systemBlue,
  Colors.systemBackground,
  DynamicColor.withBrightness(
    color: Color(0xF0F9F9F9),
    darkColor: Color.fromRGBO(22, 22, 24, 1),
  ),
  Colors.systemGroupedBackground,
  _TextThemeDefaults(
    Colors.label,
    Colors.secondaryLabel,
    Colors.inactiveGray,
    Colors.detailGray,
  ),
);

class CupertinoTheme extends StatelessWidget {
  const CupertinoTheme({
    Key key,
    @required this.data,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key);

  final CupertinoThemeData data;

  static CupertinoThemeData of(BuildContext context) {
    final _InheritedCupertinoTheme inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedCupertinoTheme>();
    return (inheritedTheme?.theme?.data ?? const CupertinoThemeData())
        .resolveFrom(context, nullOk: true);
  }

  static Brightness brightnessOf(BuildContext context, {bool nullOk = false}) {
    final _InheritedCupertinoTheme inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedCupertinoTheme>();
    return inheritedTheme?.theme?.data?._brightness ??
        MediaQuery.of(context, nullOk: nullOk)?.platformBrightness;
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _InheritedCupertinoTheme(
      theme: this,
      child: IconTheme(
        data: CupertinoIconThemeData(color: data.primaryColor),
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

class _InheritedCupertinoTheme extends InheritedWidget {
  const _InheritedCupertinoTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final CupertinoTheme theme;

  @override
  bool updateShouldNotify(_InheritedCupertinoTheme old) =>
      theme.data != old.theme.data;
}

@immutable
class CupertinoThemeData extends Diagnosticable {
  const CupertinoThemeData({
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    TextThemeData textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
  }) : this.raw(
          brightness,
          primaryColor,
          primaryContrastingColor,
          textTheme,
          barBackgroundColor,
          scaffoldBackgroundColor,
        );

  @protected
  const CupertinoThemeData.raw(
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    TextThemeData textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
  ) : this._rawWithDefaults(
          brightness,
          primaryColor,
          primaryContrastingColor,
          textTheme,
          barBackgroundColor,
          scaffoldBackgroundColor,
          _kDefaultTheme,
        );

  const CupertinoThemeData._rawWithDefaults(
    this._brightness,
    this._primaryColor,
    this._primaryContrastingColor,
    this._textTheme,
    this._barBackgroundColor,
    this._scaffoldBackgroundColor,
    this._defaults,
  );

  final _CupertinoThemeDefaults _defaults;

  Brightness get brightness => _brightness ?? Brightness.light;
  final Brightness _brightness;

  Color get primaryColor => _primaryColor ?? _defaults.primaryColor;
  final Color _primaryColor;

  Color get primaryContrastingColor =>
      _primaryContrastingColor ?? _defaults.primaryContrastingColor;
  final Color _primaryContrastingColor;

  TextThemeData get textTheme {
    return _textTheme ??
        _defaults.textThemeDefaults.createDefaults(
          primaryColor: primaryColor,
        );
  }

  final TextThemeData _textTheme;

  Color get barBackgroundColor =>
      _barBackgroundColor ?? _defaults.barBackgroundColor;
  final Color _barBackgroundColor;

  Color get scaffoldBackgroundColor =>
      _scaffoldBackgroundColor ?? _defaults.scaffoldBackgroundColor;
  final Color _scaffoldBackgroundColor;

  CupertinoThemeData noDefault() {
    return _NoDefaultCupertinoThemeData(
      _brightness,
      _primaryColor,
      _primaryContrastingColor,
      _textTheme,
      _barBackgroundColor,
      _scaffoldBackgroundColor,
    );
  }

  @protected
  CupertinoThemeData resolveFrom(BuildContext context, {bool nullOk = false}) {
    Color convertColor(Color color) =>
        DynamicColor.resolve(color, context, nullOk: nullOk);

    return CupertinoThemeData._rawWithDefaults(
      _brightness,
      convertColor(_primaryColor),
      convertColor(_primaryContrastingColor),
      _textTheme?.resolveFrom(context, nullOk: nullOk),
      convertColor(_barBackgroundColor),
      convertColor(_scaffoldBackgroundColor),
      _defaults.resolveFrom(context, _textTheme == null, nullOk: nullOk),
    );
  }

  CupertinoThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    TextThemeData textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
  }) {
    return CupertinoThemeData._rawWithDefaults(
      brightness ?? _brightness,
      primaryColor ?? _primaryColor,
      primaryContrastingColor ?? _primaryContrastingColor,
      textTheme ?? _textTheme,
      barBackgroundColor ?? _barBackgroundColor,
      scaffoldBackgroundColor ?? _scaffoldBackgroundColor,
      _defaults,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const CupertinoThemeData defaultData = CupertinoThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(createCupertinoColorProperty('primaryColor', primaryColor,
        defaultValue: defaultData.primaryColor));
    properties.add(createCupertinoColorProperty(
        'primaryContrastingColor', primaryContrastingColor,
        defaultValue: defaultData.primaryContrastingColor));
    properties.add(createCupertinoColorProperty(
        'barBackgroundColor', barBackgroundColor,
        defaultValue: defaultData.barBackgroundColor));
    properties.add(createCupertinoColorProperty(
        'scaffoldBackgroundColor', scaffoldBackgroundColor,
        defaultValue: defaultData.scaffoldBackgroundColor));
    textTheme.debugFillProperties(properties);
  }
}

class _NoDefaultCupertinoThemeData extends CupertinoThemeData {
  const _NoDefaultCupertinoThemeData(
    this.brightness,
    this.primaryColor,
    this.primaryContrastingColor,
    this.textTheme,
    this.barBackgroundColor,
    this.scaffoldBackgroundColor,
  ) : super._rawWithDefaults(
          brightness,
          primaryColor,
          primaryContrastingColor,
          textTheme,
          barBackgroundColor,
          scaffoldBackgroundColor,
          null,
        );

  @override
  final Brightness brightness;
  @override
  final Color primaryColor;
  @override
  final Color primaryContrastingColor;
  @override
  final TextThemeData textTheme;
  @override
  final Color barBackgroundColor;
  @override
  final Color scaffoldBackgroundColor;

  @override
  _NoDefaultCupertinoThemeData resolveFrom(BuildContext context,
      {bool nullOk = false}) {
    Color convertColor(Color color) =>
        DynamicColor.resolve(color, context, nullOk: nullOk);

    return _NoDefaultCupertinoThemeData(
      brightness,
      convertColor(primaryColor),
      convertColor(primaryContrastingColor),
      textTheme?.resolveFrom(context, nullOk: nullOk),
      convertColor(barBackgroundColor),
      convertColor(scaffoldBackgroundColor),
    );
  }

  @override
  CupertinoThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    TextThemeData textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
  }) {
    return _NoDefaultCupertinoThemeData(
      brightness ?? this.brightness,
      primaryColor ?? this.primaryColor,
      primaryContrastingColor ?? this.primaryContrastingColor,
      textTheme ?? this.textTheme,
      barBackgroundColor ?? this.barBackgroundColor,
      scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
    );
  }
}

@immutable
class _CupertinoThemeDefaults {
  const _CupertinoThemeDefaults(
    this.brightness,
    this.primaryColor,
    this.primaryContrastingColor,
    this.barBackgroundColor,
    this.scaffoldBackgroundColor,
    this.textThemeDefaults,
  );

  final Brightness brightness;
  final Color primaryColor;
  final Color primaryContrastingColor;
  final Color barBackgroundColor;
  final Color scaffoldBackgroundColor;
  final _TextThemeDefaults textThemeDefaults;

  _CupertinoThemeDefaults resolveFrom(
      BuildContext context, bool resolveTextTheme,
      {@required bool nullOk}) {
    assert(nullOk != null);
    Color convertColor(Color color) =>
        DynamicColor.resolve(color, context, nullOk: nullOk);

    return _CupertinoThemeDefaults(
      brightness,
      convertColor(primaryColor),
      convertColor(primaryContrastingColor),
      convertColor(barBackgroundColor),
      convertColor(scaffoldBackgroundColor),
      resolveTextTheme
          ? textThemeDefaults?.resolveFrom(context, nullOk: nullOk)
          : textThemeDefaults,
    );
  }
}

@immutable
class _TextThemeDefaults {
  const _TextThemeDefaults(
    this.labelColor,
    this.secondaryLabelColor,
    this.inactiveGray,
    this.detailGray,
  );

  final Color labelColor;
  final Color secondaryLabelColor;
  final Color inactiveGray;
  final Color detailGray;

  _TextThemeDefaults resolveFrom(BuildContext context,
      {@required bool nullOk}) {
    return _TextThemeDefaults(
      DynamicColor.resolve(labelColor, context, nullOk: nullOk),
      DynamicColor.resolve(secondaryLabelColor, context, nullOk: nullOk),
      DynamicColor.resolve(inactiveGray, context, nullOk: nullOk),
      DynamicColor.resolve(detailGray, context, nullOk: nullOk),
    );
  }

  TextThemeData createDefaults({@required Color primaryColor}) {
    assert(primaryColor != null);
    return _DefaultCupertinoTextThemeData(
      primaryColor: primaryColor,
      labelColor: labelColor,
      secondaryLabelColor: secondaryLabelColor,
      inactiveGray: inactiveGray,
      detailGray: detailGray,
    );
  }
}

class _DefaultCupertinoTextThemeData extends TextThemeData {
  const _DefaultCupertinoTextThemeData({
    @required this.labelColor,
    @required this.secondaryLabelColor,
    @required this.inactiveGray,
    @required this.detailGray,
    @required Color primaryColor,
  })  : assert(labelColor != null),
        assert(secondaryLabelColor != null),
        assert(inactiveGray != null),
        assert(primaryColor != null),
        super(primaryColor: primaryColor);

  final Color labelColor;
  final Color secondaryLabelColor;
  final Color inactiveGray;
  final Color detailGray;

  @override
  TextStyle get largeTitle => super.largeTitle.copyWith(color: labelColor);

  @override
  TextStyle get title1 => super.title1.copyWith(color: labelColor);

  @override
  TextStyle get title2 => super.title2.copyWith(color: labelColor);

  @override
  TextStyle get title3 => super.title3.copyWith(color: labelColor);

  @override
  TextStyle get headline => super.headline.copyWith(color: labelColor);

  @override
  TextStyle get body => super.body.copyWith(color: labelColor);

  @override
  TextStyle get callout => super.callout.copyWith(color: labelColor);

  @override
  TextStyle get subhead => super.subhead.copyWith(color: labelColor);

  @override
  TextStyle get footnote => super.footnote.copyWith(color: secondaryLabelColor);

  @override
  TextStyle get caption1 => super.caption1.copyWith(color: labelColor);

  @override
  TextStyle get caption2 => super.caption2.copyWith(color: labelColor);

  @override
  TextStyle get textStyle => super.textStyle.copyWith(color: labelColor);

  @override
  TextStyle get tabLabelTextStyle =>
      super.tabLabelTextStyle.copyWith(color: inactiveGray);

//  @override
//  TextStyle get navTitleTextStyle =>
//      super.navTitleTextStyle.copyWith(color: labelColor);

//  @override
//  TextStyle get navLargeTitleTextStyle =>
//      super.navLargeTitleTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get pickerTextStyle =>
      super.pickerTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get dateTimePickerTextStyle =>
      super.dateTimePickerTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get detailTextStyle =>
      super.detailTextStyle.copyWith(color: detailGray);

  @override
  TextStyle get formFooterTextStyle =>
      super.formFooterTextStyle.copyWith(color: inactiveGray);
}
