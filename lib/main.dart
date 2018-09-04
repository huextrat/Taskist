import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskist/ui/page_done.dart';
import 'package:taskist/ui/page_settings.dart';
import 'package:taskist/ui/page_task.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser _currentUser;

Future<Null> main() async {
  _currentUser = await _signInAnonymously();

  runApp(new TaskistApp());
}

Future<FirebaseUser> _signInAnonymously() async {
  final user = await _auth.signInAnonymously();
  return user;
}

class TaskistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taskist",
      home: HomePage(user: _currentUser,),
      theme: new ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class HomePage extends StatefulWidget {

  final FirebaseUser user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 1;

  final List<Widget> _children = [
    DonePage(user: _currentUser,),
    TaskPage(user: _currentUser,),
    SettingsPage(user: _currentUser,)
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: Colors.deepPurple,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendarCheck),
              title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendar), title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.slidersH), title: new Text(""))
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}

/**
    QuerySnapshot snap = await Firestore.instance
    .collection(_currentUser.uid).getDocuments();

    snap.documents.forEach((f) {

    Firestore.instance.collection(_currentUser.uid).document(f.documentID).get().then((string) {
    string.data.forEach((a, b) {
    listElement.add(new ElementTask(a, b));
    });
    userMap[f.documentID] = listElement;
    });
    });**/


/**
    new ListView(
    padding: EdgeInsets.only(left: 40.0, right: 40.0),
    scrollDirection: Axis.horizontal,
    children: new List.generate(1, (int index) {
    return new Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(8.0),
    topRight: Radius.circular(8.0),
    bottomLeft: Radius.circular(8.0),
    bottomRight: Radius.circular(8.0),
    ),
    ),
    color: Colors.deepPurple,
    child: new Container(
    width: 220.0,
    //height: 100.0,
    child: Container(
    child: Column(
    children: <Widget>[
    Padding(
    padding:
    EdgeInsets.only(top: 20.0, bottom: 15.0),
    child: Container(
    child: Text("Trip to Paris", style: TextStyle(
    color: Colors.white,
    fontSize: 19.0,
    ),),
    ),
    ),
    Padding(
    padding: EdgeInsets.only(top: 5.0),
    child: Row(
    children: <Widget>[
    Expanded(
    flex: 2,
    child: Container(
    margin: EdgeInsets.only(left: 50.0),
    color: Colors.white,
    height: 1.5,
    ),
    ),
    ],
    ),
    ),
    Padding(
    padding: EdgeInsets.only(
    top: 30.0, left: 15.0, right: 5.0),
    child: Column(
    children: <Widget>[
    Row(
    mainAxisAlignment:
    MainAxisAlignment.start,
    children: <Widget>[
    Icon(
    FontAwesomeIcons.circle,
    color: Colors.white,
    size: 14.0,
    ),
    Padding(
    padding: EdgeInsets.only(left: 10.0),
    ),
    Flexible(
    child: Text(
    "Element 1",
    style: TextStyle(
    color: Colors.white,
    fontSize: 17.0,
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    );
    }),
    ),**/