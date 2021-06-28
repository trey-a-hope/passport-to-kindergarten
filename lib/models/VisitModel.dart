import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitModel {
  String id;
  DateTime created;
  DateTime modified;
  String title;
  String imgUrl;
  String website;
  String address;

  VisitModel({
    @required this.id,
    @required this.created,
    @required this.modified,
    @required this.title,
    @required this.imgUrl,
    @required this.website,
    @required this.address,
  });

  factory VisitModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data();

    return VisitModel(
      id: data['id'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      imgUrl: data['imgUrl'],
      title: data['title'],
      website: data['website'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'modified': modified,
      'imgUrl': imgUrl,
      'title': title,
      'website': website,
      'address': address,
    };
  }
}
