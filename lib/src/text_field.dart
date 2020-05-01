import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'theme/colors.dart';
import 'icons.dart';
import 'text_selection.dart';
import 'theme/theme.dart';
import 'feedback.dart';

export 'package:flutter/services.dart'
    show TextInputType, TextInputAction, TextCapitalization;

const Color _borderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x33000000),
  darkColor: Color(0x33FFFFFF),
);

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: _borderColor,
  style: BorderStyle.solid,
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

final Border _kDefaultRoundedBorderError = Border(
  top: _kDefaultRoundedBorderSide.copyWith(color: CupertinoColors.systemRed),
  bottom: _kDefaultRoundedBorderSide.copyWith(color: CupertinoColors.systemRed),
  left: _kDefaultRoundedBorderSide.copyWith(color: CupertinoColors.systemRed),
  right: _kDefaultRoundedBorderSide.copyWith(color: CupertinoColors.systemRed),
);

const BoxDecoration cupertinoRoundedBorderDecoration = BoxDecoration(
  color: CupertinoColors.textfieldBackground,
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(7.0)),
);

const Color _kDisabledBackground = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFAFAFA),
  darkColor: Color(0xFF050505),
);

const CupertinoDynamicColor _kClearButtonColor =
    CupertinoDynamicColor.withBrightness(
  color: Color(0xFF636366),
  darkColor: Color(0xFFAEAEB2),
);

const int _iOSHorizontalCursorOffsetPixels = -2;
const int _iOSHorizontalOffset = -2;

enum OverlayVisibilityMode {
  never,
  editing,
  notEditing,
  always,
}

class _SelectionDetectorBuilder extends TextSelectionGestureDetectorBuilder {
  _SelectionDetectorBuilder({
    @required _CupertinoTextFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _CupertinoTextFieldState _state;

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
    if (_state.widget.onTap != null) _state.widget.onTap();
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

class CupertinoTextField extends StatefulWidget {
  const CupertinoTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.decoration = const BoxDecoration(),
    this.padding = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
    this.placeholder,
    this.placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    this.prefix,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = OverlayVisibilityMode.always,
    this.clearButtonMode = OverlayVisibilityMode.never,
    TextInputType keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.readOnly = false,
    ToolbarOptions toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.scrollController,
    this.scrollPhysics,
    this.forceLine: true,
    this.textWidthBasis: TextWidthBasis.parent,
  })  : assert(textAlign != null),
        assert(readOnly != null),
        assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          'minLines can\'t be greater than maxLines',
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(clearButtonMode != null),
        assert(prefixMode != null),
        assert(suffixMode != null),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
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
                  )),
        super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final String placeholder;
  final TextStyle placeholderStyle;
  final Widget prefix;
  final OverlayVisibilityMode prefixMode;
  final Widget suffix;
  final OverlayVisibilityMode suffixMode;
  final OverlayVisibilityMode clearButtonMode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final ToolbarOptions toolbarOptions;
  final TextAlignVertical textAlignVertical;
  final bool readOnly;
  final bool showCursor;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final bool forceLine;
  final TextWidthBasis textWidthBasis;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final DragStartBehavior dragStartBehavior;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;
  bool get selectionEnabled => enableInteractiveSelection;
  final GestureTapCallback onTap;

  @override
  _CupertinoTextFieldState createState() => _CupertinoTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'controller', controller,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<BoxDecoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('placeholder', placeholder));
    properties.add(
        DiagnosticsProperty<TextStyle>('placeholderStyle', placeholderStyle));
    properties.add(DiagnosticsProperty<OverlayVisibilityMode>(
        'prefix', prefix == null ? null : prefixMode));
    properties.add(DiagnosticsProperty<OverlayVisibilityMode>(
        'suffix', suffix == null ? null : suffixMode));
    properties.add(DiagnosticsProperty<OverlayVisibilityMode>(
        'clearButtonMode', clearButtonMode));
    properties.add(DiagnosticsProperty<TextInputType>(
        'keyboardType', keyboardType,
        defaultValue: TextInputType.text));
    properties.add(
        DiagnosticsProperty<TextStyle>('style', style, defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText,
        defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('autocorrect', autocorrect,
        defaultValue: true));
    properties.add(DiagnosticsProperty<bool>(
        'enableSuggestions', enableSuggestions,
        defaultValue: true));
    properties.add(IntProperty('maxLines', maxLines, defaultValue: 1));
    properties.add(IntProperty('minLines', minLines, defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('expands', expands, defaultValue: false));
    properties.add(IntProperty('maxLength', maxLength, defaultValue: null));
    properties.add(FlagProperty('maxLengthEnforced',
        value: maxLengthEnforced, ifTrue: 'max length enforced'));
    properties.add(createCupertinoColorProperty('cursorColor', cursorColor,
        defaultValue: null));
    properties.add(FlagProperty('selectionEnabled',
        value: selectionEnabled,
        defaultValue: true,
        ifFalse: 'selection disabled'));
    properties.add(DiagnosticsProperty<ScrollController>(
        'scrollController', scrollController,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ScrollPhysics>(
        'scrollPhysics', scrollPhysics,
        defaultValue: null));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign,
        defaultValue: TextAlign.start));
    properties.add(DiagnosticsProperty<TextAlignVertical>(
        'textAlignVertical', textAlignVertical,
        defaultValue: null));
  }
}

