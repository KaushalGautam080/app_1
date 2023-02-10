import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final firebaseAuthInstance = FirebaseAuth.instance;

  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    final userCred = await firebaseAuthInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }

  Future<UserCredential> signInUser({
    required String email,
    required String password,
  }) async {
    final userCred = await firebaseAuthInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }

  Future<void> logoutUser() async {
    await firebaseAuthInstance.signOut();
  }

  Future<void> deleteUser() async {
    final currentUser = firebaseAuthInstance.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
  }
}
