import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CountryCode extends StatelessWidget {
  final Function(String code) countryCode;
  const CountryCode({required this.countryCode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: CountryCodePicker(
        
        onChanged: (code) {
          countryCode(code.dialCode!);
        },
        
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'ET',
        favorite: const ['+1', 'US'],
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showFlag: false,
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: true,
      ),
    );
  }
}
