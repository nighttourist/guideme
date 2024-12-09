import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSearchPage extends StatefulWidget {
  final String tutorId;

  StudentSearchPage({required this.tutorId});

  @override
  _StudentSearchPageState createState() => _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredStudents = [];
  List<Map<String, dynamic>> _allStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchAllStudents();
  }

  // Fetch all students for the tutor
  Future<void> _fetchAllStudents() async {
    try {
      final studentsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('Students');

      QuerySnapshot snapshot = await studentsRef.get();
      final students = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();

      setState(() {
        _allStudents = students;
        _filteredStudents = students;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  // Filter students based on search input
  void _filterStudents(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final name = student['studentName']?.toLowerCase() ?? '';
        final email = student['email']?.toLowerCase() ?? '';
        final grade = student['grade']?.toLowerCase() ?? '';
        return name.contains(lowerQuery) ||
            email.contains(lowerQuery) ||
            grade.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name, email, or grade',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterStudents, // Dynamically filter as user types
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredStudents.isEmpty
                  ? Center(child: Text('No students found'))
                  : ListView.builder(
                itemCount: _filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = _filteredStudents[index];
                  final studentName = student['studentName'] ?? 'N/A';
                  final studentGrade = student['grade'] ?? 'N/A';

                  return ListTile(
                    title: Text(studentName),
                    subtitle: Text('Grade: $studentGrade'),
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
