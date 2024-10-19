import 'package:flutter/material.dart';
import 'package:guideme/pages/tutor_home.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/student_registration_page.dart';
import 'pages/tutor_registration_page.dart';
import 'pages/search.dart';
import 'pages/Student_home.dart';
import 'pages/chat_page.dart';
import 'pages/class_history.dart';
import 'pages/rating_review.dart';
import 'pages/save_tutor.dart';
import 'pages/search_tutor.dart';
import 'pages/student_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
WidgetsFlutterBinding.ensureInitialized();  // Ensure binding
await Firebase.initializeApp();
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
        '/tutor_home': (context) => TutorHomePage(),
        '/search': (context) => SearchPage(),
        '/student': (context) => StudentHomePage(),
        '/tutor_search': (context) => TutorSearchPage(),
        '/saved_tutors': (context) => SavedTutorsPage(),
        '/class_history': (context) => ClassHistoryPage(),
        '/chat': (context) => ChatPage(),
        '/ratings_reviews': (context) => RatingsReviewsPage(),
        '/student_profile': (context) => StudentProfilePage(),// Tutor Registration
      },
    );
  }
}
