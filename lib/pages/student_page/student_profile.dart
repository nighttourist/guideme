import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Student Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildProfileDetail("Name", userData!['name']),
                SizedBox(height: 10),
                _buildProfileDetail("Email", userData!['email']),
                SizedBox(height: 10),
                _buildProfileDetail("Student ID", userData!['studentId']),
                SizedBox(height: 10),
                _buildProfileDetail("Address", userData!['address']),
                SizedBox(height: 10),
                _buildProfileDetail("Grade", userData!['grade']),
                SizedBox(height: 10),
                _buildProfileDetail("Date of Birth", userData!['dateOfBirth'] != null
                    ? DateTime.parse(userData!['dateOfBirth']).toLocal().toString().split(' ')[0]
                    : "Not provided"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value ?? "Not available",
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
