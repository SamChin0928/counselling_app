import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../bookings/updateBookings.dart';
import '../../home.dart';

final DateFormat dateCompilation = DateFormat('yyyy-MM-dd HH:mm:ss');

mainDialog(
  BuildContext context,
  CalendarTapDetails details,
  Appointment appointmentDetails,
  String _subjectText,
  String _dateText,
  String _timeDetails,
  String _areaDetails,
  DateTime selectedDate,
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text(_subjectText)),
          content: Container(
            height: 80,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      _dateText,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 65),
                Row(
                  children: <Widget>[
                    Text(
                      _timeDetails,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _areaDetails,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            appointmentDetails.color.value == 4284955319
                ? new TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateBooking(
                              date: details.date!,
                              time: appointmentDetails.startTime,
                              topic: _subjectText,
                              dropDownValue: _areaDetails,
                            ),
                          ));
                    },
                    child: new Text('edit'),
                  )
                : Text(""),
            appointmentDetails.color.value == 4284955319
                ? new TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Container(
                                  child: new Text(
                                      'Are you sure about removing this booking?')),
                              content: Container(
                                height: MediaQuery.of(context).size.height / 10,
                                width: MediaQuery.of(context).size.height / 10,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            'Once removed, you will have to re-book the slot in the main page',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
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
                                        .child(dateCompilation
                                            .format(selectedDate))
                                        .remove();

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: new Text('yes'),
                                ),
                                new TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text('no'),
                                ),
                              ],
                            );
                          });
                    },
                    child: new Text('remove'),
                  )
                : Text(""),
            new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text('close'))
          ],
        );
      });
}
