import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StampModel {
  String id;
  String name;
  String created;

  StampModel({
    @required this.id,
    @required this.name,
    @required this.created,
  });

  factory StampModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    return StampModel(
      id: ds.data['id'],
      name: ds.data['name'],
      created: ds.data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created': created,
    };
  }
}
