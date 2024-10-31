import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_enrollment_page.dart'; // Import the new page

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

      // Convert the map back to a list
      setState(() {
        _students = uniqueStudentsMap.values.toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching students: $e'),
      ));
    }
  }

  void _navigateToEnrollmentDetails(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentEnrollmentPage (studentId: studentId),
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
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Student Name: ${student['studentName'] ?? 'N/A'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${student['email'] ?? 'N/A'}'),
                    Text('Grade: ${student['grade'] ?? 'N/A'}'),
                    Text('Address: ${student['address'] ?? 'N/A'}'),
                  ],
                ),
                onTap: () => _navigateToEnrollmentDetails(student['studentId']),
              ),
            );
          },
        ),
      ),
    );
  }
}
