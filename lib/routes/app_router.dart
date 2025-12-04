//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/auth/auth_page.dart';
import 'package:firebase_flutter/auth/complete_profile.dart';
import 'package:firebase_flutter/models/study_planner.dart';
import 'package:firebase_flutter/views/create_plan.dart';
import 'package:firebase_flutter/views/edit_profile_screen.dart';
// import 'package:firebase_flutter/views/home_page.dart';
import 'package:firebase_flutter/views/main_layout.dart';
import 'package:firebase_flutter/views/study_plan_details_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registrationPage = '/register';
  static const String mainPage = '/main';
  static const String profile = '/profile';
  static const String mainLayout = '/home';
  static const String createPlan = '/createPlan';
  static const String completeProfile = '/completeProfile';
  static const String studyPlanDetailsPage = '/studyPlanDetailsPage';

  // EditProfileScreen
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const AuthPage(isLogin: true));
      case registrationPage:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(isLogin: false),
        );
      case studyPlanDetailsPage:
        final args = settings.arguments as StudyPlan;
        return MaterialPageRoute(
          builder: (_) => StudyPlanDetailsPage(plan: args),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case createPlan:
        return MaterialPageRoute(builder: (_) => const CreatePlanScreen());
      case mainLayout:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => MainLayout(email: args['email']),
        );
      case completeProfile:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder:
              (_) => CompleteProfilePage(
                uid: args['uid'],
                email: args['email'],
                name: args['name'],
              ),
        );
      case mainPage:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MainLayout(email: email));
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('No route for ${settings.name}')),
              ),
        );
    }
  }
}
