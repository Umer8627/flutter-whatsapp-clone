import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import '../utills/snippets.dart';

class AuthRepo {
  static final AuthRepo instance = AuthRepo();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Reference profilePicRef =
      FirebaseStorage.instance.ref().child('profilePics');

  Future<void> sendVerificationCode({
    required String phoneNo,
    required Function(String) onCodeSent,
    required Function(String) onTimeOut,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          await onCodeSent(verificationId);
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          onTimeOut('Time Out');
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            onVerificationFailed('Invalid Phone Number');
          }
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future verifyOTP(
      {required String verificationId,
      required String userOTP,
      required Function navigate}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await firebaseAuth.signInWithCredential(credential);
      navigate();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveUserDataToFirebase(
      {required UserModel userModel, required File image}) async {
    try {
      if (firebaseAuth.currentUser?.phoneNumber != null) {
        String profilePic = await uploadImage(
            image: image,
            name: firebaseAuth.currentUser?.uid ?? "",
            reference: profilePicRef);
        await firestore
            .collection('testing-users')
            .doc(firebaseAuth.currentUser!.uid)
            .set(userModel
                .copyWith(
                  profilePic: profilePic,
                  phone: firebaseAuth.currentUser?.phoneNumber,
                  uid: firebaseAuth.currentUser?.uid,
                )
                .toMap());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel?> getUserDetail(String id) async {
    return await firestore
        .collection('testing-users')
        .doc(id)
        .get()
        .then((value) {
      return UserModel.fromMap(value.data()!);
    });
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('testing-users')
        .doc(firebaseAuth.currentUser?.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
