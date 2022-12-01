import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'students/bookings/bookings.dart';
import 'students/alertDialogs/successBooking.dart';
import 'students/alertDialogs/alreadyBooked.dart';
import 'students/alertDialogs/mainDialog.dart';
import 'students/alertDialogs/saturdayNotWorking.dart';
import 'students/alertDialogs/sundayNotWorking.dart';
import 'services/logoutConfirmation.dart';
import 'teachers/teacherHome.dart';
import 'generalSettings.dart';

final messaging = FirebaseMessaging.instance;

int _messageCount = 0;
String constructFCMPayload() {
  _messageCount++;
  return jsonEncode({
    "to": "/topics/newSession",
    "notification": {
      "body": "A student has booked a session. Have a look",
      "title": "New Session Booked"
    },
    "data": {
      "route": "TeacherHome",
    }
  });
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    messaging.unsubscribeFromTopic('newSession');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs[0]['role'] == 'student') {
                  return MyHomePage();
                } else if (snapshot.data.docs[0]['role'] == 'teacher') {
                  return TeacherHome();
                }
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

FirebaseAuth auth = FirebaseAuth.instance;

currentUserData() {
  final user = auth.currentUser;
  final userID = user?.uid;

  return userID;
}

String? _subjectText = '',
    _startTimeText = '',
    _endTimeText = '',
    _dateText = '',
    _timeDetails = '',
    _areaDetails = '';

DateTime now = new DateTime.now();

String? studentName = '';

List<TimeRegion> _getTimeRegions() {
  final List<TimeRegion> regions = <TimeRegion>[];
  regions.add(TimeRegion(
      startTime: DateTime(now.year, now.month, now.day, 12, 0, 0),
      endTime: DateTime(now.year, now.month, now.day, 14, 0, 0),
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MON,TUE,WED,THU,FRI',
      text: "Lunch",
      color: Color(0xFFBD3D3D3),
      enablePointerInteraction: false,
      textStyle: TextStyle(
        color: Colors.black,
      )));

  return regions;
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageRouteState createState() => _MyHomePageRouteState();
}

class _MyHomePageRouteState extends State<MyHomePage> {
  CalendarController _calendarController = new CalendarController();
  final DateFormat dateCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');

  bool viewType = false;

  String viewText = "Week View";

