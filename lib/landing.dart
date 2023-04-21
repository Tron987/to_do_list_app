import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist/TimeTable.dart';
import 'package:todolist/addTask.dart';
import 'package:todolist/editTask.dart';
import 'package:todolist/menu.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/editTime.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [HomeTab(), GroupsTab(), TimetableTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    Widget? floatingButton;

    switch (_currentIndex) {
      case 0:
        floatingButton = FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddActivityPage()));
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add),
        );
        break;
      case 1:
        floatingButton = FloatingActionButton.extended(
          onPressed: () {
            //TODO: Implement create group functionality
          },
          backgroundColor: Colors.purple,
          label: const Text('Create'),
          icon: const Icon(Icons.add),
        );
        break;
      case 2:
        floatingButton = FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TimeTable()));
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add),
        );
        break;
      case 3:
        floatingButton = null;
        break;
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: const Menu(),
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: Colors.white),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Colors.white),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, color: Colors.white),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.red,
      ),
      floatingActionButton: floatingButton,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class HomeTab extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteDocument(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('todos')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('todos')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Container(
          color: Colors.white,
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              DateTime time = data['time'].toDate();
              String formattedTime = DateFormat('hh:mm a').format(time);
              return ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.purple,
                  child: ListTile(
                    leading: Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      data['taskName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(todo: document),
      ),
    );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            deleteDocument(document.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}




class GroupsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Groups Tab'),
    );
  }
}

class TimetableTab extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  
 
    Future<void> deleteDocument(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('timeTable')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('timeTable')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Container(
  color: Colors.white,
  child: ListView(
    children: snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      Timestamp startTimeStamp = data['startTime'];
      DateTime startTime = startTimeStamp.toDate();
      String formattedTime = DateFormat('hh:mm a').format(startTime);

      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Colors.purple,
          child: ListTile(
            leading: Text(
              formattedTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              data['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTime(todo: document),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    deleteDocument(document.id);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  ),
);

      },
    );
  }
  
}

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final User? user = FirebaseAuth.instance.currentUser;
  File? _image;

  Future<void> _getImage(ImageSource source) async {
  final pickedFile = await ImagePicker().getImage(source: source);
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
      
    // Upload edited image to database and update user's photoUrl field
    final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${user?.uid}.jpg');
    final taskSnapshot = await storageRef.putFile(_image!);
    final photoUrl = await taskSnapshot.ref.getDownloadURL();

    print('Photo URL: $photoUrl');

    await FirebaseFirestore.instance
          .collection('users') 
          .doc(user!.uid)
          .set({'photoUrl': photoUrl}, SetOptions(merge: true));

          print('Photo uploaded to database');
  }
}


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
        final String? name = data?['name'] as String?;
        final String? email = data?['email'] as String?;
        final String? photoUrl = data?['photoUrl'] as String?;

        return Center(
          child: Container(
            color: Colors.transparent,
            
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl)
                      : const AssetImage('images/try.png') as ImageProvider<Object>,
                ),
                ElevatedButton(
                  child: const Text('Add Photo'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Select Image"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              GestureDetector(
                                child: const Text("Gallery"),
                                onTap: () {
                                  _getImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                child: const Text("Camera"),
                                onTap: () {
                                  _getImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(email ?? '', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                
              ],
            ),
          ),
        );
      },
    );
  }
}



