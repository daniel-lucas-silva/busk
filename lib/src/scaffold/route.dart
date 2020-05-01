import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble, ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show MaterialPageRoute;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart' show Curves;

import '../theme/colors.dart';
import '../constants.dart';
//import 'hero_provider.dart';
import 'interface_level.dart';

const double _kBackGestureWidth = 20.0;
const double _kMinFlingVelocity = 1.0;
const int _kMaxDroppedSwipePageForwardAnimationTime = 800;
const int _kMaxPageBackAnimationTime = 300;

const Color _kModalBarrierColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x33000000),
  darkColor: Color(0x7A000000),
);

const Duration _kModalPopupTransitionDuration = Duration(milliseconds: 335);

final Animatable<Offset> _kBottomMiddleTween = Tween<Offset>(
  begin: const Offset(0.0, 1.0),
  end: Offset.zero,
);

final Animatable<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: Offset.zero,
);

final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1.0 / 3.0, 0.0),
);

final DecorationTween _kGradientShadowTween = DecorationTween(
  begin: _CupertinoEdgeShadowDecoration.none,
  end: const _CupertinoEdgeShadowDecoration(
    edgeGradient: LinearGradient(
      begin: AlignmentDirectional(0.90, 0.0),
      end: AlignmentDirectional.centerEnd,
      colors: <Color>[
        Color(0x00000000),
        Color(0x04000000),
        Color(0x12000000),
        Color(0x38000000),
      ],
      stops: <double>[0.0, 0.3, 0.6, 1.0],
    ),
  ),
);

class CupertinoPageRoute<T> extends PageRoute<T> {
  CupertinoPageRoute({
    @required this.builder,
    this.title,
    RouteSettings settings,
    this.maintainState = true,
    this.stacked = false,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;
  final String title;
  final bool stacked;
  ValueNotifier<String> _previousTitle;

  ValueListenable<String> get previousTitle {
    assert(
      _previousTitle != null,
      'Cannot read the previousTitle for a route that has not yet been installed',
    );
    return _previousTitle;
  }

  @override
  void didChangePrevious(Route<dynamic> previousRoute) {
    final String previousTitleString =
        previousRoute is CupertinoPageRoute ? previousRoute.title : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String>(previousTitleString);
    } else {
      _previousTitle.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get barrierDismissible => true;

  @override
  bool get opaque => !stacked;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    setState(() {
      hasPageBackground =
          !stacked && nextRoute is CupertinoPageRoute && nextRoute.stacked;
      hasPageForeground =
          stacked && nextRoute is CupertinoPageRoute && !nextRoute.stacked;
    });

    return nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog;
  }

  bool hasPageBackground = false;
  bool hasPageForeground = false;

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator.userGestureInProgress;
  }

  bool get popGestureInProgress => isPopGestureInProgress(this);

  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) return false;
    if (route.willHandlePopInternally) return false;
    if (route.hasScopedWillPopCallback) return false;
    if (route.fullscreenDialog) return false;
    if (route.animation.status != AnimationStatus.completed) return false;
    if (route.secondaryAnimation.status != AnimationStatus.dismissed)
      return false;

