import 'package:flutter/material.dart';

const kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

const kLabelStyle =  TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color:Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow:const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

enum PinCodeFieldShape { box, underline, circle }

enum HapticFeedbackTypes {
  heavy,
  light,
  medium,
  selection,
  vibrate,
}
