import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_app/Screens/profile_screen.dart';
import 'package:flutter_chat_app/widgets/chat_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Api/api.dart';
import '../Models/chat_user.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    // Initializing Current User
    APIs.CurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text("Chat App"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.currentUser)));
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },
        child: Icon(Icons.add_comment_rounded),
      ),
      body: StreamBuilder(
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // If waiting the circularProgressIndicator
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: const CircularProgressIndicator());

              // If it has data then pass on
              case ConnectionState.active:
              case ConnectionState.done:
            }

            final data = snapshot.data?.docs;
            // If Data is Empty then empty list is added to the list variable
            list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              return ListView.builder(
                  padding: EdgeInsets.only(top: mq.height * 0.01),
                  physics: BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(user: list[index]);
                  });
            } else {
              return const Center(
                child: Text(
                  "No Connections Found!",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }),
    );
  }
}
