import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_enrollment_page.dart';
import '../tutor_page/chat_page.dart';

class StudentListPage extends StatefulWidget {
  final String tutorId;

  StudentListPage({required this.tutorId});

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Fetch students for the tutor from Firestore
  Future<void> _fetchStudents() async {
    try {
      final studentsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('Students');

      QuerySnapshot snapshot = await studentsRef.get();
      final uniqueStudentsMap = <String, Map<String, dynamic>>{};

      // Store unique students based on studentId
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final studentId = data['studentId']; // Assuming 'studentId' is the key for student ID
        if (studentId != null) {
          uniqueStudentsMap[studentId] = {
            ...data,
            'id': doc.id, // Include document ID in the data map
          };
        }
      }

      // Convert the map back to a list and update the state
      setState(() {
        _students = uniqueStudentsMap.values.toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching students: $e'),
      ));
    }
  }

  // Navigate to the Student Enrollment Details Page
  void _navigateToEnrollmentDetails(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentEnrollmentPage(studentId: studentId),
      ),
    );
  }

  // Navigate to the Chat Page for a specific student
  void _navigateToChat(String studentId, String studentName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorChatPage(
          studentId: studentId,
          studentName: studentName, // Pass the student name to the chat page
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students for Tutor ${widget.tutorId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _students.isEmpty
            ? Center(child: Text('No students found'))
            : ListView.builder(
          itemCount: _students.length,
          itemBuilder: (context, index) {
            final student = _students[index];
            final studentId = student['studentId'];
            final studentName = student['studentName'] ?? 'N/A';
            final studentEmail = student['email'] ?? 'N/A';
            final studentGrade = student['grade'] ?? 'N/A';
            final studentAddress = student['address'] ?? 'N/A';

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Student Name: $studentName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: $studentEmail'),
                    Text('Grade: $studentGrade'),
                    Text('Address: $studentAddress'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () => _navigateToChat(
                    studentId,
                    studentName, // Correctly pass studentName
                  ),
                ),
                onTap: () => _navigateToEnrollmentDetails(studentId),
              ),
            );
          },
        ),
      ),
    );
  }
}
