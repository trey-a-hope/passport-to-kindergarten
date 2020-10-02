import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/constants.dart';
import 'package:p/models/ParentLogModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/UserModel.dart';

abstract class IDummyService {
  Future<void> addIDKTeacherToUsers();
  Future<void> addDefaultBooksToStudent({
    @required String uid,
  });
}

class DummyService extends IDummyService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');
  final DocumentReference _tableCountsDocRef =
      Firestore.instance.collection('Data').document('tableCounts');

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

  @override
  Future<void> addIDKTeacherToUsers() async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      UserModel idkTeacher = UserModel(
        isAdmin: false,
        uid: null,
        created: DateTime.now(),
        profileType: PROFILE_TYPE.TEACHER.name,
        fcmToken: null,
        firstName: null,
        lastName: null,
        parentFirstName: null,
        parentLastName: null,
        school: null,
        imgUrl: null,
        dob: null,
        teacherID: null,
        email: null,
      );

      final DocumentReference userDocRef = _usersColRef.document();

      idkTeacher.uid = userDocRef.documentID;

      batch.setData(userDocRef, idkTeacher.toMap());

      batch.updateData(_tableCountsDocRef, {
        'users': FieldValue.increment(1),
      });

      batch.commit();

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
