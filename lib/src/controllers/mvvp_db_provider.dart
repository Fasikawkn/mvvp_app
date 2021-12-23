import 'package:flutter/foundation.dart';
import 'package:mvvp_app/src/controllers/mvvp_controllers.dart';
import 'package:mvvp_app/src/models/mvvp_models.dart';

class MvvpUserProvider with ChangeNotifier {
  final DBHelper? dbHelper;
  List<MvvpUser> _items = [];
  final tableName = 'user';
  final String phoneNumber = '+251929465849';

  MvvpUserProvider(this._items, this.dbHelper) {
    if (dbHelper != null) {
      // fetchAndSetData();
    }
  }

  List<MvvpUser> get items => [..._items];

  Future insertUser(MvvpUser user) async {
    if (dbHelper!.db != null) {
      await dbHelper!.insert(
        tableName,
        user.toJson(),
      );
    }
  }

  Future deleteUser(int id) async {
    if (dbHelper!.db != null) {
      await dbHelper!.delete(tableName, id);
    }
  }

  Future<void> fetchAndSetData() async {
    if (dbHelper!.db != null) {
      // do not execute if db is not instantiate
      final dataList = await dbHelper!.getData(tableName);

      _items = dataList
          .map((item) => MvvpUser(
              id: int.parse(item['id']),
              username: item['username'],
              phone: item['phone']))
          .toList();
      notifyListeners();
    }
  }
}
