import 'package:as_website/admin/admin.dart';
import 'package:as_website/admin/testpage.dart';
import 'package:as_website/navigation.dart';
import 'package:as_website/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anne Simonnot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.roboto(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.roboto(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleSmall: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      // home: const TestPage(),
      home: const Navigation(),
      // home: const Admin(),
    );
  }
}
