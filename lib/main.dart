import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvvp_app/src/config/mvvp_config.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/controllers/mvvp_db_helper.dart';
import 'package:mvvp_app/src/controllers/mvvp_db_provider.dart';
import 'package:mvvp_app/src/controllers/mvvp_medication_controller.dart';
import 'package:mvvp_app/src/services/data_provider/mvvp_medication_data.dart';
import 'package:mvvp_app/src/services/repository/mvvp_medication_repository.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  HttpOverrides.global = MyHttpOverrides();
  final MedicationRepository medicationRepository = MedicationRepository(
    dataProvider: MedicationDataProvider(
      httpClient: http.Client(),
    ),
  );
  runApp(MVVPApp(
    medicationRepository: medicationRepository,
  ));
}

class MVVPApp extends StatelessWidget {
  const MVVPApp({required this.medicationRepository, Key? key})
      : super(key: key);
  final MedicationRepository medicationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationModel>(
          create: (context) => AuthenticationModel()..initAuth(),
        ),
        ChangeNotifierProvider<MedicationModel>(
          create: (context) => MedicationModel(repository: medicationRepository)
            ..getAllMedication(),
        ),
        ChangeNotifierProvider<DBHelper>(
          create: (context) => DBHelper(),
        ),
        ChangeNotifierProxyProvider<DBHelper, MvvpUserProvider>(
          create: (context) => MvvpUserProvider([], null),
          update: (context, db, previous) => MvvpUserProvider(
            previous!.items,
            db,
          ),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: Wrapper.routeName,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
