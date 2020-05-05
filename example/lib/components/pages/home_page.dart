import 'package:busk/busk.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        leading: AppBarBackButton(
          previousPageTitle: "Parent Title",
          onPressed: () {},
        ),
        largeTitle: Text("Newspaper"),
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
