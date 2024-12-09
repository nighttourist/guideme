import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../other/batch_select_page.dart';

class TutorSearchPage extends StatefulWidget {
  @override
  _TutorSearchPageState createState() => _TutorSearchPageState();
}

class _TutorSearchPageState extends State<TutorSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedAddress;
  String? selectedSubject;
  List<Map<String, dynamic>> tutors = [];
  String? studentName; // To store the current user's name

  // Fetch tutors from Firestore
  Future<void> _fetchTutors() async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'tutor')
        .get();
    setState(() {
      tutors = snapshot.docs.map((doc) {
        final tutorData = doc.data() as Map<String, dynamic>;
        tutorData['uid'] = doc.id; // Add the document ID as 'uid'
        return tutorData;
      }).toList();
    });
  }

  // Fetch current user's name from Firestore
  Future<void> _fetchCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(currentUser.uid).get();
      setState(() {
        studentName =
        userDoc['name']; // Assuming 'name' field stores the user's name
      });
    }
  }

  // Filter tutors based on selected address and subject
  List<Map<String, dynamic>> _filteredTutors() {
    return tutors.where((tutor) {
      final matchesAddress =
          selectedAddress == null || tutor['location'] == selectedAddress;
      final matchesSubject =
          selectedSubject == null || tutor['subject'] == selectedSubject;
      return matchesAddress && matchesSubject;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchTutors();
    _fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Tutor Search'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Tutors',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Address',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      'Dhaka',
                      'Chittagong',
                      'Khulna',
                      'Rajshahi',
                      'Sylhet',
                      'Barisal',
                      'Rangpur',
                      'Mymensingh'
                    ]
                        .map((location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAddress = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Subject',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      'Physics',
                      'Chemistry',
                      'Math',
                      'Linux',
                      'English',
                      'Programming',
                      'History',
                      'Biology'
                    ]
                        .map((subject) => DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {}); // Refresh the filtered list
              },
              icon: Icon(Icons.search),
              label: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTutors().length,
                itemBuilder: (context, index) {
                  final tutor = _filteredTutors()[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          (tutor['name'] ?? 'N/A')[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        tutor['name'] ?? 'Name not available',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Subjects: ${tutor['subject'] ?? 'N/A'}\n'
                            'Location: ${tutor['location'] ?? 'N/A'}\n'
                            'Rating: 4.5 ⭐',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        User? currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null && studentName != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorBatchSelectionPage(
                                tutorUid: tutor['uid'] ?? '',
                                tutorName:
                                tutor['name'] ?? 'Name not available',
                                studentUid: currentUser.uid,
                                studentName:
                                studentName!, // Pass the student name
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'User not logged in or name not found.')),
                          );
                        }
                      },
                    ),
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