  List<Appointment> appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) {
      studentName = snapshot.docs[0]['name'];
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
          appointments.add(Appointment(
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            subject: values["userId"] == currentUserData().toString()
                ? values['topic']
                : 'Booked',
            color: values["userId"] == currentUserData().toString()
                ? Colors.deepPurple
                : Colors.red,
            location: values["userId"] == currentUserData().toString()
                ? values['area']
                : '',
          ));
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
          appointments.add(Appointment(
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            subject: values["userId"] == currentUserData().toString()
                ? values['topic']
                : 'Booked',
            color: values["userId"] == currentUserData().toString()
                ? Colors.deepPurple
                : Colors.red,
            location: values["userId"] == currentUserData().toString()
                ? values['area']
                : '',
          ));
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
              title: Text('Bookings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Bookings(),
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
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton.icon(
                  icon: Icon(
                    CupertinoIcons.calendar_today,
                    size: 24.0,
                  ),
                  label: Text(viewText),
                  onPressed: () {
                    appointments.clear();

                    if (viewType == true) {
                      viewType = false;
                      _calendarController.view = CalendarView.workWeek;
                    } else {
                      viewType = true;
                      _calendarController.view = CalendarView.month;
                    }

                    if (viewText == "Week View") {
                      setState(() {
                        viewText = "Month View";
                      });
                    } else {
                      setState(() {
                        viewText = "Week View";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            color: Colors.blue[600],
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('sessions')
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SfCalendar(
                      dataSource: _getDataSource(),
                      controller: _calendarController,
                      minDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
                      view: CalendarView.workWeek,
                      firstDayOfWeek: 1, // Monday
                      headerStyle: CalendarHeaderStyle(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: (CalendarTapDetails details) {
                        DateFormat dateFormatter = DateFormat('EEEE');
                        if (dateFormatter.format(details.date!) == "Sunday") {
                          sundayNotWorking(context);
                        } else if (dateFormatter.format(details.date!) ==
                            "Saturday") {
                          saturdayNotWorking(context);
                        } else {
                          if (details.targetElement ==
                                  CalendarElement.appointment ||
                              details.targetElement == CalendarElement.agenda) {
                            final Appointment appointmentDetails =
                                details.appointments![0];
                            _subjectText = appointmentDetails.subject;
                            _dateText = DateFormat('MMMM dd, yyyy')
                                .format(appointmentDetails.startTime)
                                .toString();
                            _startTimeText = DateFormat('hh:mm a')
                                .format(appointmentDetails.startTime)
                                .toString();
                            _endTimeText = DateFormat('hh:mm a')
                                .format(appointmentDetails.endTime)
                                .toString();
                            _areaDetails = appointmentDetails.location;
                            if (appointmentDetails.isAllDay) {
                              _timeDetails = 'All day';
                            } else {
                              _timeDetails = '$_startTimeText - $_endTimeText';
                            }
                            mainDialog(
                                context,
                                details,
                                appointmentDetails,
                                _subjectText!,
                                _dateText!,
                                _timeDetails!,
                                _areaDetails!,
                                details.date!);
                          } else {
                            if (viewType == false) {
                              _sendDataToSecondScreen(context);
                            } else {
                              _sendDataToCalendarDay(context);
                            }
                          }
                        }
                      },
                      todayHighlightColor: Colors.deepPurple,
                      showNavigationArrow: true,
                      specialRegions: _getTimeRegions(),
                      timeSlotViewSettings: TimeSlotViewSettings(
                        dateFormat: 'd',
                        dayFormat: 'EEE',
                        startHour: 9,
                        endHour: 18,
                        nonWorkingDays: <int>[
                          DateTime.sunday,
                          DateTime.saturday
                        ],
                        timeIntervalHeight: -1,
                      ),
                      monthViewSettings: MonthViewSettings(
                        showAgenda: true,
                        agendaItemHeight: 70,
                        agendaViewHeight:
                            MediaQuery.of(context).size.height / 5,
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
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Text(
                  "- Long press a box in month view to see day's agenda",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                Text(
                  "- Scroll through dates by swiping left / right",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                Text(
                  "- Tap a box to book a session",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // get the text in the TextField and start the Second Screen
  void _sendDataToSecondScreen(BuildContext context) {
    CalendarController dateToSend = _calendarController;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondRoute(
          date: dateToSend,
        ),
      ),
    );
  }

  // get the text in the TextField and start the Second Screen
  void _sendDataToCalendarDay(BuildContext context) {
    CalendarController dateToSend = _calendarController;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarDay(
          date: dateToSend,
        ),
      ),
    );
  }
}

class CalendarDay extends StatefulWidget {
  final CalendarController date;
  CalendarDay({Key? key, required this.date}) : super(key: key);

  @override
  _CalendarDayState createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {
  final CalendarController _calendarController = CalendarController();
  final DateFormat dateCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');

  List<Appointment> appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .onValue
        .listen((Event data) {
      if (data.snapshot.value == null) {
        return null;
      } else {
        appointments.clear();
        Map<dynamic, dynamic> values = data.snapshot.value;
        values.forEach((key, values) {
          DateTime dateTimeStart =
              DateTime.parse(values["date"] + " " + values["time"]);
          DateTime dateTimeEnd =
              DateTime.parse(values["date"] + " " + values["time"])
                  .add(new Duration(hours: 1));
          appointments.add(Appointment(
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            subject: values["userId"] == currentUserData().toString()
                ? 'Your Booking'
                : 'Booked',
            color: values["userId"] == currentUserData().toString()
                ? Colors.deepPurple
                : Colors.red,
          ));
        });
      }
    });
  }

  _DataSource _getDataSource() {
    FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .onValue
        .listen((Event data) {
      if (data.snapshot.value == null) {
        return null;
      } else {
        appointments.clear();
        Map<dynamic, dynamic> values = data.snapshot.value;
        values.forEach((key, values) {
          DateTime dateTimeStart =
              DateTime.parse(values["date"] + " " + values["time"]);
          DateTime dateTimeEnd =
              DateTime.parse(values["date"] + " " + values["time"])
                  .add(new Duration(hours: 1));
          appointments.add(Appointment(
            startTime: dateTimeStart,
            endTime: dateTimeEnd,
            subject: values["userId"] == currentUserData().toString()
                ? 'Your Booking'
                : 'Booked',
            color: values["userId"] == currentUserData().toString()
                ? Colors.deepPurple
                : Colors.red,
          ));
        });
      }
    });
    return _DataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Day View"),
      ),
      body: Container(
        child: StreamBuilder(
            stream:
                FirebaseDatabase.instance.reference().child('sessions').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SfCalendar(
                  dataSource: _getDataSource(),
                  controller: _calendarController,
                  minDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
                  view: CalendarView.timelineDay,
                  firstDayOfWeek: 1, // Monday
                  initialDisplayDate: widget.date.selectedDate,
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment ||
                        details.targetElement == CalendarElement.agenda) {
                      final Appointment appointmentDetails =
                          details.appointments![0];
                      _subjectText = appointmentDetails.subject;
                      _dateText = DateFormat('MMMM dd, yyyy')
                          .format(appointmentDetails.startTime)
                          .toString();
                      _startTimeText = DateFormat('hh:mm a')
                          .format(appointmentDetails.startTime)
                          .toString();
                      _endTimeText = DateFormat('hh:mm a')
                          .format(appointmentDetails.endTime)
                          .toString();
                      if (appointmentDetails.isAllDay) {
                        _timeDetails = 'All day';
                      } else {
                        _timeDetails = '$_startTimeText - $_endTimeText';
                      }
                      mainDialog(
                        context,
                        details,
                        appointmentDetails,
                        _subjectText!,
                        _dateText!,
                        _timeDetails!,
                        _areaDetails!,
                        details.date!,
                      );
                    } else {
                      _sendDataToSecondScreen(context);
                    }
                  },
                  todayHighlightColor: Colors.black,
                  showNavigationArrow: true,
                  specialRegions: _getTimeRegions(),
                  // dataSource: _getDataSource(),
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 9,
                    endHour: 18,
                    nonWorkingDays: <int>[DateTime.sunday, DateTime.saturday],
                    timeIntervalHeight: -1,
                    timelineAppointmentHeight:
                        MediaQuery.of(context).size.height,
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

  // get the text in the TextField and start the Second Screen
  void _sendDataToSecondScreen(BuildContext context) {
    CalendarController dateToSend = _calendarController;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondRoute(
            date: dateToSend,
          ),
        ));
  }
}

class SecondRoute extends StatefulWidget {
  final CalendarController date;

  SecondRoute({Key? key, required this.date}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  TextEditingController _topicField = TextEditingController();
  final DateFormat dateCompilation = DateFormat('yyyy-MM-dd');
  final DateFormat timeCompilation = DateFormat('HH:mm:ss');
  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
  final DateFormat timeFormatter = DateFormat.jm();

  String dropdownValue = "Bedroom";
  bool valueExists = false;

  Future<void> sendPushMessage() async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Authorization':
              'key=AAAA8xewR68:APA91bFbtj4O0SKhMoFgnc73aBOko3obFPj2lxzBLEIHoZKnep5eVr5i5i-KJKi3Rt0_euwXD0krTMY5RE3hdNIJx7azJIcAM7ty2htKKoUHcd4cfWLh2p4NJMzzMX84kolxRglWols8',
          'Content-Type': 'application/json',
        },
        body: constructFCMPayload(),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.grey),
                initialValue:
                    dateFormatter.format(widget.date.selectedDate!).toString(),
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.grey),
                initialValue:
                    timeFormatter.format(widget.date.selectedDate!).toString(),
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Time",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _topicField,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                  ),
                  hintText: "Relationship...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  labelText: "Add Topic",
                  labelStyle: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Area you will hold your session",
                    labelStyle: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  value: dropdownValue.toString(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Bedroom',
                    'Living Room',
                    'Public Space',
                    'Private Space'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                        ),
                      ),
                    );
                  }).toList(),
                )),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseDatabase.instance
                      .reference()
                      .child("sessions")
                      .once()
                      .then((DataSnapshot data) {
                    setState(() {
                      if (data.value == null) {
                        writeData(widget.date);
                        showSuccess(context);
                      } else {
                        Map<dynamic, dynamic> values = data.value;
                        values.forEach((key, values) {
                          if (values["date"] ==
                                  dateCompilation
                                      .format(widget.date.selectedDate!) &&
                              values["time"] ==
                                  timeCompilation
                                      .format(widget.date.selectedDate!)) {
                            valueExists = true;
                          } else {
                            if (valueExists != true) {
                              valueExists = false;
                            }
                          }
                        });

                        if (valueExists != true) {
                          writeData(widget.date);
                          sendPushMessage();
                          showSuccess(context);
                        } else {
                          showAlreadyBookedMainPage(context);
                        }
                      }
                    });
                  });
                },
                child: Text('Submit'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "1.   ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Please ensure that you are in a comfortable space",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 55),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "2.   ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Please be by yourself so that the counsellors can properly discuss your topic",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 55),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "3.   ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Video call is preferred, so please ensure you are somewhere you can freely talk",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 25),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Flexible(
                child: Text(
                  "All information is kept private and will not be shared unless allowed / asked to do so by the counselled",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void writeData(CalendarController date) {
    final DateFormat timeFormatter = DateFormat('HH:mm:ss');
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat dateCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');

    DatabaseReference _submittedInfo = FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .child(dateFormatter.format(date.selectedDate!).toString() +
            " " +
            timeFormatter.format(date.selectedDate!).toString());

    final userSave = _submittedInfo.child("userId");
    final topicSave = _submittedInfo.child("topic");
    final areaSave = _submittedInfo.child("area");
    final dateSave = _submittedInfo.child("date");
    final timeSave = _submittedInfo.child("time");
    final studentSave = _submittedInfo.child("studentName");
    final teacherNameSave = _submittedInfo.child("teacherName");
    final teacherIdSave = _submittedInfo.child("teacherId");

    userSave.set(currentUserData().toString());
    topicSave.set(_topicField.text);
    areaSave.set(dropdownValue);
    dateSave.set(dateFormatter.format(date.selectedDate!).toString());
    timeSave.set(timeFormatter.format(date.selectedDate!).toString());
    studentSave.set(studentName);
    teacherNameSave.set('');
    teacherIdSave.set('');
  }
}
