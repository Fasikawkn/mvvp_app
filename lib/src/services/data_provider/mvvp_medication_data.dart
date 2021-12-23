import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvvp_app/src/config/mvvp_config.dart';
import 'package:mvvp_app/src/models/mvvp_medication_model.dart';

class MedicationDataProvider {
  final http.Client httpClient;

  MedicationDataProvider({required this.httpClient});

  // get list of medication
  Future<List<Medication>> getAllMedications() async {
    final response =
        await httpClient.get(Uri.parse(ApiEndpoints.medicationEndpoint));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var problems = json['problems'];

      var diabets = problems[0]['Diabetes'];
      var medications = diabets[0]['medications'];

      var medicationsClasses = medications[0]['medicationsClasses'];
      var className = medicationsClasses[0]['className'] as List;
      return className
          .map((medication) => Medication.fromJson(medication))
          .toList();
    } else {
      throw Exception(response.body);
    }
  }
}
