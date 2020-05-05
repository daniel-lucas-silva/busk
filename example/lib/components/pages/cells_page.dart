import 'package:busk/busk.dart';

class CellsPage extends StatefulWidget {
  @override
  _CellsPageState createState() => _CellsPageState();
}

class _CellsPageState extends State<CellsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Bookmarks"),
      ),
      slivers: <Widget>[
        Section(
          header: TestSectionHeader("Simple"),
          children: <Widget>[
            Cell(
              child:
              Text("Lorem ipsum dolor sit amet indisrupt asd asd as"),
              detail: Text("Lorem ipsum"),
              onTap: () {
                print("onTap");
              },
            ),
            Cell(
              leading: Avatar.letter(
                "daniel",
                size: AvatarSize.small,
              ),
              child: Text("Lorem ipsum dolor sit amet"),
              detail: Text("Lorem ipsum"),
            ),
            Cell(
              child: Text("Lorem ipsum"),
              onTap: () {
                print("onTap");
              },
            ),
          ],
        ),
        /**
         *
         */
        Section(
          header: Text("Subtitle"),
          children: <Widget>[
            Cell.subtitle(
              title: Text("Lorem ipsum dolor sit amet"),
              subtitle: Text("Simple"),
              trailing: Tooltip(
                message: "Alguma mensagem no tooltip",
                child: Text("Simple"),
              ),
            ),
            Cell.subtitle(
              leading: Avatar.letter("daniel", badge: 3),
              title: Text("Lorem ipsum dolor sit amet"),
              subtitle: Text(
                  "Lorem ipsum dolor sit amet sit amet sit amet sit amet"),
              detail: Text("Lorem ipsum"),
              onTap: () {},
            ),
          ],
        ),
        /**
         *
         */
        Section(
          header: Text("Message"),
          children: <Widget>[
            Cell.message(
              from: "+29591",
              message:
              "Drogaria Pacheco: Imprima seu cupom especial com ofertas como ATADURA…",
              time: "Ontem",
              read: false,
              avatar: Avatar.letter("daniel", badge: 100),
              onTap: () {},
            ),
          ],
        ),
        /**
         *
         */
        Section(
          header: Text("Mail"),
          children: <Widget>[
            Cell.mail(
              from: "YouTube",
              subject: "SpaceToday acabou de enviar um vídeo",
              message:
              "SpaceToday enviou WASP76B: O EXOPLANETA ONDE CHOVE FERRO | SPACE TODAY TV EP21…",
              time: "20:13",
              read: false,
              onTap: () {},
            ),
          ],
        ),
        /**
         *
         */
        Section(
          header: Text("Review"),
          children: <Widget>[
            Cell.review(
              name: "Daniel Lucas",
              time: "Ontem",
              message:
              "This place is just like McDonalds. The food never looks like the pictures. The shrimp in my order was like nickel size. What a rip off.",
              avatar: Avatar.letter("daniel", size: AvatarSize.normal),
              rate: 5.0,
            ),
            Cell.review(
              name: "Daniel Lucas",
              time: "Ontem",
              message:
              "This place is just like McDonalds. The food never looks like the pictures. The shrimp in my order was like nickel size. What a rip off.",
              avatar: Avatar.letter("daniel", size: AvatarSize.normal),
              rate: 5.0,
            ),
          ],
        ),
        /**
         *
         */
        Section(
          header: Text("Detail"),
          children: <Widget>[
            Cell.detail(
              header: Text("Telefone"),
              content: Text("+1 (323) 234-8007"),
              onTap: () {},
            ),
            Cell.detail(
              header: Text("Horário"),
              content: Text("07:00 - 22:00"),
              status: Text("Aberto Agora"),
              after: LinkSpan(
                "Mostrar Tudo",
                subheading: true,
                onTap: () {},
              ),
            ),
            Cell.detail(
              header: Text("Endereço"),
              content: Text(
                  '''5875 Hoover Ave\nLos Angeles, CA 90001\nUnited States'''),
              trailing: Container(
                color: Colors.white,
              ),
            ),
            Cell.detail(
              header: Text("Horário"),
              after: LinkSpan(
                "Mostrar Hoje",
                subheading: true,
                onTap: () {},
              ),
              content: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Segunda"), Text("00:00")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Terca"), Text("00:00")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Quarta"), Text("00:00")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Quinta"), Text("00:00")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Sexta"), Text("00:00")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Sabado"), Text("00:00")],
                  ),
                ],
              ),
            ),
          ],
        ),
        /**
         *
         */
            Section(
              header: Text("Action"),
              children: <Widget>[
                Cell.action(
                  child: Text("Simple Action"),
                  destructive: true,
                  onTap: () {},
                ),
                Cell.action(
                  child: Text("Action Center"),
                  center: true,
                  onTap: () {},
                ),
                Cell.action(
                  child: Text("Action With Icon"),
                  icon: CupertinoIcons.bluetooth,
                  onTap: () {
                    print("AQUI");
                  },
                ),
              ],
            ),
      ],
    );
  }
}
