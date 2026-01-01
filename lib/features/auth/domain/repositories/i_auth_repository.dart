import '../entities/auth_user.dart';

abstract class IAuthRepository {
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser?> get currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  );
  Future<void> signInWithMagicLink(String email);
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInWithApple(); // Usually standard for iOS
  Future<void> signOut();
}
