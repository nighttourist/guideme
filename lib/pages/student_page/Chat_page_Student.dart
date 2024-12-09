import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String tutorId;
  final String tutorName;

  ChatPage({required this.tutorId, required this.tutorName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
  }

  // Method to send a message to Firestore
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final message = _controller.text;

      // Send the message to Firestore under the chat collection
      await FirebaseFirestore.instance.collection('chats').add({
        'senderId': _currentUserId,
        'receiverId': widget.tutorId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _controller.clear(); // Clear the text field after sending the message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.tutorName}'),
      ),
      body: Column(
        children: [
          // Display chat messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('senderId', isEqualTo: _currentUserId)
                  .where('receiverId', isEqualTo: widget.tutorId)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text(message['senderId'] == _currentUserId
                          ? 'You'
                          : widget.tutorName),
                    );
                  },
                );
              },
            ),
          ),
          // Input field and send button
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
