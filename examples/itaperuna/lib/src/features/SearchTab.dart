import 'package:busk/busk.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Buscar"),
      ),
      slivers: <Widget>[
        SliverEmpty("Em desenvolvimento"),
      ],
    );
  }
}
