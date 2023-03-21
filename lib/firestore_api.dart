import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_simple_application/user_model.dart';

Future createUser({required email, password}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  final user = UserProfileData(
    id: docUser.id,
    userName: 'Admin',
    userEmail: email,
    password: password,
    Role: 'Admin',
  );
  final json = user.toJson();

  await docUser.set(json);
}
