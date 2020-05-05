import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../theme/colors.dart';
import '../scaffold/interface_level.dart';
import '../scrollbar.dart';
import '../theme/theme.dart';

part 'raw_section.s.dart';

part 'raw_section.m.dart';

const Color _kBackgroundColor = DynamicColor.withBrightness(
  color: Color(0xFFFFFFFF),
  darkColor: Color.fromRGBO(28, 28, 30, 1.0),
);

const Color _kPressedColor = DynamicColor.withBrightness(
  color: Color(0xFFE1E1E1),
  darkColor: Color(0xFF2E2E2E),
);

const double _kEdgeVerticalPadding = 10.0;

class RawSection extends StatelessWidget {
  const RawSection({
    Key key,
    this.header,
    this.children,
    this.footer,
  })  : assert(children != null),
        super(key: key);

  final Widget header;
  final Widget footer;
  final List<Widget> children;

  Widget _buildActions() {
    if (children == null || children.isEmpty) {
      return Container(
        height: 0.0,
      );
    }
    children.removeWhere((child) => child == null);
    children.removeWhere((child) => child is Offstage);

    return _SectionCells(
      children: children,
    );
  }

  Widget buildFooter() {
    if (footer is Text)
      return Container(
        padding: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: 16.0,
          right: 16.0,
        ),
        alignment: Alignment.topLeft,
        constraints: const BoxConstraints(minHeight: 38.0),
        child: footer,
      );

    return SizedBox(height: 10.0);
  }

  Widget buildHeader() {
    if (header is Text)
      return Container(
        padding: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: 16.0,
          right: 16.0,
        ),
        alignment: Alignment.bottomLeft,
        constraints: const BoxConstraints(minHeight: 38.0),
        child: header,
      );

    return SizedBox(height: 36.0);
  }

  @override
  Widget build(BuildContext context) {

    final footnoteStyle = CupertinoTheme.of(context).textTheme.footnote;

    return _SectionRenderWidget(
      header: DefaultTextStyle(
        style: footnoteStyle,
        child: buildHeader(),
      ),
      footer: DefaultTextStyle(
        style: footnoteStyle,
        child: buildFooter(),
      ),
      cells: CupertinoUserInterfaceLevel(
        data: CupertinoUserInterfaceLevelData.elevated,
        child: RepaintBoundary(child: _buildActions()),
      ),
//          cells: RepaintBoundary(child: _buildActions()),
    );
  }
}

class _SectionCells extends StatefulWidget {
  const _SectionCells({
    Key key,
    @required this.children,
  })  : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  _SectionCellsState createState() => _SectionCellsState();
}

class _SectionCellsState extends State<_SectionCells> {
  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final List<Widget> cells = <Widget>[];
    for (int i = 0; i < widget.children.length; i += 1) {
      cells.add(
        _PressableActionButton(child: widget.children[i]),
      );
    }

    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.body,
      child: RepaintBoundary(
        child: _CellsRenderWidget(
          children: widget.children,
          dividerThickness: kDividerThickness / devicePixelRatio,
        ),
      ),
    );
  }
}

class _PressableActionButton extends StatefulWidget {
  const _PressableActionButton({
    @required this.child,
  });

  final Widget child;

  @override
  _PressableActionButtonState createState() => _PressableActionButtonState();
}

class _PressableActionButtonState extends State<_PressableActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return CellParentDataWidget(
      isPressed: _isPressed,
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails details) {
          setState(() => _isPressed = true);
        },
        onTapUp: (TapUpDetails details) {
          setState(() => _isPressed = false);
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        child: widget.child,
      ),
    );
  }
}

class CellParentDataWidget extends ParentDataWidget<_CellsRenderWidget> {
  const CellParentDataWidget({
    Key key,
    this.isPressed,
    @required Widget child,
  }) : super(key: key, child: child);

  final bool isPressed;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _CellParentData);
    final _CellParentData parentData = renderObject.parentData;
    if (parentData.isPressed != isPressed) {
      parentData.isPressed = isPressed;

      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsPaint();
    }
  }
}

class _CellParentData extends MultiChildLayoutParentData {
  _CellParentData({
    this.isPressed = false,
  });

  bool isPressed;
}
