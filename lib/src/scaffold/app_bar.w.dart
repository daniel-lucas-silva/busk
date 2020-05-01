part of 'app_bar.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    this.color,
    this.previousPageTitle,
    this.onPressed,
  })  : _backChevron = null,
        _backLabel = null;

  const AppBarBackButton._assemble(
    this._backChevron,
    this._backLabel,
  )   : previousPageTitle = null,
        color = null,
        onPressed = null;

  final Color color;
  final String previousPageTitle;
  final VoidCallback onPressed;
  final Widget _backChevron;
  final Widget _backLabel;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> currentRoute = ModalRoute.of(context);
    if (onPressed == null) {
      assert(
        currentRoute?.canPop == true,
        'AppBarBackButton should only be used in routes that can be popped',
      );
    }

    TextStyle actionTextStyle =
        CupertinoTheme.of(context).textTheme.navActionTextStyle;
    if (color != null) {
      actionTextStyle = actionTextStyle.copyWith(
          color: CupertinoDynamicColor.resolve(color, context));
    }

    return CupertinoButton(
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Voltar',
        button: true,
        child: DefaultTextStyle(
          style: actionTextStyle,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minWidth: _kNavBarBackButtonTapWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsetsDirectional.only(start: 8.0)),
                _backChevron ?? const _BackChevron(),
                const Padding(padding: EdgeInsetsDirectional.only(start: 6.0)),
                Flexible(
                  child: _backLabel ??
                      _BackLabel(
                        specifiedPreviousTitle: previousPageTitle,
                        route: currentRoute,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onPressed != null)
          onPressed();
        else
          Navigator.maybePop(context);
      },
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final TextStyle textStyle = DefaultTextStyle.of(context).style;

    Widget iconWidget = Text.rich(
      TextSpan(
        text: String.fromCharCode(CupertinoIcons.back.codePoint),
        style: TextStyle(
          inherit: false,
          color: textStyle.color,
          fontSize: 34.0,
          fontFamily: CupertinoIcons.back.fontFamily,
          package: CupertinoIcons.back.fontPackage,
        ),
      ),
    );
    switch (textDirection) {
      case TextDirection.rtl:
        iconWidget = Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
          alignment: Alignment.center,
          transformHitTests: false,
          child: iconWidget,
        );
        break;
      case TextDirection.ltr:
        break;
    }

    return iconWidget;
  }
}

class _BackLabel extends StatelessWidget {
  const _BackLabel({
    Key key,
    @required this.specifiedPreviousTitle,
    @required this.route,
  }) : super(key: key);

  final String specifiedPreviousTitle;
  final ModalRoute<dynamic> route;

  Widget _buildPreviousTitleWidget(
    BuildContext context,
    String previousTitle,
    Widget child,
  ) {
    if (previousTitle == null) return const SizedBox(height: 0.0, width: 0.0);

    Text textWidget = Text(
      previousTitle,
      maxLines: 1,
      textScaleFactor: 1.0,
    );

    if (previousTitle.length > 12) textWidget = const Text('Voltar');

    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.1,
      child: textWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (specifiedPreviousTitle != null) {
      return _buildPreviousTitleWidget(context, specifiedPreviousTitle, null);
    } else if (route is CupertinoPageRoute<dynamic> && !route.isFirst) {
      final CupertinoPageRoute<dynamic> cupertinoRoute =
          route as CupertinoPageRoute<dynamic>;

      return ValueListenableBuilder<String>(
        valueListenable: cupertinoRoute.previousTitle,
        builder: _buildPreviousTitleWidget,
      );
    } else {
      return const SizedBox(height: 0.0, width: 0.0);
    }
  }
}
