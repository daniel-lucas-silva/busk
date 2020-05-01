import 'package:flutter/widgets.dart';

import '../icons.dart';
import '../theme/colors.dart';
import '../table_view/cell.dart';
import '../utils/uid.dart';

class ArrayFormBuilder<T> extends StatefulWidget {
  final int itemCount;
  final Widget Function(
    T initialValue,
    Key key,
    int index,
    VoidCallback remove,
  ) itemBuilder;
  final T Function(int) valueBuilder;
  final void Function(int) onRemove;
  final String labelText;

  const ArrayFormBuilder({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    this.valueBuilder,
    this.onRemove,
    this.labelText,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        super(key: key);

  @override
  _ArrayFormBuilderState<T> createState() => _ArrayFormBuilderState<T>();
}

class _ArrayFormBuilderState<T> extends State<ArrayFormBuilder<T>> {
  List<String> _items;
  Map<int, T> _initialValue = {};

  @override
  void initState() {
    _items = List<String>.generate(widget.itemCount, (i) => generateID());
    if (widget.itemCount > 0)
      _initialValue = List(widget.itemCount).asMap().map((index, v) {
        return MapEntry(index, widget.valueBuilder(index));
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, String> items = _items.asMap();

    return FocusScope(
      child: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            ...items.keys.map((k) {
              return widget.itemBuilder(
                _initialValue.containsKey(k) ? _initialValue[k] : null,
                ValueKey(items[k]),
                k,
                () {
                  setState(() {
                    _items.removeAt(k);
                    _initialValue[k] = null;
                  });
                  if(widget.onRemove != null) widget.onRemove(k);
                },
              );
            }),
            Cell(
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  CupertinoIcons.add_circled_solid,
                  size: 20.0,
                  color: CupertinoColors.activeGreen,
                ),
              ),
              child: Text(widget.labelText ?? "Adicionar"),
              onTap: () {
                setState(() {
                  _items.add(generateID());
                });
              },
            ),
          ],
        );
      }),
    );
  }
}
