import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p/models/StampModel.dart';
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
  Future<Stream<QuerySnapshot>> streamStudentsForTeacher({
    @required String teacherUID,
  });

  Future<void> createStamp({@required String uid, @required StampModel stamp});
  Future<List<StampModel>> getStampsForUser({
    @required String uid,
  });
}

class UserService extends IUserService {
  final CollectionReference _usersColRef =
      Firestore.instance.collection('Users');
  final DocumentReference _tableCountsDocRef =
      Firestore.instance.collection('Data').document('tableCounts');

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      DocumentReference userDocRef = _usersColRef.document(user.uid);

      batch.setData(userDocRef, user.toMap());

      batch.updateData(_tableCountsDocRef, {
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
      DocumentSnapshot documentSnapshot =
          await _usersColRef.document(uid).get();
      return UserModel.fromDocumentSnapshot(ds: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _usersColRef.document(uid).get();
      DocumentReference documentReference = documentSnapshot.reference;
      await documentReference.updateData(data);
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

      List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
      List<UserModel> users = List<UserModel>();
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
              .getDocuments())
          .documents
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
  Future<void> createStamp(
      {@required String uid, @required StampModel stamp}) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference stampsColRef = userDocRef.collection('stamps');

      final DocumentReference stampDocRef = stampsColRef.document();

      stamp.id = stampDocRef.documentID;

      batch.setData(stampDocRef, stamp.toMap());

      await batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<StampModel>> getStampsForUser({@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersColRef.document(uid);

      final CollectionReference stampColRef = userDocRef.collection('stamps');

      final List<DocumentSnapshot> stampDocSnaps =
          (await stampColRef.getDocuments()).documents;

      return stampDocSnaps
          .map((stampDocSnap) =>
              StampModel.fromDocumentSnapshot(ds: stampDocSnap))
          .toList();
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
}