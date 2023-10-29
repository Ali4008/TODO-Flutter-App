import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/pages/addtodo.dart';
import 'package:untitled/pages/signin.dart';
import 'package:untitled/pages/viewdata.dart';
import 'package:untitled/service/authservice.dart';

import '../custom/todocard.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => signin()),
                    (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(icon:Container(
            height:52,
            width:52,
            decoration:BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.purple,
                  ]
              ),
            ),
            child:Icon(Icons.home,size: 32,color: Colors.white,),
          ),
            //title:Container(),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon:
            InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>addtodo()));
              },
              child: Container(
                height:52,
                width:52,
                decoration:BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ],
                  ),
                ),
                child:
                Icon
                  (Icons.add,size: 32,color: Colors.white,),
              ),
            ),
            //title:Container(),
            label: "Add",
          ),
          BottomNavigationBarItem(icon:Container(
            height:52,
            width:52,
            decoration:BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.indigoAccent,
                  Colors.purple,
                ],
              ),
            ),
            child:Icon(Icons.settings,size: 32,color: Colors.white,),
          ),
            //title:Container(),
            label: "Settings",
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.email)
            .collection("todo")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.docs;
          if (data == null || data.isEmpty) {
            return Center(
              child: Text("No data available"),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              IconData? iconData;
              Map<String, dynamic> doc = data[index].data() as Map<String, dynamic>;

              switch (doc["category"]) {
                case "Work":
                  iconData = Icons.run_circle_outlined;
                  break;
                case "Workout":
                  iconData = Icons.sports_gymnastics;
                  break;
                case "Food":
                  iconData = Icons.local_pizza_rounded;
                  break;
                default:
                  iconData = Icons.alarm;
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => viewdata(
                        doc: doc,
                        id: data[index].id,
                      ),
                    ),
                  );
                },
                child: todocard(
                  title: doc["title"] ?? "",
                  check: true,
                  icon: iconData ?? Icons.alarm,
                  time: doc["description"] ?? "",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
