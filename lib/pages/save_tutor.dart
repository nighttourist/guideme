import 'package:flutter/material.dart';

class SavedTutorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Tutors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 5, // Replace with the actual number of saved tutors
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    'T$index',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('Saved Tutor Name $index'),
                subtitle: Text('Subjects: Math, Science\nRating: 4.5 ⭐'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
                onTap: () {
                  // Navigate to tutor details page
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Saved Tutor"),
          content: Text("Are you sure you want to remove this tutor from your saved list?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without deleting
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
