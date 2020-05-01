part of 'app_bar.dart';

@immutable
class _Transition {
  _Transition({
    @required this.animation,
    @required _TransitionableNavigationBar bottomNavBar,
    @required _TransitionableNavigationBar topNavBar,
    @required TextDirection directionality,
  })  : bottomComponents = bottomNavBar.componentsKeys,
        topComponents = topNavBar.componentsKeys,
        bottomNavBarBox = bottomNavBar.renderBox,
        topNavBarBox = topNavBar.renderBox,
        bottomBackButtonTextStyle = bottomNavBar.backButtonTextStyle,
        topBackButtonTextStyle = topNavBar.backButtonTextStyle,
        bottomTitleTextStyle = bottomNavBar.titleTextStyle,
        topTitleTextStyle = topNavBar.titleTextStyle,
        bottomLargeTitleTextStyle = bottomNavBar.largeTitleTextStyle,
        topLargeTitleTextStyle = topNavBar.largeTitleTextStyle,
        bottomHasUserMiddle = bottomNavBar.hasUserMiddle,
        topHasUserMiddle = topNavBar.hasUserMiddle,
        bottomLargeExpanded = bottomNavBar.largeExpanded,
        topLargeExpanded = topNavBar.largeExpanded,
        transitionBox = bottomNavBar.renderBox.paintBounds
            .expandToInclude(topNavBar.renderBox.paintBounds),
        forwardDirection = directionality == TextDirection.ltr ? 1.0 : -1.0;

