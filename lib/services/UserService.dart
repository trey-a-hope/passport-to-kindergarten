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

      batch.commit();

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
}
