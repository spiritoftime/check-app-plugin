import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  // Singleton pattern

  static final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository._internal();
  factory AuthenticationRepository() => _authenticationRepository;
  AuthenticationRepository._internal();
  static String? _userId;

  Future<String?> get userId async {
    if (_userId != null) return _userId!;
// sign in once at start
    _userId = await signInGetUserId();
    return _userId!;
  }

  Future<String?> signInGetUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        return userCredential.user!.uid;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
        FormatException("Error: ${e.code}");
      }
    } else {
      return user.uid;
    }
    return null;
  }
}
