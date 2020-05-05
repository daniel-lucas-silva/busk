import 'dart:async';

import 'package:busk/busk.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/forms_page.dart';
import 'pages/cells_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('pt_BR', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuskApp(
//      theme: CupertinoThemeData(
//        brightness: Brightness.dark
//      ),
      title: 'Newspaper',
//      themeMode: ThemeMode.light,
      home: Screens(),
    );
  }
}

class Screens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      items: [
        TabItem(
          icon: CupertinoIcons.home,
          child: HomePage(),
          title: "Home",
        ),
        TabItem(
          icon: CupertinoIcons.collections,
          child: FormsPage(),
          title: "Forms",
        ),
        TabItem(
          icon: CupertinoIcons.collections,
          child: CellsPage(),
          title: "Cells",
        ),
        TabItem(
          icon: CupertinoIcons.collections,
          child: SettingsPage(),
          title: "Settings",
        ),
      ],
      builder: (context, index, child) => child,
    );
  }
}
