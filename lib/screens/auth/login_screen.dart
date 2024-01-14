import 'dart:io';

import '../../helper/dialog.dart';
import '../../main.dart';
import '../../screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if (user != null) {
        print('\nUser: ${user.user}');
        print('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n_signwithgoogle: $e');
      Dialogs.showSnackbar(context, "Something went wrong check Internet!!!");
      return null;
    }
  }
  // _signOut(){
  //  await FirebaseAuth,instance.signOut();
  //  await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Chat Pi'),
      ),
      body: Stack(children: [
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .2 : -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
            child: Image.asset('assets/App Icon/chat-box.png')),
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 255, 187),
                    shape: StadiumBorder(),
                    elevation: 1),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset(
                  'assets/google.png',
                  height: mq.height * .04,
                ),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 19),
                        children: [
                      TextSpan(text: 'Login In with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ])))),
      ]),
    );
  }
}
