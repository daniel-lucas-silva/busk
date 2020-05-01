import 'package:flutter/widgets.dart';

import '../table_view/section.dart';
import '../table_view/cell.dart';
import '_changeable_field.dart';

class RadioFormField<T> extends FormField<T> implements ChangeableField<T> {
  RadioFormField({
    Key key,
    T initialValue,
    this.onChanged,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    bool enabled = true,
    bool autoValidate = false,
    @required Map<T, String> items,
    @required String label,
    String description,
  })  : assert(items != null),
        super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<T> field) {
            var currentValue = field.value ?? initialValue;

            return Section(
              header: TestSectionHeader(label),
              description: TestSectionDescription(
                field.errorText ?? description,
                isError: field.errorText != null,
              ),
              children: items.keys.map((i) {
                return Cell(
                  child: Text(items[i]),
                  checked: i == currentValue,
                  disclosure: false,
                  onTap: () => field.didChange(i),
                );
              }).toList(),
            );
          },
        );

  final ValueChanged<T> onChanged;

  @override
  ChangeableFieldState<T> createState() => ChangeableFieldState<T>();
}
