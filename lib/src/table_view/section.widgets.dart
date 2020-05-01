part of 'section.dart';

const Color _kDividerColor = Color.fromARGB(255, 50, 50, 54);

const TextStyle _kSectionTextStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 13.0,
  letterSpacing: -0.08,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
  color: Color.fromRGBO(235, 235, 245, 0.6),
  height: 1,
);

const TextStyle _kErrorStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 12.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: _kDanger,
);

const Color _kDanger = Color(0xFFFD5739);

class TestSectionHeader extends StatelessWidget {
  final String child;
  final Widget after;
  final double height;

  const TestSectionHeader(
    this.child, {
    Key key,
    this.after,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasContent = child != null || after != null;

    return RepaintBoundary(
      child: DefaultTextStyle(
        style: _kSectionTextStyle,
        child: _Widget(
          child: child?.toUpperCase()?.toText(),
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: height ?? (hasContent ? 18.0 : 0.0),
            bottom: hasContent ? 9.0 : 0.0,
          ),
          position: _Position.top,
          after: after,
        ),
      ),
    );
  }
}

class TestSectionDescription extends StatelessWidget {
  final String child;
  final Widget after;
  final double height;
  final bool isError;

  const TestSectionDescription(
      this.child, {
        Key key,
        this.after,
        this.height,
        this.isError: false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasContent = child != null || after != null;

    return RepaintBoundary(
      child: DefaultTextStyle(
        style: _kSectionTextStyle,
        child: _Widget(
          child: child.toText(null, isError ? _kErrorStyle : null),
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: hasContent ? 11.0 : 0.0,
            bottom: height ?? (hasContent ? 6.0 : 0.0),
          ),
          position: _Position.bottom,
          after: after,
        ),
      ),
    );

    return SizedBox(
      height: 36,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned.fill(
            child: Text("Teste de description"),
          ),
          Positioned(
            top: -1,
            right: 0,
            left: 0,
            height: 1,
            child: Container(
              color: _kDividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
