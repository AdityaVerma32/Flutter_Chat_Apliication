import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_app/Auth/login_screen.dart';
import 'package:flutter_chat_app/helper/dialogue.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../Api/api.dart';
import '../Models/chat_user.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  ProfileScreen({required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Profile Page"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Dialogue.showProgressBar(context);
              await APIs.auth.signOut();
              await GoogleSignIn().signOut().then((value) {
                // For hiding progress indicator
                Navigator.pop(context);

                // for moving to home screen
                Navigator.pop(context);

                // replacing home screen with login screen
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              });
            },
            label: Text("Logout"),
            icon: Icon(Icons.add_comment_rounded),
          ),

          // This form has been added so that we can check if the user has entered something
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: mq.height * 0.03),
                    Center(
                      child: Stack(
                        children: [
                          _image != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * 0.3),
                                  child: Image.file(
                                    File(_image!),
                                    height: mq.height * .2,
                                    width: mq.height * .2,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * 0.3),
                                  child: CachedNetworkImage(
                                    height: mq.height * .2,
                                    width: mq.height * .2,
                                    fit: BoxFit.fill,
                                    imageUrl: widget.user.image,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(child: Icon(Icons.error)),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              elevation: 1,
                              shape: CircleBorder(),
                              onPressed: () {
                                _showBottomSheet();
                              },
                              color: Colors.white,
                              child: Icon(
                                Icons.edit,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: mq.height * 0.03),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: mq.height * 0.03),
                    TextFormField(
                      initialValue: widget.user.name,
                      // we have used here ternary operator but val will never be empty here
                      onSaved: (val) => APIs.currentUser.name = val ?? '',
                      // here we will ensure that val is never empty
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.amber,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "eg. Happy singh",
                          label: Text("Name")),
                    ),
                    SizedBox(height: mq.height * 0.03),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.currentUser.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.info,
                            color: Colors.amber,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: "eg. Feeling Good",
                          label: Text("About")),
                    ),
                    SizedBox(height: mq.height * 0.03),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(mq.width * 0.5, mq.height * .06)),
                      onPressed: () {
                        // calling validator
                        if (_formKey.currentState!.validate()) {
                          print(" Inside Validator ");
                          _formKey.currentState!.save();
                          APIs.updateUserInfo();
                          Dialogue.showSnackBar(
                              context, "Profile Updated Successfully");
                        } else {}
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                      ),
                      label: Text(
                        "UPDATE",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.amber.shade100,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .1),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mq.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 1,
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * 0.3, mq.height * 0.15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path} -- Mimetype: ${image.mimeType}');

                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/Logo/Image.png")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 1,
                          backgroundColor: Colors.white,
                          fixedSize: Size(mq.width * 0.3, mq.height * 0.15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path} ');

                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/Logo/camera.png"))
                ],
              )
            ],
          );
        });
  }
}
