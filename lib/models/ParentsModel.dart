import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParentsModel {
  String firstParentFirstName;
  String firstParentLastName;
  String secondParentFirstName;
  String secondParentLastName;

  ParentsModel({
    @required this.firstParentFirstName,
    @required this.firstParentLastName,
    @required this.secondParentFirstName,
    @required this.secondParentLastName,
  });

  factory ParentsModel.fromDocumentSnapshot({
    @required DocumentSnapshot ds,
  }) {
    Map<String, dynamic> parentData = ds.data;

    dynamic firstParentData = parentData['firstParent'];
    dynamic secondParentData = parentData['secondParent'];

    return ParentsModel(
      firstParentFirstName: firstParentData['firstName'],
      firstParentLastName: firstParentData['lastName'],
      secondParentFirstName: secondParentData['firstName'],
      secondParentLastName: secondParentData['lastName'],
    );
  }
}
