import 'package:busk/busk.dart';

class CategoriesTab extends StatefulWidget {
  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Categorias"),
      ),
      slivers: <Widget>[
        SliverEmpty("Em desenvolvimento"),
      ],
    );
  }
}
