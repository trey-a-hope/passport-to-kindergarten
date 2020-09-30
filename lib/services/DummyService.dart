import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';

abstract class IDummyService {
  Future<void> addDefaultReadLogsToStudent({
    @required String uid,
  });
}

class DummyService extends IDummyService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');

  @override
  Future<void> addDefaultReadLogsToStudent({
    @required String uid,
  }) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      List<LogModel> defaultReadingLogs = [
        LogModel(
          id: null,
          bookTitle: 'Little Red Robin Hood',
          created: DateTime.now(),
          description: 'This is the reading log for Little Red Robin Hood',
        ),
        LogModel(
          id: null,
          bookTitle: 'Blue Bird in A Big House',
          created: DateTime.now(),
          description: 'This is the reading log for Blue Bird in A Big House',
        ),
        LogModel(
          id: null,
          bookTitle: 'Lil Monty',
          created: DateTime.now(),
          description: 'This is the reading log for Lil Monty',
        )
      ];

      defaultReadingLogs.forEach(
        (LogModel defaultReadingLog) {
          DocumentReference readLogDocRef =
              userDocRef.collection('readLogs').document();
          defaultReadingLog.id = readLogDocRef.documentID;
          readLogDocRef.setData(
            defaultReadingLog.toMap(),
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
