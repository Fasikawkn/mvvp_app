import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/services/mvvp_services.dart';

class MedicationModel extends ChangeNotifier {
  final MedicationRepository repository;
  MedicationModel({required this.repository});
  Response response =
      Response(message: '', status: LoadingStatus.idle, data: null);

  Future getAllMedication() async {
    try {
      response = Response(
          message: "loading", status: LoadingStatus.loading, data: null);
      final responseMedication = await repository.getAllMedications();
     
      if (responseMedication is List<Medication>) {
        response = Response(
            message: "Successfully Fetched",
            status: LoadingStatus.idle,
            data: responseMedication);
      }

      notifyListeners();
    } on SocketException catch (e) {
      debugPrint("The Socket error ");
      debugPrint(e.toString());
      response = Response(
          message: 'connection-err', status: LoadingStatus.error, data: null);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(e.toString());
      response =
          Response(message: 'Api-err', status: LoadingStatus.error, data: null);
      notifyListeners();
    }
  }
}
