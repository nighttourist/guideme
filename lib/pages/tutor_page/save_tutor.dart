import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedTutorsPage extends StatefulWidget {
  @override
  _SavedTutorsPageState createState() => _SavedTutorsPageState();
}

class _SavedTutorsPageState extends State<SavedTutorsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  List<Map<String, dynamic>> _savedTutors = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedTutors();
  }

  Future<void> _fetchSavedTutors() async {
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

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
    } finally {
      setState(() {
        _isLoading = false;
      });
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

      _fetchSavedTutors(); // Refresh the saved tutors list
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
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _savedTutors.isEmpty
          ? Center(
        child: Text(
          'No saved tutors yet!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _savedTutors.length,
        itemBuilder: (context, index) {
          final tutor = _savedTutors[index];
          final tutorName = tutor['tutorName'] ?? 'Unnamed Tutor';
          final batchName = tutor['batchName'] ?? 'N/A';
          final time = tutor['time'] ?? 'N/A';

          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  tutorName[0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(tutorName),
              subtitle: Text(
                'Batch: $batchName\nTime: $time',
                style: TextStyle(fontSize: 14),
              ),
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
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String tutorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Saved Tutor"),
          content: Text(
              "Are you sure you want to remove this tutor from your saved list?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTutor(tutorId);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
