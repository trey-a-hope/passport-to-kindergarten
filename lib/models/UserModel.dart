import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/StampModel.dart';

class UserModel {
  String email;
  String imgUrl;
  String fcmToken;
  DateTime created;
  String uid;
  String firstName;
  String lastName;
  String primaryParentFirstName;
  String primaryParentLastName;
  String secondaryParentFirstName;
  String secondaryParentLastName;
  String profileType;
  String school;
  String teacherID;
  DateTime dob;
  int bookLogCount;
  int visitLogCount;
  int stampCount;

  List<EntryModel> bookEntries;
  List<EntryModel> visitEntries;
  List<StampModel> stamps;

  String bookSortBy;
  String visitSortBy;

  UserModel({
    @required this.email,
    @required this.imgUrl,
    @required this.fcmToken,
    @required this.created,
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.primaryParentFirstName,
    @required this.primaryParentLastName,
    @required this.secondaryParentFirstName,
    @required this.secondaryParentLastName,
    @required this.profileType,
    @required this.school,
    @required this.teacherID,
    @required this.dob,
    @required this.bookLogCount,
    @required this.visitLogCount,
    @required this.stampCount,
  });

  factory UserModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();

    return UserModel(
      email: data['email'],
      imgUrl: data['imgUrl'],
      fcmToken: data['fcmToken'],
      created: data['created'].toDate(),
      uid: data['uid'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      primaryParentFirstName: data['primaryParentFirstName'],
      primaryParentLastName: data['primaryParentLastName'],
      secondaryParentFirstName: data['secondaryParentFirstName'],
      secondaryParentLastName: data['secondaryParentLastName'],
      profileType: data['profileType'],
      school: data['school'],
      teacherID: data['teacherID'],
      dob: data['dob'].toDate(),
      bookLogCount: data['bookLogCount'] as int,
      visitLogCount: data['visitLogCount'] as int,
      stampCount: data['stampCount'] as int,
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
      primaryParentFirstName: data['primaryParentFirstName'],
      primaryParentLastName: data['primaryParentLastName'],
      secondaryParentFirstName: data['secondaryParentFirstName'],
      secondaryParentLastName: data['secondaryParentLastName'],
      profileType: data['profileType'],
      school: data['school'],
      teacherID: data['teacherID'],
      dob: DateTime.now(),
      bookLogCount: data['bookLogCount'],
      visitLogCount: data['visitLogCount'],
      stampCount: data['stampCount'],
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
      'primaryParentFirstName': primaryParentFirstName,
      'primaryParentLastName': primaryParentLastName,
      'secondaryParentFirstName': secondaryParentFirstName,
      'secondaryParentLastName': secondaryParentLastName,
      'profileType': profileType,
      'school': school,
      'teacherID': teacherID,
      'dob': dob,
      'bookLogCount': bookLogCount,
      'visitLogCount': visitLogCount,
      'stampCount': stampCount,
    };
  }
}
