import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

/**
 * New
 */

const TextStyle _kDefaultLargeTitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 34.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.41,
  color: Colors.label,
);

const TextStyle _kDefaultTitle1TextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 28.0,
  letterSpacing: 0.36,
  fontWeight: FontWeight.w400,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultTitle2TextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 22.0,
  letterSpacing: 0.35,
  fontWeight: FontWeight.w400,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultTitle3TextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 20.0,
  letterSpacing: 0.38,
  fontWeight: FontWeight.w400,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultHeadlineTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w700,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultBodyTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
//  height: 22/17,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultCalloutTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 16.0,
  letterSpacing: -0.32,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultSubheadTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 15.0,
  letterSpacing: -0.24,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultFootnoteTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 13.0,
  height: 18/13,
  letterSpacing: -0.08,
  color: Colors.secondaryLabel,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultCaption1TextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 12.0,
  letterSpacing: 0.0,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultCaption2TextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 11.0,
  letterSpacing: 0.07,
  color: Colors.label,
  decoration: TextDecoration.none,
);
/**
 *
 */

const TextStyle _kDefaultTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: Colors.label,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultSubtitleTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 12.0,
  letterSpacing: -0.04,
  color: Colors.inactiveGray,
  decoration: TextDecoration.none,
);

const TextStyle _kDefaultDetailTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  color: Colors.detailGray,
  decoration: TextDecoration.none,
);

//const TextStyle _kDefaultActionTextStyle = TextStyle(
//  inherit: false,
//  fontFamily: '.SF Pro Text',
//  fontSize: 17.0,
//  letterSpacing: -0.41,
//  color: Colors.activeBlue,
//  decoration: TextDecoration.none,
//);

const TextStyle _kDefaultTabLabelTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.24,
  color: Colors.inactiveGray,
);

const TextStyle _kDefaultFormFooterTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.04,
  color: Colors.inactiveGray,
);

//const TextStyle _kDefaultMiddleTitleTextStyle = TextStyle(
//  inherit: false,
//  fontFamily: '.SF Pro Text',
//  fontSize: 17.0,
//  fontWeight: FontWeight.w600,
//  letterSpacing: -0.41,
//  color: Colors.label,
//);

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 21.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -0.41,
  color: Colors.label,
);

const TextStyle _kDefaultDateTimePickerTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Display',
  fontSize: 21,
  fontWeight: FontWeight.normal,
  color: Colors.label,
);

TextStyle _resolveTextStyle(
    TextStyle style, BuildContext context, bool nullOk) {
  return style?.copyWith(
    color: DynamicColor.resolve(style?.color, context, nullOk: nullOk),
    backgroundColor:
        DynamicColor.resolve(style?.backgroundColor, context, nullOk: nullOk),
    decorationColor:
        DynamicColor.resolve(style?.decorationColor, context, nullOk: nullOk),
  );
}

