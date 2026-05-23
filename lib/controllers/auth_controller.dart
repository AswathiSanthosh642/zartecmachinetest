
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zartechmachinetest/services/google_signin_service.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Googlesigninservice _googleSignInService = Googlesigninservice();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  bool get isloggedIn => _user != null || _auth.currentUser != null;

  AuthController() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      _user = await GoogleSignIn().signInSilently();
    } catch (e) {
      debugPrint("Silent Sign-In Error: $e");
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }


  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignInService.SignInWithGoogle();

      if(googleUser!=null){
        _user=googleUser;
        notifyListeners();
        return googleUser;
      }

    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> signInWithPhone(String phoneNumber, Function(String) onCodeSent, Function(String) onError) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOTP(String verificationId, String smsCode) async {
    try {
      _isLoading = true;
      notifyListeners();

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      notifyListeners();
    } catch (e) {
      debugPrint("OTP Verification Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _googleSignInService.logout();
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
