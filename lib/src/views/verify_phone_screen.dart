import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/controllers/mvvp_db_provider.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:mvvp_app/src/widgets/mvvp_custom_button.dart';
import 'package:mvvp_app/src/widgets/mvvp_widgets.dart';
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

  _pleaseFillAllCell() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        hasError ? "*Please fill up all the cells properly" : "",
        style: const TextStyle(
            color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }

  _onPressed() async {
    formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 6) {
      errorController!
          .add(ErrorAnimationType.shake); // Triggering error shake animation
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
          await usrModel.insertUser(widget.user).then((value) async {
            await _getUser();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          });
        }
      });
    }
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
              EnterCodeText(phone: widget.user.phone),
              const SizedBox(
                height: 20,
              ),
              EnterCodeField(
                errorController: errorController,
                formKey: formKey,
                onChanged: (value) {
                  debugPrint(value);
                  setState(() {
                    currentText = value;
                  });
                },
                otpController: otpController,
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
              _pleaseFillAllCell(),
              DidnotReceiveCode(
                onPressed: () {},
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
                onPressed: _onPressed
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getUser() async {
    final userModel = Provider.of<MvvpUserProvider>(context, listen: false);
    await userModel.fetchAndSetData();
  }
}
