import 'package:flutter/material.dart';
import 'package:guideme/pages/tutor_page/tutor_home.dart';
import 'pages/common_page/login_page.dart';
import 'pages/common_page/registration_page.dart';
import 'pages/student_page/student_registration_page.dart';
import 'pages/tutor_page/tutor_registration_page.dart';
import 'pages/other/search.dart';
import 'pages/student_page/Student_home.dart';
import 'pages/chat_page/chat_page.dart';
import 'pages/other/class_history.dart';
import 'pages/other/rating_review.dart';
import 'pages/tutor_page/save_tutor.dart';
import 'pages/tutor_page/search_tutor.dart';
import 'pages/student_page/student_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding
  await Firebase.initializeApp();
  runApp(TutorFinderApp());
}

class TutorFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => LandingPage(),
        '/': (context) => LoginPage(), // Login Page
        '/register': (context) => RegistrationPage(), // Registration Selection
        '/student-register': (context) =>
            StudentRegistrationPage(), // Student Registration
        '/tutor-register': (context) => TutorRegistrationPage(),
        '/tutor_home': (context) => TutorHomePage(),
        '/search': (context) => SearchPage(),
        '/student': (context) => StudentHomePage(),
        '/tutor_search': (context) => TutorSearchPage(),
        '/saved_tutors': (context) => SavedTutorsPage(),
        '/class_history': (context) => ClassHistoryPage(),
        '/chat': (context) => ChatPage(),
        '/ratings_reviews': (context) => RatingsReviewsPage(),
        '/student_profile': (context) =>
            StudentProfilePage(), // Tutor Registration
      },
    );
  }
}
