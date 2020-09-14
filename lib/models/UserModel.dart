import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String email;
  String imgUrl;
  bool isAdmin;
  String fcmToken;
  DateTime created;
  String uid;
  String firstName;
  String lastName;
  String profileType;

  UserModel({
    @required this.email,
    @required this.imgUrl,
    @required this.isAdmin,
    @required this.fcmToken,
    @required this.created,
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.profileType,
  });

  factory UserModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    return UserModel(
      email: ds.data['email'],
      imgUrl: ds.data['imgUrl'],
      fcmToken: ds.data['fcmToken'],
      isAdmin: ds.data['isAdmin'],
      created: ds.data['created'].toDate(),
      uid: ds.data['uid'],
      firstName: ds.data['firstName'],
      lastName: ds.data['lastName'],
      profileType: ds.data['profileType'],
    );
  }

  factory UserModel.extractAlgoliaObjectSnapshot(
      {@required AlgoliaObjectSnapshot aob}) {
    Map<String, dynamic> data = aob.data;
    return UserModel(
      email: data['email'],
      imgUrl: data['imgUrl'],
      fcmToken: data['fcmToken'],
      isAdmin: data['isAdmin'],
      created: DateTime.now(),
      uid: data['uid'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      profileType: data['profileType'],
      // created: data['created'].toDate(),//todo:
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imgUrl': imgUrl,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'created': created,
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'profileType': profileType,
    };
  }
}
