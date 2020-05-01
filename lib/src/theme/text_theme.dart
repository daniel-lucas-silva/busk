// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show Brightness;
import 'package:flutter/widgets.dart';

import 'colors.dart';


const TextStyle _kDefaultTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: CupertinoColors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultSubtitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 12.0,
  letterSpacing: -0.04,
  color: CupertinoColors.inactiveGray,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultDetailTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  color: CupertinoColors.detailGray,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultActionTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  color: CupertinoColors.activeBlue,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultTabLabelTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.24,
  color: CupertinoColors.inactiveGray,
);

const TextStyle _kDefaultFormFooterTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.04,
  color: CupertinoColors.inactiveGray,
);

const TextStyle _kDefaultMiddleTitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.41,
  color: CupertinoColors.label,
);

const TextStyle _kDefaultLargeTitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 34.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.41,
  color: CupertinoColors.label,
);

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 21.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.41,
  color: CupertinoColors.label,
);

// Please update _TextThemeDefaultsBuilder accordingly after changing the default
// color here, as their implementation depends on the default value of the color
// field.
//
// Inspected on iOS 13 simulator with "Debug View Hierarchy".
// Value extracted from off-center labels. Centered labels have a font size of 25pt.
const TextStyle _kDefaultDateTimePickerTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 21,
  fontWeight: FontWeight.normal,
  color: CupertinoColors.label,
);

TextStyle _resolveTextStyle(TextStyle style, BuildContext context, bool nullOk) {
  // This does not resolve the shadow color, foreground, background, etc.
  return style?.copyWith(
    color: CupertinoDynamicColor.resolve(style?.color, context, nullOk: nullOk),
    backgroundColor: CupertinoDynamicColor.resolve(style?.backgroundColor, context, nullOk: nullOk),
    decorationColor: CupertinoDynamicColor.resolve(style?.decorationColor, context, nullOk: nullOk),
  );
}

@immutable
class CupertinoTextThemeData extends Diagnosticable {

  const CupertinoTextThemeData({
    Color primaryColor = CupertinoColors.systemBlue,
    TextStyle textStyle,
    TextStyle actionTextStyle,
    TextStyle tabLabelTextStyle,
    TextStyle navTitleTextStyle,
    TextStyle navLargeTitleTextStyle,
    TextStyle navActionTextStyle,
    TextStyle pickerTextStyle,
    TextStyle dateTimePickerTextStyle,
    TextStyle subtitleTextStyle,
    TextStyle detailTextStyle,
    TextStyle formFooterTextStyle,
  }) : this._raw(
         const _TextThemeDefaultsBuilder(CupertinoColors.label, CupertinoColors.inactiveGray, CupertinoColors.detailGray),
         primaryColor,
         textStyle,
         actionTextStyle,
         tabLabelTextStyle,
         navTitleTextStyle,
         navLargeTitleTextStyle,
         navActionTextStyle,
         pickerTextStyle,
         dateTimePickerTextStyle,
         subtitleTextStyle,
         detailTextStyle,
         formFooterTextStyle,
       );

  const CupertinoTextThemeData._raw(
    this._defaults,
    this._primaryColor,
    this._textStyle,
    this._actionTextStyle,
    this._tabLabelTextStyle,
    this._navTitleTextStyle,
    this._navLargeTitleTextStyle,
    this._navActionTextStyle,
    this._pickerTextStyle,
    this._dateTimePickerTextStyle,
    this._subtitleTextStyle,
    this._detailTextStyle,
    this._formFooterTextStyle,
  ) : assert((_navActionTextStyle != null && _actionTextStyle != null) || _primaryColor != null);

  final _TextThemeDefaultsBuilder _defaults;
  final Color _primaryColor;

  final TextStyle _textStyle;
  TextStyle get textStyle => _textStyle ?? _defaults.textStyle;

  final TextStyle _actionTextStyle;
  TextStyle get actionTextStyle {
    return _actionTextStyle ?? _defaults.actionTextStyle(primaryColor: _primaryColor);
  }

