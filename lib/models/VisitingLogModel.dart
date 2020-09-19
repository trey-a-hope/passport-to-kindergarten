import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitingLogModel {
  String id;
  DateTime created;
  String description;

  VisitingLogModel({
    @required this.id,
    @required this.created,
    @required this.description,
  });

  factory VisitingLogModel.fromDocumentSnapshot(
      {@required DocumentSnapshot ds}) {
    return VisitingLogModel(
      id: ds.data['id'],
      created: ds.data['created'].toDate(),
      description: ds.data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'description': description,
    };
  }
}
