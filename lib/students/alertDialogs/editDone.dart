import 'package:flutter/material.dart';

import '../bookings/bookings.dart';

editDone(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Booking Edited!')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Your booking has been edited.',
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
                      MaterialPageRoute(builder: (context) => Bookings()),
                      (Route<dynamic> route) => false);
                },
                child: new Text('close'))
          ],
        );
      });
}
