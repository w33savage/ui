// import 'package:club_house/pages/home/home_page.dart';
// import 'package:club_house/pages/welcome/welcome_page.dart';
import 'package:club_house/services/authenticate.dart';
import 'package:club_house/util/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clubhouse UI',
      theme: ThemeData(
        scaffoldBackgroundColor: Style.LightBrown,
        appBarTheme: AppBarTheme(
          color: Style.LightBrown,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: AuthService().handleAuth(),
    );
  }
}
