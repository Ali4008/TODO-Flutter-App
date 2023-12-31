import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/signin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final storage=new FlutterSecureStorage();
FirebaseAuth auth=FirebaseAuth.instance;
class Authclass{
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );





  Future<void> googlesignin(BuildContext context) async{
    try{
      GoogleSignInAccount? googleSignInAccount= await _googleSignIn.signIn();
      if(googleSignInAccount!=null){
        GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;

       AuthCredential credential=GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try
        {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storetokenanddata(userCredential);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>signin()), (route) => false);

        }
        catch(e){
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

        }
      }
      else{
        final snackbar = SnackBar(content: Text("IDKKKKK"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }

    catch(e){
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

    }

  }
}



Future<void> storetokenanddata(UserCredential userCredential)async{
  await storage.write(key:"token",value: userCredential.credential?.token.toString());
  await storage.write(key:"userCredential",value: userCredential.credential?.toString());

}

Future<String?> gettoken()async{
  return await storage.read(key: "token");
}

Future<void> logout() async{
  try{
    await auth.signOut();
    await storage.delete(key: "token");
  }
  catch(e){}

}
//
Future<void> verifyphone(String phone,BuildContext context,Function setdata) async{
  PhoneVerificationCompleted verificationCompleted=(PhoneAuthCredential phoneAuthCredential) async{
showsnackbar(context, "Verification completed");
  };
  PhoneVerificationFailed verificationFailed=(FirebaseAuthException exception){
    showsnackbar(context, exception.toString());
  };
  PhoneCodeSent codeSent=(String verificationId,[int? forceResendingtoken]){
    showsnackbar(context, "Code sent");
    setdata(verificationId);
  } as PhoneCodeSent;

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout=(String verificationId){
    showsnackbar(context, "Timeout");
  };
  try{
    await auth.verifyPhoneNumber(
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }
  catch(e){
    showsnackbar(context, e.toString());
  }
}

void showsnackbar(BuildContext context,String text){
  final snackbar = SnackBar(content:Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future<void> signinwithphone(String verificationId,String smsCode,BuildContext context)async {
  try{
    AuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
  UserCredential userCredential=await auth.signInWithCredential(credential);
    storetokenanddata(userCredential);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>signin()), (route) => false);
showsnackbar(context, "Logged in");
  }
      catch(e){
    showsnackbar(context, e.toString());
      }
}