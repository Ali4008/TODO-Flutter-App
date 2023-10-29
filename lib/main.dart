import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:untitled/custom/todocard.dart';
import 'package:untitled/pages/addtodo.dart';
import 'package:untitled/pages/homepage.dart';
import 'package:untitled/pages/phone.dart';
import 'package:untitled/pages/signin.dart';
import 'package:untitled/pages/signup.dart';
import 'package:untitled/service/authservice.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const todo());
}

class todo extends StatefulWidget {
  const todo({super.key});

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {

 Widget currentpage=signup();
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }

  void checklogin()async{
   String token=await gettoken() as String;
   if(token!=Null){
     setState(() {
       currentpage=homepage();
     });
   }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home:currentpage,
    );
  }
}
