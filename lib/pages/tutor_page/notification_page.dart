import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  final String tutorId;

  NotificationPage({required this.tutorId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;  // Add a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final notificationsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorId)
          .collection('notifications'); // Assuming notifications are stored here

      QuerySnapshot snapshot = await notificationsRef.get();
      setState(() {
        _notifications = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include document ID in the data map
          return data;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching notifications: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : _notifications.isEmpty
            ? Center(
          child: Text(
            'No notifications found',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        )
            : ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            final title = notification['title'] ?? 'No Title';
            final message = notification['message'] ?? 'No Message';
            final date = notification['date'] != null
                ? (notification['date'] as Timestamp).toDate()
                : null;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(
                  Icons.notifications,
                  color: Colors.teal,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.teal[800]),
                ),
                subtitle: Text(
                  message,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[700], height: 1.5),
                ),
                trailing: date == null
                    ? Text('N/A')
                    : Text(
                  '${date.month}/${date.day}/${date.year}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
