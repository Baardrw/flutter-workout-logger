import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  DataBaseService() {
    // TODO : I DO NOT KNOW YET HOW TO DO THIS
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
