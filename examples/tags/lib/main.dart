import 'package:example/main_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Fluent demo',
      theme: FluentThemeData.light().copyWith(
        // accentColor: AccentColor('normal', {'normal': Color(0xff0f6cbd)}),
        scaffoldBackgroundColor: Color(0xfffafafa),
      ),
      darkTheme: FluentThemeData.dark().copyWith(
        // accentColor: AccentColor('normal', {'normal': Color(0xff0f6cbd)}),
        scaffoldBackgroundColor: Color(0xff1f1f1f),
      ),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
