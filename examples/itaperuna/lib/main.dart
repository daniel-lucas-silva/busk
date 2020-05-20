import 'package:busk/busk.dart';

import 'src/features/CategoriesTab.dart';
import 'src/features/HomeTab.dart';
import 'src/features/SearchTab.dart';
import 'src/features/SettingsTab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initializeDateFormatting('pt_BR', null);

  runApp(MyApp());
}

// 8856333549335806928

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BuskApp(
      title: 'Itaperuna',
      color: Colors.systemBlue,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
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
          child: HomeTab(
              devicePixelRatio: MediaQuery.of(context).devicePixelRatio),
          title: "Início",
        ),
        TabItem(
          icon: CupertinoIcons.collections,
          child: CategoriesTab(),
          title: "Categorias",
        ),
        TabItem(
          icon: CupertinoIcons.search,
          child: SearchTab(),
          title: "Buscar",
        ),
        TabItem(
          icon: CupertinoIcons.settings,
          child: SettingsTab(),
          title: "Configurações",
        ),
      ],
      builder: (context, index, child) => child,
    );
  }
}
