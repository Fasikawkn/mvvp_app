import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mvvp_app/src/models/mvvp_user_model.dart';

@GenerateMocks([http.Client])
main() {
  group("[Category Model]", () {
    MvvpUser? _user;
    setUp(() {
      _user = MvvpUser(
        id: 1,
        phone: '+251929465849',
        username: "Fasikaw"
      );
    });

    // Testing category Model
    test('[Model] check individual values', () async {
      _user =MvvpUser(
        id: 1,
        phone: '+251929465849',
        username: "Fasikaw"
      );
      // BEGIN TEST...
      expect(_user!.id, 1);
      expect(_user!.phone, isNotNull);
      expect(_user!.username, isA<String>());
    });
  });
}