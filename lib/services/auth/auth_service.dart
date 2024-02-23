import 'package:notifo/services/auth/auth_provider.dart';
import 'package:notifo/services/auth/auth_user.dart';
import 'package:notifo/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    return provider.createUser(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    // TODO: implement logIn
    return provider.logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> initialize() {
    return provider.initialize();
  }
}
