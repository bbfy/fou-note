import 'package:flutter/material.dart';
import 'package:custom_note/screens/home_screen.dart';
import 'package:custom_note/styles/color_schemes.g.dart';

//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/providers.dart';

//ad
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DbSqliteProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SoloProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChildProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TodoProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debug 표시 없앰
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const HomeScreen(),
    );
  }
}
