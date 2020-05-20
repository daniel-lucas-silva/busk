import 'package:busk/busk.dart';

import 'ListingScreen.dart';

class RegioesScreen extends StatefulWidget {
  @override
  _RegioesScreenState createState() => _RegioesScreenState();
}

class _RegioesScreenState extends State<RegioesScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        previousPageTitle: "Itaperuna",
        largeTitle: Text("Regiões"),
      ),
      slivers: <Widget>[
        Section(
          children: <Widget>[
            Cell(
              child: Text("Boa Ventura"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Boa Ventura",
                    categories: ["Boa-Ventura"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Comendador Venâncio"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Comendador Venâncio",
                    categories: ["Comendador Venâncio"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Laje do Muriaé"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Laje do Muriaé",
                    categories: ["Laje do Muriaé"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Natividade"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Natividade",
                    categories: ["Natividade"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Raposo"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Raposo",
                    categories: ["Raposo"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Retiro do Muriaé"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Retiro do Muriaé",
                    categories: ["Retiro do Muriaé"],
                  ),
                );
              },
            ),
            Cell(
              child: Text("Varre-Sai"),
              onTap: () {
                push(
                  context,
                  ListingScreen(
                    previousPageTitle: "Regiões",
                    title: "Varre-Sai",
                    categories: ["Varre-Sai"],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
