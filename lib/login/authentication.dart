import 'package:flutter/material.dart';

import '../net/flutterfire.dart';
import '../home.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Form(
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
                      return 'Please enter your password';
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
                      bool shouldNavigate =
                          await signIn(_emailField.text, _passwordField.text);
                      if (shouldNavigate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(greeting().toString())));
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'You have entered an incorrect email / password')));
                      }
                    }
                  },
                  child: Text(
                    "Login",
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
                        context, '/StudentRegister', (_) => false);
                  },
                  child: Text(
                    "Student Register",
                    style: TextStyle(color: Colors.black),
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
                        context, '/TeacherRegister', (_) => false);
                  },
                  child: Text(
                    "Teacher Register",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