  static final Animatable<double> fadeOut = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );
  static final Animatable<double> fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  final Animation<double> animation;
  final _NavigationBarStaticComponentsKeys bottomComponents;
  final _NavigationBarStaticComponentsKeys topComponents;
  final RenderBox bottomNavBarBox;
  final RenderBox topNavBarBox;
  final TextStyle bottomBackButtonTextStyle;
  final TextStyle topBackButtonTextStyle;
  final TextStyle bottomTitleTextStyle;
  final TextStyle topTitleTextStyle;
  final TextStyle bottomLargeTitleTextStyle;
  final TextStyle topLargeTitleTextStyle;
  final bool bottomHasUserMiddle;
  final bool topHasUserMiddle;
  final bool bottomLargeExpanded;
  final bool topLargeExpanded;
  final Rect transitionBox;
  final double forwardDirection;

  RelativeRect positionInTransitionBox(
    GlobalKey key, {
    @required RenderBox from,
  }) {
    final RenderBox componentBox =
        key.currentContext.findRenderObject() as RenderBox;
    assert(componentBox.attached);

    return RelativeRect.fromRect(
      componentBox.localToGlobal(Offset.zero, ancestor: from) &
          componentBox.size,
      transitionBox,
    );
  }

  RelativeRectTween slideFromLeadingEdge({
    @required GlobalKey fromKey,
    @required RenderBox fromNavBarBox,
    @required GlobalKey toKey,
    @required RenderBox toNavBarBox,
  }) {
    final RelativeRect fromRect =
        positionInTransitionBox(fromKey, from: fromNavBarBox);

    final RenderBox fromBox =
        fromKey.currentContext.findRenderObject() as RenderBox;
    final RenderBox toBox =
        toKey.currentContext.findRenderObject() as RenderBox;

    Rect toRect = toBox
            .localToGlobal(
              Offset.zero,
              ancestor: toNavBarBox,
            )
            .translate(
              0.0,
              -fromBox.size.height / 2 + toBox.size.height / 2,
            ) &
        fromBox.size;

    if (forwardDirection < 0) {
      toRect = toRect.translate(-fromBox.size.width + toBox.size.width, 0.0);
    }

    return RelativeRectTween(
      begin: fromRect,
      end: RelativeRect.fromRect(toRect, transitionBox),
    );
  }

  Animation<double> fadeInFrom(double t, {Curve curve = Curves.easeIn}) {
    return animation.drive(fadeIn.chain(
      CurveTween(curve: Interval(t, 1.0, curve: curve)),
    ));
  }

  Animation<double> fadeOutBy(double t, {Curve curve = Curves.easeOut}) {
    return animation.drive(fadeOut.chain(
      CurveTween(curve: Interval(0.0, t, curve: curve)),
    ));
  }

  Widget get bottomLeading {
    final KeyedSubtree bottomLeading =
        bottomComponents.leadingKey.currentWidget;

    if (bottomLeading == null) return null;

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(
        bottomComponents.leadingKey,
        from: bottomNavBarBox,
      ),
      child: FadeTransition(
        opacity: fadeOutBy(0.4),
        child: bottomLeading.child,
      ),
    );
  }

  Widget get bottomBackChevron {
    final KeyedSubtree bottomBackChevron =
        bottomComponents.backChevronKey.currentWidget;

    if (bottomBackChevron == null) return null;

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.backChevronKey,
          from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackChevron.child,
        ),
      ),
    );
  }

  Widget get bottomBackLabel {
    final KeyedSubtree bottomBackLabel =
        bottomComponents.backLabelKey.currentWidget;

    if (bottomBackLabel == null) return null;

    final RelativeRect from = positionInTransitionBox(
      bottomComponents.backLabelKey,
      from: bottomNavBarBox,
    );

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: from.shift(
        Offset(
          forwardDirection * (-bottomNavBarBox.size.width / 2.0),
          0.0,
        ),
      ),
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeOutBy(0.2),
        child: DefaultTextStyle(
          overflow: TextOverflow.visible,
          style: bottomBackButtonTextStyle,
          child: bottomBackLabel.child,
        ),
      ),
    );
  }

  Widget get bottomMiddle {
    final KeyedSubtree bottomMiddle = bottomComponents.middleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    if (!bottomHasUserMiddle && bottomLargeExpanded) return null;

    if (bottomMiddle != null && topBackLabel != null) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.middleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              child: bottomMiddle.child,
            ),
          ),
        ),
      );
    }

    if (bottomMiddle != null && topLeading != null) {
      return Positioned.fromRelativeRect(
        rect: positionInTransitionBox(bottomComponents.middleKey,
            from: bottomNavBarBox),
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: DefaultTextStyle(
            style: bottomTitleTextStyle,
            child: bottomMiddle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get bottomLargeTitle {
    final KeyedSubtree bottomLargeTitle =
        bottomComponents.largeTitleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    if (bottomLargeTitle == null || !bottomLargeExpanded) return null;

    if (bottomLargeTitle != null && topBackLabel != null) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.largeTitleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: fadeOutBy(0.6),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomLargeTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            overflow: TextOverflow.ellipsis,
            child: bottomLargeTitle.child,
          ),
        ),
      );
    }

    if (bottomLargeTitle != null && topLeading != null) {
      final RelativeRect from = positionInTransitionBox(
          bottomComponents.largeTitleKey,
          from: bottomNavBarBox);

      final RelativeRectTween positionTween = RelativeRectTween(
        begin: from,
        end: from.shift(
          Offset(
            forwardDirection * bottomNavBarBox.size.width / 4.0,
            0.0,
          ),
        ),
      );

      return PositionedTransition(
        rect: animation.drive(positionTween),
        child: FadeTransition(
          opacity: fadeOutBy(0.4),
          child: DefaultTextStyle(
            style: bottomLargeTitleTextStyle,
            child: bottomLargeTitle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get bottomTrailing {
    final KeyedSubtree bottomTrailing =
        bottomComponents.trailingKey.currentWidget;

    if (bottomTrailing == null) return null;

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.trailingKey,
          from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: bottomTrailing.child,
      ),
    );
  }

  Widget get topLeading {
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    if (topLeading == null) return null;

    return Positioned.fromRelativeRect(
      rect:
          positionInTransitionBox(topComponents.leadingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.6),
        child: topLeading.child,
      ),
    );
  }

  Widget get topBackChevron {
    final KeyedSubtree topBackChevron =
        topComponents.backChevronKey.currentWidget;
    final KeyedSubtree bottomBackChevron =
        bottomComponents.backChevronKey.currentWidget;

    if (topBackChevron == null) return null;

    final RelativeRect to = positionInTransitionBox(
        topComponents.backChevronKey,
        from: topNavBarBox);
    RelativeRect from = to;

    if (bottomBackChevron == null) {
      final RenderBox topBackChevronBox =
          topComponents.backChevronKey.currentContext.findRenderObject()
              as RenderBox;
      from = to.shift(
        Offset(
          forwardDirection * topBackChevronBox.size.width * 2.0,
          0.0,
        ),
      );
    }

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(bottomBackChevron == null ? 0.7 : 0.4),
        child: DefaultTextStyle(
          style: topBackButtonTextStyle,
          child: topBackChevron.child,
        ),
      ),
    );
  }

  Widget get topBackLabel {
    final KeyedSubtree bottomMiddle = bottomComponents.middleKey.currentWidget;
    final KeyedSubtree bottomLargeTitle =
        bottomComponents.largeTitleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;

    if (topBackLabel == null) {
      return null;
    }

    final RenderAnimatedOpacity topBackLabelOpacity = topComponents
        .backLabelKey.currentContext
        ?.findAncestorRenderObjectOfType<RenderAnimatedOpacity>();

    Animation<double> midClickOpacity;
    if (topBackLabelOpacity != null &&
        topBackLabelOpacity.opacity.value < 1.0) {
      midClickOpacity = animation.drive(Tween<double>(
        begin: 0.0,
        end: topBackLabelOpacity.opacity.value,
      ));
    }

    if (bottomLargeTitle != null &&
        topBackLabel != null &&
        bottomLargeExpanded) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.largeTitleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.4),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomLargeTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: topBackLabel.child,
          ),
        ),
      );
    }

    if (bottomMiddle != null && topBackLabel != null) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.middleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.3),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            child: topBackLabel.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get topMiddle {
    final KeyedSubtree topMiddle = topComponents.middleKey.currentWidget;

    if (topMiddle == null) return null;

    if (!topHasUserMiddle && topLargeExpanded) return null;

    final RelativeRect to = positionInTransitionBox(
      topComponents.middleKey,
      from: topNavBarBox,
    );

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width / 2.0,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.25),
        child: DefaultTextStyle(
          style: topTitleTextStyle,
          child: topMiddle.child,
        ),
      ),
    );
  }

  Widget get topTrailing {
    final KeyedSubtree topTrailing = topComponents.trailingKey.currentWidget;

    if (topTrailing == null) return null;

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(
        topComponents.trailingKey,
        from: topNavBarBox,
      ),
      child: FadeTransition(
        opacity: fadeInFrom(0.4),
        child: topTrailing.child,
      ),
    );
  }

  Widget get topLargeTitle {
    final KeyedSubtree topLargeTitle =
        topComponents.largeTitleKey.currentWidget;

    if (topLargeTitle == null || !topLargeExpanded) return null;

    final RelativeRect to = positionInTransitionBox(topComponents.largeTitleKey,
        from: topNavBarBox);

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.3),
        child: DefaultTextStyle(
          style: topLargeTitleTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: topLargeTitle.child,
        ),
      ),
    );
  }
}

