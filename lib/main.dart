import 'package:flutter/material.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/app_screen/viewscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id,
      theme: ThemeData.dark(),
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}
