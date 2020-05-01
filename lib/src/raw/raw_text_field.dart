import 'dart:io';
import 'dart:ui';

import 'package:busk/src/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../feedback.dart';
import '../icons.dart';
import '../text_selection.dart';

enum DecorationVisibilityMode {
  never,
  editing,
  notEditing,
  always,
}

class TextFieldDecoration {
  final String placeholder;
  final String error;
  final Widget prefix;
  final Widget suffix;
  final DecorationVisibilityMode prefixMode;
  final DecorationVisibilityMode suffixMode;
  final DecorationVisibilityMode clearButtonMode;

  const TextFieldDecoration({
    this.placeholder,
    this.error,
    this.prefix,
    this.suffix,
    this.prefixMode: DecorationVisibilityMode.always,
    this.suffixMode: DecorationVisibilityMode.always,
    this.clearButtonMode: DecorationVisibilityMode.never,
  });

  TextFieldDecoration copyWith({
    String placeholder,
    String error,
    Widget prefix,
    Widget suffix,
    DecorationVisibilityMode prefixMode,
    DecorationVisibilityMode suffixMode,
    DecorationVisibilityMode clearButtonMode,
  }) {
    return TextFieldDecoration(
      placeholder: placeholder ?? this.placeholder,
      error: error ?? this.error,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      prefixMode: prefixMode ?? this.prefixMode,
      suffixMode: suffixMode ?? this.suffixMode,
      clearButtonMode: clearButtonMode ?? this.clearButtonMode,
    );
  }
}

class TextFieldActions {
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final VoidCallback onTap;
  final ValueChanged<String> onSubmitted;

  const TextFieldActions({
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onSubmitted,
  });

  TextFieldActions copyWith({
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    VoidCallback onTap,
    ValueChanged<String> onSubmitted,
  }) {
    return TextFieldActions(
      onChanged: onChanged ?? this.onChanged,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onTap: onTap ?? this.onTap,
      onSubmitted: onSubmitted ?? this.onSubmitted,
    );
  }
}

class TextFieldSettings {
  final int maxLines;
  final int minLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final Brightness keyboardAppearance;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool readOnly;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final bool expands;
  final bool showCursor;

  const TextFieldSettings({
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.keyboardAppearance,
    TextInputType keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.readOnly = false,
    this.expands = false,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.showCursor,
  })  : assert(textAlign != null),
        assert(readOnly != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
        (maxLines == null) || (minLines == null) || (maxLines >= minLines),
        "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
        !expands || (maxLines == null && minLines == null),
        'minLines and maxLines must be null when expands is true.',
        ),
        assert(maxLengthEnforced != null),
        assert(maxLength == null || maxLength > 0),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline);

  TextFieldSettings copyWith({
    int maxLines,
    int minLines,
    int maxLength,
    bool maxLengthEnforced,
    Brightness keyboardAppearance,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    TextCapitalization textCapitalization,
    TextAlign textAlign,
    TextAlignVertical textAlignVertical,
    bool readOnly,
    double cursorWidth,
    Radius cursorRadius,
    Color cursorColor,
    bool expands,
    bool showCursor,
  }) {
    return TextFieldSettings(
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      maxLength: maxLength ?? this.maxLength,
      maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      readOnly: readOnly ?? this.readOnly,
      expands: expands ?? this.expands,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      showCursor: showCursor ?? this.showCursor,
    );
  }
}

class TextFieldBehavior {
  final bool obscureText;
  final bool autoFocus;
  final bool autoCorrect;
  final bool enableInteractiveSelection;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final ToolbarOptions toolbarOptions;
  final List<TextInputFormatter> inputFormatters;
  final DragStartBehavior dragStartBehavior;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;
  final EdgeInsets scrollPadding;
  final bool enableSuggestions;

