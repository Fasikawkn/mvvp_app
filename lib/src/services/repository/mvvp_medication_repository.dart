import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/services/mvvp_services.dart';

class MedicationRepository {
  final MedicationDataProvider dataProvider;
  MedicationRepository({required this.dataProvider});

  // fetch all medicines
  Future<List<Medication>> getAllMedications() async {
     return await dataProvider.getAllMedications();
   }

  
}
