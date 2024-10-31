import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Batch {
  String batchName;
  String time;
  List<String> days;

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
  String _selectedTime = 'Select Time';
  Map<String, bool> _selectedDays = {
    'Saturday': false,
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
  };

  @override
  void initState() {
    super.initState();
    _fetchSlots();
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
            SizedBox(height: 10),
            InkWell(
              onTap: () => _pickTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
                child: Text(_selectedTime),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _selectedDays.keys.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: _selectedDays[day],
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedDays[day] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _addBatch,
              child: Text('Add Slot'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.tutorUid)
                    .collection('slots')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  _batches.clear();
                  _batches.addAll(docs.map((doc) => Batch.fromMap(doc.data() as Map<String, dynamic>)));

                  return ListView.builder(
                    itemCount: _batches.length,
                    itemBuilder: (context, index) {
                      final batch = _batches[index];
                      return ListTile(
                        title: Text(batch.batchName),
                        subtitle: Text('${batch.time} on ${batch.days.join(', ')}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeBatch(docs[index].id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  void _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    }
  }

  void _addBatch() {
    final String batchName = _batchNameController.text;
    final String time = _selectedTime;
    final List<String> selectedDays = _selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (batchName.isNotEmpty && time != 'Select Time' && selectedDays.isNotEmpty) {
      final newBatch = Batch(batchName: batchName, time: time, days: selectedDays);
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tutorUid)
          .collection('slots')
          .add(newBatch.toMap());

      _batchNameController.clear();
      setState(() {
        _selectedTime = 'Select Time';
        _selectedDays.updateAll((key, value) => false);
      });
    }
  }

  void _removeBatch(String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.tutorUid)
        .collection('slots')
        .doc(docId)
        .delete();
  }
}
