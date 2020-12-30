import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IDummyService {
  Future<void> addPropertyToAllDocsInCollection({
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  });
}

class DummyService extends IDummyService {
  @override
  Future<void> addPropertyToAllDocsInCollection({
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  }) async {
    try {
      final List<DocumentSnapshot> docs =
          (await Firestore.instance.collection(collection).getDocuments())
              .documents;

      for (int i = 0; i < docs.length; i++) {
        final DocumentSnapshot doc = docs[i];

        await Firestore.instance
            .collection(collection)
            .document(doc.documentID)
            .updateData(
          {
            propertyName: propertyValue,
          },
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
