import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/controllers/mvvp_db_provider.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:mvvp_app/src/widgets/mvvp_custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = '/mvvp/phoneverification';
  final MvvpUser user;
  const PhoneVerification(this.user, {Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController otpController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthenticationModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("assets/images/phone_image_verified.png"),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.user.phone,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      // obscureText: true,
                      // obscuringCharacter: '*',
                      // obscuringWidget: const FlutterLogo(
                      //   size: 24,
                      // ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "enter six digit";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (model.loadingStatus.status == LoadingStatus.error)
                Center(
                  child: Text(
                    model.loadingStatus.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () => snackBar('OTP send'),
                      child: const Text(
                        "RESEND",
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              CustomeButton(
                child: model.loadingStatus.status == LoadingStatus.loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "VERIFY",
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () async {
                  formKey.currentState!.validate();
                  // conditions for validating
                  if (currentText.length != 6) {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  } else {
                    final model = context.read<AuthenticationModel>();
                    final usrModel = context.read<MvvpUserProvider>();
                    await model
                        .siginInWithCredential(PhoneAuthProvider.credential(
                            verificationId: model.verificationID,
                            smsCode: otpController.text))
                        .then((value) async {
                      if (model.authStatus == AuthStatus.loggedin) {
                        await usrModel
                            .insertUser(widget.user)
                            .then((value) async {
                          await _getUser();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName, (route) => false);
                        });
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUser() async {
    final userModel = Provider.of<MvvpUserProvider>(
      context, listen: false
    );
    await userModel.fetchAndSetData();
  }
}
