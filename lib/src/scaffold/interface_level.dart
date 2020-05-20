import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum CupertinoUserInterfaceLevelData {
  base,
  elevated,
}

class CupertinoUserInterfaceLevel extends InheritedWidget {
  const CupertinoUserInterfaceLevel({
    Key key,
    @required CupertinoUserInterfaceLevelData data,
    Widget child,
  })  : assert(data != null),
        _data = data,
        super(key: key, child: child);

  final CupertinoUserInterfaceLevelData _data;

  @override
  bool updateShouldNotify(CupertinoUserInterfaceLevel oldWidget) =>
      oldWidget._data != _data;

  static CupertinoUserInterfaceLevelData of(BuildContext context,
      {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final CupertinoUserInterfaceLevel query = context
        .dependOnInheritedWidgetOfExactType<CupertinoUserInterfaceLevel>();
    if (query != null) return query._data;
    if (nullOk) return null;
    throw FlutterError(
        'CupertinoUserInterfaceLevel.of() called with a context that does not contain a CupertinoUserInterfaceLevel.\n'
        'No CupertinoUserInterfaceLevel ancestor could be found starting from the context that was passed '
        'to CupertinoUserInterfaceLevel.of(). This can happen because you do not have a WidgetsApp or '
        'MaterialApp widget (those widgets introduce a CupertinoUserInterfaceLevel), or it can happen '
        'if the context you use comes from a widget above those widgets.\n'
        'The context used was:\n'
        '  $context');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<CupertinoUserInterfaceLevelData>(
        'user interface level', _data));
  }
}
