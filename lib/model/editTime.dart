import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTime extends StatefulWidget {
  EditTime({Key? key, required this.todo}) : super(key: key);
  final DocumentSnapshot todo;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTime> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.todo['name'];
    _name.text = widget.todo['name'];
    _dayController.text = widget.todo['day'];
    _dayController.text = widget.todo['day'];
    DateTime time = widget.todo['startTime'].toDate();
    _timeController.text = DateFormat('hh:mm a').format(time);
    DateTime end = widget.todo['startTime'].toDate();
    _endTimeController.text = DateFormat('hh:mm a').format(end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Activity', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
                hintText: 'name',
              ),
            ),
            const SizedBox(height: 16.0,),
            TextField(
              controller: _dayController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
                hintText: 'Day',
              ),
            ),
            const SizedBox(height: 16.0,),
            Row(
  children: [
    Expanded(
      child: TextField(
        controller: _timeController,
        
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
          hintText: 'Start time',
        ),
        onTap: () async {
          TimeOfDay? timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (timeOfDay != null) {
            _timeController.text = timeOfDay.format(context);
          }
        },
      ),
    ),
    const SizedBox(width: 16.0),
    Expanded(
      child: TextField(
        controller: _endTimeController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
          hintText: 'End Time',
        ),
        onTap: () async {
          TimeOfDay? timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (timeOfDay != null) {
            _endTimeController.text = timeOfDay.format(context);
          }
        },
      ),
    ),
  ],
),

            const SizedBox(height: 32.0),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String taskName = _name.text;
                  String day = _dayController.text;
                  String timeStr = _timeController.text;
                  String ends = _endTimeController.text;
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  // Convert time string to DateTime object
                  DateTime startTimeDT = DateFormat('hh:mm a').parse(timeStr);
                  DateTime endTimeDT = DateFormat('hh:mm a').parse(ends);
                  
                  Timestamp startTimeStamp = Timestamp.fromDate(startTimeDT);
                  Timestamp endTimeStamp = Timestamp.fromDate(endTimeDT);

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('timeTable')
                      .doc(widget.todo.id)
                      .update({'name': taskName, 'day': day, 'startTime': startTimeStamp, 'endTime': endTimeStamp})
                      .then((value) {
                    print('Timetable edited successfully!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Failed to edit timetable: $error');
                  });
                },
                child: const Text('Edit Task'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
