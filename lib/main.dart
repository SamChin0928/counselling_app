import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'login/authentication.dart';
import 'home.dart';
import 'teachers/teacherHome.dart';
import 'login/studentRegister.dart';
import 'login/teacherRegister.dart';
import 'services/userManagement.dart';
import 'students/bookings/bookings.dart';
import 'localNotificationservice.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  LocalNotificationService.display(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Councelling Booking',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: UserManagement().handleAuth(),
      routes: {
        "/Home": (_) => new Home(),
        "/TeacherHome": (_) => new TeacherHome(),
        "/StudentRegister": (_) => new StudentRegister(),
        "/TeacherRegister": (_) => new TeacherRegister(),
        "/Authentication": (_) => new Authentication(),
        "/Bookings": (_) => new Bookings(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
