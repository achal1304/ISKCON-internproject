import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/adminpage.dart';
import 'package:login/signup.dart';
import 'package:random_color/random_color.dart';

import 'normalusers.dart';

class HomePageL extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;
  HomePageL(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _HomePageLState createState() => _HomePageLState();
}

class _HomePageLState extends State<HomePageL> {
  @override
  AsyncSnapshot<DocumentSnapshot> snapshot;

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor1 = RandomColor();
    Color _color1 = _randomColor1.randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.blue]));

    MyColor _myColor1 = getColorNameFromColor(_color1);
    print(_myColor1.getName);

    RandomColor _randomColor2 = RandomColor();
    Color _color2 = _randomColor2.randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.red]));
    MyColor _myColor2 = getColorNameFromColor(_color2);
    print(_myColor2.getName);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: /*[Colors.orange.shade300, Colors.orange.shade800]*/ [
            _color1,
            _color2
          ],
        ),
      ),
      //color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget._user.photoUrl),
            radius: 70,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Welcome ${widget._user.displayName}!',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(widget._user.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return checkRole(snapshot.data);
                }
                return LinearProgressIndicator();
              }),
        ],
      ),
    );
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Looks like you haven\'t registered yet!',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please Register first!',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 300,
              child: OutlineButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup(),
                        fullscreenDialog: true,
                      ));
                },
                child: Text('Go to Registration Page'),

                //child: Text('Google Sign-up'),
              ),
            ),
          ],
        ),
      );
    }
    if (snapshot.data['admin'] == true) {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Widget adminPage(DocumentSnapshot snapshot) {
    return Center(
      child: ButtonTheme(
        minWidth: 300,
        child: OutlineButton(
          padding: EdgeInsets.symmetric(vertical: 15),
          borderSide: BorderSide(color: Colors.white),
          shape: StadiumBorder(),
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(
                  widget._user,
                  widget._googleSignIn,
                ),
              ),
            );
          },
          child: Text('Go to Admin\'s Dashboard'),
        ),
      ),
    );
  }

  Widget userPage(DocumentSnapshot snapshot) {
    return Center(
      child: ButtonTheme(
        minWidth: 300,
        child: OutlineButton(
          padding: EdgeInsets.symmetric(vertical: 15),
          borderSide: BorderSide(color: Colors.white),
          shape: StadiumBorder(),
          textColor: Colors.white,
          color: Colors.orangeAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NormalUsers(
                          widget._user,
                          widget._googleSignIn,
                        )));
          },
          child: Text('Go to Dashboard'),
        ),
      ),
    );
  }
}
