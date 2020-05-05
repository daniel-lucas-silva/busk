// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../theme/colors.dart';
import '../theme/theme.dart';

const double _kTabBarHeight = 50.0;

const Color _kDefaultTabBarBorderColor = DynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);

const Color _kDefaultTabBarInactiveColor = Colors.inactiveGray;


class TabBarItem {
  const TabBarItem({
    @required this.icon,
    this.title,
    Widget activeIcon,
  }) : activeIcon = activeIcon ?? icon,
        assert(icon != null);
  final Widget icon;
  final Widget activeIcon;
  final Widget title;
}

class TabItem {
  const TabItem({
    @required this.icon,
    this.title,
    this.child,
    Widget activeIcon,
  }) : activeIcon = activeIcon ?? icon,
        assert(icon != null),
        assert(child != null);
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final Widget child;
}

class TabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a tab bar in the iOS style.
  const TabBar({
    Key key,
    @required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor = _kDefaultTabBarInactiveColor,
    this.iconSize = 30.0,
    this.border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    ),
  }) : assert(items != null),
       assert(
         items.length >= 2,
         "Tabs need at least 2 items to conform to Apple's HIG",
       ),
       assert(currentIndex != null),
       assert(0 <= currentIndex && currentIndex < items.length),
       assert(iconSize != null),
       assert(inactiveColor != null),
       super(key: key);

  final List<TabBarItem> items;
  final ValueChanged<int> onTap;
  final int currentIndex;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;
  final Border border;

  @override
  Size get preferredSize => const Size.fromHeight(_kTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;


    BorderSide resolveBorderSide(BorderSide side) {
      return side == BorderSide.none
        ? side
        : side.copyWith(color: DynamicColor.resolve(side.color, context));
    }

    final Border resolvedBorder = border == null || border.runtimeType != Border
      ? border
      : Border(
        top: resolveBorderSide(border.top),
        left: resolveBorderSide(border.left),
        bottom: resolveBorderSide(border.bottom),
        right: resolveBorderSide(border.right),
      );

    final Color inactive = DynamicColor.resolve(inactiveColor, context);

    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        border: resolvedBorder,
        color: this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: SizedBox(
        height: _kTabBarHeight + bottomPadding,
        child: IconTheme.merge( // Default with the inactive state.
          data: IconThemeData(color: inactive, size: iconSize),
          child: DefaultTextStyle( // Default with the inactive state.
            style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle.copyWith(color: inactive),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                // Align bottom since we want the labels to be aligned.
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildTabItems(context),
              ),
            ),
          ),
        ),
      ),
    );

    return result;
  }

  List<Widget> _buildTabItems(BuildContext context) {
    final List<Widget> result = <Widget>[];

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          context,
          Expanded(
            child: Semantics(
              selected: active,
              // TODO(xster): This needs localization support. https://github.com/flutter/flutter/issues/13452
              hint: 'tab, ${index + 1} of ${items.length}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null ? null : () { onTap(index); },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildSingleTabItem(items[index], active),
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildSingleTabItem(TabBarItem item, bool active) {
    return <Widget>[
      Expanded(
        child: Center(child: active ? item.activeIcon : item.icon),
      ),
      if (item.title != null) item.title,
    ];
  }

  /// Change the active tab item's icon and title colors to active.
  Widget _wrapActiveItem(BuildContext context, Widget item, { @required bool active }) {
    if (!active)
      return item;

    final Color activeColor = DynamicColor.resolve(
      this.activeColor ?? CupertinoTheme.of(context).primaryColor,
      context,
    );
    return IconTheme.merge(
      data: IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: activeColor),
        child: item,
      ),
    );
  }

  /// Create a clone of the current [TabBar] but with provided
  /// parameters overridden.
  TabBar copyWith({
    Key key,
    List<TabBarItem> items,
    Color backgroundColor,
    Color activeColor,
    Color inactiveColor,
    Size iconSize,
    Border border,
    int currentIndex,
    ValueChanged<int> onTap,
  }) {
    return TabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
    );
  }
}
