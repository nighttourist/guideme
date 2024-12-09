import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request accepted successfully!'),
      ));
      _fetchRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error accepting request: $e'),
      ));
    }
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('requests')
          .doc(requestId)
          .update({'status': 'rejected'});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request rejected successfully!'),
      ));
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
        title: Text(
          'Requests',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _requests.isEmpty
            ? Center(
          child: Text(
            'No requests found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: _requests.length,
          itemBuilder: (context, index) {
            final request = _requests[index];
            final requestId = request['id'] as String?;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  request['studentName'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Batch: ${request['batchName'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Time: ${request['time'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Date: ${request['requestDate'] != null ? (request['requestDate'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'N/A'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Accept Request',
                      onPressed: () => _acceptRequest(requestId!),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      tooltip: 'Reject Request',
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
