import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentEnrollmentPage extends StatefulWidget {
  final String studentId;

  StudentEnrollmentPage({required this.studentId});

  @override
  _StudentEnrollmentPageState createState() => _StudentEnrollmentPageState();
}

class _StudentEnrollmentPageState extends State<StudentEnrollmentPage> {
  List<Map<String, dynamic>> _enrollments = [];

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

  Future<void> _fetchEnrollments() async {
    try {
      final enrollmentsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.studentId)
          .collection('enrollments');

      QuerySnapshot snapshot = await enrollmentsRef.get();
      setState(() {
        _enrollments = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include document ID in the data map
          return data;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching enrollments: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrollments for Student ${widget.studentId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _enrollments.isEmpty
            ? Center(child: Text('No enrollments found'))
            : ListView.builder(
          itemCount: _enrollments.length,
          itemBuilder: (context, index) {
            final enrollment = _enrollments[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Batch Name: ${enrollment['batchName'] ?? 'N/A'}'),
                subtitle: Text('Enrollment Date: ${enrollment['date'] ?? 'N/A'}'), // Example field
              ),
            );
          },
        ),
      ),
    );
  }
}
