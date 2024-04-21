import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show AuthCredential, FirebaseAuth, FirebaseAuthException, GoogleAuthProvider, UserCredential;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../firebase_options.dart';
import 'auth_exceptions.dart';
import 'auth_user.dart';

class AuthProviderGoogle implements AuthProvider {
  @override
  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {}

  @override
  Future<AuthUser> createUser(
      {required String name,
      required String email,
      required String password}) async {
    final user = currentUser;
    if (user != null) {
      final MyUser newUser = MyUser(
          uid: user.uid!,
          name: name,
          email: email);
      await newUser.createUser();
      return user;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromGoogle(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        var user = userCredential.user;
        if (user != null) {
          var dbUser = await MyUser.readUser(uid: user.uid);
          if (dbUser == null) {
            createUser(
                name: user.displayName!,
                email: user.email!,
                password: '');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
    final user = currentUser;
    if (user != null) {
      return user;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}
}
