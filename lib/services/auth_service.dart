import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Stream<User> get authStateChanges => _auth.authStateChanges();

  static Future<String> signInWithGoogle() async {
    // await Firebase.initializeApp();
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      // DocumentSnapshot doc =
      //     await _firestore.collection("/users").doc(user.uid).get();

      // if (!doc.exists) {
      //   _firestore.collection("/users").doc(user.uid).set({
      //     "name": user.displayName,
      //     "email": user.email,
      //     "photoURL": user.photoURL,
      //     "eventDetail": [],
      //     "starred_notices": [],
      //     "interested": []
      //   });
      // }

      print('Google Sign In succeeded');
      return '$user';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("User Sign Out");
  }
}
