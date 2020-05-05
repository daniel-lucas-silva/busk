import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

//import 'page_scaffold.dart';
import 'route.dart';
import '../button.dart';
import '../constants.dart';
import '../icons.dart';
import '../theme/colors.dart';
import '../theme/theme.dart';

// Transition
part 'app_bar.g.dart';

// Widgets
part 'app_bar.w.dart';

const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;
const double _kNavBarLargeTitleHeightExtension = 52.0;
const double _kNavBarShowLargeTitleThreshold = 10.0;
const double _kNavBarEdgePadding = 16.0;
const double _kNavBarBackButtonTapWidth = 50.0;
const Duration _kNavBarTitleFadeDuration = Duration(milliseconds: 150);
const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0,
    style: BorderStyle.solid,
  ),
);

const _HeroTag _defaultHeroTag = _HeroTag(null);

class _HeroTag {
  const _HeroTag(this.navigator);

  final NavigatorState navigator;

  @override
  String toString() =>
      'Default Hero tag for Cupertino navigation bars with navigator $navigator';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is _HeroTag && other.navigator == navigator;
  }

  @override
  int get hashCode {
    return identityHashCode(navigator);
  }
}

Widget _wrapWithBackground({
  Border border,
  Color backgroundColor,
  Brightness brightness,
  Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool darkBackground = backgroundColor.computeLuminance() < 0.179;
    final Brightness brightness =
    darkBackground ? Brightness.light : Brightness.dark;
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000),
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
      ),
      sized: true,
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) return childWithBackground;

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: childWithBackground,
    ),
  );
}

Widget _wrapActiveColor(Color color, BuildContext context, Widget child) {
  if (color == null) {
    return child;
  }

  return CupertinoTheme(
    data: CupertinoTheme.of(context).copyWith(primaryColor: color),
    child: child,
  );
}

bool _isTransitionable(BuildContext context) {
  final ModalRoute<dynamic> route = ModalRoute.of(context);

  return route is PageRoute && !route.fullscreenDialog;
}

class SliverAppBar extends StatefulWidget {
  const SliverAppBar({
    Key key,
    this.largeTitle,
    this.leading,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyTitle = true,
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.border = _kDefaultNavBarBorder,
    this.backgroundColor,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = true,
    this.heroTag = _defaultHeroTag,
  })  : assert(automaticallyImplyLeading != null),
        assert(automaticallyImplyTitle != null),
        super(key: key);

  final Widget largeTitle;
  final Widget leading;
  final Widget bottom;
  final bool automaticallyImplyLeading;
  final bool automaticallyImplyTitle;
  final String previousPageTitle;
  final Widget middle;
  final Widget trailing;
  final Color backgroundColor;
  final Brightness brightness;
  final EdgeInsetsDirectional padding;
  final Border border;
  final bool transitionBetweenRoutes;
  final Object heroTag;

//  bool get opaque => backgroundColor.alpha == 0xFF;

  @override
  _SliverAppBarState createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<SliverAppBar> {
  _NavigationBarStaticComponentsKeys keys;

  @override
  void initState() {
    super.initState();
    keys = _NavigationBarStaticComponentsKeys();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = CupertinoTheme.of(context).primaryColor;

    final _NavigationBarStaticComponents components =
        _NavigationBarStaticComponents(
      keys: keys,
      route: ModalRoute.of(context),
      userLeading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      automaticallyImplyTitle: widget.automaticallyImplyTitle,
      previousPageTitle: widget.previousPageTitle,
      userMiddle: widget.middle,
      userTrailing: widget.trailing,
      padding: widget.padding,
      userLargeTitle: widget.largeTitle,
      large: widget.largeTitle != null,
    );

    return _wrapActiveColor(
      primaryColor,
      context,
      MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: SliverPersistentHeader(
          pinned: true,
          delegate: _LargeTitleNavigationBarSliverDelegate(
            keys: keys,
            components: components,
            userMiddle: widget.middle,
            backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
            brightness: widget.brightness,
            border: widget.border,
            padding: widget.padding,
            actionsForegroundColor: primaryColor,
            transitionBetweenRoutes: widget.transitionBetweenRoutes,
            heroTag: widget.heroTag,
            persistentHeight:
                _kNavBarPersistentHeight + MediaQuery.of(context).padding.top,
            alwaysShowMiddle: widget.middle != null,
            isLarge: widget.largeTitle != null,
          ),
        ),
      ),
    );
  }
}

