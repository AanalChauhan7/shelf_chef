import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/dashboard/models/user_profile_data.dart';

/// Central Firebase Authentication & Firestore Sync Service for Web and Mobile.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Current logged-in Firebase User
  static User? get currentUser => _auth.currentUser;

  /// Auth state changes stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 1. Sign Up: Save initial user record (uid, name, email, password) in Firestore `users/{uid}`
  static Future<UserProfileData> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

    final User? user = credential.user;
    if (user == null) {
      throw Exception('Failed to create account. Please try again.');
    }

    final initialProfile = UserProfileData(
      fullName: fullName.trim().isEmpty ? 'Chef User' : fullName.trim(),
    );

    try {
      final initialData = {
        'uid': user.uid,
        'fullName': initialProfile.fullName,
        'email': user.email ?? email.trim(),
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(initialData)
          .timeout(const Duration(seconds: 6), onTimeout: () {});
    } catch (_) {}

    return initialProfile;
  }

  /// 2. Log In: Match existing user in Firebase Auth / Firestore
  static Future<UserProfileData> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final User? user = credential.user;
    if (user == null) {
      throw Exception('Failed to sign in. Please check your credentials.');
    }

    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnap = await docRef.get().timeout(const Duration(seconds: 6));

      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        return UserProfileData(
          fullName: data['fullName'] ?? 'Chef User',
          familyMembers: (data['familyMembers'] as num?)?.toInt() ?? 1,
          monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 6000.0,
          allergies: List<String>.from(data['allergies'] ?? []),
          imagePath: data['imagePath'],
        );
      } else {
        final defaultProfile = UserProfileData(
          fullName: user.displayName ?? 'Chef User',
        );
        await docRef
            .set({
              'uid': user.uid,
              'fullName': defaultProfile.fullName,
              'email': user.email ?? email.trim(),
              'password': password,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            })
            .timeout(const Duration(seconds: 5), onTimeout: () {});
        return defaultProfile;
      }
    } catch (_) {
      return UserProfileData(fullName: user.displayName ?? 'Chef User');
    }
  }

  /// 3. Google Sign-In with Firebase Auth & Firestore record creation
  static Future<UserProfileData> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google Sign-In was cancelled.');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    final User? user = userCredential.user;

    if (user == null) {
      throw Exception('Failed to sign in with Google.');
    }

    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnap = await docRef.get().timeout(const Duration(seconds: 6));

      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        return UserProfileData(
          fullName: data['fullName'] ?? user.displayName ?? 'Chef User',
          familyMembers: (data['familyMembers'] as num?)?.toInt() ?? 1,
          monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 6000.0,
          allergies: List<String>.from(data['allergies'] ?? []),
          imagePath: data['imagePath'] ?? user.photoURL,
        );
      } else {
        final initialProfile = UserProfileData(
          fullName: user.displayName ?? 'Chef User',
          imagePath: user.photoURL,
        );
        await docRef
            .set({
              'uid': user.uid,
              'fullName': initialProfile.fullName,
              'email': user.email ?? '',
              'familyMembers': initialProfile.familyMembers,
              'allergies': initialProfile.allergies,
              'monthlyBudget': initialProfile.monthlyBudget,
              'imagePath': initialProfile.imagePath,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            })
            .timeout(const Duration(seconds: 5), onTimeout: () {});
        return initialProfile;
      }
    } catch (_) {
      return UserProfileData(
        fullName: user.displayName ?? 'Chef User',
        imagePath: user.photoURL,
      );
    }
  }

  /// 4. Post-Login / Setup: Store additional profile preferences
  static Future<void> updateUserProfile(UserProfileData profile) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'fullName': profile.fullName,
            'familyMembers': profile.familyMembers,
            'monthlyBudget': profile.monthlyBudget,
            'allergies': profile.allergies,
            'imagePath': profile.imagePath,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .timeout(const Duration(seconds: 6), onTimeout: () {});
    } catch (_) {}
  }

  /// Sign Out
  static Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