    if (isPopGestureInProgress(route)) return false;

    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget child = builder(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    assert(() {
      if (child == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'The builder for route "${settings.name}" returned null.'),
          ErrorDescription('Route builders must never return null.'),
        ]);
      }
      return true;
    }());
    return result;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (stacked)
      return Container(
        margin: const EdgeInsets.only(top: 45.0),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: CupertinoPageTransition(
            isStacked: stacked,
            hasPageBackground: hasPageBackground,
            hasPageForeground: hasPageForeground,
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: isPopGestureInProgress(this),
            child: _CupertinoBackGestureDetector<T>(
              direction: _BackGestureDirection.top,
              enabledCallback: () => _isPopGestureEnabled<T>(this),
              onStartPopGesture: () {
                assert(_isPopGestureEnabled(this));

                setState(() {
                  hasPageBackground = stacked;
                });

                return _CupertinoBackGestureController<T>(
                  navigator: this.navigator,
                  controller: this.controller,
                  stacked: stacked,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: child,
              ),
            ),
          ),
        ),
      );

    return CupertinoPageTransition(
      isStacked: stacked,
      hasPageBackground: hasPageBackground,
      hasPageForeground: hasPageForeground,
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: isPopGestureInProgress(this),
      child: _CupertinoBackGestureDetector<T>(
        direction: _BackGestureDirection.right,
        enabledCallback: () => _isPopGestureEnabled<T>(this),
        onStartPopGesture: () {
          assert(_isPopGestureEnabled(this));

          return _CupertinoBackGestureController<T>(
            navigator: this.navigator,
            controller: this.controller,
            stacked: stacked,
          );
        },
        child: child,
      ),
    );
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class CupertinoPageTransition extends StatelessWidget {
  CupertinoPageTransition({
    Key key,
    @required Animation<double> primaryRouteAnimation,
    @required Animation<double> secondaryRouteAnimation,
    @required this.child,
    @required bool linearTransition,
    @required this.isStacked,
    @required this.hasPageBackground,
    @required this.hasPageForeground,
  })  : assert(linearTransition != null),
        _primaryPositionAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(isStacked ? _kBottomMiddleTween : _kRightMiddleTween),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kMiddleLeftTween),
        _secondaryScaleAnimation = secondaryRouteAnimation.drive(Tween<double>(
          begin: 1.0,
          end: 0.90,
        )),
        _secondaryStackedScaleAnimation =
            secondaryRouteAnimation.drive(Tween<double>(
          begin: 1.0,
          end: 0.90,
        )),
        _secondaryStackedPositionAnimation =
            secondaryRouteAnimation.drive(Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.075),
        )),
        _secondaryFadeAnimation = secondaryRouteAnimation.drive(Tween<double>(
          begin: 1.0,
          end: 1.0,
        )),
        _secondaryDecorationAnimation =
            secondaryRouteAnimation.drive(DecorationTween(
          begin: BoxDecoration(),
          end: BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
        )),
        _primaryShadowAnimation = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                  ))
            .drive(_kGradientShadowTween),
        super(key: key);

  final Animation<Offset> _primaryPositionAnimation;
  final Animation<Offset> _secondaryPositionAnimation;
  final Animation<Offset> _secondaryStackedPositionAnimation;
  final Animation<double> _secondaryScaleAnimation;
  final Animation<double> _secondaryStackedScaleAnimation;
  final Animation<double> _secondaryFadeAnimation;
  final Animation<Decoration> _secondaryDecorationAnimation;
  final Animation<Decoration> _primaryShadowAnimation;
  final bool isStacked;
  final bool hasPageBackground;
  final bool hasPageForeground;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);

    final primaryTransition = SlideTransition(
      position: _primaryPositionAnimation,
      textDirection: textDirection,
      child: DecoratedBoxTransition(
        decoration: _primaryShadowAnimation,
        child: child,
      ),
    );

    if (isStacked)
      return SlideTransition(
        position: _secondaryStackedPositionAnimation,
        child: ScaleTransition(
          scale: _secondaryStackedScaleAnimation,
          child: DecoratedBoxTransition(
            decoration: _secondaryDecorationAnimation,
            child: primaryTransition,
          ),
        ),
      );

    if (hasPageForeground) return primaryTransition;

    if (hasPageBackground)
      return ScaleTransition(
        scale: _secondaryScaleAnimation,
        child: DecoratedBoxTransition(
          decoration: _secondaryDecorationAnimation,
          child: FadeTransition(
            opacity: _secondaryFadeAnimation,
            child: primaryTransition,
          ),
        ),
      );

    return SlideTransition(
      position: _secondaryPositionAnimation,
      textDirection: textDirection,
      transformHitTests: false,
      child: primaryTransition,
    );
  }
}

enum _BackGestureDirection {
  top,
  right,
}

class _CupertinoBackGestureDetector<T> extends StatefulWidget {
  const _CupertinoBackGestureDetector({
    Key key,
    @required this.enabledCallback,
    @required this.onStartPopGesture,
    @required this.child,
    @required this.direction,
  })  : assert(enabledCallback != null),
        assert(onStartPopGesture != null),
        assert(child != null),
        super(key: key);

  final _BackGestureDirection direction;

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_CupertinoBackGestureController<T>> onStartPopGesture;

  @override
  _CupertinoBackGestureDetectorState<T> createState() =>
      _CupertinoBackGestureDetectorState<T>();
}

