import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/logoutConfirmation.dart';
import 'package:councelling_booking_app/teachers/sessions/allSessions.dart';
import 'package:councelling_booking_app/teachers/sessions/yourSessions.dart';
import 'package:councelling_booking_app/teachers/sessions/completedSessions.dart';
import '../generalSettings.dart';
import '../localNotificationService.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final messaging = FirebaseMessaging.instance;

currentUserData() {
  final user = auth.currentUser;
  final userID = user?.uid;

  return userID;
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class TeacherHome extends StatefulWidget {
  TeacherHome({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<TeacherHome> {
  final List items = [];

  final DateFormat formattedDate = new DateFormat('MMMM dd, yyyy');
  List<Appointment> appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);

    messaging.subscribeToTopic("newSession");

    //Tapable message even when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      final routeForMessage = message!.data["route"];

      if (message.notification != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/${routeForMessage}', (_) => false);
      }
    });

    //Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    //App in background and must be opened and user onTaps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeForMessage = message.data["route"];

      Navigator.pushNamedAndRemoveUntil(
          context, '/${routeForMessage}', (_) => false);
    });

    FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .onValue
        .listen((Event event) {
      if (event.snapshot.value == null) {
        return null;
      } else {
        appointments.clear();
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key, values) {
          DateTime dateTimeStart =
              DateTime.parse(values["date"] + " " + values["time"]);
          DateTime dateTimeEnd =
              DateTime.parse(values["date"] + " " + values["time"])
                  .add(new Duration(hours: 1));
          if (values["teacherId"] == currentUserData().toString()) {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.deepPurple,
                location: values['area']));
          } else if (values["teacherId"] != currentUserData().toString() &&
              values["teacherId"] != "") {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.orange,
                location: values['area']));
          } else {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.blue,
                location: values['area']));
          }
        });
      }
    });
  }

  _DataSource _getDataSource() {
    FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .onValue
        .listen((Event event) {
      if (event.snapshot.value == null) {
        return null;
      } else {
        appointments.clear();
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key, values) {
          DateTime dateTimeStart =
              DateTime.parse(values["date"] + " " + values["time"]);
          DateTime dateTimeEnd =
              DateTime.parse(values["date"] + " " + values["time"])
                  .add(new Duration(hours: 1));
          if (values["teacherId"] == currentUserData().toString()) {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.deepPurple,
                location: values['area']));
          } else if (values["teacherId"] != currentUserData().toString() &&
              values["teacherId"] != "") {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.orange,
                location: values['area']));
          } else {
            appointments.add(Appointment(
                startTime: dateTimeStart,
                endTime: dateTimeEnd,
                subject: values['topic'],
                color: Colors.blue,
                location: values['area']));
          }
        });
      }
    });
    return _DataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("SSIS Care"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      );
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      userDocument.docs[0]['name'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    );
                  }),
            ),
            ListTile(
              title: Text('All Sessions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSessions(),
                    ));
              },
            ),
            ListTile(
              title: Text('Your Sessions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YourSessions(),
                    ));
              },
            ),
            ListTile(
              title: Text('Done Sessions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompletedSessions(),
                    ));
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GeneralSettings(),
                    ));
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                logoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.3,
        child: StreamBuilder(
            stream:
                FirebaseDatabase.instance.reference().child('sessions').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SfCalendar(
                  dataSource: _getDataSource(),
                  view: CalendarView.month,
                  firstDayOfWeek: 1, // Monday
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: (CalendarTapDetails details) {},
                  todayHighlightColor: Colors.deepPurple,
                  showNavigationArrow: true,
                  monthViewSettings: MonthViewSettings(
                    showAgenda: true,
                    agendaItemHeight: 70,
                    agendaViewHeight: MediaQuery.of(context).size.height / 5,
                    showTrailingAndLeadingDates: true,
                  ),
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
    );
  }
}
