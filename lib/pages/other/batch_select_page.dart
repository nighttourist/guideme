import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Batch {
  final String batchName;
  final String time;
  final List<String> days;

  Batch({required this.batchName, required this.time, required this.days});

  Map<String, dynamic> toMap() {
    return {
      'batchName': batchName,
      'time': time,
      'days': days,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      batchName: map['batchName'] ?? '',
      time: map['time'] ?? '',
      days: List<String>.from(map['days'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Batch &&
        other.batchName == batchName &&
        other.time == time &&
        other.days.toString() == days.toString();
  }

  @override
  int get hashCode => batchName.hashCode ^ time.hashCode ^ days.hashCode;
}

class TutorBatchSelectionPage extends StatefulWidget {
  final String tutorUid;
  final String tutorName;
  final String studentUid;
  final String studentName;

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
  List<Batch> _selectedBatches = [];

  @override
  void initState() {
    super.initState();
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
    if (_selectedBatches.isNotEmpty) {
      try {
        final studentBatchesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.studentUid)
            .collection('enrollments');

        for (var batch in _selectedBatches) {
          await studentBatchesRef.add({
            'batchName': batch.batchName,
            'time': batch.time,
            'days': batch.days,
            'tutorName': widget.tutorName,
            'tutorUid': widget.tutorUid,
            'enrollmentDate': Timestamp.now(),
          });
        }

        final tutorRequestsRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.tutorUid)
            .collection('requests');

        for (var batch in _selectedBatches) {
          await tutorRequestsRef.add({
            'studentUid': widget.studentUid,
            'studentName': widget.studentName,
            'tutorName': widget.tutorName,
            'batchName': batch.batchName,
            'time': batch.time,
            'days': batch.days,
            'requestDate': Timestamp.now(),
            'status': "",
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Batches selected and requests sent successfully!'),
        ));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error confirming batch: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select at least one batch'),
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
                  return CheckboxListTile(
                    title: Text(batch.batchName),
                    subtitle: Text('${batch.time} - ${batch.days.join(', ')}'), // Display time and list of days
                    value: _selectedBatches.contains(batch),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked != null && isChecked) {
                          _selectedBatches.add(batch);
                        } else {
                          _selectedBatches.remove(batch);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmBatchSelection,
              child: Text('Confirm Batch(s)'),
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
