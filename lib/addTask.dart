import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AddActivityPage extends StatelessWidget {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  AddActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity', style: TextStyle(color: Colors.white)),
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
              controller: _taskNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
                hintText: 'Task Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(223, 161, 93, 68).withOpacity(0.5),
                hintText: 'Time',
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
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String taskName = _taskNameController.text;
                  String timeStr = _timeController.text;
                  String uid = FirebaseAuth.instance.currentUser!.uid;

                  // Convert time string to DateTime object
                  DateTime time = DateFormat('hh:mm a').parse(timeStr);

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('todos')
                      .add({'taskName': taskName, 'time': time})
                      .then((value) {
                    print('Todo added successfully!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Failed to add todo: $error');
                  });
                },
                child: const Text('Add Todo List'),
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
