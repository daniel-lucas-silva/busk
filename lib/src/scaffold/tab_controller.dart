import 'dart:math' as math;

import 'package:flutter/widgets.dart';

const Duration kTabScrollDuration = Duration(milliseconds: 300);

class TabController extends ChangeNotifier {
  TabController(
      {int initialIndex = 0,
      @required this.length,
      @required TickerProvider vsync})
      : assert(length != null && length >= 0),
        assert(initialIndex != null &&
            initialIndex >= 0 &&
            (length == 0 || initialIndex < length)),
        _index = initialIndex,
        _previousIndex = initialIndex,
        _animationController = AnimationController.unbounded(
          value: initialIndex.toDouble(),
          vsync: vsync,
        );

  TabController._({
    int index,
    int previousIndex,
    AnimationController animationController,
    @required this.length,
  })  : _index = index,
        _previousIndex = previousIndex,
        _animationController = animationController;

  TabController _copyWith({int index, int length, int previousIndex}) {
    return TabController._(
      index: index ?? _index,
      length: length ?? this.length,
      animationController: _animationController,
      previousIndex: previousIndex ?? _previousIndex,
    );
  }

  Animation<double> get animation => _animationController?.view;
  AnimationController _animationController;

  final int length;

  void _changeIndex(int value, {Duration duration, Curve curve}) {
    assert(value != null);
    assert(value >= 0 && (value < length || length == 0));
    assert(duration != null || curve == null);
    assert(_indexIsChangingCount >= 0);
    if (value == _index || length < 2) return;
    _previousIndex = index;
    _index = value;
    if (duration != null) {
      _indexIsChangingCount += 1;
      notifyListeners();
      _animationController
          .animateTo(_index.toDouble(), duration: duration, curve: curve)
          .whenCompleteOrCancel(() {
        _indexIsChangingCount -= 1;
        notifyListeners();
      });
    } else {
      _indexIsChangingCount += 1;
      _animationController.value = _index.toDouble();
      _indexIsChangingCount -= 1;
      notifyListeners();
    }
  }

  int get index => _index;
  int _index;

  set index(int value) {
    _changeIndex(value);
  }

  int get previousIndex => _previousIndex;
  int _previousIndex;

  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;

  void animateTo(int value,
      {Duration duration = kTabScrollDuration, Curve curve = Curves.ease}) {
    _changeIndex(value, duration: duration, curve: curve);
  }

  double get offset => _animationController.value - _index.toDouble();

  set offset(double value) {
    assert(value != null);
    assert(value >= -1.0 && value <= 1.0);
    assert(!indexIsChanging);
    if (value == offset) return;
    _animationController.value = value + _index.toDouble();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }
}

class _TabControllerScope extends InheritedWidget {
  const _TabControllerScope({
    Key key,
    this.controller,
    this.enabled,
    Widget child,
  }) : super(key: key, child: child);

  final TabController controller;
  final bool enabled;

  @override
  bool updateShouldNotify(_TabControllerScope old) {
    return enabled != old.enabled || controller != old.controller;
  }
}

class DefaultTabController extends StatefulWidget {
  const DefaultTabController({
    Key key,
    @required this.length,
    this.initialIndex = 0,
    @required this.child,
  })  : assert(initialIndex != null),
        assert(length >= 0),
        assert(length == 0 || (initialIndex >= 0 && initialIndex < length)),
        super(key: key);

  final int length;

  final int initialIndex;

  final Widget child;

  static TabController of(BuildContext context) {
    final _TabControllerScope scope =
        context.dependOnInheritedWidgetOfExactType<_TabControllerScope>();
    return scope?.controller;
  }

  @override
  _DefaultTabControllerState createState() => _DefaultTabControllerState();
}

class _DefaultTabControllerState extends State<DefaultTabController>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: widget.length,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TabControllerScope(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(DefaultTabController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      int newIndex;
      int previousIndex = _controller.previousIndex;
      if (_controller.index >= widget.length) {
        newIndex = math.max(0, widget.length - 1);
        previousIndex = _controller.index;
      }
      _controller = _controller._copyWith(
        length: widget.length,
        index: newIndex,
        previousIndex: previousIndex,
      );
    }
  }
}