class _LargeTitleNavigationBarSliverDelegate
    extends SliverPersistentHeaderDelegate with DiagnosticableTreeMixin {
  _LargeTitleNavigationBarSliverDelegate({
    @required this.keys,
    @required this.components,
    @required this.userMiddle,
    @required this.backgroundColor,
    @required this.brightness,
    @required this.border,
    @required this.padding,
    @required this.actionsForegroundColor,
    @required this.transitionBetweenRoutes,
    @required this.heroTag,
    @required this.persistentHeight,
    @required this.alwaysShowMiddle,
    @required this.isLarge: false,
  })  : assert(persistentHeight != null),
        assert(alwaysShowMiddle != null),
        assert(transitionBetweenRoutes != null);

  final _NavigationBarStaticComponentsKeys keys;
  final _NavigationBarStaticComponents components;
  final Widget userMiddle;
  final Color backgroundColor;
  final Brightness brightness;
  final Border border;
  final EdgeInsetsDirectional padding;
  final Color actionsForegroundColor;
  final bool transitionBetweenRoutes;
  final Object heroTag;
  final double persistentHeight;
  final bool alwaysShowMiddle;
  final bool isLarge;

  @override
  double get minExtent => persistentHeight;

  @override
  double get maxExtent {
    if (isLarge) return persistentHeight + _kNavBarLargeTitleHeightExtension;
    return persistentHeight;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool showLargeTitle =
        shrinkOffset < maxExtent - minExtent - _kNavBarShowLargeTitleThreshold;

    final textTheme = CupertinoTheme.of(context).textTheme;
    final bgColor = DynamicColor.resolve(backgroundColor, context);

    final _PersistentNavigationBar persistentNavigationBar =
        _PersistentNavigationBar(
      components: components,
      padding: padding,
      middleVisible: alwaysShowMiddle ? null : !showLargeTitle,
    );

    final Widget navBar = _wrapWithBackground(
      border: border,
      backgroundColor: bgColor,
      brightness: brightness,
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (isLarge)
              Positioned(
                top: persistentHeight,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: ClipRect(
                  child: OverflowBox(
                    minHeight: 0.0,
                    maxHeight: double.infinity,
                    alignment: AlignmentDirectional.bottomStart,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: _kNavBarEdgePadding,
                        bottom: 8.0,
                      ),
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: AnimatedOpacity(
                          opacity: showLargeTitle ? 1.0 : 0.0,
                          duration: _kNavBarTitleFadeDuration,
                          child: Semantics(
                            header: true,
                            child: DefaultTextStyle(
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .largeTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: components.largeTitle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              child: persistentNavigationBar,
            ),
          ],
        ),
      ),
    );

    if (!transitionBetweenRoutes || !_isTransitionable(context)) {
      return navBar;
    }

    return Hero(
      tag: heroTag == _defaultHeroTag
          ? _HeroTag(Navigator.of(context))
          : heroTag,
      createRectTween: _linearTranslateWithLargestRectSizeTween,
      flightShuttleBuilder: _navBarHeroFlightShuttleBuilder,
      placeholderBuilder: _navBarHeroLaunchPadBuilder,
      transitionOnUserGestures: true,
      child: _TransitionableNavigationBar(
        componentsKeys: keys,
        backgroundColor: bgColor,
        backButtonTextStyle: textTheme.body.copyWith(
          color: CupertinoTheme.of(context).primaryColor,
        ),
        titleTextStyle: textTheme.body,
        largeTitleTextStyle: textTheme.largeTitle,
        border: border,
        hasUserMiddle: userMiddle != null,
        largeExpanded: showLargeTitle,
        child: navBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_LargeTitleNavigationBarSliverDelegate oldDelegate) {
    return components != oldDelegate.components ||
        userMiddle != oldDelegate.userMiddle ||
        backgroundColor != oldDelegate.backgroundColor ||
        border != oldDelegate.border ||
        padding != oldDelegate.padding ||
        actionsForegroundColor != oldDelegate.actionsForegroundColor ||
        transitionBetweenRoutes != oldDelegate.transitionBetweenRoutes ||
        persistentHeight != oldDelegate.persistentHeight ||
        alwaysShowMiddle != oldDelegate.alwaysShowMiddle ||
        heroTag != oldDelegate.heroTag;
  }
}

class _PersistentNavigationBar extends StatelessWidget {
  const _PersistentNavigationBar({
    Key key,
    this.components,
    this.padding,
    this.middleVisible,
  }) : super(key: key);

  final _NavigationBarStaticComponents components;

  final EdgeInsetsDirectional padding;

  final bool middleVisible;

  @override
  Widget build(BuildContext context) {
    Widget middle = components.middle;

    if (middle != null) {
      middle = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.body,
        child: Semantics(header: true, child: middle),
      );

      middle = middleVisible == null
          ? middle
          : AnimatedOpacity(
              opacity: middleVisible ? 1.0 : 0.0,
              duration: _kNavBarTitleFadeDuration,
              child: middle,
            );
    }

    Widget leading = components.leading;
    final Widget backChevron = components.backChevron;
    final Widget backLabel = components.backLabel;

    if (leading == null && backChevron != null && backLabel != null) {
      leading = AppBarBackButton._assemble(
        backChevron,
        backLabel,
      );
    }

    Widget paddedToolbar = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: components.trailing,
      centerMiddle: true,
      middleSpacing: 6.0,
    );

    if (padding != null) {
      paddedToolbar = Padding(
        padding: EdgeInsets.only(
          top: padding.top,
          bottom: padding.bottom,
        ),
        child: paddedToolbar,
      );
    }

    return SizedBox(
      height: _kNavBarPersistentHeight + MediaQuery.of(context).padding.top,
      child: SafeArea(
        bottom: false,
        child: paddedToolbar,
      ),
    );
  }
}

@immutable
class _NavigationBarStaticComponentsKeys {
  _NavigationBarStaticComponentsKeys()
      : navBarBoxKey = GlobalKey(debugLabel: 'Navigation bar render box'),
        leadingKey = GlobalKey(debugLabel: 'Leading'),
        backChevronKey = GlobalKey(debugLabel: 'Back chevron'),
        backLabelKey = GlobalKey(debugLabel: 'Back label'),
        middleKey = GlobalKey(debugLabel: 'Middle'),
        trailingKey = GlobalKey(debugLabel: 'Trailing'),
        largeTitleKey = GlobalKey(debugLabel: 'Large title');

  final GlobalKey navBarBoxKey;
  final GlobalKey leadingKey;
  final GlobalKey backChevronKey;
  final GlobalKey backLabelKey;
  final GlobalKey middleKey;
  final GlobalKey trailingKey;
  final GlobalKey largeTitleKey;
}

@immutable
class _NavigationBarStaticComponents {
  _NavigationBarStaticComponents({
    @required _NavigationBarStaticComponentsKeys keys,
    @required ModalRoute<dynamic> route,
    @required Widget userLeading,
    @required bool automaticallyImplyLeading,
    @required bool automaticallyImplyTitle,
    @required String previousPageTitle,
    @required Widget userMiddle,
    @required Widget userTrailing,
    @required Widget userLargeTitle,
    @required EdgeInsetsDirectional padding,
    @required bool large,
  })  : leading = createLeading(
          leadingKey: keys.leadingKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          padding: padding,
        ),
        backChevron = createBackChevron(
          backChevronKey: keys.backChevronKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        backLabel = createBackLabel(
          backLabelKey: keys.backLabelKey,
          userLeading: userLeading,
          route: route,
          previousPageTitle: previousPageTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
        middle = createMiddle(
          middleKey: keys.middleKey,
          userMiddle: userMiddle,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticallyImplyTitle: automaticallyImplyTitle,
          large: large,
        ),
        trailing = createTrailing(
          trailingKey: keys.trailingKey,
          userTrailing: userTrailing,
          padding: padding,
        ),
        largeTitle = createLargeTitle(
          largeTitleKey: keys.largeTitleKey,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticImplyTitle: automaticallyImplyTitle,
          large: large,
        );

  static Widget _derivedTitle({
    bool automaticallyImplyTitle,
    ModalRoute<dynamic> currentRoute,
  }) {
    if (automaticallyImplyTitle &&
        currentRoute is CupertinoPageRoute &&
        currentRoute.title != null) {
      return Text(currentRoute.title);
    }

    return null;
  }

  final KeyedSubtree leading;

  static KeyedSubtree createLeading({
    @required GlobalKey leadingKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
    @required EdgeInsetsDirectional padding,
  }) {
    Widget leadingContent;

    if (userLeading != null) {
      leadingContent = userLeading;
    } else if (automaticallyImplyLeading &&
        route is PageRoute &&
        route.canPop &&
        route.fullscreenDialog) {
      leadingContent = Button(
        child: const Text('Close'),
        padding: EdgeInsets.zero,
        onPressed: () {
          route.navigator.maybePop();
        },
      );
    }

    if (leadingContent == null) {
      return null;
    }

    return KeyedSubtree(
      key: leadingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: padding?.start ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: leadingContent,
        ),
      ),
    );
  }

  final KeyedSubtree backChevron;

  static KeyedSubtree createBackChevron({
    @required GlobalKey backChevronKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
  }) {
    if (userLeading != null ||
        !automaticallyImplyLeading ||
        route == null ||
        !route.canPop ||
        (route is PageRoute && route.fullscreenDialog)) {
      return null;
    }

    return KeyedSubtree(key: backChevronKey, child: const _BackChevron());
  }

  final KeyedSubtree backLabel;

  static KeyedSubtree createBackLabel({
    @required GlobalKey backLabelKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
    @required String previousPageTitle,
  }) {
    if (userLeading != null ||
        !automaticallyImplyLeading ||
        route == null ||
        !route.canPop ||
        (route is PageRoute && route.fullscreenDialog)) {
      return null;
    }

    return KeyedSubtree(
      key: backLabelKey,
      child: _BackLabel(
        specifiedPreviousTitle: previousPageTitle,
        route: route,
      ),
    );
  }

  final KeyedSubtree middle;

  static KeyedSubtree createMiddle({
    @required GlobalKey middleKey,
    @required Widget userMiddle,
    @required Widget userLargeTitle,
    @required bool large,
    @required bool automaticallyImplyTitle,
    @required ModalRoute<dynamic> route,
  }) {
    Widget middleContent = userMiddle;

    if (large) middleContent ??= userLargeTitle;

    middleContent ??= _derivedTitle(
      automaticallyImplyTitle: automaticallyImplyTitle,
      currentRoute: route,
    );

    if (middleContent == null) return null;

    return KeyedSubtree(
      key: middleKey,
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.1,
        child: middleContent,
      ),
    );
  }

  final KeyedSubtree trailing;

  static KeyedSubtree createTrailing({
    @required GlobalKey trailingKey,
    @required Widget userTrailing,
    @required EdgeInsetsDirectional padding,
  }) {
    if (userTrailing == null) return null;

    return KeyedSubtree(
      key: trailingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: padding?.end ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: userTrailing,
        ),
      ),
    );
  }

  final KeyedSubtree largeTitle;

  static KeyedSubtree createLargeTitle({
    @required GlobalKey largeTitleKey,
    @required Widget userLargeTitle,
    @required bool large,
    @required bool automaticImplyTitle,
    @required ModalRoute<dynamic> route,
  }) {
    if (!large) return null;

    final Widget largeTitleContent = userLargeTitle ??
        _derivedTitle(
          automaticallyImplyTitle: automaticImplyTitle,
          currentRoute: route,
        );

    assert(
      largeTitleContent != null,
      'largeTitle was not provided and there was no title from the route.',
    );

    return KeyedSubtree(
      key: largeTitleKey,
      child: largeTitleContent,
    );
  }
}

