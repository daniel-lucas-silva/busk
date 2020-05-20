import 'dart:ui' show Color, Brightness;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../scaffold/interface_level.dart';
import 'theme.dart';

class Colors {
  Colors._();

  static const DynamicColor activeBlue = systemBlue;
  static const DynamicColor activeGreen = systemGreen;
  static const DynamicColor activeOrange = systemOrange;

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color lightBackgroundGray = Color(0xFFE5E5EA);
  static const Color extraLightBackgroundGray = Color(0xFFEFEFF4);
  static const Color darkBackgroundGray = Color(0xFF171717);

  static const DynamicColor inactiveGray =
      DynamicColor.withBrightness(
    debugLabel: 'inactiveGray',
    color: Color(0xFF999999),
    darkColor: Color(0xFF757575),
  );

  static const DynamicColor detailGray =
      DynamicColor.withBrightness(
    debugLabel: 'detailGray',
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  static const DynamicColor infoBlue =
      DynamicColor.withBrightness(
    debugLabel: 'infoBlue',
    color: Color(0xFF007AFF),
    darkColor: Color(0xFF0A84FF),
  );

  static const DynamicColor divider = DynamicColor.withBrightness(
    debugLabel: 'divider',
    color: Color(0xFFC6C6C8),
//  darkColor: Color(0xFFFF9900),
    darkColor: Color(0xFF38383A),
//  darkColor: Color.fromRGBO(84, 84, 88, 0.65),
  );

  static const DynamicColor disclosure =
  DynamicColor.withBrightness(
    debugLabel: 'disclosure',
    color: Color.fromRGBO(60, 60, 67, 0.30),
    darkColor: Color.fromRGBO(235, 235, 245, 0.30),
  );

  static const DynamicColor cellBackground =
      DynamicColor.withBrightness(
    debugLabel: 'cellBackground',
    color: Color(0xFFFFFFFF),
    darkColor: Color.fromARGB(255, 26, 26, 28),
  );

  static const DynamicColor errorRed =
      DynamicColor.withBrightness(
    debugLabel: 'errorRed',
    color: Color.fromARGB(255, 255, 59, 48),
    darkColor: Color.fromARGB(255, 255, 85, 73),
  );

  static const DynamicColor searchBackground =
      DynamicColor.withBrightness(
    debugLabel: 'searchBackground',
    color: Color.fromRGBO(224, 224, 226, 0.73),
    darkColor: Color.fromARGB(255, 44, 44, 46),
  );

  static const DynamicColor textfieldBackground =
      DynamicColor.withBrightness(
    debugLabel: 'textfieldBackground',
    color: Color.fromRGBO(255, 255, 255, 1),
    darkColor: Color.fromARGB(255, 36, 36, 36),
  );

  static const Color destructiveRed = systemRed;

  static const DynamicColor systemBlue =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemBlue',
    color: Color.fromARGB(255, 0, 122, 255),
    darkColor: Color.fromARGB(255, 10, 132, 255),
    highContrastColor: Color.fromARGB(255, 0, 64, 221),
    darkHighContrastColor: Color.fromARGB(255, 64, 156, 255),
  );

