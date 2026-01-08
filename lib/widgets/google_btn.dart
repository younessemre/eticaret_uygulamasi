import 'package:ecommerce_flutter/root_screen.dart';
import 'package:ecommerce_flutter/services/myapp_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  Future<void> _googleSignIn({required BuildContext context}) async {
    try{
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if(googleAccount != null){
        final googleAuth = await googleAccount.authentication;
        if(googleAuth.accessToken != null && googleAuth.idToken != null){
          final autResults = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));

        }
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp){
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      });

    } on FirebaseException catch(error){
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: error.message.toString(),
        fct: (){},
      );
    }
    catch(error){
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: error.toString(),
        fct: (){},);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon
      (
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.red
      ),
      icon: const Icon(Ionicons.logo_google),
      label:const Text("Google ile giriş yap"),
      onPressed: () async {
        await _googleSignIn(context: context);
      },
    );
  }
}