class _TransitionableNavigationBar extends StatelessWidget {
  _TransitionableNavigationBar({
    @required this.componentsKeys,
    @required this.backgroundColor,
    @required this.backButtonTextStyle,
    @required this.titleTextStyle,
    @required this.largeTitleTextStyle,
    @required this.border,
    @required this.hasUserMiddle,
    @required this.largeExpanded,
    @required this.child,
  })  : assert(componentsKeys != null),
        assert(largeExpanded != null),
        assert(!largeExpanded || largeTitleTextStyle != null),
        super(key: componentsKeys.navBarBoxKey);

  final _NavigationBarStaticComponentsKeys componentsKeys;
  final Color backgroundColor;
  final TextStyle backButtonTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle largeTitleTextStyle;
  final Border border;
  final bool hasUserMiddle;
  final bool largeExpanded;
  final Widget child;

  RenderBox get renderBox {
    final RenderBox box = componentsKeys.navBarBoxKey.currentContext
        .findRenderObject() as RenderBox;
    assert(
      box.attached,
      '_TransitionableNavigationBar.renderBox should be called when building '
      'hero flight shuttles when the from and the to nav bar boxes are already '
      'laid out and painted.',
    );
    return box;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      bool inHero;
      context.visitAncestorElements((Element ancestor) {
        if (ancestor is ComponentElement) {
          assert(
            ancestor.widget.runtimeType != _NavigationBarTransition,
            '_TransitionableNavigationBar should never re-appear inside '
            '_NavigationBarTransition. Keyed _TransitionableNavigationBar should '
            'only serve as anchor points in routes rather than appearing inside '
            'Hero flights themselves.',
          );
          if (ancestor.widget.runtimeType == Hero) {
            inHero = true;
          }
        }
        inHero ??= false;
        return true;
      });
      assert(
        inHero == true,
        '_TransitionableNavigationBar should only be added as the immediate '
        'child of Hero widgets.',
      );
      return true;
    }());
    return child;
  }
}

