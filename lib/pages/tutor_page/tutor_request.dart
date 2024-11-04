import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tutor_page/notification_page.dart';
class RequestPage extends StatefulWidget {
  final String tutorId;

  RequestPage({required this.tutorId});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final tutorRequestsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .where('status', isEqualTo: ''); // Filter for pending requests

      QuerySnapshot snapshot = await tutorRequestsRef.get();
      setState(() {
        _requests = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include document ID in the data map
          return data;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching requests: $e'),
      ));
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    try {
      // Update request status to accepted in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      // Fetch updated request document for details
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .doc(requestId)
          .get();

      String studentId = requestDoc['studentUid'];
      String batchName = requestDoc['batchName'] ?? 'N/A';
      String time = requestDoc['time'] ?? 'N/A';

      // Fetch the tutor's details (including tutorName) from the users collection
      DocumentSnapshot tutorDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .get();

      String tutorName = tutorDoc['name'] ?? 'Unknown Tutor';
      String tutorEmail = tutorDoc['email'] ?? 'N/A';
      String tutorSubject = tutorDoc['subject'] ?? 'N/A';  // Example additional field

      // Fetch the student's details from the users collection
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        // Save the full student details in the Students collection under the tutor's document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.tutorId)
            .collection('Students')
            .doc(studentId)
            .set({
          'studentId': studentId,
          'studentName': studentDoc['name'],
          'tutorName': tutorName,
          'email': studentDoc['email'],
          'grade': studentDoc['grade'],
          'address': studentDoc['address'],
          'batchName': batchName,
          'time': time,
        });

        // Save tutor details in the student's savedTutor collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(studentId)
            .collection('savedTutors')
            .doc(widget.tutorId)
            .set({
          'tutorId': widget.tutorId,
          'tutorName': tutorName,
          'tutorEmail': tutorEmail,
          'subject': tutorSubject,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Request accepted, student and tutor saved!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Student details not found.'),
        ));
      }

      // Refresh the requests list to remove accepted request from UI
      _fetchRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error accepting request: $e'),
      ));
    }
  }


  Future<void> _rejectRequest(String requestId) async {
    try {
      // Update request status to rejected in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .doc(requestId)
          .update({'status': 'rejected'});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request rejected successfully!'),
      ));

      // Refresh the requests list to remove rejected request from UI
      _fetchRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error rejecting request: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests for ${widget.tutorId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _requests.isEmpty
            ? Center(child: Text('No requests found'))
            : ListView.builder(
          itemCount: _requests.length,
          itemBuilder: (context, index) {
            final request = _requests[index];
            final requestId = request['id'] as String?;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Student: ${request['studentName'] ?? 'N/A'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Batch: ${request['batchName'] ?? 'N/A'}'),
                    Text('Time: ${request['time'] ?? 'N/A'}'),
                    Text(
                        'Date: ${request['requestDate'] != null ? (request['requestDate'] as Timestamp).toDate().toString() : 'N/A'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptRequest(requestId!),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _rejectRequest(requestId!),
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
