import 'package:flutter/material.dart';

import '../bookings/updateBookings.dart';

youBooked(BuildContext context, DateTime date, DateTime time, String topic,
    String dropDownValue) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('You Booked This Session')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'You have already booked this session.',
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => UpdateBooking(
                          date: date,
                          time: time,
                          topic: topic,
                          dropDownValue: dropDownValue,
                        ),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: new Text('close'))
          ],
        );
      });
}