class _NavigationBarTransition extends StatelessWidget {
  _NavigationBarTransition({
    @required this.animation,
    @required this.topNavBar,
    @required this.bottomNavBar,
  })  : heightTween = Tween<double>(
          begin: bottomNavBar.renderBox.size.height,
          end: topNavBar.renderBox.size.height,
        ),
        backgroundTween = ColorTween(
          begin: bottomNavBar.backgroundColor,
          end: topNavBar.backgroundColor,
        ),
        borderTween = BorderTween(
          begin: bottomNavBar.border,
          end: topNavBar.border,
        );

  final Animation<double> animation;
  final _TransitionableNavigationBar topNavBar;
  final _TransitionableNavigationBar bottomNavBar;

  final Tween<double> heightTween;
  final ColorTween backgroundTween;
  final BorderTween borderTween;

  @override
  Widget build(BuildContext context) {
    final _Transition transition = _Transition(
      animation: animation,
      bottomNavBar: bottomNavBar,
      topNavBar: topNavBar,
      directionality: Directionality.of(context),
    );

    final List<Widget> children = <Widget>[
      AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return _wrapWithBackground(
            updateSystemUiOverlay: false,
            backgroundColor: backgroundTween.evaluate(animation),
            border: borderTween.evaluate(animation),
            child: SizedBox(
              height: heightTween.evaluate(animation),
              width: double.infinity,
            ),
          );
        },
      ),
      transition.bottomBackChevron,
      transition.bottomBackLabel,
      transition.bottomLeading,
      transition.bottomMiddle,
      transition.bottomLargeTitle,
      transition.bottomTrailing,
      transition.topLeading,
      transition.topBackChevron,
      transition.topBackLabel,
      transition.topMiddle,
      transition.topLargeTitle,
      transition.topTrailing,
    ];

    children.removeWhere((Widget child) => child == null);

    return SizedBox(
      height: math.max(heightTween.begin, heightTween.end) +
          MediaQuery.of(context).padding.top,
      width: double.infinity,
      child: Stack(
        children: children,
      ),
    );
  }
}
