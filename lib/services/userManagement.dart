import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import '../home.dart';
import '../login/authentication.dart';

class UserManagement {
  Widget handleAuth() {
    return new StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return Authentication();
          }
        });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
