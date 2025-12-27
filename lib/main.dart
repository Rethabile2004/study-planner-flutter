//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBx54EAXp9TCYte8d705fUIGEzn_V6JwTk",
        authDomain: "studyplanner-51b4d.firebaseapp.com",
        projectId: "studyplanner-51b4d",
        storageBucket: "studyplanner-51b4d.firebasestorage.app",
        messagingSenderId: "1018117580183",
        appId: "1:1018117580183:web:f0d8da541db3a2842a90d2",
        measurementId: "G-YWZ8ZQ1SQW",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  final authService = AuthService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      // theme: ThemeData(
      //   primarySwatch: Colors.purple,
      // ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteManager.loginPage,
      onGenerateRoute: RouteManager.generateRoute,
      theme: ThemeData(
        useMaterial3: true, // Enables smoother transitions & cleaner components
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          primary: Colors.blueGrey.shade800,
          secondary: Colors.amber.shade600,
        ),

        fontFamily: 'LibreFranklin',

        // --- AppBar Theme ---
        bottomAppBarTheme: BottomAppBarThemeData(
          elevation: 6,
          color: Colors.white
          
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade800,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'LibreFranklin',
            color: Colors.white,
          ),
          iconTheme:  IconThemeData(color: Colors.amber.shade600),
        ),

        // --- Floating Action Button ---
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber.shade600,
          foregroundColor: Colors.blueGrey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        // --- Elevated Button Theme ---
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade800,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'LibreFranklin',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
            elevation: 2,
          ),
        ),

        // --- Text Button Theme ---
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey.shade800,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'LibreFranklin',
            ),
          ),
        ),

        // --- Card Theme ---
        cardTheme: CardThemeData(
          color: Colors.blueGrey.shade50,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        ),

        // --- Input Fields ---
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber.shade600, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.blueGrey.shade700),
        ),

        // --- Icon Theme ---
        iconTheme: IconThemeData(color: Colors.blueGrey.shade800),

        // --- Text Theme ---
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          bodyMedium: TextStyle(fontSize: 15),
          bodySmall: TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

class WebsiteButton extends StatelessWidget {
  const WebsiteButton({super.key});

  // The URL to launch
  final String websiteUrl = 'https://github.com/Rethabile2004';

  // Function to launch the URL
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(websiteUrl);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $websiteUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchUrl,
      child: const Text(style: TextStyle(fontSize: 18,color: Colors.amber),"Rethabile Eric Siase"),
    );
  }
}