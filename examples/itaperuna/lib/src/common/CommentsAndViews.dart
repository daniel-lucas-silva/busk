import 'package:busk/busk.dart';

class CommentsAndViews extends StatelessWidget {
  final int comments;
  final int views;

  const CommentsAndViews({
    Key key,
    this.comments,
    this.views,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if(comments != null)
        ...[
          SimpleIcon(
            CupertinoIcons.chat_solid,
            color: Colors.inactiveGray.resolveFrom(context),
            size: 15,
          ),
          SizedBox(width: 3),
          Text("$comments"),
          SizedBox(width: 10),
        ],
        if(views != null)
          ...[
            SimpleIcon(
              CupertinoIcons.eye_solid,
              color: Colors.inactiveGray.resolveFrom(context),
              size: 15,
            ),
            SizedBox(width: 3),
            Text("$views"),
          ],
        Offstage(),
      ],
    );
  }
}
