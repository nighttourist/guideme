import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'batch_select_page.dart';

class TutorSearchPage extends StatefulWidget {
  @override
  _TutorSearchPageState createState() => _TutorSearchPageState();
}

class _TutorSearchPageState extends State<TutorSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedSubject;
  String? selectedLocation;
  List<Map<String, dynamic>> tutors = [];
  String? studentName; // To store the current user's name

  // Fetch tutors from Firestore
  Future<void> _fetchTutors() async {
    QuerySnapshot snapshot = await _firestore.collection('users').where('role', isEqualTo: 'tutor').get();
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
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      setState(() {
        studentName = userDoc['name']; // Assuming 'name' field stores the user's name
      });
    }
  }

  // Filter tutors based on selected subject and location
  List<Map<String, dynamic>> _filteredTutors() {
    return tutors.where((tutor) {
      final matchesSubject = selectedSubject == null || tutor['subject'] == selectedSubject;
      final matchesLocation = selectedLocation == null || tutor['location'] == selectedLocation;
      return matchesSubject && matchesLocation;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchTutors();
    _fetchCurrentUser(); // Fetch current user's name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Tutors'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(),
              ),
              items: ['Math', 'Science', 'English', 'Programming']
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
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(),
              ),
              items: ['Dhaka', 'Chittagong', 'Rajshahi', 'Sylhet']
                  .map((location) => DropdownMenuItem(
                value: location,
                child: Text(location),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
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
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          (tutor['name'] ?? 'N/A')[0], // Fallback if name is null
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(tutor['name'] ?? 'Name not available'),
                      subtitle: Text(
                        'Subjects: ${tutor['subject'] ?? 'N/A'}\n'
                            'Location: ${tutor['location'] ?? 'N/A'}\n'
                            'Rating: 4.5 ⭐',
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
                                tutorName: tutor['name'] ?? 'Name not available',
                                studentUid: currentUser.uid,
                                studentName: studentName!, // Pass the student name
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not logged in or name not found.')),
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
