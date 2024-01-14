import 'package:chatpi/api/api.dart';
import 'package:chatpi/main.dart';
import 'package:chatpi/screens/auth/login_screen.dart';
import 'package:chatpi/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            right: mq.width * .2,
            width: mq.width * .5,
            child: Image.asset('assets/App Icon/chat-box.png')),
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text(
              'Made in India !!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
      ]),
    );
  }
}
