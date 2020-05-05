part of 'cell.dart';

const Color _kDanger = Color(0xFFFD5739);

const _spaceSpan = TextSpan(
  text: " • ",
  style: TextStyle(
    fontSize: 10.0,
    inherit: false,
  ),
);

const TextStyle _kErrorStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: _kDanger,
);