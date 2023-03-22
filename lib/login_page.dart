// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_application/firestore_api.dart';
import 'package:flutter_simple_application/home_page.dart';
import 'package:flutter_simple_application/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController pwdcontroller = TextEditingController();

  bool showPassword = true;
  String userName = '';
  String password = '';
  String? profession;
  bool ontap = false;
  List<String> professionList = [
    'English',
    'Hindi',
    'Telugu',
    'Kannada',
  ];

  @override
  void initState() {
    //checkdata();
    super.initState();
  }

  void trySubmitForm(BuildContext context) {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    }
  }

  void configLoading(status) {
    EasyLoading.showToast('Login Successfully',
        toastPosition: EasyLoadingToastPosition.bottom,
        maskType: EasyLoadingMaskType.custom);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color.fromRGBO(4, 9, 35, 1),
              Color.fromRGBO(39, 105, 170, 1),
            ],
                begin: FractionalOffset.bottomLeft,
                end: FractionalOffset.topCenter)),
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade100),
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      controller: emailcontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(Icons.mail_outline,
                            color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
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
                      onChanged: (value) => userName = value,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: pwdcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(color: Colors.white),
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: showPassword
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.white38,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(
                          Icons.key_sharp,
                          color: Colors.white54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '*This field is mandatory';
                        }

                        if (!RegExp(r'^(?=.*?[A-Z]).{1,}$').hasMatch(value)) {
                          return '* At least one uppercase.\n';
                        } else if (!RegExp(r'^(?=.*?[!_@#\$&*~]).{1,}$')
                            .hasMatch(value)) {
                          return '* At least one special character';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 charachters';
                        }
                        return null;
                      },
                      onChanged: (value) => password = value,
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            newuUser.userEmail = emailcontroller.text;
                            newuUser.password = pwdcontroller.text;
                            showDialog(
                                context: context,
                                builder: ((context) => const Center(
                                      child: CircularProgressIndicator(),
                                    )));
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailcontroller.text,
                                      password: pwdcontroller.text);
                            } on FirebaseAuthException catch (e) {
                              Navigator.of(context).pop();
                              if (e.email == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Center(
                                  child: Text(
                                    'No user found for the email',
                                    textAlign: TextAlign.center,
                                  ),
                                )));
                              } else if (e.code == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  'Wrong password',
                                  textAlign: TextAlign.center,
                                )));
                              }
                            }

                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: ((context, animation,
                                            secondaryAnimation) =>
                                        const Homepage())));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: size.height * 0.065,
                          width: size.width * 0.45,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: size.height * 0.04,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
