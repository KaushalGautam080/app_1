import 'package:flutter/material.dart';
import 'package:to_do_copy/features/authentication/screens/login_screen.dart';
import 'package:to_do_copy/features/dashboard/screens/home_page.dart';
import 'package:to_do_copy/features/dashboard/widgets/user_details_card.dart';

import 'features/authentication/screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (ctx) {
          return RegisterScreen();
        },
        '/home': (ctx) {
          return HomePage();
        },
        '/profile': (ctx) {
          return UserDetail();
        },
        '/login': (ctx) {
          return LoginScreen();
        }
      },
      initialRoute: '/register',
    );
  }
}
