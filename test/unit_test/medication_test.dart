import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mvvp_app/src/models/mvvp_medication_model.dart';

@GenerateMocks([http.Client])
main() {
  group("[Category Model]", () {
    Medication? _medication;
    setUp(() {
      _medication = Medication(name: "Abebe", dose: "kebede", strength: "bbbb");
    });

    // Testing category Model
    test('[Model] check individual values', () async {
      _medication = Medication(name: "Abebe", dose: "kebede", strength: "bbbb");

      // BEGIN TEST...
      expect(_medication!.name, 'Abebe');
      expect(_medication!.dose, isNotNull);
      expect(_medication!.strength, isA<String>());
    });
  });
}