  static const DynamicColor systemGreen =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGreen',
    color: Color.fromARGB(255, 52, 199, 89),
    darkColor: Color.fromARGB(255, 48, 209, 88),
    highContrastColor: Color.fromARGB(255, 36, 138, 61),
    darkHighContrastColor: Color.fromARGB(255, 48, 219, 91),
  );

  static const DynamicColor systemIndigo =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemIndigo',
    color: Color.fromARGB(255, 88, 86, 214),
    darkColor: Color.fromARGB(255, 94, 92, 230),
    highContrastColor: Color.fromARGB(255, 54, 52, 163),
    darkHighContrastColor: Color.fromARGB(255, 125, 122, 255),
  );

  static const DynamicColor systemOrange =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemOrange',
    color: Color.fromARGB(255, 255, 149, 0),
    darkColor: Color.fromARGB(255, 255, 159, 10),
    highContrastColor: Color.fromARGB(255, 201, 52, 0),
    darkHighContrastColor: Color.fromARGB(255, 255, 179, 64),
  );

  static const DynamicColor systemPink =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemPink',
    color: Color.fromARGB(255, 255, 45, 85),
    darkColor: Color.fromARGB(255, 255, 55, 95),
    highContrastColor: Color.fromARGB(255, 211, 15, 69),
    darkHighContrastColor: Color.fromARGB(255, 255, 100, 130),
  );

  static const DynamicColor systemPurple =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemPurple',
    color: Color.fromARGB(255, 175, 82, 222),
    darkColor: Color.fromARGB(255, 191, 90, 242),
    highContrastColor: Color.fromARGB(255, 137, 68, 171),
    darkHighContrastColor: Color.fromARGB(255, 218, 143, 255),
  );

  static const DynamicColor systemRed =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemRed',
    color: Color.fromARGB(255, 255, 59, 48),
    darkColor: Color.fromARGB(255, 255, 69, 58),
    highContrastColor: Color.fromARGB(255, 215, 0, 21),
    darkHighContrastColor: Color.fromARGB(255, 255, 105, 97),
  );

  static const DynamicColor systemTeal =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemTeal',
    color: Color.fromARGB(255, 90, 200, 250),
    darkColor: Color.fromARGB(255, 100, 210, 255),
    highContrastColor: Color.fromARGB(255, 0, 113, 164),
    darkHighContrastColor: Color.fromARGB(255, 112, 215, 255),
  );

  static const DynamicColor systemYellow =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemYellow',
    color: Color.fromARGB(255, 255, 204, 0),
    darkColor: Color.fromARGB(255, 255, 214, 10),
    highContrastColor: Color.fromARGB(255, 160, 90, 0),
    darkHighContrastColor: Color.fromARGB(255, 255, 212, 38),
  );

  static const DynamicColor systemGrey =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey',
    color: Color.fromARGB(255, 142, 142, 147),
    darkColor: Color.fromARGB(255, 142, 142, 147),
    highContrastColor: Color.fromARGB(255, 108, 108, 112),
    darkHighContrastColor: Color.fromARGB(255, 174, 174, 178),
  );

  static const DynamicColor systemGrey2 =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey2',
    color: Color.fromARGB(255, 174, 174, 178),
    darkColor: Color.fromARGB(255, 99, 99, 102),
    highContrastColor: Color.fromARGB(255, 142, 142, 147),
    darkHighContrastColor: Color.fromARGB(255, 124, 124, 128),
  );

  static const DynamicColor systemGrey3 =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey3',
    color: Color.fromARGB(255, 199, 199, 204),
    darkColor: Color.fromARGB(255, 72, 72, 74),
    highContrastColor: Color.fromARGB(255, 174, 174, 178),
    darkHighContrastColor: Color.fromARGB(255, 84, 84, 86),
  );

  static const DynamicColor systemGrey4 =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey4',
    color: Color.fromARGB(255, 209, 209, 214),
    darkColor: Color.fromARGB(255, 58, 58, 60),
    highContrastColor: Color.fromARGB(255, 188, 188, 192),
    darkHighContrastColor: Color.fromARGB(255, 68, 68, 70),
  );

  static const DynamicColor systemGrey5 =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey5',
    color: Color.fromARGB(255, 229, 229, 234),
    darkColor: Color.fromARGB(255, 44, 44, 46),
    highContrastColor: Color.fromARGB(255, 216, 216, 220),
    darkHighContrastColor: Color.fromARGB(255, 54, 54, 56),
  );

  static const DynamicColor systemGrey6 =
      DynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemGrey6',
    color: Color.fromARGB(255, 242, 242, 247),
    darkColor: Color.fromARGB(255, 28, 28, 30),
    highContrastColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastColor: Color.fromARGB(255, 36, 36, 38),
  );

  static const DynamicColor label = DynamicColor(
    debugLabel: 'label',
    color: Color.fromARGB(255, 0, 0, 0),
    darkColor: Color.fromARGB(255, 255, 255, 255),
    highContrastColor: Color.fromARGB(255, 0, 0, 0),
    darkHighContrastColor: Color.fromARGB(255, 255, 255, 255),
    elevatedColor: Color.fromARGB(255, 0, 0, 0),
    darkElevatedColor: Color.fromARGB(255, 255, 255, 255),
    highContrastElevatedColor: Color.fromARGB(255, 0, 0, 0),
    darkHighContrastElevatedColor: Color.fromARGB(255, 255, 255, 255),
  );

  static const DynamicColor secondaryLabel = DynamicColor(
    debugLabel: 'secondaryLabel',
    color: Color.fromRGBO(60, 60, 67, 0.60),
    darkColor: Color.fromARGB(153, 235, 235, 245),
    highContrastColor: Color.fromARGB(173, 60, 60, 67),
    darkHighContrastColor: Color.fromARGB(173, 235, 235, 245),
    elevatedColor: Color.fromARGB(153, 60, 60, 67),
    darkElevatedColor: Color.fromARGB(153, 235, 235, 245),
    highContrastElevatedColor: Color.fromARGB(173, 60, 60, 67),
    darkHighContrastElevatedColor: Color.fromARGB(173, 235, 235, 245),
  );

  static const DynamicColor tertiaryLabel = DynamicColor(
    debugLabel: 'tertiaryLabel',
    color: Color.fromARGB(76, 60, 60, 67),
    darkColor: Color.fromARGB(76, 235, 235, 245),
    highContrastColor: Color.fromARGB(96, 60, 60, 67),
    darkHighContrastColor: Color.fromARGB(96, 235, 235, 245),
    elevatedColor: Color.fromARGB(76, 60, 60, 67),
    darkElevatedColor: Color.fromARGB(76, 235, 235, 245),
    highContrastElevatedColor: Color.fromARGB(96, 60, 60, 67),
    darkHighContrastElevatedColor: Color.fromARGB(96, 235, 235, 245),
  );

  static const DynamicColor quaternaryLabel = DynamicColor(
    debugLabel: 'quaternaryLabel',
    color: Color.fromARGB(45, 60, 60, 67),
    darkColor: Color.fromARGB(40, 235, 235, 245),
    highContrastColor: Color.fromARGB(66, 60, 60, 67),
    darkHighContrastColor: Color.fromARGB(61, 235, 235, 245),
    elevatedColor: Color.fromARGB(45, 60, 60, 67),
    darkElevatedColor: Color.fromARGB(40, 235, 235, 245),
    highContrastElevatedColor: Color.fromARGB(66, 60, 60, 67),
    darkHighContrastElevatedColor: Color.fromARGB(61, 235, 235, 245),
  );

  static const DynamicColor systemFill = DynamicColor(
    debugLabel: 'systemFill',
    color: Color.fromARGB(51, 120, 120, 128),
    darkColor: Color.fromARGB(91, 120, 120, 128),
    highContrastColor: Color.fromARGB(71, 120, 120, 128),
    darkHighContrastColor: Color.fromARGB(112, 120, 120, 128),
    elevatedColor: Color.fromARGB(51, 120, 120, 128),
    darkElevatedColor: Color.fromARGB(91, 120, 120, 128),
    highContrastElevatedColor: Color.fromARGB(71, 120, 120, 128),
    darkHighContrastElevatedColor: Color.fromARGB(112, 120, 120, 128),
  );

  static const DynamicColor secondarySystemFill =
      DynamicColor(
    debugLabel: 'secondarySystemFill',
    color: Color.fromARGB(40, 120, 120, 128),
    darkColor: Color.fromARGB(81, 120, 120, 128),
    highContrastColor: Color.fromARGB(61, 120, 120, 128),
    darkHighContrastColor: Color.fromARGB(102, 120, 120, 128),
    elevatedColor: Color.fromARGB(40, 120, 120, 128),
    darkElevatedColor: Color.fromARGB(81, 120, 120, 128),
    highContrastElevatedColor: Color.fromARGB(61, 120, 120, 128),
    darkHighContrastElevatedColor: Color.fromARGB(102, 120, 120, 128),
  );

  static const DynamicColor tertiarySystemFill = DynamicColor(
    debugLabel: 'tertiarySystemFill',
    color: Color.fromARGB(30, 118, 118, 128),
    darkColor: Color.fromARGB(61, 118, 118, 128),
    highContrastColor: Color.fromARGB(51, 118, 118, 128),
    darkHighContrastColor: Color.fromARGB(81, 118, 118, 128),
    elevatedColor: Color.fromARGB(30, 118, 118, 128),
    darkElevatedColor: Color.fromARGB(61, 118, 118, 128),
    highContrastElevatedColor: Color.fromARGB(51, 118, 118, 128),
    darkHighContrastElevatedColor: Color.fromARGB(81, 118, 118, 128),
  );

  static const DynamicColor quaternarySystemFill =
      DynamicColor(
    debugLabel: 'quaternarySystemFill',
    color: Color.fromARGB(20, 116, 116, 128),
    darkColor: Color.fromARGB(45, 118, 118, 128),
    highContrastColor: Color.fromARGB(40, 116, 116, 128),
    darkHighContrastColor: Color.fromARGB(66, 118, 118, 128),
    elevatedColor: Color.fromARGB(20, 116, 116, 128),
    darkElevatedColor: Color.fromARGB(45, 118, 118, 128),
    highContrastElevatedColor: Color.fromARGB(40, 116, 116, 128),
    darkHighContrastElevatedColor: Color.fromARGB(66, 118, 118, 128),
  );

  static const DynamicColor placeholderText = DynamicColor(
    debugLabel: 'placeholderText',
    color: Color.fromARGB(76, 60, 60, 67),
    darkColor: Color.fromARGB(76, 235, 235, 245),
    highContrastColor: Color.fromARGB(96, 60, 60, 67),
    darkHighContrastColor: Color.fromARGB(96, 235, 235, 245),
    elevatedColor: Color.fromARGB(76, 60, 60, 67),
    darkElevatedColor: Color.fromARGB(76, 235, 235, 245),
    highContrastElevatedColor: Color.fromARGB(96, 60, 60, 67),
    darkHighContrastElevatedColor: Color.fromARGB(96, 235, 235, 245),
  );

  static const DynamicColor systemBackground = DynamicColor(
    debugLabel: 'systemBackground',
    color: Color.fromARGB(255, 255, 255, 255),
    darkColor: Color.fromARGB(255, 0, 0, 0),
    highContrastColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastColor: Color.fromARGB(255, 0, 0, 0),
    elevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkElevatedColor: Color.fromARGB(255, 28, 28, 30),
    highContrastElevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastElevatedColor: Color.fromARGB(255, 36, 36, 38),
  );

  static const DynamicColor secondarySystemBackground =
      DynamicColor(
    debugLabel: 'secondarySystemBackground',
    color: Color.fromARGB(255, 242, 242, 247),
    darkColor: Color.fromARGB(255, 28, 28, 30),
    highContrastColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastColor: Color.fromARGB(255, 36, 36, 38),
    elevatedColor: Color.fromARGB(255, 242, 242, 247),
    darkElevatedColor: Color.fromARGB(255, 44, 44, 46),
    highContrastElevatedColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastElevatedColor: Color.fromARGB(255, 54, 54, 56),
  );

  static const DynamicColor tertiarySystemBackground =
      DynamicColor(
    debugLabel: 'tertiarySystemBackground',
    color: Color.fromARGB(255, 255, 255, 255),
    darkColor: Color.fromARGB(255, 44, 44, 46),
    highContrastColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastColor: Color.fromARGB(255, 54, 54, 56),
    elevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkElevatedColor: Color.fromARGB(255, 58, 58, 60),
    highContrastElevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastElevatedColor: Color.fromARGB(255, 68, 68, 70),
  );

  static const DynamicColor systemGroupedBackground =
      DynamicColor(
    debugLabel: 'systemGroupedBackground',
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF000000),
    highContrastColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastColor: Color.fromARGB(255, 0, 0, 0),
    elevatedColor: Color.fromARGB(255, 242, 242, 247),
    darkElevatedColor: Color.fromARGB(255, 28, 28, 30),
    highContrastElevatedColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastElevatedColor: Color.fromARGB(255, 36, 36, 38),
  );

  static const DynamicColor secondarySystemGroupedBackground =
      DynamicColor(
    debugLabel: 'secondarySystemGroupedBackground',
    color: Color.fromARGB(255, 255, 255, 255),
    darkColor: Color.fromARGB(255, 28, 28, 30),
    highContrastColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastColor: Color.fromARGB(255, 36, 36, 38),
    elevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkElevatedColor: Color.fromARGB(255, 44, 44, 46),
    highContrastElevatedColor: Color.fromARGB(255, 255, 255, 255),
    darkHighContrastElevatedColor: Color.fromARGB(255, 54, 54, 56),
  );

  static const DynamicColor tertiarySystemGroupedBackground =
      DynamicColor(
    debugLabel: 'tertiarySystemGroupedBackground',
    color: Color.fromARGB(255, 242, 242, 247),
    darkColor: Color.fromARGB(255, 44, 44, 46),
    highContrastColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastColor: Color.fromARGB(255, 54, 54, 56),
    elevatedColor: Color.fromARGB(255, 242, 242, 247),
    darkElevatedColor: Color.fromARGB(255, 58, 58, 60),
    highContrastElevatedColor: Color.fromARGB(255, 235, 235, 240),
    darkHighContrastElevatedColor: Color.fromARGB(255, 68, 68, 70),
  );

  static const DynamicColor separator = DynamicColor(
    debugLabel: 'separator',
    color: Color.fromRGBO(60, 60, 67, 0.15),
    darkColor: Color.fromARGB(153, 84, 84, 88),
    highContrastColor: Color.fromARGB(94, 60, 60, 67),
    darkHighContrastColor: Color.fromARGB(173, 84, 84, 88),
    elevatedColor: Color.fromARGB(73, 60, 60, 67),
    darkElevatedColor: Color.fromARGB(153, 84, 84, 88),
    highContrastElevatedColor: Color.fromARGB(94, 60, 60, 67),
    darkHighContrastElevatedColor: Color.fromARGB(173, 84, 84, 88),
  );

  static const DynamicColor opaqueSeparator = DynamicColor(
    debugLabel: 'opaqueSeparator',
    color: Color.fromARGB(255, 198, 198, 200),
    darkColor: Color.fromARGB(255, 56, 56, 58),
    highContrastColor: Color.fromARGB(255, 198, 198, 200),
    darkHighContrastColor: Color.fromARGB(255, 56, 56, 58),
    elevatedColor: Color.fromARGB(255, 198, 198, 200),
    darkElevatedColor: Color.fromARGB(255, 56, 56, 58),
    highContrastElevatedColor: Color.fromARGB(255, 198, 198, 200),
    darkHighContrastElevatedColor: Color.fromARGB(255, 56, 56, 58),
  );

  static const DynamicColor link = DynamicColor(
    debugLabel: 'link',
    color: Color.fromARGB(255, 0, 122, 255),
    darkColor: Color.fromARGB(255, 9, 132, 255),
    highContrastColor: Color.fromARGB(255, 0, 122, 255),
    darkHighContrastColor: Color.fromARGB(255, 9, 132, 255),
    elevatedColor: Color.fromARGB(255, 0, 122, 255),
    darkElevatedColor: Color.fromARGB(255, 9, 132, 255),
    highContrastElevatedColor: Color.fromARGB(255, 0, 122, 255),
    darkHighContrastElevatedColor: Color.fromARGB(255, 9, 132, 255),
  );
}

