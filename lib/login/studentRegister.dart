import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';

import '../net/flutterfire.dart';
import 'authentication.dart';
import '../home.dart';

class StudentRegister extends StatefulWidget {
  StudentRegister({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<StudentRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _phoneField = TextEditingController();
  TextEditingController _classField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _nameField = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;

  bool submitValid = false;

  void sendOtp() async {
    EmailAuth.sessionName = "Sri Sempurna Care";
    bool result = await EmailAuth.sendOtp(receiverMail: _emailField.text);
    if (result) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('OTP sent')));
      setState(() {
        submitValid = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP could not be sent. Please try again')));
    }
  }

  void onBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Authentication(),
      ),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: new WillPopScope(
        onWillPop: () async {
          onBack();
          return true;
        },
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 20,
                  left: MediaQuery.of(context).size.width / 8.5,
                  right: MediaQuery.of(context).size.width / 8.5),
              children: [
                Container(
                  child: new Image.asset(
                    'assets/images/ssis_logo.png',
                    width: 200,
                    height: 200,
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _nameField,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                      ),
                      hintText: "name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Name",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _classField,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                      ),
                      hintText: "7 Aman",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Class",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your class';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _phoneField,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                      ),
                      hintText: "0123456789",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _emailField,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                      ),
                      hintText: "something@email.com",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _passwordField,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                      ),
                      hintText: "password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.deepPurple,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        sendOtp();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterOTP(
                              studentName: _nameField.text,
                              studentClass: _classField.text,
                              studentEmail: _emailField.text,
                              studentPhone: _phoneField.text,
                              studentPassword: _passwordField.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/Authentication', (_) => false);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterOTP extends StatefulWidget {
  final String studentName;
  final String studentClass;
  final String studentEmail;
  final String studentPhone;
  final String studentPassword;

  RegisterOTP({
    Key? key,
    required this.studentName,
    required this.studentClass,
    required this.studentEmail,
    required this.studentPhone,
    required this.studentPassword,
  }) : super(key: key);

  @override
  _RegisterOTPState createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _otpField = TextEditingController();
  bool otpValid = false;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  void verify() {
    var res = EmailAuth.validate(
        receiverMail: widget.studentEmail.toString(), userOTP: _otpField.text);
    if (res) {
      setState(() {
        otpValid = true;
      });
    } else {
      setState(() {
        otpValid = false;
      });
    }
  }

  void onBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StudentRegister(),
      ),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        onBack();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => StudentRegister(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: Text('Bookings'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20,
                    left: MediaQuery.of(context).size.width / 8.5,
                    right: MediaQuery.of(context).size.width / 8.5),
                children: [
                  Container(
                    child: new Image.asset(
                      'assets/images/ssis_logo.png',
                      width: 200,
                      height: 200,
                    ),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _otpField,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurple, width: 2.0),
                        ),
                        hintText: "Enter OTP",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: "OTP",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP sent to your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    child: Text(
                      'An OTP has been sent to your email. Plase find the OTP number and enter it here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.deepPurple,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        verify();
                        if (_formKey.currentState!.validate()) {
                          if (otpValid == true) {
                            bool shouldNavigate = await register(
                                widget.studentEmail.toString(),
                                widget.studentPassword.toString());
                            await userSetup(
                                widget.studentName.toString(),
                                widget.studentEmail.toString(),
                                widget.studentPhone.toString(),
                                widget.studentClass.toString());
                            if (shouldNavigate) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(greeting().toString())));
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (Route<dynamic> route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Invalid OTP')));
                            }
                          }
                        }
                      },
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
