// ignore_for_file: unused_import

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tmcmerchant/models/merchant.dart' as model;
import 'package:tmcmerchant/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get merchant details
  Future<model.Merchant> getMerchantDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('merchant').doc(currentUser.uid).get();

    return model.Merchant.fromSnap(documentSnapshot);
  }

  // Signing Up Merchant

  Future<String> signUpMerchant({
    required String email,
    required String password,
    required String merchantname,
    required String description,
    required String latitude,
    required String longitude,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          merchantname.isNotEmpty ||
          description.isNotEmpty ||
          latitude.isNotEmpty ||
          longitude.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.Merchant _merchant = model.Merchant(
            merchantname: merchantname,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            email: email,
            description: description,
            latitude: latitude,
            longitude: longitude);

        // adding merchant in our database
        await _firestore
            .collection("merchant")
            .doc(cred.user!.uid)
            .set(_merchant.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginMerchant({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in merchant with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

//signing out the merchants
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