  final TextStyle _tabLabelTextStyle;
  TextStyle get tabLabelTextStyle => _tabLabelTextStyle ?? _defaults.tabLabelTextStyle;

  final TextStyle _navTitleTextStyle;
  TextStyle get navTitleTextStyle => _navTitleTextStyle ?? _defaults.navTitleTextStyle;

  final TextStyle _navLargeTitleTextStyle;
  TextStyle get navLargeTitleTextStyle => _navLargeTitleTextStyle ?? _defaults.navLargeTitleTextStyle;

  final TextStyle _navActionTextStyle;
  TextStyle get navActionTextStyle {
    return _navActionTextStyle ?? _defaults.navActionTextStyle(primaryColor: _primaryColor);
  }

  final TextStyle _pickerTextStyle;
  TextStyle get pickerTextStyle => _pickerTextStyle ?? _defaults.pickerTextStyle;

  final TextStyle _dateTimePickerTextStyle;
  TextStyle get dateTimePickerTextStyle => _dateTimePickerTextStyle ?? _defaults.dateTimePickerTextStyle;

  final TextStyle _subtitleTextStyle;
  TextStyle get subtitleTextStyle => _subtitleTextStyle ?? _defaults.subtitleTextStyle;

  final TextStyle _detailTextStyle;
  TextStyle get detailTextStyle => _detailTextStyle ?? _defaults.detailTextStyle;

  final TextStyle _formFooterTextStyle;
  TextStyle get formFooterTextStyle => _formFooterTextStyle ?? _defaults.formFooterTextStyle;

  CupertinoTextThemeData resolveFrom(BuildContext context, { bool nullOk = false }) {
    return CupertinoTextThemeData._raw(
      _defaults?.resolveFrom(context, nullOk),
      CupertinoDynamicColor.resolve(_primaryColor, context, nullOk: nullOk),
      _resolveTextStyle(_textStyle, context, nullOk),
      _resolveTextStyle(_actionTextStyle, context, nullOk),
      _resolveTextStyle(_tabLabelTextStyle, context, nullOk),
      _resolveTextStyle(_navTitleTextStyle, context, nullOk),
      _resolveTextStyle(_navLargeTitleTextStyle, context, nullOk),
      _resolveTextStyle(_navActionTextStyle, context, nullOk),
      _resolveTextStyle(_pickerTextStyle, context, nullOk),
      _resolveTextStyle(_dateTimePickerTextStyle, context, nullOk),
      _resolveTextStyle(_subtitleTextStyle, context, nullOk),
      _resolveTextStyle(_detailTextStyle, context, nullOk),
      _resolveTextStyle(_formFooterTextStyle, context, nullOk),
    );
  }

