import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../teacherHome.dart';

sessionTake(
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
) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Do you want this session?')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  '"Yes" if you want to take this session.\n\n"No" if you do not want this session.',
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
                  DatabaseReference _submittedInfo = FirebaseDatabase.instance
                      .reference()
                      .child("sessions")
                      .child(date + " " + time);

                  final userSave = _submittedInfo.child("userId");
                  final topicSave = _submittedInfo.child("topic");
                  final areaSave = _submittedInfo.child("area");
                  final dateSave = _submittedInfo.child("date");
                  final timeSave = _submittedInfo.child("time");
                  final studentSave = _submittedInfo.child("studentName");
                  final teacherNameSave = _submittedInfo.child("teacherName");
                  final teacherIdSave = _submittedInfo.child("teacherId");

                  userSave.set(studentId);
                  topicSave.set(topic);
                  areaSave.set(area);
                  dateSave.set(date);
                  timeSave.set(time);
                  studentSave.set(studentName);
                  teacherNameSave.set(teacherName);
                  teacherIdSave.set(teacherId);

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
