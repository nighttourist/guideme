import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Batch {
  final String batchName;
  final String time;

  Batch({required this.batchName, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'batchName': batchName,
      'time': time,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      batchName: map['batchName'] ?? '',
      time: map['time'] ?? '',
    );
  }
}

class TutorBatchSelectionPage extends StatefulWidget {
  final String tutorUid;
  final String tutorName;
  final String studentUid;
  final String studentName;// Add the studentUid to directly save selections

  TutorBatchSelectionPage({
    required this.tutorUid,
    required this.tutorName,
    required this.studentUid,
    required this.studentName,
  });

  @override
  _TutorBatchSelectionPageState createState() => _TutorBatchSelectionPageState();
}

class _TutorBatchSelectionPageState extends State<TutorBatchSelectionPage> {
  List<Batch> _availableBatches = [];
  Batch? _selectedBatch;

  @override
  void initState() {
    super.initState();
    print('Tutor UID: ${widget.tutorUid}');
    print('Tutor Name: ${widget.tutorName}');
    print('StudentID Name: ${widget.studentUid}');
    _fetchAvailableBatches();
  }

  Future<void> _fetchAvailableBatches() async {
    try {
      final CollectionReference slotsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorUid)
          .collection('slots');

      QuerySnapshot snapshot = await slotsRef.get();
      setState(() {
        _availableBatches = snapshot.docs
            .map((doc) => Batch.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching batches: $e'),
      ));
    }
  }

  Future<void> _confirmBatchSelection() async {
    if (_selectedBatch != null) {
      try {
        final studentBatchesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.studentUid)
            .collection('enrollments');

        // Save the student's enrollment under their profile
        await studentBatchesRef.add({
          'batchName': _selectedBatch!.batchName,
          'time': _selectedBatch!.time,
          'tutorName': widget.tutorName,
          'tutorUid': widget.tutorUid,
          'enrollmentDate': Timestamp.now(),
        });

        // Save the request directly under the tutor's document in the users collection
        final tutorRequestsRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.tutorUid)
            .collection('requests');

        await tutorRequestsRef.add({
          'studentUid': widget.studentUid,
          'studentName': widget.studentName, // Replace with actual student name if available
          'batchName': _selectedBatch!.batchName,
          'time': _selectedBatch!.time,
          'requestDate': Timestamp.now(),
          'status':"",
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Batch selected and request sent successfully!'),
        ));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error confirming batch: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a batch'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches for ${widget.tutorName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Batches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _availableBatches.length,
                itemBuilder: (context, index) {
                  final batch = _availableBatches[index];
                  return ListTile(
                    title: Text(batch.batchName),
                    subtitle: Text(batch.time),
                    leading: Radio<Batch>(
                      value: batch,
                      groupValue: _selectedBatch,
                      onChanged: (Batch? value) {
                        setState(() {
                          _selectedBatch = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmBatchSelection,
              child: Text('Confirm Batch'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
