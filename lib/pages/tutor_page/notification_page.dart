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
      });
    } catch (e) {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _notifications.isEmpty
            ? Center(child: Text('No notifications found'))
            : ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(notification['title'] ?? 'No Title'),
                subtitle: Text(notification['message'] ?? 'No Message'),
                trailing: Text(notification['date'] != null
                    ? (notification['date'] as Timestamp)
                    .toDate()
                    .toString()
                    : 'N/A'),
              ),
            );
          },
        ),
      ),
    );
  }
}