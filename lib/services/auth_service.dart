import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Authentication service untuk handle semua operasi login/register
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream untuk auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Register dengan Email dan Password
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user di Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document di Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': null,
          'phoneNumber': null,
          'address': null,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Registrasi gagal: $e';
    }
  }

  /// Login dengan Email dan Password
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Login gagal: $e';
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Logout gagal: $e';
    }
  }

  /// Reset Password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Reset password gagal: $e';
    }
  }

  /// Update Profile
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User tidak ditemukan';

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update di Firestore juga
      await _firestore.collection('users').doc(user.uid).update({
        if (displayName != null) 'name': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
      });
    } catch (e) {
      throw 'Update profile gagal: $e';
    }
  }

  /// Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User tidak ditemukan';

      // Delete user document dari Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user dari Firebase Auth
      await user.delete();
    } catch (e) {
      throw 'Delete account gagal: $e';
    }
  }

  /// Handle Firebase Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Gunakan email lain atau login.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan register terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'user-disabled':
        return 'Akun Anda telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return e.message ?? 'Terjadi kesalahan: ${e.code}';
    }
  }

  // TODO: Implement Google Sign In
  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   return await _auth.signInWithCredential(credential);
  // }

  // TODO: Implement Apple Sign In
  // Future<UserCredential> signInWithApple() async {
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(...);
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     accessToken: appleCredential.authorizationCode,
  //   );
  //   return await _auth.signInWithCredential(oauthCredential);
  // }
}
