import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../alertDialogs/alreadyBooked.dart';
import '../alertDialogs/editDone.dart';
import '../alertDialogs/youBooked.dart';
import 'bookings.dart';
import '../alertDialogs/weekendWarning.dart';

FirebaseAuth auth = FirebaseAuth.instance;

currentUserData() {
  final user = auth.currentUser;
  final userID = user?.uid;

  return userID;
}

class UpdateBooking extends StatefulWidget {
  final DateTime date;
  final DateTime time;
  final String topic;
  final String dropDownValue;

  UpdateBooking({
    Key? key,
    required this.date,
    required this.time,
    required this.topic,
    required this.dropDownValue,
  }) : super(key: key);

  @override
  _UpdateBookingState createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking> {
  TextEditingController _topicField = TextEditingController();
  TextEditingController _dateField = TextEditingController();
  TextEditingController _timeField = TextEditingController();

  final DateFormat dayFinder = DateFormat('EEEE');
  final DateFormat dateConverter = DateFormat('MMMM dd, yyyy');
  final DateFormat dateCompilation = DateFormat('yyyy-MM-dd');
  final DateFormat timeCompilation = DateFormat('HH:mm:ss');
  final DateFormat dateAndTimeCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');
  final DateFormat dateAndTimeCompilationNoSeconds =
      DateFormat('yyyy-MM-dd HH:mm');
  final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
  final DateFormat timeFormatter = DateFormat.jm();

  String dropdownValue = "Bedroom";
  bool valueExists = false;
  String dateUpdated = '';
  String timeUpdated = '';

  @override
  void initState() {
    super.initState();
    dateUpdated = widget.date.toString();
    timeUpdated = widget.time.toString();
    _topicField = TextEditingController(text: widget.topic);
    _dateField = TextEditingController(
        text: dateFormatter.format(widget.date).toString());
    _timeField = TextEditingController(
        text: timeFormatter.format(widget.time).toString());
  }

  void onBack() {
    Navigator.pushNamedAndRemoveUntil(context, '/Bookings', (_) => false);
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
                  builder: (context) => Bookings(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: Text('Edit Booking'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
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
                  style: TextStyle(color: Colors.black),
                  controller: _dateField,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    hintStyle: null,
                    labelStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    errorText: dayFinder.format(
                                    dateConverter.parse(_dateField.text)) ==
                                "Sunday" ||
                            dayFinder.format(
                                    dateConverter.parse(_dateField.text)) ==
                                "Saturday"
                        ? 'Councellors are not working on Saturdays/Sundays'
                        : '',
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(dateUpdated),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != widget.date)
                      setState(() {
                        _dateField = TextEditingController(
                            text: dateFormatter.format(picked).toString());
                        dateUpdated = picked.toString();
                      });
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: _timeField,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: "Time",
                    labelStyle: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () async {
                    // print(timeUpdated);
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.dial,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        );
                      },
                      initialTime: TimeOfDay(
                        hour: int.parse(timeCompilation
                            .format(DateTime.parse(timeUpdated))
                            .split(":")[0]),
                        minute: int.parse(timeCompilation
                            .format(DateTime.parse(timeUpdated))
                            .split(":")[1]),
                      ),
                    );
                    if (newTime != null && newTime != widget.time) {
                      final now = DateTime.parse(
                          dateCompilation.format(DateTime.parse(dateUpdated)));

                      final dt = DateTime(now.year, now.month, now.day,
                          newTime.hour, newTime.minute);

                      setState(() {
                        _timeField = TextEditingController(
                            text: timeFormatter
                                .format(DateTime.parse(
                                    dateAndTimeCompilation.format(dt)))
                                .toString());

                        timeUpdated = dt.toString();
                      });
                    }
                  },
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
                      borderSide: const BorderSide(
                          color: Colors.deepPurple, width: 2.0),
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
                    value: widget.dropDownValue,
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
                    if (dayFinder.format(DateTime.parse(dateUpdated)) ==
                            "Sunday" ||
                        dayFinder.format(DateTime.parse(dateUpdated)) ==
                            "Saturday") {
                      weekendWarning(context);
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child("sessions")
                          .once()
                          .then((DataSnapshot data) {
                        setState(() {
                          if (data.value == null) {
                            editData(widget.date);
                            editDone(context);
                          } else {
                            Map<dynamic, dynamic> values = data.value;
                            values.forEach((key, values) {
                              if (values["date"] ==
                                      dateCompilation.format(
                                          DateTime.parse(dateUpdated)) &&
                                  values["time"] ==
                                      timeCompilation.format(
                                          DateTime.parse(timeUpdated))) {
                                valueExists = true;
                              } else {
                                if (valueExists != true) {
                                  valueExists = false;
                                }
                              }
                            });
                            if (valueExists != true) {
                              editData(widget.date);
                              editDone(context);
                            } else {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child("sessions")
                                  .once()
                                  .then((DataSnapshot data) {
                                Map<dynamic, dynamic> values = data.value;
                                List value = [];
                                values.forEach((key, values) {
                                  value.add(key + "/" + values['userId']);
                                });
                                for (int i = 0; i < value.length; i++) {
                                  if (value[i].contains(
                                          '${dateCompilation.format(DateTime.parse(dateUpdated)).toString()} ${timeCompilation.format(DateTime.parse(timeUpdated)).toString()}') &&
                                      value[i].contains(
                                          currentUserData().toString())) {
                                    if (widget.topic != _topicField.text &&
                                        widget.dropDownValue == dropdownValue) {
                                      editData(widget.date);
                                      editDone(context);
                                      break;
                                    } else if (widget.topic ==
                                            _topicField.text &&
                                        widget.dropDownValue != dropdownValue) {
                                      editData(widget.date);
                                      editDone(context);
                                      break;
                                    } else if (widget.topic !=
                                            _topicField.text &&
                                        widget.dropDownValue != dropdownValue) {
                                      editData(widget.date);
                                      editDone(context);
                                      break;
                                    } else {
                                      youBooked(
                                          context,
                                          widget.date,
                                          widget.date,
                                          _topicField.text,
                                          dropdownValue);
                                      break;
                                    }
                                  } else if (value[i].contains(
                                          '${dateCompilation.format(DateTime.parse(dateUpdated)).toString()} ${timeCompilation.format(DateTime.parse(timeUpdated)).toString()}') &&
                                      !value[i].contains(
                                          currentUserData().toString())) {
                                    showAlreadyBookedBookingPage(
                                        context,
                                        widget.date,
                                        widget.date,
                                        _topicField.text,
                                        dropdownValue);
                                    break;
                                  }
                                }
                              });
                            }
                          }
                        });
                      });
                    }
                  },
                  child: Text('Edit'),
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
      ),
    );
  }

  void editData(DateTime date) {
    final DateFormat timeFormatter = DateFormat('HH:mm:ss');
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat dateCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');

    FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .child(dateCompilation.format(date))
        .remove();

    DatabaseReference _submittedInfo = FirebaseDatabase.instance
        .reference()
        .child("sessions")
        .child(dateFormatter.format(DateTime.parse(dateUpdated)).toString() +
            " " +
            timeFormatter.format(DateTime.parse(timeUpdated)).toString());

    final userSave = _submittedInfo.child("userId");
    userSave.set(currentUserData().toString());

    final topicSave = _submittedInfo.child("topic");
    topicSave.set(_topicField.text);

    final areaSave = _submittedInfo.child("area");
    areaSave.set(dropdownValue);

    final dateSave = _submittedInfo.child("date");
    dateSave.set(dateFormatter.format(DateTime.parse(dateUpdated)).toString());

    final timeSave = _submittedInfo.child("time");
    timeSave.set(timeFormatter.format(DateTime.parse(timeUpdated)).toString());
  }
}
