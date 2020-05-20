import 'package:busk/busk.dart';


class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Configurações"),
      ),
      slivers: <Widget>[
//        Section(
//          children: <Widget>[
//            Cell.subtitle(
//              leading: Avatar(
//                child: Icon(CupertinoIcons.person_solid),
//              ),
//              title: Text("Username"),
//              subtitle: Text("email@example.com"),
//              onTap: () {
//                push(context, AccountPage());
//              },
//            ),
//          ],
//        ),
        Section(
          header: Text("Geral".toUpperCase()),
          children: <Widget>[
            Cell(
              leading: SimpleIcon(CupertinoIcons.brightness, size: 27,),
              child: Text("Tema Escuro"),
              trailing: CupertinoSwitch(
                value: true,
                onChanged: (v) {},
              ),
            ),
//            SelectFormField(
//              label: "Country",
//              items: {
//                "us": "United States",
//                "br": "Brazil",
//              },
//              initialValue: "br",
//            ),
//            SelectFormField(
//              label: "Language",
//              items: {
//                "en": "English",
//                "pt": "Portuguese",
//              },
//              initialValue: "en",
//            ),
//            SelectFormField(
//              label: "Currency",
//              items: {
//                "USD": "\$ - USB",
//                "BRL": "R\$ - BRL",
//              },
//              initialValue: "BRL",
//            ),
          ],
        ),
        Section(
          header: Text("Ajuda".toUpperCase()),
          children: <Widget>[
            Cell(
              child: Text("Sobre"),
              onTap: () {},
            ),
            Cell(
              child: Text("Contato"),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
