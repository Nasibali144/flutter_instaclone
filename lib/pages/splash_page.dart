import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/home_page.dart';
import 'package:flutter_instaclone/pages/signin_page.dart';
import 'package:flutter_instaclone/services/prefs_service.dart';

class SplashPage extends StatefulWidget {

  static final String id = "splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _initTimer() {
    Timer(Duration(seconds: 2), () {
      _callHomePage();
    });
  }

  _callHomePage() {
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _initNotification() {
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print(token);
        Prefs.saveFCM(token);
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(193, 53, 132, 1),
              Color.fromRGBO(131, 58, 180, 1),
            ]
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontFamily: 'Billabong',
                  ),
                ),
              ),
            ),
            Text("All rights reserved", style: TextStyle(color: Colors.white, fontSize: 16,),),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
