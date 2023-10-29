import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../service/authservice.dart';

class phone extends StatefulWidget {
  const phone({super.key});

  @override
  State<phone> createState() => _phoneState();
}

class _phoneState extends State<phone> {
  int start=30;
  bool wait=false;
  String buttonName="Send";
  TextEditingController phonecontroller=TextEditingController();
  String verificationid="";
  String smscode="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.black ,
        title:Text("Signup",style: TextStyle(color: Colors.white,fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              textfield(),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  children: [
                 Expanded(
                 child:Container(
                      height: 1,
                       color: Colors.white38,
                    ),),
                    Text("Enter 6 Digit OTP",
                    style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                      Expanded(child: Container
                        (
                        height: 1,
                        color: Colors.white38,
                      )

                      )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              otpfield(),
              SizedBox(
                height: 40,
              ),
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "Send OTP again in ",
                    style: TextStyle(fontSize: 16,color: Colors.amber),
                  ),
                  TextSpan(
                      text: "00:$start",
                      style: TextStyle(fontSize: 16,color: Colors.pinkAccent),
                  ),
                  TextSpan(
                    text: " sec",
                    style: TextStyle(fontSize: 16,color: Colors.amber),
                  ),
                ]
              )),
              SizedBox(
                height: 50,
              ),
InkWell(
  onTap: (){
    signinwithphone(verificationid, smscode, context);
  },
child:Container(
  height: 60,
  width: MediaQuery.of(context).size.width-40,
decoration: BoxDecoration(
  color: Colors.orange,
  borderRadius: BorderRadius.circular(15),
),
  child: Center(
    child: Text("Lets go",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700),),
  ),


),
),
            ],
          ),
        ),
      ),

    );
  }

void timer(){
    const onsec=Duration(seconds: 1);
    Timer timer=Timer.periodic(onsec, (timer) {
if(start==0){
setState(() {
  timer.cancel();
  wait=false;
});
}
else{
 setState(() {
   start--;
 });
}
    });
}



  Widget otpfield(){
    return OTPTextField(
        length: 6,
        width: MediaQuery.of(context).size.width-40,
        fieldWidth: 55,
        otpFieldStyle: OtpFieldStyle(
          backgroundColor: Colors.white38,
          borderColor: Colors.white38,
        ),
        style: TextStyle(
            fontSize: 17,
          color: Colors.white,
        ),
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.underline,
        onCompleted: (pin) {
          print("Completed: " + pin);
          setState(() {
            smscode=pin;
          });
        },
    );
  }


  Widget textfield(){
    return Container(
      width: MediaQuery.of(context).size.width-40,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(15),
      ),
      child:TextFormField(
        controller: phonecontroller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your Phone Number",
          hintStyle: TextStyle(color:Colors.white,fontSize: 17),
          contentPadding: const EdgeInsets.symmetric(vertical: 19,horizontal: 8),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 15),
            child: Text("(+92)",
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 15),
            child:
            InkWell(
              onTap:wait?null: ()async
              {
                timer();
                setState(() {
                  start=30;
                  wait=true;
                  buttonName="Resend";
                });
                await verifyphone("+92 ${phonecontroller.text}",context,setdata);
              },
            child:Text(buttonName,
              style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
            ),)

          ),
        ),
      ),
    );
  }

  void setdata(verificationid){
    setState(() {
      verificationid=verificationid;
    });
    timer();
  }


}
