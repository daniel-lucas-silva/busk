import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';
import 'app_bar.dart';
import 'tab_bar.dart';

class SliverScaffold extends StatefulWidget {
  const SliverScaffold({
    Key key,
    this.appBar,
    @required this.slivers,
    this.backgroundColor,
    this.navigationBarColor,
    this.resizeToAvoidBottomInset = false,
  })  : assert(slivers != null),
        assert(resizeToAvoidBottomInset != null),
        super(key: key);

  final SliverAppBar appBar;
  final List<Widget> slivers;
  final Color backgroundColor;
  final Color navigationBarColor;
  final bool resizeToAvoidBottomInset;

  @override
  SliverScaffoldState createState() => SliverScaffoldState();
}

class SliverScaffoldState extends State<SliverScaffold> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      navigationBarColor: widget.navigationBarColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      child: FocusScope(
        node: _focusScopeNode,
        child: CustomScrollView(
          slivers: <Widget>[
            if (widget.appBar != null) widget.appBar,
            ...widget.slivers ?? []
          ],
        ),
      ),
    );
  }
}

class TabScaffold extends StatefulWidget {
  final List<TabItem> items;
  final Widget Function(BuildContext context, int index, Widget child) builder;
  final Color backgroundColor;
  final Color navigationBarColor;
  final bool resizeToAvoidBottomInset;

  const TabScaffold({
    Key key,
    @required this.items,
    @required this.builder,
    this.backgroundColor,
    this.navigationBarColor,
    this.resizeToAvoidBottomInset = false,
  })  : assert(items != null && items.length > 1),
        assert(builder != null),
        super(key: key);

  @override
  _TabScaffoldState createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  PageController _controller;
  int _index = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: _index, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      navigationBarColor: widget.navigationBarColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return widget.builder(
                  context,
                  index,
                  widget.items[index].child,
                );
              },
            ),
          ),
          TabBar(
            items: widget.items.map<TabBarItem>((item) {
              return TabBarItem(
                icon: item.icon != null ? Icon(item.icon) : null,
                activeIcon:
                    item.activeIcon != null ? Icon(item.activeIcon) : null,
                title: item.title != null ? Text(item.title) : null,
              );
            }).toList(),
            currentIndex: _index,
            onTap: (index) {
              setState(() {
                _controller.jumpToPage(index);
                _index = index;
              });
            },
//            backgroundColor:,
//            activeColor:,
//            border:,
//            iconSize:,
//            inactiveColor:,
          ),
        ],
      ),
    );
  }
}

class Scaffold extends StatefulWidget {
  const Scaffold({
    Key key,
    this.backgroundColor,
    this.navigationBarColor,
    this.resizeToAvoidBottomInset = false,
    this.bottom,
    @required this.child,
  })  : assert(child != null),
        assert(resizeToAvoidBottomInset != null),
        super(key: key);

  final PreferredSizeWidget bottom;
  final Widget child;
  final Color backgroundColor;
  final Color navigationBarColor;
  final bool resizeToAvoidBottomInset;

