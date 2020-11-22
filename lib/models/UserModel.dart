import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/VisitModel.dart';

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

  List<BookModel> books;
  List<VisitModel> visits;
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
    return UserModel(
      email: ds.data['email'],
      imgUrl: ds.data['imgUrl'],
      fcmToken: ds.data['fcmToken'],
      created: ds.data['created'].toDate(),
      uid: ds.data['uid'],
      firstName: ds.data['firstName'],
      lastName: ds.data['lastName'],
      primaryParentFirstName: ds.data['primaryParentFirstName'],
      primaryParentLastName: ds.data['primaryParentLastName'],
      secondaryParentFirstName: ds.data['secondaryParentFirstName'],
      secondaryParentLastName: ds.data['secondaryParentLastName'],
      profileType: ds.data['profileType'],
      school: ds.data['school'],
      teacherID: ds.data['teacherID'],
      dob: ds.data['dob'].toDate(),
      bookLogCount: ds.data['bookLogCount'] as int,
      visitLogCount: ds.data['visitLogCount'] as int,
      stampCount: ds.data['stampCount'] as int,
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
