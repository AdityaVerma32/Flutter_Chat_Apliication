import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_app/Screens/home_screen.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Api/api.dart';
import '../helper/dialogue.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  handleGoogleSignIn() {
    Dialogue.showProgressBar(context);

    signInWithGoogle().then((value) {
      if (value != null) {
        Navigator.pop(context);
        log('\nUser: ${value.user}');
        print("\n UserAdittional Information : ${value.additionalUserInfo}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
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
      print("\nsigninwith Google: $e");
      Dialogue.showSnackBar(context, "Check your Internet");
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to Chat App"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            top: mq.height * .15,
            right: _isAnimated ? mq.width * .25 : -mq.width * 0.5,
            width: mq.width * .5,
            child: Image(image: AssetImage("assets/Logo/meetme.png")),
          ),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * 0.05,
              width: mq.width * .9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), elevation: 1),
                  onPressed: () {
                    handleGoogleSignIn();
                  },
                  icon: Image.asset(
                    "assets/Logo/google-logo.png",
                    height: mq.height * 0.05,
                  ),
                  label: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 19),
                          children: [
                        TextSpan(text: "LogIn with "),
                        TextSpan(
                            text: "Google",
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ]))))
        ],
      ),
    );
  }
}
