import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StampModel {
  String id;
  String name;
  DateTime created;
  String imgUrl;

  StampModel({
    @required this.id,
    @required this.name,
    @required this.created,
    @required this.imgUrl,
  });

  factory StampModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    Map<String, dynamic> data = ds.data();

    return StampModel(
      id: data['id'],
      name: data['name'],
      created: data['created'].toDate(),
      imgUrl: data['imgUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created': created,
      'imgUrl': imgUrl,
    };
  }
}