@immutable
class DynamicColor extends Color
    with DiagnosticableMixin
    implements Diagnosticable {
  const DynamicColor({
    String debugLabel,
    @required Color color,
    @required Color darkColor,
    @required Color highContrastColor,
    @required Color darkHighContrastColor,
    @required Color elevatedColor,
    @required Color darkElevatedColor,
    @required Color highContrastElevatedColor,
    @required Color darkHighContrastElevatedColor,
  }) : this._(
          color,
          color,
          darkColor,
          highContrastColor,
          darkHighContrastColor,
          elevatedColor,
          darkElevatedColor,
          highContrastElevatedColor,
          darkHighContrastElevatedColor,
          null,
          debugLabel,
        );

  const DynamicColor.withBrightnessAndContrast({
    String debugLabel,
    @required Color color,
    @required Color darkColor,
    @required Color highContrastColor,
    @required Color darkHighContrastColor,
  }) : this(
          debugLabel: debugLabel,
          color: color,
          darkColor: darkColor,
          highContrastColor: highContrastColor,
          darkHighContrastColor: darkHighContrastColor,
          elevatedColor: color,
          darkElevatedColor: darkColor,
          highContrastElevatedColor: highContrastColor,
          darkHighContrastElevatedColor: darkHighContrastColor,
        );

  const DynamicColor.withBrightness({
    String debugLabel,
    @required Color color,
    @required Color darkColor,
  }) : this(
          debugLabel: debugLabel,
          color: color,
          darkColor: darkColor,
          highContrastColor: color,
          darkHighContrastColor: darkColor,
          elevatedColor: color,
          darkElevatedColor: darkColor,
          highContrastElevatedColor: color,
          darkHighContrastElevatedColor: darkColor,
        );

  const DynamicColor._(
    this._effectiveColor,
    this.color,
    this.darkColor,
    this.highContrastColor,
    this.darkHighContrastColor,
    this.elevatedColor,
    this.darkElevatedColor,
    this.highContrastElevatedColor,
    this.darkHighContrastElevatedColor,
    this._debugResolveContext,
    this._debugLabel,
  )   : assert(color != null),
        assert(darkColor != null),
        assert(highContrastColor != null),
        assert(darkHighContrastColor != null),
        assert(elevatedColor != null),
        assert(darkElevatedColor != null),
        assert(highContrastElevatedColor != null),
        assert(darkHighContrastElevatedColor != null),
        assert(_effectiveColor != null),
        super(0);

  final Color _effectiveColor;

  @override
  int get value => _effectiveColor.value;

  final String _debugLabel;

  final Element _debugResolveContext;

  final Color color;

  final Color darkColor;

  final Color highContrastColor;

  final Color darkHighContrastColor;

  final Color elevatedColor;

  final Color darkElevatedColor;

  final Color highContrastElevatedColor;

  final Color darkHighContrastElevatedColor;

  static Color resolve(Color resolvable, BuildContext context,
      {bool nullOk = true}) {
    if (resolvable == null) return null;
    assert(context != null);
    return (resolvable is DynamicColor)
        ? resolvable.resolveFrom(context, nullOk: nullOk)
        : resolvable;
  }

  bool get _isPlatformBrightnessDependent {
    return color != darkColor ||
        elevatedColor != darkElevatedColor ||
        highContrastColor != darkHighContrastColor ||
        highContrastElevatedColor != darkHighContrastElevatedColor;
  }

  bool get _isHighContrastDependent {
    return color != highContrastColor ||
        darkColor != darkHighContrastColor ||
        elevatedColor != highContrastElevatedColor ||
        darkElevatedColor != darkHighContrastElevatedColor;
  }

  bool get _isInterfaceElevationDependent {
    return color != elevatedColor ||
        darkColor != darkElevatedColor ||
        highContrastColor != highContrastElevatedColor ||
        darkHighContrastColor != darkHighContrastElevatedColor;
  }

  DynamicColor resolveFrom(BuildContext context,
      {bool nullOk = true}) {
    final Brightness brightness = _isPlatformBrightnessDependent
        ? CupertinoTheme.brightnessOf(context, nullOk: nullOk) ??
            Brightness.light
        : Brightness.light;

    final bool isHighContrastEnabled = _isHighContrastDependent &&
        (MediaQuery.of(context, nullOk: nullOk)?.highContrast ?? false);

    final CupertinoUserInterfaceLevelData level = _isInterfaceElevationDependent
        ? CupertinoUserInterfaceLevel.of(context, nullOk: nullOk) ??
            CupertinoUserInterfaceLevelData.base
        : CupertinoUserInterfaceLevelData.base;

    Color resolved;
    switch (brightness) {
      case Brightness.light:
        switch (level) {
          case CupertinoUserInterfaceLevelData.base:
            resolved = isHighContrastEnabled ? highContrastColor : color;
            break;
          case CupertinoUserInterfaceLevelData.elevated:
            resolved = isHighContrastEnabled
                ? highContrastElevatedColor
                : elevatedColor;
            break;
        }
        break;
      case Brightness.dark:
        switch (level) {
          case CupertinoUserInterfaceLevelData.base:
            resolved =
                isHighContrastEnabled ? darkHighContrastColor : darkColor;
            break;
          case CupertinoUserInterfaceLevelData.elevated:
            resolved = isHighContrastEnabled
                ? darkHighContrastElevatedColor
                : darkElevatedColor;
            break;
        }
    }

    Element _debugContext;
    assert(() {
      _debugContext = context;
      return true;
    }());
    return DynamicColor._(
      resolved,
      color,
      darkColor,
      highContrastColor,
      darkHighContrastColor,
      elevatedColor,
      darkElevatedColor,
      highContrastElevatedColor,
      darkHighContrastElevatedColor,
      _debugContext,
      _debugLabel,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;

    return other.runtimeType == runtimeType &&
        value == other.value &&
        color == other.color &&
        darkColor == other.darkColor &&
        highContrastColor == other.highContrastColor &&
        darkHighContrastColor == other.darkHighContrastColor &&
        elevatedColor == other.elevatedColor &&
        darkElevatedColor == other.darkElevatedColor &&
        highContrastElevatedColor == other.highContrastElevatedColor &&
        darkHighContrastElevatedColor == other.darkHighContrastElevatedColor;
  }

  @override
  int get hashCode {
    return hashValues(
      value,
      color,
      darkColor,
      highContrastColor,
      elevatedColor,
      darkElevatedColor,
      darkHighContrastColor,
      darkHighContrastElevatedColor,
      highContrastElevatedColor,
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    String toString(String name, Color color) {
      final String marker = color == _effectiveColor ? '*' : '';
      return '$marker$name = $color$marker';
    }

    final List<String> xs = <String>[
      toString('color', color),
      if (_isPlatformBrightnessDependent) toString('darkColor', darkColor),
      if (_isHighContrastDependent)
        toString('highContrastColor', highContrastColor),
      if (_isPlatformBrightnessDependent && _isHighContrastDependent)
        toString('darkHighContrastColor', darkHighContrastColor),
      if (_isInterfaceElevationDependent)
        toString('elevatedColor', elevatedColor),
      if (_isPlatformBrightnessDependent && _isInterfaceElevationDependent)
        toString('darkElevatedColor', darkElevatedColor),
      if (_isHighContrastDependent && _isInterfaceElevationDependent)
        toString('highContrastElevatedColor', highContrastElevatedColor),
      if (_isPlatformBrightnessDependent &&
          _isHighContrastDependent &&
          _isInterfaceElevationDependent)
        toString(
            'darkHighContrastElevatedColor', darkHighContrastElevatedColor),
    ];

    return '${_debugLabel ?? runtimeType.toString()}(${xs.join(', ')}, resolved by: ${_debugResolveContext?.widget ?? "UNRESOLVED"})';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_debugLabel != null)
      properties.add(MessageProperty('debugLabel', _debugLabel));
    properties.add(createCupertinoColorProperty('color', color));
    if (_isPlatformBrightnessDependent)
      properties.add(createCupertinoColorProperty('darkColor', darkColor));
    if (_isHighContrastDependent)
      properties.add(
          createCupertinoColorProperty('highContrastColor', highContrastColor));
    if (_isPlatformBrightnessDependent && _isHighContrastDependent)
      properties.add(createCupertinoColorProperty(
          'darkHighContrastColor', darkHighContrastColor));
    if (_isInterfaceElevationDependent)
      properties
          .add(createCupertinoColorProperty('elevatedColor', elevatedColor));
    if (_isPlatformBrightnessDependent && _isInterfaceElevationDependent)
      properties.add(
          createCupertinoColorProperty('darkElevatedColor', darkElevatedColor));
    if (_isHighContrastDependent && _isInterfaceElevationDependent)
      properties.add(createCupertinoColorProperty(
          'highContrastElevatedColor', highContrastElevatedColor));
    if (_isPlatformBrightnessDependent &&
        _isHighContrastDependent &&
        _isInterfaceElevationDependent)
      properties.add(createCupertinoColorProperty(
          'darkHighContrastElevatedColor', darkHighContrastElevatedColor));

    if (_debugResolveContext != null)
      properties.add(
          DiagnosticsProperty<Element>('last resolved', _debugResolveContext));
  }
}

DiagnosticsProperty<Color> createCupertinoColorProperty(
  String name,
  Color value, {
  bool showName = true,
  Object defaultValue = kNoDefaultValue,
  DiagnosticsTreeStyle style = DiagnosticsTreeStyle.shallow,
  DiagnosticLevel level = DiagnosticLevel.info,
}) {
  if (value is DynamicColor) {
    return DiagnosticsProperty<DynamicColor>(
      name,
      value,
      description: value._debugLabel,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  } else {
    return ColorProperty(
      name,
      value,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  }
}
