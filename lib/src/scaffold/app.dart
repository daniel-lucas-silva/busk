import 'dart:io' show Platform;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button.dart';
import '../theme/colors.dart';
import '../icons.dart';
import 'interface_level.dart';
import '../intl/localizations.dart';
import 'route.dart';
import '../theme/theme.dart';

class CupertinoApp extends StatefulWidget {
  const CupertinoApp({
    Key key,
    this.navigatorKey,
    this.home,
    this.theme,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
  })  : assert(routes != null),
        assert(navigatorObservers != null),
        assert(title != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
        super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;
  final CupertinoThemeData theme;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final RouteFactory onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder builder;
  final String title;
  final GenerateAppTitle onGenerateTitle;
  final Color color;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final LocaleListResolutionCallback localeListResolutionCallback;
  final LocaleResolutionCallback localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<LocalKey, ActionFactory> actions;

  @override
  _CupertinoAppState createState() => _CupertinoAppState();

  static HeroController createCupertinoHeroController() => HeroController();
}

class _AlwaysCupertinoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class _CupertinoAppState extends State<CupertinoApp> {
  HeroController _heroController;

  @override
  void initState() {
    super.initState();
    _heroController = CupertinoApp.createCupertinoHeroController();
    _updateNavigator();
  }

  @override
  void didUpdateWidget(CupertinoApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorKey != oldWidget.navigatorKey) {
      _heroController = CupertinoApp.createCupertinoHeroController();
    }
    _updateNavigator();
  }

  List<NavigatorObserver> _navigatorObservers;

  void _updateNavigator() {
    if (widget.home != null ||
        widget.routes.isNotEmpty ||
        widget.onGenerateRoute != null ||
        widget.onUnknownRoute != null) {
      _navigatorObservers =
          List<NavigatorObserver>.from(widget.navigatorObservers)
            ..add(_heroController);
    } else {
      _navigatorObservers = const <NavigatorObserver>[];
    }
  }

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
    if (widget.localizationsDelegates != null)
      yield* widget.localizationsDelegates;
    yield DefaultCupertinoLocalizations.delegate;
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData effectiveThemeData =
        widget.theme ?? const CupertinoThemeData();

    return ScrollConfiguration(
      behavior: _AlwaysCupertinoScrollBehavior(),
      child: CupertinoUserInterfaceLevel(
        data: CupertinoUserInterfaceLevelData.base,
        child: CupertinoTheme(
          data: effectiveThemeData,
          child: Builder(
            builder: (BuildContext context) {
              final Color background = CupertinoDynamicColor.resolve(
                  effectiveThemeData.barBackgroundColor, context);
              final bool isDark = background.computeLuminance() < 0.179;
              final Brightness brightness =
                  isDark ? Brightness.light : Brightness.dark;
              final double barOpacity = Platform.isIOS ? 0.8 : 1.0;

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  systemNavigationBarColor: background.withOpacity(barOpacity),
                  systemNavigationBarIconBrightness: brightness,
                ),
                child: WidgetsApp(
                  key: GlobalObjectKey(this),
                  navigatorKey: widget.navigatorKey,
                  navigatorObservers: _navigatorObservers,
                  pageRouteBuilder: <T>(
                    RouteSettings settings,
                    WidgetBuilder builder,
                  ) =>
                      CupertinoPageRoute<T>(
                    settings: settings,
                    builder: builder,
                  ),
                  home: widget.home,
                  routes: widget.routes,
                  initialRoute: widget.initialRoute,
                  onGenerateRoute: widget.onGenerateRoute,
                  onUnknownRoute: widget.onUnknownRoute,
                  builder: widget.builder,
                  title: widget.title,
                  onGenerateTitle: widget.onGenerateTitle,
                  textStyle: CupertinoTheme.of(context).textTheme.textStyle,
                  color: CupertinoDynamicColor.resolve(
                      widget.color ?? effectiveThemeData.primaryColor, context),
                  locale: widget.locale,
                  localizationsDelegates: _localizationsDelegates,
                  localeResolutionCallback: widget.localeResolutionCallback,
                  localeListResolutionCallback:
                      widget.localeListResolutionCallback,
                  supportedLocales: widget.supportedLocales,
                  showPerformanceOverlay: widget.showPerformanceOverlay,
                  checkerboardRasterCacheImages:
                      widget.checkerboardRasterCacheImages,
                  checkerboardOffscreenLayers:
                      widget.checkerboardOffscreenLayers,
                  showSemanticsDebugger: widget.showSemanticsDebugger,
                  debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
                  inspectorSelectButtonBuilder:
                      (BuildContext context, VoidCallback onPressed) {
                    return CupertinoButton.filled(
                      child: const Icon(
                        CupertinoIcons.search,
                        size: 28.0,
                        color: CupertinoColors.white,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: onPressed,
                    );
                  },
                  shortcuts: widget.shortcuts,
                  actions: widget.actions,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
