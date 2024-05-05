import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/check_connectivity.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
class MyUser {
  final String uid;
  final String email;
  String name;
  String? profileImage;
  late bool deleted;
  final bool isAdmin;

  static CollectionReference dbUsers =
      FirebaseFirestore.instance.collection('users');

  MyUser({
    this.profileImage,
    required this.uid,
    required this.name,
    required this.email,
    this.deleted = false,
    this.isAdmin = false,
  });

  Future<void> updateInfo({String? name}) async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    if (name == null || name.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
    }).catchError((error) => debugPrint("Failed to update info: $error"));
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('user_info.id', isEqualTo: uid)
        .get();

    querySnapshot.docs.forEach((DocumentSnapshot doc) async {
      DocumentReference documentRef = doc.reference;
      try {
        await documentRef.update({
          'user_info.name': name,
        });
      } catch (error) {
        print('Error updating document: $error');
      }
    });
  }

  static Future<MyUser?> getCurrentUser() async {
    final googleUser =
        await readUser(uid: AuthService.google().currentUser?.uid);
    if (googleUser != null) {
      currentUser = googleUser;
      return googleUser;
    }
    currentUser = await readUser(uid: AuthService.firebase().currentUser?.uid);
    return currentUser;
  }

  static MyUser? currentUser;

  Future<void> createUser() async {
    if (!(await checkInternetConnectivity())) {
      displayNoInternet();
      return;
    }
    final userData = toJson();
    // Call the user's CollectionReference to add a new user
    return dbUsers
        .doc(uid)
        .set(userData)
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  static Future<MyUser?> readUser({required String? uid}) async {
    final docUser = FirebaseFirestore.instance.collection(AppCollections.users).doc(uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return MyUser.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'profile_image': profileImage,
    'name': name,
    'email': email,
    'deleted': deleted,
    'is_admin': isAdmin
  };

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
    uid: cvToString(json['uid']),
    profileImage: cvToString(json['profile_image']),
    name: cvToString(json['name']),
    email: cvToString(json['email']),
    deleted: cvToBool(json['deleted']),
    isAdmin: cvToBool(json['is_admin']),
  );
}