class _CupertinoTextFieldState extends State<CupertinoTextField>
    with AutomaticKeepAliveClientMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  final GlobalKey _clearGlobalKey = GlobalKey();

  TextEditingController _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _showSelectionHandles = false;

  _SelectionDetectorBuilder
      _selectionGestureDetectorBuilder;

  @override
  bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _SelectionDetectorBuilder(state: this);
    if (widget.controller == null) {
      _controller = TextEditingController();
      _controller.addListener(updateKeepAlive);
    }
  }

  @override
  void didUpdateWidget(CupertinoTextField oldWidget) {
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

    if (_effectiveController.selection.isCollapsed) return false;

    if (cause == SelectionChangedCause.keyboard) return false;

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

  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  @override
  bool get wantKeepAlive => _controller?.text?.isNotEmpty == true;

  bool _shouldShowAttachment({
    OverlayVisibilityMode attachment,
    bool hasText,
  }) {
    switch (attachment) {
      case OverlayVisibilityMode.never:
        return false;
      case OverlayVisibilityMode.always:
        return true;
      case OverlayVisibilityMode.editing:
        return hasText;
      case OverlayVisibilityMode.notEditing:
        return !hasText;
    }
    assert(false);
    return null;
  }

  bool _showPrefixWidget(TextEditingValue text) {
    return widget.prefix != null &&
        _shouldShowAttachment(
          attachment: widget.prefixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showSuffixWidget(TextEditingValue text) {
    return widget.suffix != null &&
        _shouldShowAttachment(
          attachment: widget.suffixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showClearButton(TextEditingValue text) {
    return _shouldShowAttachment(
      attachment: widget.clearButtonMode,
      hasText: text.text.isNotEmpty,
    );
  }

  bool get _hasDecoration {
    return widget.placeholder != null ||
        widget.clearButtonMode != OverlayVisibilityMode.never ||
        widget.prefix != null ||
        widget.suffix != null;
  }

  TextAlignVertical get _textAlignVertical {
    if (widget.textAlignVertical != null) {
      return widget.textAlignVertical;
    }
    return _hasDecoration ? TextAlignVertical.center : TextAlignVertical.top;
  }

  Widget _addTextDependentAttachments(
      Widget editableText, TextStyle textStyle, TextStyle placeholderStyle) {
    assert(editableText != null);
    assert(textStyle != null);
    assert(placeholderStyle != null);

    if (!_hasDecoration) {
      return editableText;
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      child: editableText,
      builder: (BuildContext context, TextEditingValue text, Widget child) {
        return Row(children: <Widget>[
          if (_showPrefixWidget(text)) widget.prefix,
          Expanded(
            child: Stack(
              children: <Widget>[
                if (widget.placeholder != null && text.text.isEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: widget.padding,
                      child: Text(
                        widget.placeholder,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: placeholderStyle,
                        textAlign: widget.textAlign,
                      ),
                    ),
                  ),
                child,
              ],
            ),
          ),
          if (_showSuffixWidget(text))
            widget.suffix
          else if (_showClearButton(text))
            GestureDetector(
              key: _clearGlobalKey,
              onTap: widget.enabled ?? true
                  ? () {
                      final bool textChanged =
                          _effectiveController.text.isNotEmpty;
                      _effectiveController.clear();
                      if (widget.onChanged != null && textChanged)
                        widget.onChanged(_effectiveController.text);
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(
                  CupertinoIcons.clear_thick_circled,
                  size: 18.0,
                  color: CupertinoDynamicColor.resolve(
                      _kClearButtonColor, context),
                ),
              ),
            ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assert(debugCheckHasDirectionality(context));
    final TextEditingController controller = _effectiveController;
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final List<TextInputFormatter> formatters =
        widget.inputFormatters ?? <TextInputFormatter>[];
    final bool enabled = widget.enabled ?? true;
    if (widget.maxLength != null && widget.maxLengthEnforced) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    Radius cursorRadius = widget.cursorRadius;

    if (Platform.isIOS) {
      forcePressEnabled = true;
      paintCursorAboveText = true;
      cursorOpacityAnimates = true;
      cursorRadius ??= const Radius.circular(2.0);
      cursorOffset = Offset(_iOSHorizontalOffset / devicePixelRatio, 0);
    } else {
      forcePressEnabled = false;
      paintCursorAboveText = false;
      cursorOpacityAnimates = false;
    }

    final CupertinoThemeData themeData = CupertinoTheme.of(context);

    final TextStyle resolvedStyle = widget.style?.copyWith(
      color: CupertinoDynamicColor.resolve(widget.style?.color, context),
      backgroundColor:
          CupertinoDynamicColor.resolve(widget.style?.backgroundColor, context),
    );

    final TextStyle textStyle =
        themeData.textTheme.textStyle.merge(resolvedStyle);

    final TextStyle resolvedPlaceholderStyle =
        widget.placeholderStyle?.copyWith(
      color: CupertinoDynamicColor.resolve(
          widget.placeholderStyle?.color, context),
      backgroundColor: CupertinoDynamicColor.resolve(
          widget.placeholderStyle?.backgroundColor, context),
    );

    final TextStyle placeholderStyle =
        textStyle.merge(resolvedPlaceholderStyle);

    final Brightness keyboardAppearance =
        widget.keyboardAppearance ?? themeData.brightness;
    final Color cursorColor =
        CupertinoDynamicColor.resolve(widget.cursorColor, context) ??
            themeData.primaryColor;
    final Color disabledColor =
        CupertinoDynamicColor.resolve(_kDisabledBackground, context);

    final Color decorationColor =
        CupertinoDynamicColor.resolve(widget.decoration?.color, context);

    final BoxBorder border = widget.decoration?.border;
    Border resolvedBorder = border;
    if (border is Border) {
      BorderSide resolveBorderSide(BorderSide side) {
        return side == BorderSide.none
            ? side
            : side.copyWith(
                color: CupertinoDynamicColor.resolve(side.color, context));
      }

      resolvedBorder = border == null || border.runtimeType != Border
          ? border
          : Border(
              top: resolveBorderSide(border.top),
              left: resolveBorderSide(border.left),
              bottom: resolveBorderSide(border.bottom),
              right: resolveBorderSide(border.right),
            );
    }

    final BoxDecoration effectiveDecoration = widget.decoration?.copyWith(
      border: resolvedBorder,
      color: enabled ? decorationColor : (decorationColor ?? disabledColor),
    );

    final Widget paddedEditable = Padding(
      padding: widget.padding,
      child: RepaintBoundary(
        child: EditableText(
          key: editableTextKey,
          controller: controller,
          readOnly: widget.readOnly,
          toolbarOptions: widget.toolbarOptions,
          showCursor: widget.showCursor,
          showSelectionHandles: _showSelectionHandles,
          focusNode: _effectiveFocusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          style: textStyle,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          selectionColor: CupertinoTheme.of(context).primaryColor.withOpacity(0.2),
          selectionControls: widget.selectionEnabled ? textSelectionControls /* cupertinoTextSelectionControls */ : null,
          onChanged: widget.onChanged,
          onSelectionChanged: _handleSelectionChanged,
          onSelectionHandleTapped: _handleSelectionHandleTapped,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          inputFormatters: formatters,
          rendererIgnoresPointer: true,
          cursorWidth: widget.cursorWidth,
          cursorRadius: widget.cursorRadius,
          cursorColor: cursorColor,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          paintCursorAboveText: paintCursorAboveText,
          backgroundCursorColor: CupertinoDynamicColor.resolve(
              CupertinoColors.inactiveGray, context),
          scrollPadding: widget.scrollPadding,
          keyboardAppearance: keyboardAppearance,
          dragStartBehavior: widget.dragStartBehavior,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          forceLine: widget.forceLine,
          textWidthBasis: widget.textWidthBasis,
        ),
      ),
    );

    return Semantics(
      onTap: () {
        if (!controller.selection.isValid) {
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
        }
        _requestKeyboard();
      },
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          decoration: effectiveDecoration,
          child: _selectionGestureDetectorBuilder.buildGestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Align(
              alignment: Alignment(-1.0, _textAlignVertical.y),
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: _addTextDependentAttachments(
                  paddedEditable, textStyle, placeholderStyle),
            ),
          ),
        ),
      ),
    );
  }
}

class CupertinoTextFormField extends FormField<String> {
  CupertinoTextFormField({
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    BoxDecoration decoration = cupertinoRoundedBorderDecoration,
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius = const Radius.circular(2.0),
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    Widget prefix,
    OverlayVisibilityMode prefixMode = OverlayVisibilityMode.always,
    Widget suffix,
    OverlayVisibilityMode suffixMode = OverlayVisibilityMode.always,
    OverlayVisibilityMode clearButtonMode = OverlayVisibilityMode.never,
    EdgeInsets padding =
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    String placeholder,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    TextStyle placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    ScrollController scrollController,
    ScrollPhysics scrollPhysics,
    bool enableSuggestions = true,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(autovalidate != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          'minLines can\'t be greater than maxLines',
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _CupertinoTextFormFieldState state = field;
            void onChangedHandler(String value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            final theme = CupertinoTheme.of(field.context);

            final bool hasError = field.errorText?.isNotEmpty ?? false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoTextField(
                  controller: state._effectiveController,
                  decoration: decoration.copyWith(
                    border: hasError
                        ? _kDefaultRoundedBorderError
                        : _kDefaultRoundedBorder,
                  ),
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  style: style,
                  strutStyle: strutStyle,
                  textAlign: textAlign,
                  textAlignVertical: textAlignVertical,
                  textCapitalization: textCapitalization,
                  autofocus: autofocus,
                  toolbarOptions: toolbarOptions,
                  readOnly: readOnly,
                  showCursor: showCursor,
                  obscureText: obscureText,
                  autocorrect: autocorrect,
                  maxLengthEnforced: maxLengthEnforced,
                  maxLines: maxLines,
                  minLines: minLines,
                  expands: expands,
                  maxLength: maxLength,
                  onChanged: onChangedHandler,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onFieldSubmitted,
                  inputFormatters: inputFormatters,
                  enabled: enabled,
                  cursorWidth: cursorWidth,
                  cursorRadius: cursorRadius,
                  cursorColor: cursorColor,
                  scrollPadding: scrollPadding,
                  keyboardAppearance: keyboardAppearance,
                  enableInteractiveSelection: enableInteractiveSelection,
                  prefix: prefix,
                  prefixMode: prefixMode,
                  clearButtonMode: clearButtonMode,
                  suffix: suffix,
                  suffixMode: suffixMode,
                  enableSuggestions: enableSuggestions,
                  padding: padding,
                  placeholder: placeholder,
                  dragStartBehavior: dragStartBehavior,
                  placeholderStyle: placeholderStyle,
                  scrollController: scrollController,
                  scrollPhysics: scrollPhysics,
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      field.errorText,
                      style: theme.textTheme.formFooterTextStyle.copyWith(
                          color: CupertinoDynamicColor.resolve(
                              CupertinoColors.errorRed, field.context),
                          height: 1),
                    ),
                  ),
              ],
            );
          },
        );

  final TextEditingController controller;

  @override
  _CupertinoTextFormFieldState createState() => _CupertinoTextFormFieldState();
}

class _CupertinoTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  CupertinoTextFormField get widget => super.widget;

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
  void didUpdateWidget(CupertinoTextFormField oldWidget) {
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
}
