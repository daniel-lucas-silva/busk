import 'package:flutter/widgets.dart';

abstract class ChangeableField<T> extends FormField<T> {
  ChangeableField({this.onChanged});

  final ValueChanged<T> onChanged;
}

class ChangeableFieldState<T> extends FormFieldState<T> {
  T value;

  @override
  void initState() {
    super.initState();
    setState(() {
      value = widget.initialValue;
    });
  }

  @override
  ChangeableField<T> get widget => super.widget;

  @override
  void reset() {
    super.reset();
    setState(() {
      value = widget.initialValue;
    });
  }

  @override
  void didChange(T newValue) {
    super.didChange(newValue);
    if(!widget.autovalidate)
      validate();
    setState(() {
      value = newValue;
      print(newValue);
    });
    if (widget.onChanged != null) {
      widget.onChanged(newValue);
    }
  }
}