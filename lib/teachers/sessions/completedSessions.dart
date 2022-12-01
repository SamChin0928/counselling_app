import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../teacherHome.dart';

FirebaseAuth auth = FirebaseAuth.instance;

currentUserData() {
  final user = auth.currentUser;
  final userID = user?.uid;

  return userID;
}

class Post {
  final String date;
  final String time;
  final String topic;
  final String area;
  final String studentName;

  Post(this.date, this.time, this.topic, this.area, this.studentName);
}

class CompletedSessions extends StatefulWidget {
  @override
  _CompletedSessionsState createState() => _CompletedSessionsState();
}

class _CompletedSessionsState extends State<CompletedSessions> {
  final List items = [];

  final DateFormat formattedDate = new DateFormat('MMMM dd, yyyy');

  Color _boxColor = Colors.white;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void onBack() {
    Navigator.pushNamedAndRemoveUntil(context, '/TeacherHome', (_) => false);
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
                  builder: (context) => TeacherHome(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: Text('Done Sessions'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('completedSessions')
                  .where('teacherId', isEqualTo: currentUserData().toString())
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: _getData,
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned.fill(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            padding: const EdgeInsets.all(15.0),
                            itemBuilder: (context, position) {
                              return new GestureDetector(
                                //You need to make my child interactive
                                onTap: () => {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  margin: const EdgeInsets.only(
                                    bottom: 15.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _boxColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 90,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data.docs[position]['date']))}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          '${DateFormat.jm().format(DateTime.parse(snapshot.data.docs[position]['date'] + " " + snapshot.data.docs[position]['time']))}',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    65),
                                            AutoSizeText(
                                              '${snapshot.data.docs[position]['topic']}',
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: new TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    30),
                                            AutoSizeText(
                                              '${snapshot.data.docs[position]['studentName']}',
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: new TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '${snapshot.data.docs[position]['area']}',
                                              textAlign: TextAlign.left,
                                              style: new TextStyle(
                                                fontSize: 15.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      if (snapshot.data.docs.isEmpty)
                        Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You have not completed any sessions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Text(
                                  'Pull down to refresh',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    CupertinoIcons.arrow_clockwise,
                                    size: 20.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ]),
                        ),
                    ]),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.deepPurple,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {});
  }
}
