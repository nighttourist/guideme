import 'package:flutter/material.dart';

class SavedTutorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Tutors'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with the actual number of saved tutors
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Saved Tutor Name $index'),
            subtitle: Text('Subjects: Math, Science\nRating: 4.5'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Functionality to remove tutor from saved list
              },
            ),
            onTap: () {
              // Navigate to tutor details page
            },
          );
        },
      ),
    );
  }
}
