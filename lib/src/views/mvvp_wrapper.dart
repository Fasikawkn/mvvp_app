import 'package:flutter/material.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static const routeName = "/mmvp/wrapper";
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationModel>(context);
    return auth.authStatus == AuthStatus.loggedin
        ? const HomePage()
        : const LoginPage();
  }
}
