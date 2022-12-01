import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<void> userSetup(
    String name, String email, String phoneNumber, String studentClass) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({
      'uid': uid.toString(),
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'studentClass': studentClass,
      'role': 'student'
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email');
    }
  } catch (e) {
    print(e.toString());
  }
}

Future<void> teacherSetup(String name, String email, String phoneNumber) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({
      'uid': uid.toString(),
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': 'teacher'
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email');
    }
  } catch (e) {
    print(e.toString());
  }
}
