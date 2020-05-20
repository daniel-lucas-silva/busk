part of 'cell.dart';

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
    final textTheme = CupertinoTheme.of(context).textTheme;

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
              ? textTheme.body
              : textTheme.subhead.copyWith(
                  color: CupertinoTheme.of(context).primaryColor,
                ),
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
