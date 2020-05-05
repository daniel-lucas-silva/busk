import 'dart:math' as math;
import 'dart:io' show Platform;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import '../../theme.dart';
import '../text_selection.dart';
import '../feedback.dart';
import '../theme/colors.dart';
import '../utils/extensions.dart';
import '../icons.dart';
import '../constants.dart';

import '_changeable_field.dart';

part 'text_field.g.dart';

part 'text_field.r.dart';

class TextFormField extends FormField<String>
    implements ChangeableField<String> {
  TextFormField({
    Key key,
    this.controller,
    this.onChanged,
    String initialValue,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    bool autoValidate = false,
    bool enabled = true,
    FocusNode focusNode,
    TextStyle style,
    StrutStyle strutStyle,
    String placeholder,
    TextFieldDecoration decoration,
    TextFieldSettings settings = const TextFieldSettings(),
    TextFieldBehavior behavior = const TextFieldBehavior(),
    TextFieldActions actions = const TextFieldActions(),
  })  : assert(initialValue == null || controller == null),
        assert(autoValidate != null),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            final TextFieldDecoration effectiveDecoration =
                (decoration ?? const TextFieldDecoration())
                    .copyWith(placeholder: placeholder);

//            void onChangedHandler(String value) {
//              if (actions.onChanged != null) {
//                actions.onChanged(value);
//              }
//              field.didChange(value);
//            }

            return _TextField(
              controller: state._effectiveController,
              focusNode: focusNode,
              style: style,
              strutStyle: strutStyle,
              decoration: effectiveDecoration.copyWith(error: field.errorText),
              enabled: enabled,
              settings: settings,
              behavior: behavior,
              actions: actions.copyWith(onChanged: (String value) {
                if (actions.onChanged != null) {
                  actions.onChanged(value);
                }
                field.didChange(value);
              }),
            );
          },
        );

  final TextEditingController controller;

  @override
  _TextFormFieldState createState() => _TextFormFieldState();

  final ValueChanged<String> onChanged;
}

class _TextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  TextFormField get widget => super.widget as TextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }

  @override
  void didChange(String newValue) {
    super.didChange(newValue);
    if (!widget.autovalidate) validate();
    if (widget.onChanged != null) {
      widget.onChanged(newValue);
    }
  }
}

class _TextField extends StatefulWidget {
  const _TextField({
    Key key,
    this.initialValue,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.decoration = const TextFieldDecoration(),
    this.style,
    this.strutStyle,
    this.settings = const TextFieldSettings(),
    this.behavior = const TextFieldBehavior(),
    this.actions = const TextFieldActions(),
  }) : super(key: key);

  final TextEditingController controller;
  final String initialValue;
  final bool enabled;
  final FocusNode focusNode;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextFieldDecoration decoration;
  final TextFieldSettings settings;
  final TextFieldBehavior behavior;
  final TextFieldActions actions;

  bool get selectionEnabled => behavior.enableInteractiveSelection;

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField>
    with AutomaticKeepAliveClientMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey _clearGlobalKey = GlobalKey();

  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  FocusNode _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

//  bool get needsCounter => widget.maxLength != null
//      && widget.decoration != null
//      && widget.decoration.counterText == null;

  bool _showSelectionHandles = false;

  _SelectionDetectorBuilder _selectionGestureDetectorBuilder;

  @override
  bool get wantKeepAlive => _effectiveController?.text?.isNotEmpty == true;

  @override
  bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  bool get _isEnabled => widget.enabled ?? true;

