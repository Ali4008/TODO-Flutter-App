import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';


class viewdata extends StatefulWidget {
  const viewdata({super.key, required this.doc, required this.id});
final Map<String,dynamic> doc;
final String id;
  @override
  State<viewdata> createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {
  late TextEditingController titlecontroller;
  late TextEditingController descriptioncontroller;
  late String type;
  late String category;
  bool edit=false;
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title2=widget.doc["title"]==null?"Hey":widget.doc["title"];
    titlecontroller=TextEditingController(text:title2);
    descriptioncontroller=TextEditingController(text: widget.doc["description"]);
    type=widget.doc["task"];
    category=widget.doc["category"];

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:
          [Color(0xff1d1e26),Color(0xff252041),
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>homepage()));
                  }, icon: Icon(CupertinoIcons.arrow_left,color: Colors.white,size: 28,)),
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(user?.email)
                            .collection("todo")
                            .doc(widget.id)
                            .delete()
                            .then((value) {
                          Navigator.pop(context);
                        });



                       }, icon: Icon(Icons.delete,color:Colors.red,size: 28,)),


                      IconButton(onPressed: (){
                       setState(() {
                         edit=!edit;
                       });
                      }, icon: Icon(Icons.edit,color:edit?Colors.green: Colors.white,size: 28,)),
                    ],
                  ),

                ],
              ),
              Padding(
                padding:const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     edit?"Editing":"View",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 2,),
                    Text(
                      "Your Todo",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 20,),
                    label("Task Title"),
                    SizedBox(height: 12,),
                    title(),
                    SizedBox(height: 30,),
                    label("Task Type"),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        task("Important",0xff2664fa),
                        SizedBox(width: 20,),
                        task("Planned", 0xff2bc8d9)
                      ],
                    ),
                    SizedBox(height: 25,),
                    label("Desciption"),
                    SizedBox(height: 10,),
                    description(),
                    SizedBox(height: 25,),
                    label("Category"),
                    SizedBox(height: 10,),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        cat("Food",0xffff6d6e),
                        SizedBox(width: 20,),
                        cat("Workout", 0xfff29732),
                        SizedBox(width: 20,),
                        cat("Work", 0xff6557ff),
                      ],
                    ),
                    SizedBox(height: 40,),
                    edit?button():Container(),
                    SizedBox(height: 30,),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }




  Widget button(){
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance
        .collection("users")
        .doc(user?.email)
        .collection("todo")
        .doc(widget.id)
        .update({
      "title": titlecontroller.text,
      "task": type,
      "description": descriptioncontroller.text,
      "category": category,
    })
        .then((value) {
      Navigator.pop(context);
    });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ])
        ),
        child: Center(
          child: Text("Update Todo",style:TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ) ,),
        ),
      ),
    );
  }

  Widget description(){
    return Container(
        height: 145,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(20)
        ),
        child:
        TextFormField(
          enabled: edit,
          controller: descriptioncontroller,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
          ),
        )

    );
  }




  Widget title(){
    return Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(20)
        ),
        child:
        TextFormField(
          enabled: edit,
          controller: titlecontroller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
          ),
        )

    );
  }


  Widget task(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          type=label;
        });
      },
      child: Chip(
        backgroundColor:type==label?Colors.black87: Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10,)),
        label: Text(label,style:TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 4,
        ),
      ),
    );
  }


  Widget cat(String label,int color){
    return InkWell(
      onTap: (){
        category=label;
      },
      child: Chip(
        backgroundColor:category==label?Colors.black87: Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10,)),
        label: Text(label,style:TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 4,
        ),
      ),
    );
  }

  Widget label(String label){
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );

  }
}
