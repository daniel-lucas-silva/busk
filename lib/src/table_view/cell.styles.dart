part of 'cell.dart';

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
  color: CupertinoColors.inactiveGray,
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
  color: CupertinoColors.detailGray,
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