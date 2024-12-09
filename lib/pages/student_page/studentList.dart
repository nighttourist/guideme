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

  Future<void> _fetchStudents() async {
    try {
      final studentsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('Students');

      QuerySnapshot snapshot = await studentsRef.get();
      final uniqueStudentsMap = <String, Map<String, dynamic>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final studentId = data['studentId'];
        if (studentId != null) {
          uniqueStudentsMap[studentId] = {
            ...data,
            'id': doc.id,
          };
        }
      }

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
        builder: (context) => StudentEnrollmentPage(studentId: studentId),
      ),
    );
  }

  void _navigateToChat(String studentId, String studentName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorChatPage(
          studentId: studentId,
          studentName: studentName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _students.isEmpty
            ? Center(
          child: Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        )
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
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        child: Text(
                          studentName[0].toUpperCase(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(
                        studentName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Email: $studentEmail',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.chat,
                          color: Colors.teal,
                        ),
                        onPressed: () => _navigateToChat(
                          studentId,
                          studentName,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grade: $studentGrade',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          Text(
                            'Address: $studentAddress',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _navigateToEnrollmentDetails(studentId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
