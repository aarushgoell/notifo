import 'package:notifo/services/auth/auth_Exceptions.dart';
import 'package:notifo/services/auth/auth_provider.dart';
import 'package:notifo/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main(){
  group('Mock Authentication', (){
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with',(){
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized',(){
      expect(provider.logOut(),throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized',() async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after intialization',(){
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async{
      await provider.initialize();
      expect(provider.isInitialized, true);
    },timeout: const Timeout(Duration(seconds: (2))));

    test('Create user should delegate to login function',() async{
      final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser,throwsA(const TypeMatcher<InvalidemailAuthException>(),));
      final badPasswordUser = provider.createUser(email: 'someone@.com', password: 'foobar');
      expect(badPasswordUser,throwsA(const TypeMatcher<InvalidcredentialAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser,user);
      expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified',(){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again',()async{
      await provider.logOut();
      await provider.logIn(email: 'user', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });



  });
}

class NotInitializedException implements Exception{}


class MockAuthProvider implements AuthProvider{

  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;


  @override
  Future<AuthUser> createUser({required String email, required String password})async {
    if(!isInitialized){
      throw NotInitializedException();
    }
    Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
   if(!isInitialized)throw NotInitializedException();
    if(email == 'foo@bar.com') throw InvalidemailAuthException();
    if(password == 'foobar') throw InvalidcredentialAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
   if(!isInitialized)throw NotInitializedException();
   if(_user == null) throw InvalidemailAuthException();
   await Future.delayed(const Duration(seconds: 1));
   _user = null;

  }

  @override
  Future<void> sendEmailVerification()async {
    if(!isInitialized)throw NotInitializedException();
    final user = _user;
    if(user == null) throw InvalidemailAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

}