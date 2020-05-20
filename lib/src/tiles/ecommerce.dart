import 'package:busk/theme.dart';
import 'package:flutter/widgets.dart';

class ProductTile extends StatelessWidget {
  final Widget title;
  final Widget description;
  final Widget header;
  final Widget trailing;
  final ImageProvider image;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductTile({
    Key key,
    this.title,
    this.description,
    this.header,
    this.trailing,
    this.image,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: Colors.systemRed,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                  style: CupertinoTheme.of(context).textTheme.body,
                  child: title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null)
                  DefaultTextStyle(
                    style: CupertinoTheme.of(context).textTheme.footnote,
                    child: description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if(trailing != null)
            SizedBox(width: 10),
          if(trailing != null)
            trailing
        ],
      ),
    );
  }
}