@immutable
class TextThemeData extends Diagnosticable {
  const TextThemeData({
    Color primaryColor = Colors.systemBlue,
    //
    TextStyle largeTitle,
    TextStyle title1,
    TextStyle title2,
    TextStyle title3,
    TextStyle headline,
    TextStyle body,
    TextStyle callout,
    TextStyle subhead,
    TextStyle footnote,
    TextStyle caption1,
    TextStyle caption2,
    //
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
          const _TextThemeDefaultsBuilder(
            Colors.label,
            Colors.secondaryLabel,
            Colors.inactiveGray,
            Colors.detailGray,
          ),
          primaryColor,
          // New
          largeTitle,
          title1,
          title2,
          title3,
          headline,
          body,
          callout,
          subhead,
          footnote,
          caption1,
          caption2,
          // New
          textStyle,
          actionTextStyle,
          tabLabelTextStyle,
          navTitleTextStyle,
//          navLargeTitleTextStyle,
//          navActionTextStyle,
          pickerTextStyle,
          dateTimePickerTextStyle,
          subtitleTextStyle,
          detailTextStyle,
          formFooterTextStyle,
        );

  const TextThemeData._raw(
    this._defaults,
    this._primaryColor,
    // New
    this._largeTitle,
    this._title1,
    this._title2,
    this._title3,
    this._headline,
    this._body,
    this._callout,
    this._subhead,
    this._footnote,
    this._caption1,
    this._caption2,

    /// New
    this._textStyle,
    this._actionTextStyle,
    this._tabLabelTextStyle,
    this._navTitleTextStyle,
//    this._navLargeTitleTextStyle,
//    this._navActionTextStyle,
    this._pickerTextStyle,
    this._dateTimePickerTextStyle,
    this._subtitleTextStyle,
    this._detailTextStyle,
    this._formFooterTextStyle,
  ) : assert((_actionTextStyle != null) || _primaryColor != null);

  final _TextThemeDefaultsBuilder _defaults;
  final Color _primaryColor;

  ///
  ///
  /// New
  final TextStyle _largeTitle;

  TextStyle get largeTitle => _largeTitle ?? _defaults.largeTitle;

  final TextStyle _title1;

  TextStyle get title1 => _title1 ?? _defaults.title1;

  final TextStyle _title2;

  TextStyle get title2 => _title2 ?? _defaults.title2;

  final TextStyle _title3;

  TextStyle get title3 => _title3 ?? _defaults.title3;

  final TextStyle _headline;

  TextStyle get headline => _headline ?? _defaults.headline;

  final TextStyle _body;

  TextStyle get body => _body ?? _defaults.body;

  final TextStyle _callout;

  TextStyle get callout => _callout ?? _defaults.callout;

  final TextStyle _subhead;

  TextStyle get subhead => _subhead ?? _defaults.subhead;

  final TextStyle _footnote;

  TextStyle get footnote => _footnote ?? _defaults.footnote;

  final TextStyle _caption1;

  TextStyle get caption1 => _caption1 ?? _defaults.caption1;

  final TextStyle _caption2;

  TextStyle get caption2 => _caption2 ?? _defaults.caption2;

  final TextStyle _textStyle;

  TextStyle get textStyle => _textStyle ?? _defaults.textStyle;

  /// New
  ///
  ///

  final TextStyle _actionTextStyle;

  TextStyle get actionTextStyle {
    return _actionTextStyle ??
        _defaults.actionTextStyle(primaryColor: _primaryColor);
  }

  final TextStyle _tabLabelTextStyle;

  TextStyle get tabLabelTextStyle =>
      _tabLabelTextStyle ?? _defaults.tabLabelTextStyle;

  final TextStyle _navTitleTextStyle;

//  TextStyle get navTitleTextStyle =>
//      _navTitleTextStyle ?? _defaults.navTitleTextStyle;

//  final TextStyle _navLargeTitleTextStyle;
//
//  TextStyle get navLargeTitleTextStyle =>
//      _navLargeTitleTextStyle ?? _defaults.navLargeTitleTextStyle;

//  final TextStyle _navActionTextStyle;
//
//  TextStyle get navActionTextStyle {
//    return _navActionTextStyle ??
//        _defaults.navActionTextStyle(primaryColor: _primaryColor);
//  }

  final TextStyle _pickerTextStyle;

  TextStyle get pickerTextStyle =>
      _pickerTextStyle ?? _defaults.pickerTextStyle;

  final TextStyle _dateTimePickerTextStyle;

  TextStyle get dateTimePickerTextStyle =>
      _dateTimePickerTextStyle ?? _defaults.dateTimePickerTextStyle;

  final TextStyle _subtitleTextStyle;

  TextStyle get subtitleTextStyle =>
      _subtitleTextStyle ?? _defaults.subtitleTextStyle;

  final TextStyle _detailTextStyle;

  TextStyle get detailTextStyle =>
      _detailTextStyle ?? _defaults.detailTextStyle;

  final TextStyle _formFooterTextStyle;

  TextStyle get formFooterTextStyle =>
      _formFooterTextStyle ?? _defaults.formFooterTextStyle;

  TextThemeData resolveFrom(BuildContext context, {bool nullOk = false}) {
    return TextThemeData._raw(
      _defaults?.resolveFrom(context, nullOk),
      DynamicColor.resolve(_primaryColor, context, nullOk: nullOk),

      /// New
      _resolveTextStyle(_largeTitle, context, nullOk),
      _resolveTextStyle(_title1, context, nullOk),
      _resolveTextStyle(_title2, context, nullOk),
      _resolveTextStyle(_title3, context, nullOk),
      _resolveTextStyle(_headline, context, nullOk),
      _resolveTextStyle(_body, context, nullOk),
      _resolveTextStyle(_callout, context, nullOk),
      _resolveTextStyle(_subhead, context, nullOk),
      _resolveTextStyle(_footnote, context, nullOk),
      _resolveTextStyle(_caption1, context, nullOk),
      _resolveTextStyle(_caption2, context, nullOk),

      /// New
      _resolveTextStyle(_textStyle, context, nullOk),
      _resolveTextStyle(_actionTextStyle, context, nullOk),
      _resolveTextStyle(_tabLabelTextStyle, context, nullOk),
      _resolveTextStyle(_navTitleTextStyle, context, nullOk),
//      _resolveTextStyle(_navLargeTitleTextStyle, context, nullOk),
//      _resolveTextStyle(_navActionTextStyle, context, nullOk),
      _resolveTextStyle(_pickerTextStyle, context, nullOk),
      _resolveTextStyle(_dateTimePickerTextStyle, context, nullOk),
      _resolveTextStyle(_subtitleTextStyle, context, nullOk),
      _resolveTextStyle(_detailTextStyle, context, nullOk),
      _resolveTextStyle(_formFooterTextStyle, context, nullOk),
    );
  }

  TextThemeData copyWith({
    Color primaryColor,

    /// New
    TextStyle largeTitle,
    TextStyle title1,
    TextStyle title2,
    TextStyle title3,
    TextStyle headline,
    TextStyle body,
    TextStyle callout,
    TextStyle subhead,
    TextStyle footnote,
    TextStyle caption1,
    TextStyle caption2,

    /// New
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
    return TextThemeData._raw(
      _defaults,
      primaryColor ?? _primaryColor,

      /// New
      largeTitle ?? _largeTitle,
      title1 ?? _title1,
      title2 ?? _title2,
      title3 ?? _title3,
      headline ?? _headline,
      body ?? _body,
      callout ?? _callout,
      subhead ?? _subhead,
      footnote ?? _footnote,
      caption1 ?? _caption1,
      caption2 ?? _caption2,

      /// New
      textStyle ?? _textStyle,
      actionTextStyle ?? _actionTextStyle,
      tabLabelTextStyle ?? _tabLabelTextStyle,
      navTitleTextStyle ?? _navTitleTextStyle,
//      navLargeTitleTextStyle ?? _navLargeTitleTextStyle,
//      navActionTextStyle ?? _navActionTextStyle,
      pickerTextStyle ?? _pickerTextStyle,
      dateTimePickerTextStyle ?? _dateTimePickerTextStyle,
      subtitleTextStyle ?? _subtitleTextStyle,
      detailTextStyle ?? _detailTextStyle,
      formFooterTextStyle ?? _formFooterTextStyle,
    );
  }
}

@immutable
class _TextThemeDefaultsBuilder {
  const _TextThemeDefaultsBuilder(
    this.labelColor,
    this.secondaryLabelColor,
    this.inactiveGrayColor,
    this.detailGray,
  )   : assert(labelColor != null),
        assert(inactiveGrayColor != null),
        assert(detailGray != null);

  final Color labelColor;
  final Color secondaryLabelColor;
  final Color inactiveGrayColor;
  final Color detailGray;

  static TextStyle _applyLabelColor(TextStyle original, Color color) {
    return original?.color == color
        ? original
        : original?.copyWith(color: color);
  }

  TextStyle get largeTitle =>
      _applyLabelColor(_kDefaultLargeTitleTextStyle, labelColor);

  TextStyle get title1 =>
      _applyLabelColor(_kDefaultTitle1TextStyle, labelColor);

  TextStyle get title2 =>
      _applyLabelColor(_kDefaultTitle2TextStyle, labelColor);

  TextStyle get title3 =>
      _applyLabelColor(_kDefaultTitle3TextStyle, labelColor);

  TextStyle get headline =>
      _applyLabelColor(_kDefaultHeadlineTextStyle, labelColor);

  TextStyle get body => _applyLabelColor(_kDefaultBodyTextStyle, labelColor);

  TextStyle get callout =>
      _applyLabelColor(_kDefaultCalloutTextStyle, labelColor);

  TextStyle get subhead =>
      _applyLabelColor(_kDefaultSubheadTextStyle, labelColor);

  TextStyle get footnote =>
      _applyLabelColor(_kDefaultFootnoteTextStyle, secondaryLabelColor);

  TextStyle get caption1 =>
      _applyLabelColor(_kDefaultCaption1TextStyle, labelColor);

  TextStyle get caption2 =>
      _applyLabelColor(_kDefaultCaption2TextStyle, labelColor);

  TextStyle get textStyle => _applyLabelColor(_kDefaultTextStyle, labelColor);

  TextStyle get tabLabelTextStyle =>
      _applyLabelColor(_kDefaultTabLabelTextStyle, inactiveGrayColor);

//  TextStyle get navTitleTextStyle =>
//      _applyLabelColor(_kDefaultBodyTextStyle, labelColor);

  TextStyle get navLargeTitleTextStyle =>
      _applyLabelColor(_kDefaultLargeTitleTextStyle, labelColor);

  TextStyle get pickerTextStyle =>
      _applyLabelColor(_kDefaultPickerTextStyle, labelColor);

  TextStyle get dateTimePickerTextStyle =>
      _applyLabelColor(_kDefaultDateTimePickerTextStyle, labelColor);

  TextStyle get subtitleTextStyle =>
      _applyLabelColor(_kDefaultSubtitleTextStyle, inactiveGrayColor);

  TextStyle get detailTextStyle =>
      _applyLabelColor(_kDefaultDetailTextStyle, detailGray);

  TextStyle get formFooterTextStyle =>
      _applyLabelColor(_kDefaultFormFooterTextStyle, inactiveGrayColor);

  TextStyle actionTextStyle({Color primaryColor}) =>
      _kDefaultBodyTextStyle.copyWith(color: primaryColor);

//  TextStyle navActionTextStyle({Color primaryColor}) =>
//      actionTextStyle(primaryColor: primaryColor);

  _TextThemeDefaultsBuilder resolveFrom(BuildContext context, bool nullOk) {
    final Color resolvedLabelColor =
        DynamicColor.resolve(labelColor, context, nullOk: nullOk);
    final Color resolvedSecondaryLabelColor =
    DynamicColor.resolve(secondaryLabelColor, context, nullOk: nullOk);
    final Color resolvedInactiveGray =
        DynamicColor.resolve(inactiveGrayColor, context, nullOk: nullOk);
    final Color resolvedDetailGray =
        DynamicColor.resolve(detailGray, context, nullOk: nullOk);
    return resolvedLabelColor == labelColor &&
            resolvedInactiveGray == Colors.inactiveGray &&
            resolvedDetailGray == Colors.detailGray
        ? this
        : _TextThemeDefaultsBuilder(
            resolvedLabelColor,
            resolvedSecondaryLabelColor,
            resolvedInactiveGray,
            resolvedDetailGray,
          );
  }
}
