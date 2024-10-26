import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedTutorsPage extends StatefulWidget {
  @override
  _SavedTutorsPageState createState() => _SavedTutorsPageState();
}

class _SavedTutorsPageState extends State<SavedTutorsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> _savedTutors = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedTutors();
  }

  Future<void> _fetchSavedTutors() async {
    if (user == null) return;

    try {
      final savedTutorsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('savedTutors')
          .get();

      setState(() {
        _savedTutors = savedTutorsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include document ID for deletion
          return data;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching saved tutors: $e'),
      ));
    }
  }

  Future<void> _deleteTutor(String tutorId) async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('savedTutors')
          .doc(tutorId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tutor removed from saved list!'),
      ));

      // Refresh the saved tutors list
      _fetchSavedTutors();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting tutor: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Tutors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _savedTutors.isEmpty
            ? Center(child: Text('No saved tutors'))
            : ListView.builder(
          itemCount: _savedTutors.length,
          itemBuilder: (context, index) {
            final tutor = _savedTutors[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    tutor['tutorName'][0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(tutor['tutorName'] ?? 'N/A'),
                subtitle: Text('Batch: ${tutor['batchName'] ?? 'N/A'}\nTime: ${tutor['time'] ?? 'N/A'}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, tutor['id']);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String tutorId) {
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
                _deleteTutor(tutorId);
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
