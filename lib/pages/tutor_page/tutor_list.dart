import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../student_page/Chat_page_Student.dart'; // Import StudentChatPage

class TutorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Tutors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('savedTutors') // Get the saved tutors for the student
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final savedTutors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: savedTutors.length,
            itemBuilder: (context, index) {
              final tutor = savedTutors[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    tutor['tutorName'], // Tutor's name
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    tutor['subject'] ?? 'Subject not available', // Tutor's subject
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                  trailing: Icon(Icons.chat, color: Colors.green),
                  onTap: () {
                    // Navigate to the chat page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          tutorId: tutor['tutorId'], // Pass tutorId and tutorName to the chat page
                          tutorName: tutor['tutorName'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
