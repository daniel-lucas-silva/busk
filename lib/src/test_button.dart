import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'raw/raw_section.dart';
import 'theme/colors.dart';
import 'constants.dart';
import 'theme/theme.dart';

const EdgeInsets _kButtonPadding = EdgeInsets.all(12.0);
const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.symmetric(
  vertical: 14.0,
  horizontal: 64.0,
);

enum ButtonSize {
  _,
  small,
  large,
}

enum ButtonType {
  _,
  raised,
  outline,
}

enum ButtonShape {
  _,
  rounded,
  circle,
}

class TestButton extends StatefulWidget {
  const TestButton({
    Key key,
    @required this.child,
    this.padding,
    this.color,
    this.disabledColor = Colors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.type: ButtonType._,
    this.size: ButtonSize._,
    this.shape: ButtonShape._,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        assert(disabledColor != null),
        super(key: key);

  const TestButton.icon({
    Key key,
    @required this.child,
    this.padding,
    this.disabledColor = Colors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.type: ButtonType._,
    this.size: ButtonSize._,
    this.shape: ButtonShape._,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        assert(disabledColor != null),
        color = null,
        super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final VoidCallback onPressed;
  final double minSize;
  final double pressedOpacity;
  final BorderRadius borderRadius;
  final ButtonType type;
  final ButtonSize size;
  final ButtonShape shape;

  bool get enabled => onPressed != null;

  @override
  _TestButtonState createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(TestButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    super.dispose();
  }

  getCellParentData() {
    return context.findAncestorWidgetOfExactType<CellParentDataWidget>();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (getCellParentData() != null) return;
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  getBackgroundColor() {
    switch (widget.type) {
      case ButtonType.raised:
        return Colors.tertiarySystemFill.resolveFrom(context);
      case ButtonType.outline:
        return null;
        break;
      default:
        return null;
    }
//    DynamicColor.resolve(widget.color, context);
  }

  getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return widget.type == null
            ? EdgeInsets.all(12.0)
            : EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0);
      case ButtonSize.large:
        return widget.type == null
            ? EdgeInsets.all(12.0)
            : EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0);
      default:
        return widget.type == null
            ? EdgeInsets.all(12.0)
            : EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0);
    }
  }

  getTextStyle(Color foregroundColor) {
    final bool enabled = widget.enabled;
    final CupertinoThemeData themeData = CupertinoTheme.of(context);

    switch (widget.size) {
      case ButtonSize.small:
        return themeData.textTheme.footnote.copyWith(color: foregroundColor);
      case ButtonSize.large:
        return themeData.textTheme.body.copyWith(color: foregroundColor);
      default:
        return themeData.textTheme.body.copyWith(color: foregroundColor);
    }
  }

  BoxConstraints getMinSize() {
    double minSize;
    switch (widget.size) {
      case ButtonSize.small:
        minSize = kMinInteractiveDimensionCupertino * 0.5;
        break;
      case ButtonSize.large:
        minSize = kMinInteractiveDimensionCupertino * 1.5;
        break;
      default:
        minSize = kMinInteractiveDimensionCupertino;
        break;
    }

    return BoxConstraints(
      minHeight: minSize,
      minWidth: minSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final Color primaryColor = themeData.primaryColor;

    Color foregroundColor;

    if (!enabled) {
      foregroundColor = DynamicColor.resolve(Colors.placeholderText, context);
    } else {
      foregroundColor = themeData.primaryColor;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: getMinSize(),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: getBackgroundColor() != null && !enabled
                    ? DynamicColor.resolve(widget.disabledColor, context)
                    : getBackgroundColor(),
                border: widget.type == ButtonType.outline
                    ? Border.all(color: themeData.primaryColor)
                    : null,
              ),
              child: Padding(
                padding: getPadding(),
                child: Center(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: DefaultTextStyle(
                    style: getTextStyle(foregroundColor),
                    child: IconTheme(
                      data: IconThemeData(color: foregroundColor),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
