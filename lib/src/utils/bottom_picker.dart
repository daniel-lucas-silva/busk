import 'package:flutter/widgets.dart';

import '../button.dart';
import '../theme/theme.dart';

const double _kPickerSheetHeight = 216.0;
const double _kPickerToolbarHeight = 44.0;

const Color labelColor = Color.fromARGB(255, 255, 255, 255);
const Color systemBackground = Color.fromARGB(255, 0, 0, 0);

class BottomPicker extends StatelessWidget {
  const BottomPicker({
    Key key,
    @required this.child,
    this.selectText,
    this.onSelect,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final VoidCallback onSelect;
  final String selectText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kPickerSheetHeight + _kPickerToolbarHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoTheme.of(context).barBackgroundColor,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 22.0),
        child: GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: _kPickerToolbarHeight,
                  child: NavigationToolbar(
                    leading: Offstage(),
                    trailing: Button(
                      child: Text(selectText ?? "Selecionar"),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      onPressed: onSelect,
                      minSize: _kPickerToolbarHeight,
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
