import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IDummyService {
  Future<void> updatePropertyToAllDocsInCollection({
    @required String userID,
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  });

  Future<void> deleteAllDocsInNestedCollection({
    @required String userID,
    @required String collection,
    @required String nestedCollection,
  });
}

class DummyService extends IDummyService {
  @override
  Future<void> updatePropertyToAllDocsInCollection({
    @required String userID,
    @required String collection,
    @required String propertyName,
    @required dynamic propertyValue,
  }) async {
    try {
      print('Updating $propertyName to $propertyValue for userID $userID...');

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userID)
          .update(
        {
          propertyName: propertyValue,
        },
      );

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteAllDocsInNestedCollection({
    @required String userID,
    @required String collection,
    @required String nestedCollection,
  }) async {
    try {
      print('Deleting all $nestedCollection for userID $userID...');
      // final List<DocumentSnapshot> docs =
      //     (await Firestore.instance.collection(collection).getDocuments())
      //         .documents;

      // for (int i = 0; i < docs.length; i++) {
      //   final DocumentSnapshot doc = docs[i];

      //   final List<DocumentSnapshot> nestedDocs = (await Firestore.instance
      //           .collection(collection)
      //           .document(doc.documentID)
      //           .collection(nestedCollection)
      //           .getDocuments())
      //       .documents;

      //   for (int j = 0; j < nestedDocs.length; j++) {
      //     final DocumentSnapshot nestedDoc = nestedDocs[j];

      //     await Firestore.instance
      //         .collection(collection)
      //         .document(doc.documentID)
      //         .collection(nestedCollection)
      //         .document(nestedDoc.documentID)
      //         .delete();
      //   }
      // }

      final List<DocumentSnapshot> nestedDocs = (await FirebaseFirestore
              .instance
              .collection(collection)
              .doc(userID)
              .collection(nestedCollection)
              .get())
          .docs;

      for (int j = 0; j < nestedDocs.length; j++) {
        final DocumentSnapshot nestedDoc = nestedDocs[j];

        if (nestedCollection != 'stamps') {
          final List<DocumentSnapshot> logDocs = (await FirebaseFirestore
                  .instance
                  .collection(collection)
                  .doc(userID)
                  .collection(nestedCollection)
                  .doc(nestedDoc.id)
                  .collection('logs')
                  .get())
              .docs;

          for (int l = 0; l < logDocs.length; l++) {
            final DocumentSnapshot logDoc = logDocs[l];

            await FirebaseFirestore.instance
                .collection(collection)
                .doc(userID)
                .collection(nestedCollection)
                .doc(nestedDoc.id)
                .collection('logs')
                .doc(logDoc.id)
                .delete();
          }
        }

        await FirebaseFirestore.instance
            .collection(collection)
            .doc(userID)
            .collection(nestedCollection)
            .doc(nestedDoc.id)
            .delete();
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
