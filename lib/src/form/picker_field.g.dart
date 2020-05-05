part of 'picker_field.dart';

typedef PickerChangeCallback<T> = void Function(List<T> items);

class PickerDialogSettings {
  final String title;
  final String description;
  final bool multiple;
  final bool pop;

  const PickerDialogSettings({
    this.title,
    this.description,
    this.multiple: false,
    this.pop: false,
  });

  PickerDialogSettings copyWith({
    String title,
    String description,
    bool multiple,
    bool pop,
  }) {
    return PickerDialogSettings(
      title: title ?? this.title,
      description: description ?? this.description,
      multiple: multiple ?? this.multiple,
      pop: pop ?? this.pop,
    );
  }
}

class _Dialog<T> extends StatefulWidget {
  final List<T> selected;
  final Map<T, String> items;
  final PickerChangeCallback<T> onChange;
  final String title;
  final String description;
  final bool multiple;
  final bool pop;

  const _Dialog({
    Key key,
    this.selected,
    this.onChange,
    @required this.items,
    @required this.title,
    this.description,
    this.multiple,
    this.pop: false,
  }) : super(key: key);

  @override
  _DialogState<T> createState() => _DialogState<T>();
}

class _DialogState<T> extends State<_Dialog<T>> {
  List<T> _selected;

  @override
  void initState() {
    _selected = widget.selected ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items.entries.toList();

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            previousPageTitle: "Voltar",
            middle: Text(widget.title),
          ),
          Section.dynamic(
            header: TestSectionHeader(
              widget.description,
              height: widget.description != null ? null : 36.0,
            ),
            description: TestSectionDescription(null, height: 36.0),
            itemCount: items.length, //widget.itemCount,
            itemBuilder: (context, index) {
              final String title = items[index].value;
              final T key = items[index].key;

              return Cell(
                child: Text(title),
                checked: _selected.any((s) => s == key),
                disclosure: false,
                onTap: () {
                  if (_selected.contains(key)) {
                    _selected.remove(key);
                  } else {
                    if (!widget.multiple) _selected.clear();
                    _selected.add(key);
                  }

                  widget.onChange(
                    List<T>.from(
                      items
                          .map((entry) => entry.key)
                          .where((key) => _selected.contains(key)),
                    ),
                  );

                  if (widget.pop) {
                    pop(context, items[index].key);
                    return null;
                  }

                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
