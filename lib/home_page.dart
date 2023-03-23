import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_application/drawer.dart';
import 'package:flutter_simple_application/user_model.dart';
import 'color_palette.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final sliderbar = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: const DrawerSide(),
        key: sliderbar,
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: ColorPalette.secondryGradient),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: (() {
                setState(() {
                  sliderbar.currentState!.openDrawer();
                });
              }),
              icon: const Icon(Icons.menu)),
          title: const Text(
            'List Of Users',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                List<UserProfileData> userlist = [];
                for (var doc in snapshot.data!.docs) {
                  final data = UserProfileData.fromJson(
                      doc.data() as Map<String, dynamic>);

                  userlist.add(data);
                }
                return ListView.builder(
                  itemCount: userlist.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Container(
                        padding: const EdgeInsets.only(
                            right: 10, top: 10, bottom: 10),
                        height: size.height * 0.1,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: ListTile(
                            horizontalTitleGap: 10,
                            leading: CircleAvatar(
                              radius: size.height * 0.042,
                              child: Image.asset('assets/profile.png'),
                            ),
                            title: Text(
                              userlist[index].userName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              userlist[index].role!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                            ),
                          ),
                        )),
                  ),
                );
              }
              return const SizedBox();
            }));
  }
}