CreateRectTween _linearTranslateWithLargestRectSizeTween =
    (Rect begin, Rect end) {
  final Size largestSize = Size(
    math.max(begin.size.width, end.size.width),
    math.max(begin.size.height, end.size.height),
  );
  return RectTween(
    begin: begin.topLeft & largestSize,
    end: end.topLeft & largestSize,
  );
};

final HeroPlaceholderBuilder _navBarHeroLaunchPadBuilder = (
  BuildContext context,
  Size heroSize,
  Widget child,
) {
  assert(child is _TransitionableNavigationBar);

  return Visibility(
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: false,
    child: child,
  );
};

final HeroFlightShuttleBuilder _navBarHeroFlightShuttleBuilder = (
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  assert(animation != null);
  assert(flightDirection != null);
  assert(fromHeroContext != null);
  assert(toHeroContext != null);
  assert(fromHeroContext.widget is Hero);
  assert(toHeroContext.widget is Hero);

  final Hero fromHeroWidget = fromHeroContext.widget as Hero;
  final Hero toHeroWidget = toHeroContext.widget as Hero;

  assert(fromHeroWidget.child is _TransitionableNavigationBar);
  assert(toHeroWidget.child is _TransitionableNavigationBar);

  final _TransitionableNavigationBar fromNavBar =
      fromHeroWidget.child as _TransitionableNavigationBar;
  final _TransitionableNavigationBar toNavBar =
      toHeroWidget.child as _TransitionableNavigationBar;

  assert(fromNavBar.componentsKeys != null);
  assert(toNavBar.componentsKeys != null);

  assert(
    fromNavBar.componentsKeys.navBarBoxKey.currentContext.owner != null,
    'The from nav bar to Hero must have been mounted in the previous frame',
  );
  assert(
    toNavBar.componentsKeys.navBarBoxKey.currentContext.owner != null,
    'The to nav bar to Hero must have been mounted in the previous frame',
  );

  switch (flightDirection) {
    case HeroFlightDirection.push:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: fromNavBar,
        topNavBar: toNavBar,
      );
      break;
    case HeroFlightDirection.pop:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: toNavBar,
        topNavBar: fromNavBar,
      );
  }
  return null;
};
