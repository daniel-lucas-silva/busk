import 'package:busk/busk.dart';

class BookmarksTab extends StatefulWidget {
  @override
  _BookmarksTabState createState() => _BookmarksTabState();
}

class _BookmarksTabState extends State<BookmarksTab> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Cart"),
      ),
      slivers: <Widget>[
        Section(
          children: <Widget>[
            Cell(child: Text("Aqui 1")),
          ],
        ),
      ],
    );
  }
}
