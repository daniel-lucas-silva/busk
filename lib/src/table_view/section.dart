import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import '../utils/extensions.dart';

part 'section.widgets.dart';

part 'section.decoration.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

typedef _IndexedCellBuilder = Widget Function(BuildContext context, int index);

class Section extends StatelessWidget {
  final List<Widget> children;
  final TestSectionHeader header;
  final TestSectionDescription description;

  const Section({
    Key key,
    this.header: const TestSectionHeader(null),
    this.description: const TestSectionDescription(null),
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        header,
        ...children,
        description,
      ],
    );
  }
}

class SliverSection extends SliverList {
  SliverSection._({
    Key key,
    TestSectionHeader header,
    TestSectionDescription description,
    ChildIndexGetter findChildIndexCallback,
    SemanticIndexCallback semanticIndexCallback: _kDefaultSemanticIndexCallback,
    int semanticIndexOffset: 0,
    bool addSemanticIndexes: true,
    bool addRepaintBoundaries: true,
    bool addAutomaticKeepAlives: true,
    @required _IndexedCellBuilder itemBuilder,
    @required int itemCount,
  }) : super(
          key: key,
          delegate: _BuildDelegate(
            header: header,
            description: description,
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

  factory SliverSection({
    TestSectionHeader header: const TestSectionHeader(null),
    TestSectionDescription description: const TestSectionDescription(null),
    List<Widget> children,
  }) {
    assert(children != null);
    return SliverSection._(
      header: header,
      description: description,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  factory SliverSection.dynamic({
    TestSectionHeader header: const TestSectionHeader(null),
    TestSectionDescription description: const TestSectionDescription(null),
    @required int itemCount,
    @required _IndexedCellBuilder itemBuilder,
  }) {
    assert(itemBuilder != null);
    assert(itemCount != null);

    return SliverSection._(
      header: header,
      description: description,
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
    this.description,
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

  final TestSectionHeader header;
  final TestSectionDescription description;
  final _IndexedCellBuilder itemBuilder;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final ChildIndexGetter findChildIndexCallback;

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

    if (index == 0)
      return itemCount == 0 ? Offstage() : header;

    index -= 1;

    if (index == itemCount)
      return itemCount == 0 ? Offstage() : description;

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
