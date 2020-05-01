part of "text_field.dart";

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
