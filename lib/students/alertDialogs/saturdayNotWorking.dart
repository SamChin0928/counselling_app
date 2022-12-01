import 'package:flutter/material.dart';

saturdayNotWorking(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Not Working')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Counsellors are not available on Saturdays. Sorry for any inconveniences caused.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 18),
                Text(
                  'Please make a booking on a weekday',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text('close'))
          ],
        );
      });
}