class _CupertinoBackGestureDetectorState<T>
    extends State<_CupertinoBackGestureDetector<T>> {
  _CupertinoBackGestureController<T> _backGestureController;

  DragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    if (isTopDirection) {
      _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
        ..onStart = _handleDragStart
        ..onUpdate = _handleDragUpdate
        ..onEnd = _handleDragEnd
        ..onCancel = _handleDragCancel;
    } else {
      _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
        ..onStart = _handleDragStart
        ..onUpdate = _handleDragUpdate
        ..onEnd = _handleDragEnd
        ..onCancel = _handleDragCancel;
    }
  }

  bool get isTopDirection => widget.direction == _BackGestureDirection.top;

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    if (isTopDirection)
      _backGestureController.dragUpdate(
          _convertToLogical(details.primaryDelta / context.size.height));
    else
      _backGestureController.dragUpdate(
          _convertToLogical(details.primaryDelta / context.size.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    if (isTopDirection)
      _backGestureController.dragEnd(_convertToLogical(
          details.velocity.pixelsPerSecond.dy / context.size.height));
    else
      _backGestureController.dragEnd(_convertToLogical(
          details.velocity.pixelsPerSecond.dx / context.size.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);

    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer.addPointer(event);
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth);

    if (widget.direction == _BackGestureDirection.top) {
      return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          widget.child,
          PositionedDirectional(
            start: 0.0,
            height: kMinInteractiveDimensionCupertino,
            end: 0.0,
            top: 0.0,
            child: Listener(
              onPointerDown: _handlePointerDown,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _CupertinoBackGestureController<T> {
  _CupertinoBackGestureController({
    @required this.navigator,
    @required this.controller,
    @required this.stacked,
  })  : assert(navigator != null),
        assert(controller != null) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;
  final bool stacked;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    bool animateForward;

    if (velocity.abs() >= _kMinFlingVelocity)
      animateForward = velocity <= 0;
    else
      animateForward = controller.value > 0.5;

    if (animateForward) {
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(
          stacked ? 500 : 800,
          0,
          controller.value,
        ).floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(
        1.0,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
        curve: animationCurve,
      );
    } else {
      navigator.pop();

      if (controller.isAnimating) {
        final int droppedPageBackAnimationTime = lerpDouble(
          0,
          stacked ? 500 : 800,
          controller.value,
        ).floor();
        controller.animateBack(
          0.0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: animationCurve,
        );
      }
    }
    if (controller.isAnimating) {
      AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

class _CupertinoEdgeShadowDecoration extends Decoration {
  const _CupertinoEdgeShadowDecoration({this.edgeGradient});

  static const _CupertinoEdgeShadowDecoration none =
      _CupertinoEdgeShadowDecoration();

  final LinearGradient edgeGradient;

  static _CupertinoEdgeShadowDecoration lerp(
    _CupertinoEdgeShadowDecoration a,
    _CupertinoEdgeShadowDecoration b,
    double t,
  ) {
    assert(t != null);
    if (a == null && b == null) return null;
    return _CupertinoEdgeShadowDecoration(
      edgeGradient: LinearGradient.lerp(a?.edgeGradient, b?.edgeGradient, t),
    );
  }

  @override
  _CupertinoEdgeShadowDecoration lerpFrom(Decoration a, double t) {
    if (a is _CupertinoEdgeShadowDecoration)
      return _CupertinoEdgeShadowDecoration.lerp(a, this, t);
    return _CupertinoEdgeShadowDecoration.lerp(null, this, t);
  }

  @override
  _CupertinoEdgeShadowDecoration lerpTo(Decoration b, double t) {
    if (b is _CupertinoEdgeShadowDecoration)
      return _CupertinoEdgeShadowDecoration.lerp(this, b, t);
    return _CupertinoEdgeShadowDecoration.lerp(this, null, t);
  }

  @override
  _CupertinoEdgeShadowPainter createBoxPainter([VoidCallback onChanged]) {
    return _CupertinoEdgeShadowPainter(this, onChanged);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _CupertinoEdgeShadowDecoration &&
        other.edgeGradient == edgeGradient;
  }

  @override
  int get hashCode => edgeGradient.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<LinearGradient>('edgeGradient', edgeGradient));
  }
}

class _CupertinoEdgeShadowPainter extends BoxPainter {
  _CupertinoEdgeShadowPainter(
    this._decoration,
    VoidCallback onChange,
  )   : assert(_decoration != null),
        super(onChange);

  final _CupertinoEdgeShadowDecoration _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final LinearGradient gradient = _decoration.edgeGradient;
    if (gradient == null) return;

    final TextDirection textDirection = configuration.textDirection;
    assert(textDirection != null);
    double deltaX;
    switch (textDirection) {
      case TextDirection.rtl:
        deltaX = configuration.size.width;
        break;
      case TextDirection.ltr:
        deltaX = -configuration.size.width;
        break;
    }
    final Rect rect = (offset & configuration.size).translate(deltaX, 0.0);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect, textDirection: textDirection);

    canvas.drawRect(rect, paint);
  }
}

class _CupertinoModalPopupRoute<T> extends PopupRoute<T> {
  _CupertinoModalPopupRoute({
    this.barrierColor,
    this.barrierLabel,
    this.builder,
    ImageFilter filter,
    RouteSettings settings,
  }) : super(
          filter: filter,
          settings: settings,
        );

  final WidgetBuilder builder;

  @override
  final String barrierLabel;

  @override
  final Color barrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => false;

  @override
  Duration get transitionDuration => _kModalPopupTransitionDuration;

  Animation<double> _animation;

  Tween<Offset> _offsetTween;

  @override
  Animation<double> createAnimation() {
    assert(_animation == null);
    _animation = CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linearToEaseOut.flipped,
    );
    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    );
    return _animation;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.elevated,
      child: Builder(builder: builder),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation),
        child: child,
      ),
    );
  }
}

