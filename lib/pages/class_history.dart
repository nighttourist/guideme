import 'package:flutter/material.dart';

class ClassHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class History'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with the actual number of classes
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Session with Tutor Name $index'),
            subtitle: Text('Date: 2024-10-12\nSubject: Math\nRating: 4.5'),
            onTap: () {
              // Navigate to class details page (if needed)
            },
          );
        },
      ),
    );
  }
}
