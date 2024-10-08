import 'package:flutter/material.dart';

class TutorHomePage extends StatefulWidget {
  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends State<TutorHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> students = [
    {"name": "Student 1", "time": "10:00 AM - 11:00 AM", "location": "Location A"},
    {"name": "Student 2", "time": "11:30 AM - 12:30 PM", "location": "Location B"},
    {"name": "Student 3", "time": "2:00 PM - 3:00 PM", "location": "Location C"},
  ];
  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all students
    filteredStudents = students;
  }

  void _filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = students; // Reset to all students
      });
    } else {
      setState(() {
        filteredStudents = students
            .where((student) => student["name"]!.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter the list based on the query
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Student Requests'),
              onTap: () {
                Navigator.pushNamed(context, '/student-requests');
              },
            ),
            ListTile(
              leading: Icon(Icons.timeline),
              title: Text('Edit Time Slots'),
              onTap: () {
                // Log out action here
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Log out action here
              },
            ),
            ListTile(
              leading: Icon(Icons.person_3_rounded),
              title: Text('Current Students'),
              onTap: () {
                // Log out action here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Log out action here
              },
            ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome, Tamjid!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a student',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterStudents, // Call filter method on input change
            ),
            const SizedBox(height: 20),
            // Headline for schedule section
            Text(
              'Scheduled Sessions',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display the filtered student schedule
            for (var student in filteredStudents)
              _buildScheduleItem(student["name"]!, student["time"]!, student["location"]!),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String studentName, String time, String location) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(studentName),
        subtitle: Text('$time @ $location'),
      ),
    );
  }
}
