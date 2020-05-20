
import 'package:busk/theme.dart';
import 'package:flutter/widgets.dart';

class ListHeader extends StatelessWidget {

  final Widget title;
  final Widget after;

  const ListHeader({
    Key key,
    @required this.title,
    this.after,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = CupertinoTheme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 20.0,
        bottom: 5.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DefaultTextStyle(
            child: title,
            style: textTheme.title2,
          ),
          if(after != null) after,
        ],
      ),
    );
  }
}


class SliverHeader extends StatelessWidget {
  final Widget title;
  final Widget after;

  const SliverHeader({
    Key key,
    @required this.title,
    this.after,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListHeader(title: title, after: after),
    );
  }
}
