import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mvvp_app/src/models/mvvp_medication_model.dart';

import 'package:mvvp_app/src/services/data_provider/mvvp_medication_data.dart';

import 'mock_constatnts.dart';

@GenerateMocks([http.Client])
void main() {
  group('Testing Medication data provider Method', () {
    test('returns A list of medications if the http call completes succesfully',
        () async {
      final client = MockClient((req) async {
        return http.Response(jsonEncode(apiMedication), 200);
      });

      MedicationDataProvider dataProvider =
          MedicationDataProvider(httpClient: client);

      expect(await dataProvider.getAllMedications(), isA<List<Medication>>());
    });

    test('throws exception if the http call is unsuccesfull', () async {
      final client = MockClient((req) async {
        return http.Response(jsonEncode('Somthing went wrong'), 404);
      });

      MedicationDataProvider dataProvider =
          MedicationDataProvider(httpClient: client);

      expect(await dataProvider.getAllMedications(), throwsException);
    });
  });
}
