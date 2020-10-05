import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String email;
  String imgUrl;
  String fcmToken;
  DateTime created;
  String uid;
  String firstName;
  String lastName;
  String profileType;
  String school;
  String teacherID;
  DateTime dob;

  UserModel({
    @required this.email,
    @required this.imgUrl,
    @required this.fcmToken,
    @required this.created,
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.profileType,
    @required this.school,
    @required this.teacherID,
    @required this.dob,
  });

  factory UserModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    return UserModel(
      email: ds.data['email'],
      imgUrl: ds.data['imgUrl'],
      fcmToken: ds.data['fcmToken'],
      created: ds.data['created'].toDate(),
      uid: ds.data['uid'],
      firstName: ds.data['firstName'],
      lastName: ds.data['lastName'],
      profileType: ds.data['profileType'],
      school: ds.data['school'],
      teacherID: ds.data['teacherID'],
      dob: ds.data['dob'].toDate(),
    );
  }

  factory UserModel.extractAlgoliaObjectSnapshot(
      {@required AlgoliaObjectSnapshot aob}) {
    Map<String, dynamic> data = aob.data;
    return UserModel(
        email: data['email'],
        imgUrl: data['imgUrl'],
        fcmToken: data['fcmToken'],
        created: DateTime.now(),
        uid: data['uid'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        profileType: data['profileType'],
        school: data['school'],
        teacherID: data['teacherID'],
        dob: DateTime.now() //todo: Set accurate dob.
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imgUrl': imgUrl,
      'fcmToken': fcmToken,
      'created': created,
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'profileType': profileType,
      'school': school,
      'teacherID': teacherID,
      'dob': dob,
    };
  }
}
