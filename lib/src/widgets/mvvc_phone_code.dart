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
        
        initialSelection: 'ET',
        favorite: const ['+1', 'US'],
        showCountryOnly: false,
        showFlag: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: true,
      ),
    );
  }
}
