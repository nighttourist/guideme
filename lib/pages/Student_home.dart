import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Finder - Student Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome message
              Text(
                'Welcome, [Student Name]',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Search for Tutors Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tutor_search');
                },
                child: Text('Search for Tutors'),
              ),
              SizedBox(height: 10),
              // View Saved Tutors Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/saved_tutors');
                },
                child: Text('View Saved Tutors'),
              ),
              SizedBox(height: 10),
              // Class History Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/class_history');
                },
                child: Text('View Class History'),
              ),
              SizedBox(height: 10),
              // Chat with Tutors Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: Text('Chat with Tutors'),
              ),
              SizedBox(height: 10),
              // Ratings and Reviews Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ratings_reviews');
                },
                child: Text('Rate Tutors'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
