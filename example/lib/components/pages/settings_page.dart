import 'package:busk/busk.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Section & Cells"),
      ),
      slivers: <Widget>[
        Section(
          header: Text("TODOS OS TECLADOS"),
          footer: Text(
            "Se voce tocar na barra de espaço duas vezes, um ponto seguido por um espaço sera inserido.",
          ),
          children: <Widget>[
            Cell(
              child: Text("Aqui 1"),
              onTap: () {},
            ),
            Cell(
              child: Text("Aqui 2"),
              onTap: () {},
            ),
            Cell(
              child: Text("Aqui 3"),
              onTap: () {},
            ),
          ],
        ),
        Section(
          header: Text("TODOS OS TECLADOS".toUpperCase()),
          footer: null,
          children: <Widget>[
            Cell(
              child: Text("Aqui 1"),
              onTap: () {},
            ),
            Cell.subtitle(
              title: Text("Algum titulo"),
              subtitle: Text("Subtitulo qualquer"),
              onTap: () {},
            ),
          ],
        ),
        Section(
          header: Text("TODOS OS TECLADOS".toUpperCase()),
          footer: Text(
            "Se voce ocar na barra de espaço duas vezes, um ponto seguido por um espaço sera inserido.",
          ),
          children: <Widget>[
            Cell(
              child: Text("Aqui 1"),
              onTap: () {},
            ),
            Cell(
              child: Text("Aqui 2"),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}