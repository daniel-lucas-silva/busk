import 'package:busk/busk.dart';

class CategoryAndDate extends StatelessWidget {
  final String category;
  final DateTime date;

  const CategoryAndDate({
    Key key,
    this.category,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if(category != null && category.isNotEmpty)
        Text(
          category.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CupertinoTheme.of(context).primaryColor,
          ),
        ),
        if(category != null && category.isNotEmpty)
        SizedBox(width: 10),
        if(date != null)
        Text(date.format("dd MMM yyyy").toUpperCase()),
      ],
    );
  }
}
