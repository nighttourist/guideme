import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/tutor_page/tutor_home.dart';
import 'pages/common_page/login_page.dart';
import 'pages/common_page/registration_page.dart';
import 'pages/student_page/student_registration_page.dart';
import 'pages/tutor_page/tutor_registration_page.dart';
import 'pages/other/search.dart';
import 'pages/student_page/student_home.dart';
import 'pages/chat_page/chat_page.dart';
import 'pages/other/class_history.dart';
import 'pages/other/rating_review.dart';
import 'pages/tutor_page/save_tutor.dart';
import 'pages/tutor_page/search_tutor.dart';
import 'pages/student_page/student_profile.dart';
import 'pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load the saved dark mode preference
  final prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  MyApp({required this.isDarkMode});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool darkMode) async {
    setState(() {
      isDarkMode = darkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutor Finder',
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // New style for body text
          bodyMedium: TextStyle(color: Colors.black), // New style for medium body text
          bodySmall: TextStyle(color: Colors.black),  // New style for small body text
          titleLarge: TextStyle(color: Colors.black), // Title style for large titles
          titleMedium: TextStyle(color: Colors.black), // Title style for medium titles
          titleSmall: TextStyle(color: Colors.black),  // Title style for small titles
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // New style for body text
          bodyMedium: TextStyle(color: Colors.white), // New style for medium body text
          bodySmall: TextStyle(color: Colors.white),  // New style for small body text
          titleLarge: TextStyle(color: Colors.white), // Title style for large titles
          titleMedium: TextStyle(color: Colors.white), // Title style for medium titles
          titleSmall: TextStyle(color: Colors.white),  // Title style for small titles
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing', // Set the initial route here
      routes: {
        '/landing': (context) => LandingPage(),
        '/': (context) => LoginPage(), // Login Page
        '/register': (context) => RegistrationPage(), // Registration Selection
        '/student-register': (context) => StudentRegistrationPage(), // Student Registration
        '/tutor-register': (context) => TutorRegistrationPage(), // Tutor Registration
        '/tutor_home': (context) => TutorHomePage(),
        '/search': (context) => SearchPage(),
        '/student': (context) => StudentHomePage(),
        '/tutor_search': (context) => TutorSearchPage(),
        '/saved_tutors': (context) => SavedTutorsPage(),
        '/class_history': (context) => ClassHistoryPage(),
        '/chat': (context) => ChatPage(),
        '/ratings_reviews': (context) => RatingsReviewsPage(),
        '/student_profile': (context) => StudentProfilePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final Function(bool) toggleTheme;

  AuthWrapper({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return TutorHomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
