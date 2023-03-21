import 'package:flutter/material.dart';
import 'package:flutter_simple_application/login_page.dart';
import 'package:flutter_simple_application/user_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserProfileData user = userdata[0];
  final sliderbar = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              // Container(
              //     height: size.height * 0.25,
              //     width: size.width,
              //     padding: const EdgeInsets.only(left: 20, top: 20),
              //     decoration: const BoxDecoration(
              //         gradient: LinearGradient(
              //             colors: [
              //           Color.fromRGBO(4, 9, 35, 1),
              //           Color.fromRGBO(39, 105, 170, 1),
              //         ],
              //             begin: FractionalOffset.bottomLeft,
              //             end: FractionalOffset.topCenter)),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             GestureDetector(
              //               onTap: () {},
              //               child: CircleAvatar(
              //                 radius: size.height * 0.06,
              //                 backgroundColor: Colors.white,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(
              //           width: size.width * 0.04,
              //         ),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               user.name ?? '',
              //               style: const TextStyle(
              //                   fontSize: 24,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white),
              //             ),
              //             const SizedBox(
              //               height: 5,
              //             ),
              //             Text(
              //               user.email ?? '',
              //               style: const TextStyle(
              //                   decoration: TextDecoration.underline,
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.normal,
              //                   color: Colors.white),
              //             )
              //           ],
              //         ),
              //       ],
              //     )),
              SizedBox(height: size.height * 0.02),
              ListTile(
                leading: const Icon(
                  Icons.work,
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
                onTap: () {},
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
                    //await deleteUserDetails();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const LoginScreen())));
                  },
                ),
              )
            ],
          ),
        ),
        key: sliderbar,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: (() {
                setState(() {
                  sliderbar.currentState!.openDrawer();
                });
              }),
              icon: const Icon(Icons.menu)),
          title: Text(
            'Home Screen',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          children: [],
        ));
  }
}
