import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../teacherHome.dart';

sessionCompleted(
  BuildContext context,
  List items,
  int position,
  String teacherId,
  String teacherName,
  String studentName,
  String date,
  String area,
  String topic,
  String studentId,
  String time,
  String finishedTiime,
) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Have you completed this session?')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  '"Yes" if you have completed the session.\n\n"No" if you have not.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  FirebaseDatabase.instance
                      .reference()
                      .child("sessions")
                      .child('${date + " " + time}')
                      .remove();

                  CollectionReference takenSessions = FirebaseFirestore.instance
                      .collection('completedSessions');
                  takenSessions.add({
                    'teacherId': teacherId,
                    'teacherName': teacherName,
                    'studentName': studentName,
                    'area': area,
                    'date': date,
                    'time': time,
                    'topic': topic,
                    'studentId': studentId,
                    'timeFinished': finishedTiime,
                  });

                  Navigator.of(context).pop();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => TeacherHome(),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: new Text('yes')),
            new TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('no')),
          ],
        );
      });
}
