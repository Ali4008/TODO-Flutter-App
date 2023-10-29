import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:untitled/pages/homepage.dart';
import 'package:untitled/pages/phone.dart';
import 'package:untitled/pages/signin.dart';
import '../service/authservice.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  firebase_auth.FirebaseAuth firebaseAuth=firebase_auth.FirebaseAuth.instance;
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController pwdcontroller=TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  bool circular=false;
  Authclass authclass=Authclass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
          child:Container(
            height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
             color:Colors.black,
             child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Signup",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 20,
              ),
               buttonitem('assets/google2.png',"Continue with Google",()async{
                //await authclass.googlesignin(context);
               }),
              SizedBox(height: 15),
             buttonitem("assets/phone2.png","Continue with Mobile",(){
               Navigator.push(context,MaterialPageRoute(builder: (builder)=>phone()));
             }),
              SizedBox(height: 30),
              textitem("Email",emailcontroller,false),
              textitem("Password",pwdcontroller,true),
              SizedBox(height: 15),
              colorbutton(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you already have an account? ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                  ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>signin()), (route) => false);
                    },
                  child:Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                  ),)
                ],
              ),
            ],
          ),
          ),
      ),
    );
  }



  Widget buttonitem(String image, String title,VoidCallback onTap2) {

   return InkWell
     (
     onTap:onTap2,

   child:Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 50,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 1, color: Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
          ),
        ),
      ),
   );
  }


  Widget textitem(String title,TextEditingController controller,bool obsecureText){
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 60,
      height: 70,
      child:TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style:TextStyle(fontSize: 17,color: Colors.white),
        decoration: InputDecoration(
          labelText: title,
          labelStyle:TextStyle(fontSize: 17,color: Colors.white),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1.5, color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 1, color: Colors.white)
          ),

      ),
      )
    );

  }



  Widget colorbutton(){
    return InkWell(
        onTap: () async {
          setState(() {
            circular = true;
          });

          try {
            firebase_auth.UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
                email: emailcontroller.text, password: pwdcontroller.text);
            //print(emailcontroller);
            FirebaseFirestore.instance.collection("users").doc(user?.email).set({
              "email": user?.email,
              // Add other user-specific data fields as needed
            })
                .then((value) {
              // Document successfully created
            })
                .catchError((error) {
              // Error occurred while creating the document
            });


            setState(() {
              circular = false;
            });
            storetokenanddata(userCredential);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>homepage()), (route) => false);
          } catch (e) {
            final snackbar = SnackBar(content: Text(e.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          }
        },
   child: Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 90,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [Color(0xfffd746c),Color(0xffff9068),Color(0xfffd746c)])
      ),
        child:Center(
child:circular?CircularProgressIndicator(): Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20)),
)
   )
    );

  }




}
