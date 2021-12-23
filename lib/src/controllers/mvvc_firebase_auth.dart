import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/views/verify_phone_screen.dart';

class AuthenticationModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthStatus authStatus = AuthStatus.loggedout;
  Response loadingStatus =
      Response(message: '', status: LoadingStatus.idle, data: null);

  String verificationID = '';

  String otpCode = '';

  String phone = '+251929465849';

  initAuth() {
    if (_firebaseAuth.currentUser == null) {
      authStatus = AuthStatus.loggedout;
    } else {
      authStatus = AuthStatus.loggedin;
    }
    notifyListeners();
  }

  Future verifyPhone(MvvpUser user, BuildContext context) async {
    try {
      phone = user.phone;
      loadingStatus =
          Response(message: '', status: LoadingStatus.loading, data: null);
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: user.phone,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: (String verificationId, int? forceResendingToken) {
          verificationID = verificationId;
          loadingStatus = Response(
            data: null,
            message: '',
            status: LoadingStatus.idle,
          );
          notifyListeners();

          Navigator.of(context)
              .pushNamed(PhoneVerification.routeName, arguments: user);
        },
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String message = getMessageFromErrorCode(e.code);
      loadingStatus = Response(
        message: message,
        status: LoadingStatus.error,
        data: null,
      );
      notifyListeners();
    } catch (e) {
      debugPrint(
          "===================================Exception =======================");
      debugPrint(e.toString());
    }
  }

  // Verification Completed
  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    debugPrint("verification completed${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    otpCode = authCredential.smsCode!;
    loadingStatus = Response(
      message: '',
      status: LoadingStatus.idle,
      data: null,
    );

    if (authCredential.smsCode != null) {
      try {
        
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await siginInWithCredential(authCredential);
        }
      }
    }
    notifyListeners();
  }

  Future siginInWithCredential(PhoneAuthCredential phoneAuthCredential) async {
    try {
      loadingStatus = Response(
        message: '',
        status: LoadingStatus.loading,
        data: null,
      );
      notifyListeners();
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      authStatus = AuthStatus.loggedin;
      notifyListeners();
    } catch (e) {
      debugPrint("Error");
      if (e.toString().toLowerCase().contains("auth credential is invalid")) {
        loadingStatus = Response(
          message: "Invalid verification code",
          status: LoadingStatus.error,
          data: null,
        );
      } else {
        loadingStatus = Response(
            message: "Somthing went wrong,",
            status: LoadingStatus.error,
            data: null);
      }
      notifyListeners();
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    debugPrint(
        '===========================================================ERROR=======================');
    debugPrint(exception.code);
    if (exception.code == 'invalid-phone-number') {
      debugPrint("The phone Number is invalid");
    }
    String message = getMessageFromErrorCode(exception.code);
    loadingStatus =
        Response(message: message, status: LoadingStatus.error, data: null);
    notifyListeners();
  }
  _onCodeAutoRetrievalTimeout(String timeout) {
    return null;
  }

  signout() async {
    try {
      await _firebaseAuth.signOut();
      authStatus = AuthStatus.loggedout;
      loadingStatus = Response(
            message: "",
            status: LoadingStatus.idle,
            data: null);
      notifyListeners();
    } catch (e) {
      debugPrint("somting happened");
    }
  }

  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "wrong-password":
        return "Wrong email/password combination.";
      case "user-not-found":
        return "No user found with this email.";
      case "user-disabled":
        return "User disabled.";
      case "too-many-requests":
        return "Too many requests to log into this account.";
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
