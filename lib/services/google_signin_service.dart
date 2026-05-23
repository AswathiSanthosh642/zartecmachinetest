
import 'package:google_sign_in/google_sign_in.dart';

class Googlesigninservice {
  final GoogleSignIn _googleSignIn=GoogleSignIn();

  Future<GoogleSignInAccount?> SignInWithGoogle() async {
    try{
      GoogleSignInAccount? account= await _googleSignIn.signIn();
      return account;
    }
    catch(e){
      print(e);
    }
  }


  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}