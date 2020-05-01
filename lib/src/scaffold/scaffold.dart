import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';
import 'page_scaffold.dart';

class Scaffold extends StatefulWidget {
  const Scaffold({
    Key key,
    this.navigationBar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = false,
    @required this.child,
  })  : assert(child != null),
        assert(resizeToAvoidBottomInset != null),
        super(key: key);

  final ObstructingPreferredSizeWidget navigationBar;
  final PreferredSizeWidget bottomNavigationBar;
  final Widget child;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;

  @override
  _ScaffoldState createState() => _ScaffoldState();
}

class _ScaffoldState extends State<Scaffold> {
  final ScrollController _primaryScrollController = ScrollController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  DragGestureRecognizer _recognizer;

  @override
  void initState() {
    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
    super.initState();
  }

  void _handleDragStart(DragStartDetails details) {
    print("_handleDragStart");
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    print("_handleDragUpdate ${details.primaryDelta / context.size.height}");
  }

  void _handleDragEnd(DragEndDetails details) {
    print(
        "_handleDragEnd ${details.velocity.pixelsPerSecond.dy / context.size.height}");
  }

  void _handleDragCancel() {
//    print("_handleDragCancel");
  }

  void _handlePointerDown(PointerDownEvent event) {
    _recognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    Widget paddedContent = widget.child;

    final MediaQueryData existingMediaQuery = MediaQuery.of(context);

    final double bottomPadding = widget.resizeToAvoidBottomInset
        ? existingMediaQuery.viewInsets.bottom
        : 0.0;
    paddedContent = Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: paddedContent,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(widget.backgroundColor, context) ??
            CupertinoTheme.of(context).scaffoldBackgroundColor,
      ),
      child: FocusScope(
        node: _focusScopeNode,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
//            print(scrollNotification.metrics.pixels);
//            print(scrollNotification.metrics.extentInside);
//            print(scrollNotification.metrics.viewportDimension);
//            if(scrollNotification.metrics.extentInside >= scrollNotification.metrics.viewportDimension) {
//              if(_focusScopeNode.hasFocus) {
//                _focusScopeNode.unfocus();
//              }
//            }
            return;
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Listener(
                        behavior: HitTestBehavior.translucent,
                        onPointerDown: _handlePointerDown,
                      ),
                      widget.child,
                    ],
                  ),
                ),
                if (widget.bottomNavigationBar != null)
                  widget.bottomNavigationBar,
              ],
            ),
          ),
        ),
      ),
    );
  }
}