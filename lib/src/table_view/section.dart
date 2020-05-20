import 'dart:math' as math;

import 'package:busk/busk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import '../../theme.dart';
import '../constants.dart';
import '../utils/extensions.dart';

part 'section.widgets.dart';

part 'section.decoration.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class Section extends SliverList {
  Section._({
    Key key,
    Widget header,
    Widget footer,
    ChildIndexGetter findChildIndexCallback,
    SemanticIndexCallback semanticIndexCallback: _kDefaultSemanticIndexCallback,
    int semanticIndexOffset: 0,
    bool addSemanticIndexes: true,
    bool addRepaintBoundaries: true,
    bool addAutomaticKeepAlives: true,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
  }) : super(
          key: key,
          delegate: _BuildDelegate(
            header: header,
            footer: footer,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            findChildIndexCallback: findChildIndexCallback,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
          ),
        );

  factory Section({
    Widget header,
    Widget footer,
    List<Widget> children,
  }) {
    assert(children != null);
    return Section._(
      header: header,
      footer: footer,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  factory Section.dynamic({
    Widget header,
    Widget description,
    @required int itemCount,
    @required IndexedWidgetBuilder itemBuilder,
  }) {
    assert(itemBuilder != null);
    assert(itemCount != null);

    return Section._(
      header: header,
      footer: description,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}

class _BuildDelegate extends SliverChildDelegate {
  const _BuildDelegate({
    @required this.itemBuilder,
    @required this.itemCount,
    this.header,
    this.footer,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  })  : assert(itemBuilder != null),
        assert(itemCount != null),
        assert(addAutomaticKeepAlives != null),
        assert(addRepaintBoundaries != null),
        assert(addSemanticIndexes != null),
        assert(semanticIndexCallback != null);

  final Widget header;
  final Widget footer;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final ChildIndexGetter findChildIndexCallback;

  Widget buildFooter(BuildContext context) {
    Widget content;

    if (footer is Text || footer is Row)
      content = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.footnote,
        child: Container(
          padding: EdgeInsets.only(
            bottom: 5.0,
            top: 5.0,
            left: 16.0,
            right: 16.0,
          ),
          alignment: Alignment.topLeft,
          constraints: const BoxConstraints(minHeight: 38.0),
          child: footer,
        ),
      );
    else if(footer != null)
      content = footer;
    else
      content = SizedBox(height: 10.0);

    final dividerThickness = kDividerThickness / MediaQuery.of(context).devicePixelRatio;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        content,
        Positioned(
          top: -dividerThickness,
          height: dividerThickness,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.divider.resolveFrom(context)
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    Widget content;
    if (header is Text || header is Row)
      content = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.footnote,
        child: Container(
          padding: EdgeInsets.only(
            bottom: 5.0,
            top: 5.0,
            left: 16.0,
            right: 16.0,
          ),
          alignment: Alignment.bottomLeft,
          constraints: const BoxConstraints(minHeight: 38.0),
          child: header,
        ),
      );
    else if(header != null)
      content = header;
    else
      content = SizedBox(height: 36.0);

    final dividerThickness = kDividerThickness / MediaQuery.of(context).devicePixelRatio;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        content,
        Positioned(
          bottom: 0,
          height: dividerThickness,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.divider.resolveFrom(context)
            ),
          ),
        ),
      ],
    );
  }

  @override
  int findIndexByKey(Key key) {
    if (findChildIndexCallback == null) return null;
    assert(key != null);
    Key childKey;
    if (key is _SaltedValueKey) {
      final _SaltedValueKey saltedValueKey = key;
      childKey = saltedValueKey.value;
    } else {
      childKey = key;
    }
    return findChildIndexCallback(childKey);
  }

  @override
  Widget build(BuildContext context, int index) {
    assert(itemBuilder != null);

    if (index < 0 || (itemCount != null && index >= itemCount + 2)) return null;

    if (index == 0) return itemCount == 0 ? Offstage() : buildHeader(context);

    index -= 1;

    if (index == itemCount)
      return itemCount == 0 ? Offstage() : buildFooter(context);

    Widget child;
    try {
      child = itemBuilder(context, index);
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    if (child == null) return null;
    final Key key = child.key != null ? _SaltedValueKey(child.key) : null;
    if (addRepaintBoundaries) child = RepaintBoundary(child: child);
    if (addSemanticIndexes) {
      final int semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null)
        child = IndexedSemantics(
            index: semanticIndex + semanticIndexOffset, child: child);
    }
    if (addAutomaticKeepAlives) child = AutomaticKeepAlive(child: child);
    return KeyedSubtree(child: child, key: key);
  }

  @override
  int get estimatedChildCount => itemCount + 2;

  @override
  bool shouldRebuild(covariant _BuildDelegate oldDelegate) => true;
}

class _SaltedValueKey extends ValueKey<Key> {
  const _SaltedValueKey(Key key)
      : assert(key != null),
        super(key);
}

Widget _createErrorWidget(dynamic exception, StackTrace stackTrace) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stackTrace,
    library: 'widgets library',
    context: ErrorDescription('building'),
  );
  FlutterError.reportError(details);
  return ErrorWidget.builder(details);
}
