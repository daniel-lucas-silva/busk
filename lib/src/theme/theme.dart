import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'icon_theme_data.dart';
import 'text_theme.dart';

export 'package:flutter/services.dart' show Brightness;

const _CupertinoThemeDefaults _kDefaultTheme = _CupertinoThemeDefaults(
  null,
  CupertinoColors.systemBlue,
  CupertinoColors.systemBackground,
  CupertinoDynamicColor.withBrightness(
    color: Color(0xF0F9F9F9),
    darkColor: Color.fromRGBO(22, 22, 24, 0.8),
  ),
  CupertinoColors.systemGroupedBackground,
  _CupertinoTextThemeDefaults(CupertinoColors.label,
      CupertinoColors.inactiveGray, CupertinoColors.detailGray),
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
    CupertinoTextThemeData textTheme,
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
    CupertinoTextThemeData textTheme,
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

  CupertinoTextThemeData get textTheme {
    return _textTheme ??
        _defaults.textThemeDefaults.createDefaults(primaryColor: primaryColor);
  }

  final CupertinoTextThemeData _textTheme;

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
        CupertinoDynamicColor.resolve(color, context, nullOk: nullOk);

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
    CupertinoTextThemeData textTheme,
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
  final CupertinoTextThemeData textTheme;
  @override
  final Color barBackgroundColor;
  @override
  final Color scaffoldBackgroundColor;

  @override
  _NoDefaultCupertinoThemeData resolveFrom(BuildContext context,
      {bool nullOk = false}) {
    Color convertColor(Color color) =>
        CupertinoDynamicColor.resolve(color, context, nullOk: nullOk);

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
    CupertinoTextThemeData textTheme,
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
  final _CupertinoTextThemeDefaults textThemeDefaults;

  _CupertinoThemeDefaults resolveFrom(
      BuildContext context, bool resolveTextTheme,
      {@required bool nullOk}) {
    assert(nullOk != null);
    Color convertColor(Color color) =>
        CupertinoDynamicColor.resolve(color, context, nullOk: nullOk);

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
class _CupertinoTextThemeDefaults {
  const _CupertinoTextThemeDefaults(
    this.labelColor,
    this.inactiveGray,
    this.detailGray,
  );

  final Color labelColor;
  final Color inactiveGray;
  final Color detailGray;

  _CupertinoTextThemeDefaults resolveFrom(BuildContext context,
      {@required bool nullOk}) {
    return _CupertinoTextThemeDefaults(
      CupertinoDynamicColor.resolve(labelColor, context, nullOk: nullOk),
      CupertinoDynamicColor.resolve(inactiveGray, context, nullOk: nullOk),
      CupertinoDynamicColor.resolve(detailGray, context, nullOk: nullOk),
    );
  }

  CupertinoTextThemeData createDefaults({@required Color primaryColor}) {
    assert(primaryColor != null);
    return _DefaultCupertinoTextThemeData(
      primaryColor: primaryColor,
      labelColor: labelColor,
      inactiveGray: inactiveGray,
      detailGray: detailGray,
    );
  }
}

class _DefaultCupertinoTextThemeData extends CupertinoTextThemeData {
  const _DefaultCupertinoTextThemeData({
    @required this.labelColor,
    @required this.inactiveGray,
    @required this.detailGray,
    @required Color primaryColor,
  })  : assert(labelColor != null),
        assert(inactiveGray != null),
        assert(primaryColor != null),
        super(primaryColor: primaryColor);

  final Color labelColor;
  final Color inactiveGray;
  final Color detailGray;

  @override
  TextStyle get textStyle => super.textStyle.copyWith(color: labelColor);

  @override
  TextStyle get tabLabelTextStyle =>
      super.tabLabelTextStyle.copyWith(color: inactiveGray);

  @override
  TextStyle get navTitleTextStyle =>
      super.navTitleTextStyle.copyWith(color: labelColor);

  @override
  TextStyle get navLargeTitleTextStyle =>
      super.navLargeTitleTextStyle.copyWith(color: labelColor);

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
