import 'package:flutter/material.dart';

class TutorSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Tutors'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search fields for location, subject, etc.
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform search functionality
              },
              child: Text('Search'),
            ),
            // Display list of tutors below after search
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with the actual number of tutors
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Tutor Name $index'),
                    subtitle: Text('Subjects: Math, Science\nRating: 4.5'),
                    onTap: () {
                      // Navigate to tutor details page (to be created)
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
