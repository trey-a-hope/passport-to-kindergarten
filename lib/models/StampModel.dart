import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StampModel {
  String id;
  String name;
  DateTime created;
  String assetImagePath;

  StampModel({
    @required this.id,
    @required this.name,
    @required this.created,
    @required this.assetImagePath,
  });

  factory StampModel.fromDocumentSnapshot({@required DocumentSnapshot ds}) {
    return StampModel(
      id: ds.data['id'],
      name: ds.data['name'],
      created: ds.data['created'].toDate(),
      assetImagePath: ds.data['assetImagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created': created,
      'assetImagePath': assetImagePath,
    };
  }
}