  const TextFieldBehavior({
    this.obscureText = false,
    this.autoFocus = false,
    this.autoCorrect = true,
    this.enableInteractiveSelection = true,
    SmartDashesType smartDashesType,
    SmartQuotesType smartQuotesType,
    ToolbarOptions toolbarOptions,
    this.inputFormatters,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableSuggestions = true,
  })  : assert(obscureText != null),
        assert(autoFocus != null),
        assert(autoCorrect != null),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(enableSuggestions != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
              selectAll: true,
              paste: true,
            )
                : const ToolbarOptions(
              copy: true,
              cut: true,
              selectAll: true,
              paste: true,
            ));

  TextFieldBehavior copyWith({
    bool obscureText,
    bool autoFocus,
    bool autoCorrect,
    bool enableInteractiveSelection,
    SmartDashesType smartDashesType,
    SmartQuotesType smartQuotesType,
    ToolbarOptions toolbarOptions,
    List<TextInputFormatter> inputFormatters,
    DragStartBehavior dragStartBehavior,
    ScrollController scrollController,
    ScrollPhysics scrollPhysics,
    EdgeInsets scrollPadding,
    bool enableSuggestions,
  }) {
    return TextFieldBehavior(
      obscureText: obscureText ?? this.obscureText,
      autoFocus: autoFocus ?? this.autoFocus,
      autoCorrect: autoCorrect ?? this.autoCorrect,
      enableInteractiveSelection:
      enableInteractiveSelection ?? this.enableInteractiveSelection,
      smartDashesType: smartDashesType ?? this.smartDashesType,
      smartQuotesType: smartQuotesType ?? this.smartQuotesType,
      toolbarOptions: toolbarOptions ?? this.toolbarOptions,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      scrollController: scrollController ?? this.scrollController,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
    );
  }
}

class _SelectionDetectorBuilder extends TextSelectionGestureDetectorBuilder {
  _SelectionDetectorBuilder({
    @required _TextFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _TextFieldState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      if (Platform.isIOS) {
        renderEditable.selectPositionAt(
          from: details.globalPosition,
          cause: SelectionChangedCause.longPress,
        );
      } else {
        renderEditable.selectWordsInRange(
          from: details.globalPosition - details.offsetFromOrigin,
          to: details.globalPosition,
          cause: SelectionChangedCause.longPress,
        );
      }
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      if (Platform.isIOS)
        renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
      else
        renderEditable.selectPosition(cause: SelectionChangedCause.tap);
    }
    _state._requestKeyboard();
    if (_state.widget.actions.onTap != null) _state.widget.actions.onTap();
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      if (Platform.isIOS) {
        renderEditable.selectPositionAt(
          from: details.globalPosition,
          cause: SelectionChangedCause.longPress,
        );
      } else {
        renderEditable.selectWord(cause: SelectionChangedCause.longPress);
        Feedback.forLongPress(_state.context);
      }
    }
  }
}

const Color _kPrimaryLabel = Color.fromRGBO(255, 255, 255, 1.0);
const Color _kSecondaryLabel = Color.fromRGBO(235, 235, 245, 0.6);
const Color _kPrimary = Color(0xFFFBC02D);
const Color _kInactive = Color(0xFF757575);
const Color _kDanger = Color(0xFFFD5739);

const TextStyle _kStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 17.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: _kPrimaryLabel,
);

const TextStyle _kErrorStyle = TextStyle(
  inherit: false,
  fontFamily: '.SF Pro Text',
  fontSize: 10.0,
  letterSpacing: -0.41,
  fontWeight: FontWeight.w400,
  color: _kDanger,
);

const Color _kClearButtonColor = Color(0xFFAEAEB2);

class RemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const RemoveButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          CupertinoIcons.minus_circled_filled,
          size: 20.0,
          color: _kDanger,
        ),
      ),
    );
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
        style:
        _kStyle.copyWith(color: CupertinoColors.placeholderText.darkColor),
      );
    return null;
  }

  Widget _getPrefix(TextEditingValue text, [bool hasError = false]) {
    if (_showPrefixWidget(text)) {
      final bool hasFocus = _effectiveFocusNode.hasFocus;
      Color color = hasFocus ? _kPrimary : _kPrimaryLabel;
      color = widget.enabled ? color : _kSecondaryLabel;

      return IconTheme(
        data: IconThemeData(size: 24.0, color: color),
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _kStyle.copyWith(color: color),
          child: widget.decoration.prefix,
        ),
      );
    }

    return null;
  }

  Widget _getSuffix(TextEditingValue text) {
    if (_showSuffixWidget(text)) {
      return IconTheme(
        data: IconThemeData(size: 24.0, color: _kSecondaryLabel),
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _kStyle.copyWith(color: _kSecondaryLabel),
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
        style: _kStyle,
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
        selectionColor: _kPrimary.withOpacity(0.2),
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
        cursorColor: _kPrimary,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: _kInactive,
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
              child: IgnorePointer(
                ignoring: !_isEnabled,
                child: _selectionGestureDetectorBuilder.buildGestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: child,
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
          controller.selection = TextSelection.collapsed(offset: controller.text.length);
        _requestKeyboard();
      },
      child: child,
    );
  }
}