import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sound4u/login.dart';

void main() => runApp(Sound4U());

class Sound4U extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Sound4U', home: SplashScrn());
  }
}

class SplashScrn extends StatefulWidget {
  @override
  _SplashScrnState createState() => _SplashScrnState();
}

class _SplashScrnState extends State<SplashScrn> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/sound4u.png', scale: 0.7),
          SpinKitPouringHourglass(color: Colors.amber[800], size: 100),
          Text('Welcome',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.amber[800],
                  fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
