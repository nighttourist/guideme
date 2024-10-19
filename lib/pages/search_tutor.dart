import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorSearchPage extends StatefulWidget {
  @override
  _TutorSearchPageState createState() => _TutorSearchPageState();
}

class _TutorSearchPageState extends State<TutorSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Make these variables nullable (String?)
  String? selectedSubject;
  String? selectedLocation;
  List<Map<String, dynamic>> tutors = [];

  // Fetch all tutors from Firestore
  Future<void> _fetchTutors() async {
    QuerySnapshot snapshot = await _firestore.collection('users').where('role', isEqualTo: 'tutor').get();
    setState(() {
      tutors = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Filter tutors by subject and location
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
    _fetchTutors();  // Fetch tutors when the page is loaded
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
            // Search fields for subject and location
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
                  selectedSubject = value;  // No more error because selectedSubject is now nullable
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
                  selectedLocation = value;  // No more error because selectedLocation is now nullable
                });
              },
            ),
            SizedBox(height: 20),
            // Search button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {});  // Rebuild the UI to apply filters
              },
              icon: Icon(Icons.search),
              label: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            // Display list of tutors
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
                          tutor['name'][0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(tutor['name']),
                      subtitle: Text(
                        'Subjects: ${tutor['subject']}\nLocation: ${tutor['location']}\nRating: 4.5 ⭐',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to tutor details page (to be implemented)
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
