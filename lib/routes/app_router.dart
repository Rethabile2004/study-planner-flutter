//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/auth/auth_page.dart';
import 'package:firebase_flutter/views/edit_profile_screen.dart';
import 'package:firebase_flutter/views/home_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registrationPage = '/register';
  static const String mainPage = '/main';
  static const String profile = '/profile';

// EditProfileScreen
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: true));
      case registrationPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: false));
      case profile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case mainPage:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MainPage(email: email),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route for ${settings.name}')),
          ),
        );
    }
  }
}