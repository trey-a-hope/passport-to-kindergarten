import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p/models/UserModel.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<User> onAuthStateChanged();
  Future<UserCredential> signInWithEmailAndPassword(
      {@required String email, @required String password});
  Future<UserCredential> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  void updatePassword({@required String password});
  Future<void> deleteUser({@required String userID});
  Future<void> resetPassword({@required String email});
}

class AuthService extends IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      User user = _auth.currentUser;
      DocumentSnapshot documentSnapshot = await _usersDB.doc(user.uid).get();
      final UserModel userModel =
          UserModel.fromDocumentSnapshot(ds: documentSnapshot);

      return userModel;
    } catch (e) {
      throw Exception('Could not fetch user at this time.');
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Stream<User> onAuthStateChanged() {
    return _auth.authStateChanges();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  void updatePassword({String password}) async {
    try {
      User user = _auth.currentUser;
      user.updatePassword(password);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteUser({@required String userID}) async {
    try {
      User user = _auth.currentUser;
      await user.delete();
      await _usersDB.doc(userID).delete();
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
