import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'home.dart';
import 'teachers/teacherHome.dart';
import 'userAccount.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool page = false;

  List settings = [''];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((values) {
      if (values.docs.isEmpty) {
        return null;
      } else {
        if (values.docs[0]['role'] == 'student') {
          page = true;
          setState(() {
            settings = ['Account', '', '', '', ''];
          });
        } else if (values.docs[0]['role'] == 'teacher') {
          page = false;
          setState(() {
            settings = ['Account', 'Certificate', '', '', ''];
          });
        }
      }
    });
  }

  void onBack() {
    Navigator.pushNamedAndRemoveUntil(
        context, page == true ? '/Home' : '/TeacherHome', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        onBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      page == true ? MyHomePage() : TeacherHome(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: Text('Settings'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Scaffold(
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: new GestureDetector(
                  child: SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          settings[index],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.normal),
                        ),
                        // decoration: BoxDecoration(
                        //   border: Border(
                        //     bottom: BorderSide(
                        //       width: 0.5,
                        //     ),
                        //   ),
                        // ),
                      ),
                      onPressed: () {
                        switch (index) {
                          case 0:
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserAccount(),
                                  ));
                            }
                            break;
                          case 1:
                            {}
                            break;
                          case 2:
                            {}
                            break;
                          case 3:
                            {}
                            break;
                          case 4:
                            {}
                            break;
                          case 5:
                            {}
                            break;
                          default:
                            {
                              print('Invalid Option');
                            }
                            break;
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
