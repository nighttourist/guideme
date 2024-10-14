import 'package:flutter/material.dart';

class RatingsReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Tutors'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with the actual number of tutors to rate
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Tutor Name $index'),
            subtitle: Text('Rate this tutor:'),
            trailing: DropdownButton<int>(
              items: [1, 2, 3, 4, 5].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                // Functionality to submit rating
              },
            ),
            onTap: () {
              // Navigate to review details (if needed)
            },
          );
        },
      ),
    );
  }
}
