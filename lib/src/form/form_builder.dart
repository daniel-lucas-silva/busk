import 'package:flutter/widgets.dart';

import '../dialog.dart';
import '../scaffold/route.dart';

typedef SaveCallback = bool Function();
typedef FormWidgetBuilder = Widget Function(
  BuildContext context,
  SaveCallback save,
  VoidCallback reset,
);

class FormBuilder extends StatefulWidget {
  final bool autoValidate;
  final FormWidgetBuilder builder;
  final VoidCallback onChanged;
  final VoidCallback onSaved;

  FormBuilder({
    Key key,
    this.builder,
    this.onChanged,
    this.onSaved,
    this.autoValidate: false,
  }) : super(key: key);

  @override
  _FormBuilderState createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _validateSave() {
    if(_key.currentState.validate()) {
      _key.currentState.save();
      if(widget.onSaved != null) widget.onSaved();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      onChanged: widget.onChanged,
      autovalidate: widget.autoValidate,
      child: Builder(builder: (context) {
        return widget.builder(
          context,
          _validateSave,
          _key.currentState.reset,
        );
      }),
    );
  }
}
