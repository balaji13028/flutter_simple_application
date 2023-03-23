// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_application/color_palette.dart';
import 'package:flutter_simple_application/user_model.dart';

import 'firestore_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController crtPwdController = TextEditingController();
  final TextEditingController newPwdcontroller = TextEditingController();
  bool showPassword1 = true;
  bool showPassword2 = true;

  ///add user textedting controllers
  final TextEditingController userName = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPWD = TextEditingController();
  List<String> roles = ['Admin', 'Viewer'];
  String? role;
  bool showPassword = true;
  late List<UserProfileData> user;
  @override
  void initState() {
    user = [];

    super.initState();
  }

  bool errorText = false;
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
            for (var doc in snapshot.data!.docs) {
              final data =
                  UserProfileData.fromJson(doc.data() as Map<String, dynamic>);

              user.add(data);
            }

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  Container(
                    height: size.height,
                    width: size.width,
                    decoration: const BoxDecoration(
                        gradient: ColorPalette.primaryGradient),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //SizedBox(height: size.height * 0.025),
                          SizedBox(height: size.height * 0.065),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                              const Text(
                                'Profile',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.transparent,
                              )
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 25),
                            child: CircleAvatar(
                              radius: size.height * 0.09,
                              child: Image.asset('assets/profile.png'),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.6,
                            child: Text(
                              user[0].userName ?? 'User Name',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            user[0].userEmail ?? 'admin@gmail.com',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            user[0].role ?? 'Admin',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomSheet: Container(
                height: size.height * 0.525,
                width: size.width,
                padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.manage_accounts,
                        size: 35,
                        color: Colors.black54,
                      ),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        alertBox(context, size, 'Reset Password?',
                            'Are you sure do you want to change password.', 1);
                      },
                    ),
                    user[0].role == 'Viewer'
                        ? const SizedBox()
                        : ListTile(
                            leading: const Icon(
                              Icons.person_add_alt_1,
                              size: 35,
                              color: Colors.black54,
                            ),
                            title: const Text(
                              'Add User',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            onTap: () {
                              alertBox(context, size, 'Add User?',
                                  'Are you sure do you want to add User.', 2);
                            },
                          ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  passwordTextfieldsBox(context, Size size) {
    showDialog(
        context: context,
        builder: ((context) => StatefulBuilder(
            builder: ((context, setState) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                insetPadding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  height: errorText == true
                      ? size.height * 0.48
                      : size.height * 0.44,
                  //width: size.width * 0.35,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text('Reset Password',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          controller: crtPwdController,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(color: Colors.black),
                          obscureText: showPassword1,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            suffixIcon: IconButton(
                              icon: showPassword1
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black54,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                setState(() {
                                  showPassword1 = !showPassword1;
                                });
                              },
                            ),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            errorStyle: const TextStyle(
                              height: 0.5,
                              fontSize: 10,
                            ),
                            prefixIcon: const Icon(
                              Icons.key_sharp,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '*This field is mandatory';
                            }

                            if (!RegExp(r'^(?=.*?[A-Z]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one uppercase.\n';
                            } else if (!RegExp(r'^(?=.*?[!_@#\$&*~]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one special character';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 charachters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: newPwdcontroller,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(color: Colors.black),
                          obscureText: showPassword2,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            suffixIcon: IconButton(
                              icon: showPassword2
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black54,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                setState(() {
                                  showPassword2 = !showPassword2;
                                });
                              },
                            ),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            errorStyle: const TextStyle(
                              height: 0.5,
                              fontSize: 10,
                            ),
                            prefixIcon: const Icon(
                              Icons.key_sharp,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '*This field is mandatory';
                            }

                            if (!RegExp(r'^(?=.*?[A-Z]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one uppercase.\n';
                            } else if (!RegExp(r'^(?=.*?[!_@#\$&*~]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one special character';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 charachters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.08),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                crtPwdController.clear();
                                newPwdcontroller.clear();
                                setState(
                                  () {
                                    errorText = false;
                                  },
                                );
                              },
                              child: Container(
                                height: size.height * 0.048,
                                width: size.width * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 2),
                                          color: Colors.transparent,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  if (crtPwdController.text ==
                                      user[0].password) {
                                    changePassword(
                                        newPwdcontroller.text, user[0].id);
                                    crtPwdController.clear();
                                    newPwdcontroller.clear();

                                    Navigator.pop(context, true);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              'Password changed successfully',
                                              textAlign: TextAlign.center,
                                            )));
                                  } else {
                                    EasyLoading.showToast('wrong password');
                                  }
                                } else {
                                  setState(() {
                                    errorText = true;
                                  });
                                }
                              },
                              child: Container(
                                height: size.height * 0.048,
                                width: size.width * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 2),
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))))));
  }

  userTextfieldsBox(context, Size size) {
    showDialog(
        context: context,
        builder: ((context) => StatefulBuilder(
            builder: ((context, setState) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                insetPadding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  height: errorText == true
                      ? size.height * 0.63
                      : size.height * 0.555,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text('Add User',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.words,
                          controller: userName,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            errorStyle: const TextStyle(
                              height: 0.5,
                              fontSize: 10,
                            ),
                            prefixIcon: const Icon(Icons.mail_outline,
                                color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '*This field is mandatory';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          controller: userEmail,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            errorStyle: const TextStyle(
                              height: 0.5,
                              fontSize: 10,
                            ),
                            prefixIcon: const Icon(Icons.mail_outline,
                                color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '*This field is mandatory';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return 'Enter valid email ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autocorrect: false,
                          controller: userPWD,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(color: Colors.black),
                          obscureText: showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: showPassword
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Colors.black54,
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            errorStyle: const TextStyle(
                              height: 0.5,
                              fontSize: 10,
                            ),
                            prefixIcon: const Icon(
                              Icons.key_sharp,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '*This field is mandatory';
                            }

                            if (!RegExp(r'^(?=.*?[A-Z]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one uppercase.\n';
                            } else if (!RegExp(r'^(?=.*?[!_@#\$&*~]).{1,}$')
                                .hasMatch(value)) {
                              return '* At least one special character';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 charachters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            errorStyle:
                                const TextStyle(fontSize: 10, height: 0.5),
                            prefixIcon: const Icon(
                              Icons.work,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 0, right: 10, bottom: 20, top: 15),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return '*This field is mandatory';
                            }
                            return null;
                          },
                          hint: const Text(
                            'Role',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400),
                          ),

                          //iconEnabledColor: Colors.black54,
                          items: roles
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                              .toList(),
                          value: role,
                          onChanged: (value) {
                            setState(() {
                              role = value as String;
                            });
                          },
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).viewInsets.bottom != 0
                                    ? size.height * 0.02
                                    : size.height * 0.06),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: size.height * 0.048,
                                width: size.width * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 2),
                                          color: Colors.transparent,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => const Center(
                                            child: CircularProgressIndicator(),
                                          )));
                                  await createUser(
                                      email: userEmail.text,
                                      password: userPWD.text,
                                      name: userName.text,
                                      role: role);
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: userEmail.text,
                                    password: userPWD.text,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                  userName.clear();
                                  userEmail.clear();
                                  userPWD.clear();
                                  role = '';
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            'User added successfully',
                                            textAlign: TextAlign.center,
                                          )));
                                } else {
                                  setState(() {
                                    errorText = true;
                                  });
                                }
                              },
                              child: Container(
                                height: size.height * 0.048,
                                width: size.width * 0.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 2),
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))))));
  }

  alertBox(context, Size size, String title, content, type) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: Text(
                content,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'NO',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          if (type == 1) {
                            passwordTextfieldsBox(context, size);
                          } else {
                            userTextfieldsBox(context, size);
                          }
                        },
                        child: const Text(
                          'YES',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            )));
  }
}
