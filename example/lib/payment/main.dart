import 'package:busk/busk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Ecommerce',
//      theme: BuskTheme.light(Colors.deepPurple),
//      darkTheme: BuskTheme.dark(Colors.purple),
//      themeMode: ThemeMode.light,
      home: Screens(),
    );
  }
}

class Screens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            middle: Text("Ecommerce"),
          ),
        ],
      ),
    );
  }
}