Future<T> showCupertinoModalPopup<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  ImageFilter filter,
  bool useRootNavigator = true,
}) {
  assert(useRootNavigator != null);
  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _CupertinoModalPopupRoute<T>(
      barrierColor: CupertinoDynamicColor.resolve(_kModalBarrierColor, context),
      barrierLabel: 'Dismiss',
      builder: builder,
      filter: filter,
    ),
  );
}

final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
    .chain(CurveTween(curve: Curves.linearToEaseOut));

Widget _buildCupertinoDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  final CurvedAnimation fadeAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );
  if (animation.status == AnimationStatus.reverse) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      child: child,
      scale: animation.drive(_dialogScaleTween),
    ),
  );
}

Future<T> showCupertinoDialog<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool useRootNavigator = true,
}) {
  assert(builder != null);
  assert(useRootNavigator != null);
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: CupertinoDynamicColor.resolve(_kModalBarrierColor, context),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return builder(context);
    },
    transitionBuilder: _buildCupertinoDialogTransitions,
    useRootNavigator: useRootNavigator,
  );
}

Future<T> push<T>(
  context,
  Widget screen, {
  String title,
  bool rootNavigator: true,
  bool stacked: false,
  RouteSettings settings,
}) {
  return Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).push(
    CupertinoPageRoute(
      builder: (context) => screen,
      title: title,
      settings: settings,
      stacked: stacked,
    ),
  );
}

//Future<T> pushModal<T>(context, Widget screen, [RouteSettings settings]) {
//  return Navigator.push(
//    context,
//    CupertinoModalRoute(
//      builder: (context) => screen,
//      settings: settings,
//    ),
//  );
//}

bool pop<T extends Object>(context, [T result]) {
  return Navigator.of(context).pop<T>(result);
}

Future<T> replace<T>(context, Widget screen) {
  return Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (context) => screen,
    ),
  );
}

Future<T> resetTo<T>(context, Widget screen) {
  return Navigator.of(context).pushAndRemoveUntil(
    CupertinoPageRoute(
      builder: (context) => screen,
    ),
    (_) => false,
  );
}

Future<T> pushAndRemoveUntil<T>(context, Widget screen, [String to]) {
  return Navigator.of(context).pushAndRemoveUntil(
    CupertinoPageRoute(
      builder: (context) => screen,
    ),
    ModalRoute.withName(to ?? '/'),
  );
}

void popUntil<T>(context, [String to]) {
  return Navigator.of(context).popUntil(
    ModalRoute.withName(to ?? '/'),
  );
}
