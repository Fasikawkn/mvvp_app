import 'package:flutter/material.dart';
import 'package:mvvp_app/src/controllers/mvvc_firebase_auth.dart';
import 'package:mvvp_app/src/controllers/mvvp_controllers.dart';
import 'package:mvvp_app/src/controllers/mvvp_medication_controller.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';
import 'package:mvvp_app/src/views/mvvp_views.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/mvvc/homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _getUser();
  }

 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _getUser();
  }

  String _getGreetMessage(String username) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,\n$username';
    }
    if (hour < 17) {
      return 'Good Afternoon, \n$username';
    }
    return 'Good Evening, \n$username';
  }

  String _getDate() {
    DateTime aDateTime = DateTime.now();
    var dateFormat = DateFormat.MMMMEEEEd().format(aDateTime);
    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<MvvpUserProvider>(context);
    // userModel.fetchAndSetData();
    // debugPrint("User ${userModel.items}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("MVVP App"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<AuthenticationModel>(context, listen: false)
                  .signout();
              await Provider.of<MvvpUserProvider>(context, listen: false)
                  .deleteUser(1);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginPage.routeName, (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(_getDate(),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
            ),
            Center(
              child: Text(
                  _getGreetMessage(userModel.items.isNotEmpty
                      ? userModel.items[0].username
                      : "Username"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      // color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                child: Text(
                  "Medicines",
                  style: TextStyle(fontSize: 18.0, color: Colors.lightBlue),
                ),
              ),
            ),
            Consumer<MedicationModel>(
              builder: (context, value, child) {
                if (value.response.status == LoadingStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.response.status == LoadingStatus.error) {
                  return Center(
                    child: Text(value.response.message),
                  );
                }
                debugPrint("The value is model ${value.response.data}");
                List<Medication> medicines = value.response.data;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      // horizontal: 20.0,
                      ),
                  child: Column(
                      children: medicines
                          .map((medicine) => Card(
                                child: ListTile(
                                  title: Text(
                                    medicine.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    medicine.strength,
                                  ),
                                  trailing: const Text('dose'),
                                ),
                              ))
                          .toList()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
