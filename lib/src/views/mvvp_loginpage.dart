import 'package:flutter/material.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/widgets/mvvc_phone_code.dart';
import 'package:provider/provider.dart';

import 'package:mvvp_app/src/widgets/mvvp_widgets.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/mvvp/loginpage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEextEditingController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _dialCode = '+251';

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthenticationModel>(context).otpCode;
    debugPrint("===============================The code sent is $model");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<AuthenticationModel>(
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: size.height * 0.3,
                    ),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _emailEextEditingController,
                      onSaved: (value) {
                        _emailEextEditingController.text = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email or Username required";
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email or Username"),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    TextFormField(
                      controller: _phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        _phoneTextEditingController.text = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "phone required";
                        }
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text("Phone Number"),
                        // prefixIcon: Icon(Icons.phone),
                        prefixIcon: CountryCode(
                          countryCode: (code) {
                            setState(() {
                              _dialCode = code;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    if(value.loadingStatus.status == LoadingStatus.error)
                      Text(value.loadingStatus.message, style: const TextStyle(color: Colors.red),)
                    ,
                    CustomeButton(
                      onPressed: () async {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Pressed");
                          debugPrint(_phoneTextEditingController.text);

                          MvvpUser _user = MvvpUser(
                            id: 1, 
                            phone:  _dialCode + _phoneTextEditingController.text, 
                            username: _emailEextEditingController.text,);
                          
                          await value.verifyPhone(
                             _user,
                              context);
                        }
                      },
                      child: value.loadingStatus.status == LoadingStatus.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


