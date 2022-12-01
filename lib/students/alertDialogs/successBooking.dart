import 'package:flutter/material.dart';

showSuccess(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Booking Successful!')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Your booking has been made. To change any booking details please go to the "Bookings" tab in the menu',
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
