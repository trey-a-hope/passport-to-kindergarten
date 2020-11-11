import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<FirebaseUser> onAuthStateChanged();
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password});
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  Future<void> updatePassword({@required String password});
  Future<void> deleteUser({@required String userID});
  Future<void> resetPassword({@required String email});
}

class AuthService extends IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      DocumentSnapshot documentSnapshot =
          await _usersDB.document(firebaseUser.uid).get();
      final UserModel user =
          UserModel.fromDocumentSnapshot(ds: documentSnapshot);

      return user;
    } catch (e) {
      throw Exception('Could not fetch user at this time.');
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Stream<FirebaseUser> onAuthStateChanged() {
    return _auth.onAuthStateChanged;
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> updatePassword({String password}) async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      firebaseUser.updatePassword(password);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteUser({String userID}) async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      await firebaseUser.delete();
      await _usersDB.document(userID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> resetPassword({@required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
