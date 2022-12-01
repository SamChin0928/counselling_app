import '../bookings/updateBookings.dart';
import 'package:flutter/material.dart';

showAlreadyBookedMainPage(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Already Booked')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Sorry for the inconvenience but this slot has already been booked before your booking',
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
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/Home', (_) => false);
                },
                child: new Text('close'))
          ],
        );
      });
}

showAlreadyBookedBookingPage(BuildContext context, DateTime date, DateTime time,
    String topic, String dropDownValue) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Already Booked')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Sorry for the inconvenience but this slot has already been booked before your booking',
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
