import 'package:flutter/material.dart';

import 'userManagement.dart';

logoutConfirmation(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: new Text('Logout')),
          content: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: <Widget>[
                Text(
                  'Are you sure you want to logout?',
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
                  Navigator.pop(context);
                },
                child: new Text('No')),
            new TextButton(
                onPressed: () {
                  UserManagement().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/Authentication', (_) => false);
                },
                child: new Text('Yes'))
          ],
        );
      });
}
