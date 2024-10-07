import 'package:flutter/material.dart';
import 'package:guideme/pages/tutor_home.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/student_registration_page.dart';
import 'pages/tutor_registration_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TutorFinderApp());
}

class TutorFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(), // Login Page
        '/register': (context) => RegistrationPage(), // Registration Selection
        '/student-register': (context) => StudentRegistrationPage(), // Student Registration
        '/tutor-register': (context) => TutorRegistrationPage(),
        '/tutor_home': (context) => TutorHomePage(),// Tutor Registration
      },
    );
  }
}
