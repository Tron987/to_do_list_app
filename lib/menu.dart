import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/loginScreen.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'Other Tools',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Google Calendar'),
            onTap: () async {
              const googleCalendarUrlScheme = 'com.google.calendar://';
              if (await canLaunch(googleCalendarUrlScheme)) {
                await launch(googleCalendarUrlScheme);
              } else {
              //
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Evernote'),
            onTap: () async {
              const evernoteUrlScheme = 'evernote://';
              if (await canLaunch(evernoteUrlScheme)) {
                await launch(evernoteUrlScheme);
              } else {
                // Handle the case where the user doesn't have Evernote installed
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
