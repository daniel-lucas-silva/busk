import 'package:flutter/widgets.dart';

import '../table_view/cell.dart';
import '../scaffold/route.dart';
import '../date_picker.dart';
import '../utils/extensions.dart';
import '../utils/bottom_picker.dart';
import '../theme/theme.dart';
import '_changeable_field.dart';

part 'date_field.g.dart';

class DateFormField extends FormField<DateTime> implements ChangeableField<DateTime> {
  DateFormField({
    Key key,
    DateTime initialValue,
    DatePickerSettings settings,
    String pattern,
    this.onChanged,
    bool autoValidate = false,
    bool enabled = true,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    @required String label,
  }) : super(
          key: key,
          initialValue: initialValue ?? DateTime.now(),
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<DateTime> field) {
            final DatePickerSettings effectiveSettings = (settings ?? const DatePickerSettings());
            var currentValue = field.value ?? initialValue;

            void onChangedHandler(DateTime value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            onTap() async {
              FocusScope.of(field.context).unfocus();
              showCupertinoModalPopup<DateTime>(
                context: field.context,
                builder: (BuildContext context) {
                  return BottomPicker(
                    selectText: "Selecionar",
                    onSelect: () {
                      pop(context);
                    },
                    child: CupertinoDatePicker(
                      backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
                      mode: effectiveSettings.mode,
                      maximumDate: effectiveSettings.maximumDate,
                      maximumYear: effectiveSettings.maximumYear,
                      minimumDate: effectiveSettings.minimumDate,
                      minimumYear: effectiveSettings.minimumYear,
                      minuteInterval: effectiveSettings.minuteInterval,
                      use24hFormat: effectiveSettings.use24hFormat,
                      initialDateTime: initialValue ?? DateTime.now(),
                      onDateTimeChanged: onChangedHandler,
                    ),
                  );
                },
              );
            }

            return Cell.field(
              title: Text(label),
              error: field.errorText,
              detail: currentValue == null
                  ? Text("Selecionar")
                  : Text(currentValue.format(pattern)),
              onTap: onTap,
              disclosure: true,
            );
          },
        );

  final ValueChanged<DateTime> onChanged;

  @override
  ChangeableFieldState<DateTime> createState() => ChangeableFieldState<DateTime>();
}