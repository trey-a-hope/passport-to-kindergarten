import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';

abstract class IDummyService {
  Future<void> addDefaultBooksToStudent({
    @required String uid,
  });
}

class DummyService extends IDummyService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  Future<void> addDefaultBooksToStudent({
    @required String uid,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<ParentLogModel> defaultBooks = [
        ParentLogModel(
          id: null,
          title: 'Little Red Robin Hood',
          created: DateTime.now(),
          logCount: 0,
        ),
        ParentLogModel(
          id: null,
          title: 'Little Blue Robin Hood',
          created: DateTime.now(),
          logCount: 0,
        ),
        ParentLogModel(
          id: null,
          title: 'Little Green Robin Hood',
          created: DateTime.now(),
          logCount: 0,
        ),
      ];

      defaultBooks.forEach(
        (ParentLogModel defaultBook) {
          DocumentReference defaultBookRef =
              userDocRef.collection('books').document();
          defaultBook.id = defaultBookRef.documentID;
          defaultBookRef.setData(
            defaultBook.toMap(),
          );
        },
      );

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}

// todo: Place this in the HomeBloc
// locator<DummyService>().addDefaultBooksToStudent(uid: _currentUser.uid);
