import 'package:flutter/material.dart';
import 'package:mvvp_app/src/models/mvvp_user_model.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:mvvp_app/src/views/verify_phone_screen.dart';

class AppRoute {
  static Route generateRoute(RouteSettings settings) {

    if (settings.name == Wrapper.routeName) {
      return MaterialPageRoute(
        builder: (context) => const Wrapper(),
      );
    } else if (settings.name == HomePage.routeName) {
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
    } else if (settings.name == PhoneVerification.routeName) {
      final MvvpUser user = settings.arguments as MvvpUser;
      return MaterialPageRoute(
        builder: (context) =>  PhoneVerification(user),
      );
    }
    return MaterialPageRoute(
      builder: (context) => const Wrapper(),
    );
  }
}
