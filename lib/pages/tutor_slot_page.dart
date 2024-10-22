import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Batch class definition
class Batch {
  String batchName;
  String time;

  Batch({required this.batchName, required this.time});

  // Convert Batch to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'batchName': batchName,
      'time': time,
    };
  }

  // Factory constructor to create a Batch from a map
  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      batchName: map['batchName'] ?? '',
      time: map['time'] ?? '',
    );
  }
}

class TutorSlotPage extends StatefulWidget {
  final String tutorUid;

  TutorSlotPage({required this.tutorUid});

  @override
  _TutorSlotPageState createState() => _TutorSlotPageState();
}

class _TutorSlotPageState extends State<TutorSlotPage> {
  final List<Batch> _batches = [];
  final TextEditingController _batchNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSlots(); // Fetch saved slots when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Slots'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _batchNameController,
              decoration: InputDecoration(
                labelText: 'Batch Name',
              ),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addBatch,
              child: Text('Add Slot'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _batches.length,
                itemBuilder: (context, index) {
                  final batch = _batches[index];
                  return ListTile(
                    title: Text(batch.batchName),
                    subtitle: Text(batch.time),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeBatch(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveToFirestore,
        child: Icon(Icons.save),
      ),
    );
  }

  // Fetch slots from Firestore
  Future<void> _fetchSlots() async {
    try {
      final CollectionReference slotsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorUid)
          .collection('slots');

      QuerySnapshot snapshot = await slotsRef.get();
      setState(() {
        _batches.clear();
        _batches.addAll(snapshot.docs
            .map((doc) => Batch.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching slots: $e'),
      ));
    }
  }

  // Add a new batch to the list
  void _addBatch() {
    final String batchName = _batchNameController.text;
    final String time = _timeController.text;

    if (batchName.isNotEmpty && time.isNotEmpty) {
      setState(() {
        _batches.add(Batch(batchName: batchName, time: time));
      });

      // Clear the text fields after adding
      _batchNameController.clear();
      _timeController.clear();
    }
  }

  // Remove a batch from the list
  void _removeBatch(int index) {
    setState(() {
      _batches.removeAt(index);
    });
  }

  // Save the list of batches to Firestore
  Future<void> _saveToFirestore() async {
    try {
      final CollectionReference slotsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorUid)
          .collection('slots');

      // Clear the previous slots before adding new ones
      await slotsRef.get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      for (Batch batch in _batches) {
        await slotsRef.add(batch.toMap());
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Slots saved successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving slots: $e'),
      ));
    }
  }
}
