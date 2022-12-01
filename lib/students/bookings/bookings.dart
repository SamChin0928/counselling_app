import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'updateBookings.dart';
import '../../home.dart';

FirebaseAuth auth = FirebaseAuth.instance;

currentUserData() {
  final user = auth.currentUser;
  final userID = user?.uid;

  return userID;
}

class Post {
  final String date;
  final String time;
  final String topic;
  final String area;

  Post(this.date, this.time, this.topic, this.area);
}

class Bookings extends StatefulWidget {
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final List items = [];

  final DateFormat formattedDate = new DateFormat('MMMM dd, yyyy');

  Color _boxColor = Colors.white;

  @override
  void initState() {
    super.initState();
    setState(() {
      FirebaseDatabase.instance
          .reference()
          .child("sessions")
          .orderByChild("date")
          .onValue
          .listen((Event event) {
        if (event.snapshot.value == null) {
          return null;
        } else {
          Map<dynamic, dynamic> values = event.snapshot.value;
          values.forEach((key, values) {
            values["userId"] == currentUserData().toString()
                ? items.add(new Post(values["date"], values["time"],
                    values["topic"], values['area']))
                : null;
          });
        }
      });
    });
  }

  void onBack() {
    Navigator.pushNamedAndRemoveUntil(context, '/Home', (_) => false);
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
                  builder: (context) => Home(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: Text('Bookings'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("sessions")
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (items.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: _getData,
                        child: Stack(alignment: Alignment.center, children: [
                          Positioned.fill(
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: items.length,
                                padding: const EdgeInsets.all(15.0),
                                itemBuilder: (context, position) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        5.5,
                                    margin: const EdgeInsets.only(
                                      bottom: 15.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _boxColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                35),
                                        ListTile(
                                          leading: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 90,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${DateFormat.yMMMMd('en_US').format(DateTime.parse(items[position].date))}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          title: Text(
                                            '${DateFormat.jm().format(DateTime.parse(items[position].date + " " + items[position].time))}',
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      65),
                                              AutoSizeText(
                                                '${items[position].topic}',
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                style: new TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      40),
                                              Text(
                                                '${items[position].area}',
                                                textAlign: TextAlign.left,
                                                style: new TextStyle(
                                                  fontSize: 15.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 100,
                                                child: Row(
                                                  children: [
                                                    RawMaterialButton(
                                                      elevation: 2.0,
                                                      splashColor:
                                                          Colors.black12,
                                                      enableFeedback: true,
                                                      shape: CircleBorder(),
                                                      fillColor: Colors.white,
                                                      child: new Icon(
                                                        CupertinoIcons.pencil,
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                      constraints:
                                                          BoxConstraints
                                                              .tightFor(
                                                        width: 46.0,
                                                        height: 46.0,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateBooking(
                                                                date: DateTime.parse(items[
                                                                            position]
                                                                        .date +
                                                                    " " +
                                                                    items[position]
                                                                        .time),
                                                                time: DateTime.parse(items[
                                                                            position]
                                                                        .date +
                                                                    " " +
                                                                    items[position]
                                                                        .time),
                                                                topic: items[
                                                                        position]
                                                                    .topic,
                                                                dropDownValue:
                                                                    items[position]
                                                                        .area,
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                    IconButton(
                                                      enableFeedback: true,
                                                      color: Colors.red,
                                                      tooltip: 'Remove Booking',
                                                      icon: const Icon(
                                                        CupertinoIcons.trash,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Container(
                                                                    child: new Text(
                                                                        'Are you sure about removing this booking?')),
                                                                content:
                                                                    Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      10,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      10,
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              'Once removed, you will have to re-book the slot in the main page',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 15,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  new TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      FirebaseDatabase
                                                                          .instance
                                                                          .reference()
                                                                          .child(
                                                                              "sessions")
                                                                          .child(
                                                                              '${items[position].date + " " + items[position].time}')
                                                                          .remove();

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();

                                                                      Navigator.of(context).pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                super.widget,
                                                                          ),
                                                                          (Route<dynamic> route) => false);
                                                                    },
                                                                    child: new Text(
                                                                        'yes'),
                                                                  ),
                                                                  new TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        new Text(
                                                                            'no'),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ]),
                      );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            'You have not made any bookings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {});
  }
}
