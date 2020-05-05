import 'package:busk/busk.dart';

class FormsPage extends StatefulWidget {
  @override
  _FormsPageState createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  @override
  Widget build(BuildContext context) {

    return SliverScaffold(
      appBar: SliverAppBar(
        largeTitle: Text("Forms"),
      ),
      slivers: <Widget>[
        Section(
          header: Text("Lorem ipsum".toUpperCase()),
          footer: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ultricies massa magna, eget pharetra lectus mattis ut.",
          ),
          children: <Widget>[
            DateFormField(
              label: "Birthday",
              onSaved: print,
            ),
            RatingFormField(
              label: "Rating",
              onSaved: print,
            ),
            SwitchFormField(
              label: "Switch",
              onSaved: print,
            ),
            PickerFormField(
              label: "Picker",
              initialValue: ["1", "3", "4"],
              onSaved: print,
              items: {
                "1": "Teste",
                "2": "Aqui",
                "3": "Ali",
              },
            ),
            SelectFormField(
              label: "Select",
              onSaved: print,
              initialValue: "4",
              items: {
                "1": "Teste",
                "2": "Aqui",
              },
            ),
            TextFormField(
              onSaved: print,
              validator: (v) => v.isEmpty ? "Error" : null,
            ),
          ],
        ),
        Section(
          header: Text("Lorem ipsum".toUpperCase()),
          footer: null,
          children: <Widget>[
            RadioFormField(
              label: "Radio",
              onSaved: print,
              validator: (v) => v == null ? "Error" : null,
              items: {
                "1": "Teste",
                "2": "Aqui",
              },
            ),
          ],
        ),
        Section(
          header: Text("Lorem ipsum".toUpperCase()),
          footer: Text(
            "Se voce ocar na barra de espaço duas vezes, um ponto seguido por um espaço sera inserido.",
          ),
          children: <Widget>[
            ArrayFormBuilder(
              labelText: "Adicionar Telefone",
              itemCount: 0,
              itemBuilder: (initialValue, key, index, remove) {
                return TextFormField(
                  key: key,
                  onSaved: (v) => print("$index - $v"),
                  decoration: TextFieldDecoration(
                    prefix: RemoveButton(
                      onTap: remove,
                    ),
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
