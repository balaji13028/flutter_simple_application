// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_application/profile_page.dart';
import 'package:flutter_simple_application/user_model.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userEmail', isEqualTo: newuUser.userEmail)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const SizedBox();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              child: Center(child: Text("No users")),
            );
          }

          if (snapshot.hasData) {
            List<UserProfileData> user = [];
            for (var doc in snapshot.data!.docs) {
              final data =
                  UserProfileData.fromJson(doc.data() as Map<String, dynamic>);

              user.add(data);
            }
            return Drawer(
              child: Column(
                children: [
                  Container(
                      height: size.height * 0.25,
                      width: size.width,
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Color.fromRGBO(4, 9, 35, 1),
                            Color.fromRGBO(39, 105, 170, 1),
                          ],
                              begin: FractionalOffset.bottomLeft,
                              end: FractionalOffset.topCenter)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: size.height * 0.06,
                                  backgroundColor: Colors.white,
                                  child: Image.asset('assets/profile.png'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user[0].userName ?? 'User Name',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  user[0].role ?? 'Admin',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: size.height * 0.02),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black54,
                    ),
                    title: const Text(
                      'Profile Info',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const ProfilePage())));
                    },
                  ),
                  SizedBox(height: size.height * 0.5),
                  Container(
                    height: size.height * 0.07,
                    width: size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(
                        Icons.exit_to_app,
                        size: 35,
                        color: Colors.white,
                      ),
                      title: Text(
                        'sign out'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        // showDialog(
                        //     context: context,
                        //     builder: ((context) => const Center(
                        //           child: CircularProgressIndicator(),
                        //         )));
                        signOut(context);

                        //Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }

  signOut(context) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      auth.signOut().then((res) async {
        Navigator.of(context).pop(true);
      });
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: ((context) => const LoginScreen())));
      // });
    } catch (e) {
      log(e.toString());
    }
  }
}
