import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class IUserService {
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String uid});
  Future<List<UserModel>> retrieveUsers(
      {bool isAdmin, int limit, String orderBy});
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data});
  Future<List<UserModel>> retrieveStudentsForTeacher({
    @required String uid,
  });
  Future<List<UserModel>> retrieveTeachers();
  Future<Stream<QuerySnapshot>> streamStudentsForTeacher({
    @required String teacherUID,
  });
}

class UserService extends IUserService {
  final CollectionReference _usersColRef =
      FirebaseFirestore.instance.collection('Users');
  final DocumentReference _tableCountsDocRef =
      FirebaseFirestore.instance.collection('Data').doc('tableCounts');

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      DocumentReference userDocRef = _usersColRef.doc(user.uid);

      batch.set(userDocRef, user.toMap());

      batch.update(_tableCountsDocRef, {
        'users': FieldValue.increment(1),
      });

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({@required String uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersColRef.doc(uid).get();
      return UserModel.fromDocumentSnapshot(ds: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersColRef.doc(uid).get();
      DocumentReference documentReference = documentSnapshot.reference;
      await documentReference.update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveUsers(
      {bool isAdmin, int limit, String orderBy}) async {
    try {
      Query query = _usersColRef;

      if (isAdmin != null) {
        query = query.where('isAdmin', isEqualTo: isAdmin);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy);
      }

      List<DocumentSnapshot> docs = (await query.get()).docs;
      List<UserModel> users = [];
      for (int i = 0; i < docs.length; i++) {
        users.add(
          UserModel.fromDocumentSnapshot(ds: docs[i]),
        );
      }

      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserModel>> retrieveStudentsForTeacher(
      {@required String uid}) async {
    try {
      List<UserModel> students = (await _usersColRef
              .orderBy('lastName')
              .where('teacherID', isEqualTo: uid)
              .get())
          .docs
          .map(
            (docSnap) => UserModel.fromDocumentSnapshot(ds: docSnap),
          )
          .toList();

      return students;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamStudentsForTeacher(
      {@required String teacherUID}) async {
    try {
      final Query studentsQuery = (_usersColRef
          .orderBy('lastName')
          .where('teacherID', isEqualTo: teacherUID));
      return studentsQuery.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveTeachers() async {
    try {
      List<UserModel> teachers = (await _usersColRef
              .orderBy('lastName')
              .where('profileType', isEqualTo: 'TEACHER')
              .get())
          .docs
          .map(
            (docSnap) => UserModel.fromDocumentSnapshot(ds: docSnap),
          )
          .toList();

      return teachers;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
