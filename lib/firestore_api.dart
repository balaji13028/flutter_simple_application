import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_simple_application/user_model.dart';

final db = FirebaseFirestore.instance.collection('users');

Future createUser(
    {required email, required password, required name, required role}) async {
  final docUser = db.doc(); //to get id to store with a id.
  UserProfileData user = UserProfileData(
    id: docUser.id,
    userName: name,
    userEmail: email,
    password: password,
    role: role,
  );
  final json = user.toJson();

  await docUser.set(json).then((value) => log('user added'));
}

void changePassword(String yourPassword, id) async {
  var user = FirebaseAuth.instance.currentUser!;
  log(user.toString());
  user.updatePassword(yourPassword).then((_) {
    FirebaseFirestore.instance.collection("users").doc(id).update({
      "userPassword": yourPassword,
    }).then((_) {
      log("Successfully changed password");
    });
  }).catchError((error) {
    log("Error $error");
  });
}
