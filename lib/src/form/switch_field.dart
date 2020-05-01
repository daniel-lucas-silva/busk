import 'package:flutter/widgets.dart';

import '../switch.dart';
import '../table_view/cell.dart';
import '_changeable_field.dart';

class SwitchFormField extends FormField<bool> implements ChangeableField<bool> {
  SwitchFormField({
    Key key,
    bool initialValue,
    this.onChanged,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool enabled = true,
    bool autoValidate = false,
    @required String label,
  }) : super(
          key: key,
          initialValue: initialValue ?? false,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<bool> field) {
            var currentValue = field.value ?? initialValue;

            return Cell.field(
              title: Text(label),
              error: field.errorText,
              trailing: CupertinoSwitch(
                value: currentValue,
                onChanged: field.didChange,
              ),
              disclosure: false,
            );
          },
        );

  final ValueChanged<bool> onChanged;

  @override
  ChangeableFieldState<bool> createState() => ChangeableFieldState<bool>();
}