  int get _currentLength => _effectiveController.value.text.runes.length;

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder = _SelectionDetectorBuilder(state: this);
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
      _controller.addListener(updateKeepAlive);
    }
  }

  @override
  void didUpdateWidget(_TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
      _controller.addListener(updateKeepAlive);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller = null;
    }
    final bool isEnabled = widget.enabled ?? true;
    final bool wasEnabled = oldWidget.enabled ?? true;
    if (wasEnabled && !isEnabled) {
      _effectiveFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller?.removeListener(updateKeepAlive);
    super.dispose();
  }

  EditableTextState get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar)
      return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (widget.settings.readOnly && _effectiveController.selection.isCollapsed)
      return false;

    if (cause == SelectionChangedCause.longPress) return true;

    if (_effectiveController.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    if (Platform.isIOS) {
      if (cause == SelectionChangedCause.longPress) {
        _editableText?.bringIntoView(selection.base);
      }
      return;
    }
  }

  bool _shouldShowAttachment(
      {DecorationVisibilityMode attachment, bool hasText}) {
    switch (attachment) {
      case DecorationVisibilityMode.never:
        return false;
      case DecorationVisibilityMode.always:
        return true;
      case DecorationVisibilityMode.editing:
        return widget.enabled ? hasText : false;
      case DecorationVisibilityMode.notEditing:
        return !hasText;
    }
    assert(false);
    return null;
  }

  bool _showPlaceholderWidget(TextEditingValue text) {
    final decoration = widget.decoration;
    return decoration.placeholder != null && text.text.isEmpty;
  }

  bool _showPrefixWidget(TextEditingValue text) {
    final decoration = widget.decoration;
    return decoration.prefix != null &&
        _shouldShowAttachment(
          attachment: decoration.prefixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showSuffixWidget(TextEditingValue text) {
    final decoration = widget.decoration;
    return decoration.suffix != null &&
        _shouldShowAttachment(
          attachment: decoration.suffixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showClearButton(TextEditingValue text) {
    return _shouldShowAttachment(
      attachment: widget.decoration.clearButtonMode,
      hasText: text.text.isNotEmpty,
    );
  }

//  bool get _hasDecoration {
//    final decoration = widget.decoration;
//
//    return decoration.placeholder != null ||
//        decoration.clearButtonMode != DecorationVisibilityMode.never ||
//        decoration.prefix != null ||
//        decoration.suffix != null;
//  }

//  TextAlignVertical get _textAlignVertical {
//    if (widget.textAlignVertical != null) {
//      return widget.textAlignVertical;
//    }
//    return _hasDecoration ? TextAlignVertical.center : TextAlignVertical.top;
//  }

  Widget _getPlaceholder(TextEditingValue text) {
    if (_showPlaceholderWidget(text))
      return Text(
        widget.decoration.placeholder,
        textAlign: widget.settings.textAlign,
        style: CupertinoTheme.of(context)
            .textTheme
            .body
            .copyWith(color: Colors.placeholderText.darkColor),
      );
    return null;
  }

  Widget _getPrefix(TextEditingValue text, [bool hasError = false]) {
    if (_showPrefixWidget(text)) {
      final bool hasFocus = _effectiveFocusNode.hasFocus;
      Color color = hasFocus ? CupertinoTheme.of(context).primaryColor : Colors.label.resolveFrom(context);
      color = widget.enabled ? color : Colors.secondaryLabel.resolveFrom(context);

      return IconTheme(
        data: IconThemeData(size: 24.0, color: color),
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: CupertinoTheme.of(context)
              .textTheme
              .body.copyWith(color: color),
          child: widget.decoration.prefix,
        ),
      );
    }

    return null;
  }

  Widget _getSuffix(TextEditingValue text) {
    if (_showSuffixWidget(text)) {
      return IconTheme(
        data: IconThemeData(size: 24.0, color: Colors.secondaryLabel.resolveFrom(context)),
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: CupertinoTheme.of(context)
              .textTheme
              .body.copyWith(color: Colors.secondaryLabel.resolveFrom(context)),
          child: widget.decoration.suffix,
        ),
      );
    } else if (_showClearButton(text)) {
      return GestureDetector(
        key: _clearGlobalKey,
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ?? true
            ? () {
                final bool textChanged = _effectiveController.text.isNotEmpty;
                _effectiveController.clear();
                if (widget.actions.onChanged != null && textChanged)
                  widget.actions.onChanged(_effectiveController.text);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            CupertinoIcons.clear_thick_circled,
            size: 18.0,
            color: _kClearButtonColor,
          ),
        ),
      );
    }
    return null;
  }

  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assert(debugCheckHasDirectionality(context));
    final Brightness keyboardAppearance = Brightness.dark;
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final List<TextInputFormatter> formatters =
        widget.behavior.inputFormatters ?? [];
    if (widget.settings.maxLength != null && widget.settings.maxLengthEnforced)
      formatters
          .add(LengthLimitingTextInputFormatter(widget.settings.maxLength));

    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    Radius cursorRadius = widget.settings.cursorRadius;

    if (Platform.isIOS) {
      forcePressEnabled = true;
      paintCursorAboveText = true;
      cursorOpacityAnimates = true;
      cursorRadius ??= const Radius.circular(2.0);
      cursorOffset = Offset(iOSHorizontalOffset / devicePixelRatio, 0);
    } else {
      forcePressEnabled = false;
      paintCursorAboveText = false;
      cursorOpacityAnimates = false;
    }

    Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        readOnly: widget.settings.readOnly,
        toolbarOptions: widget.behavior.toolbarOptions,
        showCursor: widget.settings.showCursor,
        showSelectionHandles: _showSelectionHandles,
        controller: controller,
        focusNode: focusNode,
        keyboardType: widget.settings.keyboardType,
        textInputAction: widget.settings.textInputAction,
        textCapitalization: widget.settings.textCapitalization,
        style: CupertinoTheme.of(context).textTheme.body,
        strutStyle: widget.strutStyle,
        textAlign: widget.settings.textAlign,
        textDirection: TextDirection.ltr,
        autofocus: widget.behavior.autoFocus,
        obscureText: widget.behavior.obscureText,
        autocorrect: widget.behavior.autoCorrect,
        smartDashesType: widget.behavior.smartDashesType,
        smartQuotesType: widget.behavior.smartQuotesType,
        enableSuggestions: widget.behavior.enableSuggestions,
        maxLines: widget.settings.maxLines,
        minLines: widget.settings.minLines,
        expands: widget.settings.expands,
        selectionColor: CupertinoTheme.of(context)
            .primaryColor.withOpacity(0.2),
        selectionControls:
            widget.selectionEnabled ? textSelectionControls : null,
        onChanged: widget.actions.onChanged,
        onSelectionChanged: _handleSelectionChanged,
        onEditingComplete: widget.actions.onEditingComplete,
        onSubmitted: widget.actions.onSubmitted,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        inputFormatters: formatters,
        rendererIgnoresPointer: true,
        cursorWidth: widget.settings.cursorWidth,
        cursorRadius: cursorRadius,
        cursorColor: CupertinoTheme.of(context)
            .primaryColor,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: Colors.inactiveGray.resolveFrom(context),
        scrollPadding: widget.behavior.scrollPadding,
        keyboardAppearance: keyboardAppearance,
        enableInteractiveSelection: widget.behavior.enableInteractiveSelection,
        dragStartBehavior: widget.behavior.dragStartBehavior,
        scrollController: widget.behavior.scrollController,
        scrollPhysics: widget.behavior.scrollPhysics,
      ),
    );

    if (widget.decoration != null) {
      final bool hasError = widget.decoration.error != null;

      child = ValueListenableBuilder(
        valueListenable: _effectiveController,
        child: child,
        builder: (BuildContext context, TextEditingValue text, Widget child) {
          return RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 4.0,
                bottom: hasError ? 10.0 : 4.0,
              ),
              child: TextFieldRender(
                type: TextFieldType.DEFAULT,
                placeholder: _getPlaceholder(text),
                prefix: _getPrefix(text, hasError),
                suffix: _getSuffix(text),
                error: widget.decoration.error.toText(null, _kErrorStyle),
                child: IgnorePointer(
                  ignoring: !_isEnabled,
                  child: _selectionGestureDetectorBuilder.buildGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Semantics(
      onTap: () {
        if (!controller.selection.isValid)
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
//        _requestKeyboard();
      },
      child: child,
    );
  }
}