  /// Returns a copy of the current [CupertinoTextThemeData] instance with
  /// specified overrides.
  CupertinoTextThemeData copyWith({
    Color primaryColor,
    @Deprecated(
      'This argument no longer does anything. You can remove it. '
      'This feature was deprecated after v1.10.14.'
    )
    Brightness brightness,
    TextStyle textStyle,
    TextStyle actionTextStyle,
    TextStyle tabLabelTextStyle,
    TextStyle navTitleTextStyle,
    TextStyle navLargeTitleTextStyle,
    TextStyle navActionTextStyle,
    TextStyle pickerTextStyle,
    TextStyle dateTimePickerTextStyle,
    TextStyle subtitleTextStyle,
    TextStyle detailTextStyle,
    TextStyle formFooterTextStyle,
  }) {
    return CupertinoTextThemeData._raw(
      _defaults,
      primaryColor ?? _primaryColor,
      textStyle ?? _textStyle,
      actionTextStyle ?? _actionTextStyle,
      tabLabelTextStyle ?? _tabLabelTextStyle,
      navTitleTextStyle ?? _navTitleTextStyle,
      navLargeTitleTextStyle ?? _navLargeTitleTextStyle,
      navActionTextStyle ?? _navActionTextStyle,
      pickerTextStyle ?? _pickerTextStyle,
      dateTimePickerTextStyle ?? _dateTimePickerTextStyle,
      subtitleTextStyle ?? _subtitleTextStyle,
      detailTextStyle ?? _detailTextStyle,
      formFooterTextStyle ?? _formFooterTextStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const CupertinoTextThemeData defaultData = CupertinoTextThemeData();
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle, defaultValue: defaultData.textStyle));
    properties.add(DiagnosticsProperty<TextStyle>('actionTextStyle', actionTextStyle, defaultValue: defaultData.actionTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('tabLabelTextStyle', tabLabelTextStyle, defaultValue: defaultData.tabLabelTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('navTitleTextStyle', navTitleTextStyle, defaultValue: defaultData.navTitleTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('navLargeTitleTextStyle', navLargeTitleTextStyle, defaultValue: defaultData.navLargeTitleTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('navActionTextStyle', navActionTextStyle, defaultValue: defaultData.navActionTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('pickerTextStyle', pickerTextStyle, defaultValue: defaultData.pickerTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('dateTimePickerTextStyle', dateTimePickerTextStyle, defaultValue: defaultData.dateTimePickerTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('subtitleTextStyle', subtitleTextStyle, defaultValue: defaultData.subtitleTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('detailTextStyle', detailTextStyle, defaultValue: defaultData.detailTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>('formFooterTextStyle', formFooterTextStyle, defaultValue: defaultData.formFooterTextStyle));
  }
}


@immutable
class _TextThemeDefaultsBuilder {
  const _TextThemeDefaultsBuilder(
    this.labelColor,
    this.inactiveGrayColor,
    this.detailGray,
  ) : assert(labelColor != null),
        assert(inactiveGrayColor != null),
        assert(detailGray != null);

  final Color labelColor;
  final Color inactiveGrayColor;
  final Color detailGray;

  static TextStyle _applyLabelColor(TextStyle original, Color color) {
    return original?.color == color
      ?  original
      :  original?.copyWith(color: color);
  }

  TextStyle get textStyle => _applyLabelColor(_kDefaultTextStyle, labelColor);
  TextStyle get tabLabelTextStyle => _applyLabelColor(_kDefaultTabLabelTextStyle, inactiveGrayColor);
  TextStyle get navTitleTextStyle => _applyLabelColor(_kDefaultMiddleTitleTextStyle, labelColor);
  TextStyle get navLargeTitleTextStyle => _applyLabelColor(_kDefaultLargeTitleTextStyle, labelColor);
  TextStyle get pickerTextStyle => _applyLabelColor(_kDefaultPickerTextStyle, labelColor);
  TextStyle get dateTimePickerTextStyle => _applyLabelColor(_kDefaultDateTimePickerTextStyle, labelColor);
  TextStyle get subtitleTextStyle => _applyLabelColor(_kDefaultSubtitleTextStyle, inactiveGrayColor);
  TextStyle get detailTextStyle => _applyLabelColor(_kDefaultDetailTextStyle, detailGray);
  TextStyle get formFooterTextStyle => _applyLabelColor(_kDefaultFormFooterTextStyle, inactiveGrayColor);

  TextStyle actionTextStyle({ Color primaryColor }) => _kDefaultActionTextStyle.copyWith(color: primaryColor);
  TextStyle navActionTextStyle({ Color primaryColor }) => actionTextStyle(primaryColor: primaryColor);

  _TextThemeDefaultsBuilder resolveFrom(BuildContext context, bool nullOk) {
    final Color resolvedLabelColor = CupertinoDynamicColor.resolve(labelColor, context, nullOk: nullOk);
    final Color resolvedInactiveGray = CupertinoDynamicColor.resolve(inactiveGrayColor, context, nullOk: nullOk);
    final Color resolvedDetailGray = CupertinoDynamicColor.resolve(detailGray, context, nullOk: nullOk);
    return resolvedLabelColor == labelColor && resolvedInactiveGray == CupertinoColors.inactiveGray && resolvedDetailGray == CupertinoColors.detailGray
      ? this
      : _TextThemeDefaultsBuilder(resolvedLabelColor, resolvedInactiveGray, resolvedDetailGray);
  }
}
