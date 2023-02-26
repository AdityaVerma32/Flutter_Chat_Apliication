import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/Models/chat_user.dart';

class APIs {
  // instance for Firebase Authenticaion
  static FirebaseAuth auth = FirebaseAuth.instance;

  // instance for firebase Firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // instnace for firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser currentUser;

  // for return current user
  static User get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  // for getting current user information
  static Future<void> CurrentUserInfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        currentUser = ChatUser.fromJson(value.data()!);
      } else {
        await createUser().then((value) => CurrentUserInfo());
      }
    });
  }

  // For creating user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Chatuser = ChatUser(
        LastActive: time,
        image: user.photoURL.toString(),
        about: "Hey there! I am using Chat App",
        createdAt: time,
        isOnline: false,
        id: user.uid,
        pushToken: '',
        name: user.displayName.toString(), // Taking name from email id
        email: user.email.toString()); // comming from authentication
    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(Chatuser.toJson());
  }

  // Getting all users from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('Users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'name': currentUser.name, 'about': currentUser.about});
  }

  // fr storing Images on firbase storage

  static Future<void> updateProfilePicture(File file) async {
    // for getting extension of the image
    final ext = file.path.split('.').last;

    // storage file refrence with path
    final ref = storage.ref().child("Profile_pictures/${user.uid}.$ext");

    // Uploading image
    await ref
        .putFile(
            file,
            SettableMetadata(
                contentType: 'image/$ext')) // meta data is optional
        .then((p0) {
      // p0 is for excessing snapshots of image
      log('Data Transferred:${p0.bytesTransferred / 1000} kb '); // printing size in kb
    });

    // updating image in the firestore database

    // getting downloadable url of Image
    currentUser.image = await ref.getDownloadURL();
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'image': currentUser.image});
  }
}
