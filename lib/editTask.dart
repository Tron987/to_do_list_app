import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  EditTask({Key? key, required this.todo}) : super(key: key);
  final DocumentSnapshot todo;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskNameController.text = widget.todo['taskName'];
    DateTime time = widget.todo['time'].toDate();
    _timeController.text = DateFormat('hh:mm a').format(time);
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
                  DateTime time = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    timeOfDay.hour,
                    timeOfDay.minute,
                  );
                  _timeController.text = DateFormat('hh:mm a').format(time);
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
                      .doc(widget.todo.id)
                      .update({'taskName': taskName, 'time': time})
                      .then((value) {
                    print('Todo edited successfully!');
                    Navigator.pop(context);
                  }).catchError((error) {
                    print('Failed to edit todo: $error');
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
