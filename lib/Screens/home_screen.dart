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
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initializing Current User
    APIs.CurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
// to hide keboard when tapped on empty screen
      onTap: () => FocusScope.of(context).unfocus(),
// Will Scope is only valid to scaffold and it is aplied on current screen only
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }

// Below line will stop the your back and you will no tbe able to close the app through back button
// return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        // because this set state is called inside for loop so it will keep track of even a character being pressed
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    style: TextStyle(fontSize: 16),
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "Name,Email...", border: InputBorder.none))
                : Text("Chat App"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProfileScreen(user: APIs.currentUser)));
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
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                if (_list.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
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
        ),
      ),
    );
  }
}
