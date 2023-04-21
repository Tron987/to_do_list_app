import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task', style: TextStyle(color: Colors.white)),
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
              controller: _nameController,
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
        controller: _startTimeController,
        
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
            _startTimeController.text = timeOfDay.format(context);
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String name = _nameController.text;
                  String day = _dayController.text;
                  String startTime = _startTimeController.text;
                  String endTime = _endTimeController.text;
                  
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  // Convert time string to DateTime object
                  DateTime startTimeDT = DateFormat('hh:mm a').parse(startTime);
                  DateTime endTimeDT = DateFormat('hh:mm a').parse(endTime);
                  
                  Timestamp startTimeStamp = Timestamp.fromDate(startTimeDT);
                  Timestamp endTimeStamp = Timestamp.fromDate(endTimeDT);
                  //Timestamp startTimestamp = Timestamp.fromDate(startTimeDT);
                  //Timestamp endTimestamp = Timestamp.fromDate(endTimeDT);
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('timeTable')
                      .add({'name': name, 'day': day , 'startTime' : startTimeStamp, 'endTime': endTimeStamp})
                      .then((value) {
                    print('TimeTable added successfully!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Failed to add TimeTable: $error');
                  });
                },
                child: const Text('Add to Time Table'),
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
