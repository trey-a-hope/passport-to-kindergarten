import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogModel {
  String id;
  DateTime created;
  String description;

  LogModel({
    @required this.id,
    @required this.created,
    @required this.description,
  });

  factory LogModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    return LogModel(
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
