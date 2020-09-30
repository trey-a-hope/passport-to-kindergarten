import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChildLogModel {
  String id;
  DateTime created;
  String title;
  String notes;

  ChildLogModel({
    @required this.id,
    @required this.created,
    @required this.title,
    @required this.notes,
  });

  factory ChildLogModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> data = ds.data;

    return ChildLogModel(
      id: data['id'],
      created: data['created'].toDate(),
      title: data['title'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
      'title': title,
      'notes': notes,
    };
  }
}
