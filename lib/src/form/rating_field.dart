import 'package:flutter/widgets.dart';

import '../icons.dart';
import '../theme/colors.dart';
import '../rating_bar.dart';
import '../table_view/cell.dart';

import '_changeable_field.dart';

part 'rating_field.g.dart';

class RatingFormField extends FormField<double> implements ChangeableField<double> {

  RatingFormField({
    Key key,
    double initialValue,
    this.onChanged,
    FormFieldSetter<double> onSaved,
    FormFieldValidator<double> validator,
    bool enabled = true,
    bool autoValidate = false,
    RatingSettings settings,
    @required String label,
  }) : super(
    key: key,
    initialValue: initialValue ?? 0,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autoValidate,
    enabled: enabled,
    builder: (FormFieldState<double> field) {
      final RatingSettings effectiveSettings = (settings ?? const RatingSettings());
      var currentValue = field.value ?? initialValue;

      return Cell.field(
        title: Text(label),
        error: field.errorText,
        trailing: RatingBar(
          initialRating: currentValue,
          direction: effectiveSettings.direction,
          allowHalfRating: effectiveSettings.allowHalfRating,
          itemCount: effectiveSettings.itemCount,
          tapOnlyMode: effectiveSettings.tapOnlyMode,
          itemSize: effectiveSettings.itemSize,
          itemBuilder: (context, v) => effectiveSettings.icon,
          onRatingUpdate: field.didChange,
        ),
        disclosure: false,
      );
    },
  );

  final ValueChanged<double> onChanged;

  @override
  ChangeableFieldState<double> createState() => ChangeableFieldState<double>();
}