  static ScaffoldState of(BuildContext context, {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final ScaffoldState result =
        context.findAncestorStateOfType<ScaffoldState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'Scaffold.of() called with a context that does not contain a Scaffold.'),
      ErrorDescription(
          'No Scaffold ancestor could be found starting from the context that was passed to Scaffold.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the Scaffold widget being sought.'),
      ErrorHint(
          'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
          'context that is "under" the Scaffold. For an example of this, please see the '
          'documentation for Scaffold.of():\n'
          '  https://api.flutter.dev/flutter/material/Scaffold/of.html'),
      ErrorHint(
          'A more efficient solution is to split your build function into several widgets. This '
          'introduces a new context from which you can obtain the Scaffold. In this solution, '
          'you would have an outer widget that creates the Scaffold populated by instances of '
          'your new inner widgets, and then in these inner widgets you would use Scaffold.of().\n'
          'A less elegant but more expedient solution is assign a GlobalKey to the Scaffold, '
          'then use the key.currentState property to obtain the ScaffoldState rather than '
          'using the Scaffold.of() function.'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  ScaffoldState createState() => ScaffoldState();
}

class ScaffoldState extends State<Scaffold> {
  //  final Queue<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> _snackBars = Queue<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>();
//  AnimationController _snackBarController;
//  Timer _snackBarTimer;
//  bool _accessibleNavigation;
//
//  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackbar) {
//    _snackBarController ??= SnackBar.createAnimationController(vsync: this)
//      ..addStatusListener(_handleSnackBarStatusChange);
//    if (_snackBars.isEmpty) {
//      assert(_snackBarController.isDismissed);
//      _snackBarController.forward();
//    }
//    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;
//    controller = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>._(
//      snackbar.withAnimation(_snackBarController, fallbackKey: UniqueKey()),
//      Completer<SnackBarClosedReason>(),
//          () {
//        assert(_snackBars.first == controller);
//        hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
//      },
//      null, // SnackBar doesn't use a builder function so setState() wouldn't rebuild it
//    );
//    setState(() {
//      _snackBars.addLast(controller);
//    });
//    return controller;
//  }
//
//  void _handleSnackBarStatusChange(AnimationStatus status) {
//    switch (status) {
//      case AnimationStatus.dismissed:
//        assert(_snackBars.isNotEmpty);
//        setState(() {
//          _snackBars.removeFirst();
//        });
//        if (_snackBars.isNotEmpty)
//          _snackBarController.forward();
//        break;
//      case AnimationStatus.completed:
//        setState(() {
//          assert(_snackBarTimer == null);
//          // build will create a new timer if necessary to dismiss the snack bar
//        });
//        break;
//      case AnimationStatus.forward:
//      case AnimationStatus.reverse:
//        break;
//    }
//  }
//
//  void removeCurrentSnackBar({ SnackBarClosedReason reason = SnackBarClosedReason.remove }) {
//    assert(reason != null);
//    if (_snackBars.isEmpty)
//      return;
//    final Completer<SnackBarClosedReason> completer = _snackBars.first._completer;
//    if (!completer.isCompleted)
//      completer.complete(reason);
//    _snackBarTimer?.cancel();
//    _snackBarTimer = null;
//    _snackBarController.value = 0.0;
//  }
//
//  void hideCurrentSnackBar({ SnackBarClosedReason reason = SnackBarClosedReason.hide }) {
//    assert(reason != null);
//    if (_snackBars.isEmpty || _snackBarController.status == AnimationStatus.dismissed)
//      return;
//    final MediaQueryData mediaQuery = MediaQuery.of(context);
//    final Completer<SnackBarClosedReason> completer = _snackBars.first._completer;
//    if (mediaQuery.accessibleNavigation) {
//      _snackBarController.value = 0.0;
//      completer.complete(reason);
//    } else {
//      _snackBarController.reverse().then<void>((void value) {
//        assert(mounted);
//        if (!completer.isCompleted)
//          completer.complete(reason);
//      });
//    }
//    _snackBarTimer?.cancel();
//    _snackBarTimer = null;
//  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData existingMediaQuery = MediaQuery.of(context);

    final double bottomPadding = widget.resizeToAvoidBottomInset
        ? existingMediaQuery.viewInsets.bottom
        : 0.0;

    final Color effectiveBackgroundColor =
        DynamicColor.resolve(widget.backgroundColor, context) ??
            CupertinoTheme.of(context).scaffoldBackgroundColor;

    final Color effectiveNavigationBarColor =
        DynamicColor.resolve(widget.navigationBarColor, context) ??
            CupertinoTheme.of(context).barBackgroundColor;

    final bool isDark = effectiveNavigationBarColor.computeLuminance() < 0.179;
    final Brightness brightness = isDark ? Brightness.light : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: effectiveNavigationBarColor,
        systemNavigationBarIconBrightness: brightness,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: effectiveBackgroundColor),
        child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: widget.child,
                ),
                if (widget.bottom != null) widget.bottom,
              ],
            )),
      ),
    );
  }
}
