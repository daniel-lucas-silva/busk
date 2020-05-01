import 'package:flutter/widgets.dart';

import '_changeable_field.dart';

import '../scaffold/page_scaffold.dart';
import '../scaffold/app_bar.dart';
import '../scaffold/route.dart';
import '../table_view/section.dart';
import '../table_view/cell.dart';

part 'picker_field.g.dart';

class PickerFormField<T> extends FormField<List<T>>
    implements ChangeableField<List<T>> {
  PickerFormField({
    Key key,
    List<T> initialValue,
    this.onChanged,
    FormFieldSetter<List<T>> onSaved,
    FormFieldValidator<List<T>> validator,
    Map<T, String> items,
    bool enabled = true,
    bool autoValidate = false,
    bool multiple = true,
    @required String label,
    String description,
  }) : super(
          key: key,
          initialValue:
              initialValue.where((key) => items.containsKey(key)).toList(),
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<List<T>> field) {
            var currentValue = field.value ?? initialValue ?? [];

            void onTap() async {
              FocusScope.of(field.context).unfocus();

              await push(
                field.context,
                _Dialog<T>(
                  title: label,
                  description: description,
                  items: items,
                  selected: currentValue,
                  multiple: multiple,
                  pop: false,
                  onChange: field.didChange,
                ),
              );
            }

            return Cell.field(
              title: Text(label),
              error: field.errorText,
              detail: currentValue.isEmpty
                  ? Text("Selecionar")
                  : Text(currentValue
                      .where((key) => items.containsKey(key))
                      .map<String>((key) => items[key])
                      .join(", ")),
              onTap: onTap,
              disclosure: false,
            );
          },
        );

  final ValueChanged<List<T>> onChanged;

  @override
  ChangeableFieldState<List<T>> createState() =>
      ChangeableFieldState<List<T>>();
}

class SelectFormField<T> extends FormField<T> implements ChangeableField<T> {
  SelectFormField({
    Key key,
    T initialValue,
    this.onChanged,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    Map<T, String> items,
    bool enabled = true,
    bool autoValidate = false,
    bool pop = true,
    @required String label,
    String description,
  }) : super(
          key: key,
          initialValue: items.containsKey(initialValue) ? initialValue : null,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<T> field) {
            var currentValue = field.value ?? initialValue;

            void onTap() async {
              FocusScope.of(field.context).unfocus();

              await push(
                field.context,
                _Dialog<T>(
                  title: label,
                  description: description,
                  items: items,
                  selected: [currentValue],
                  multiple: false,
                  pop: pop,
                  onChange: (v) => field.didChange(v.first),
                ),
              );
            }

            return Cell.field(
              title: Text(label),
              error: field.errorText,
              detail: currentValue == null || !items.containsKey(currentValue)
                  ? Text("Selecionar")
                  : Text(items[currentValue]),
              onTap: onTap,
            );
          },
        );

  final ValueChanged<T> onChanged;

  @override
  ChangeableFieldState<T> createState() => ChangeableFieldState<T>();
}
