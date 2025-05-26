import 'auth_viewmodel.dart';

class UserViewModel extends AuthViewModel {
  @override
  Future<bool> loginWithPin(String pin) async {
    print('UserViewModel: Attempting login with PIN: $pin');
    final result = await super.loginWithPin(pin);
    print('UserViewModel: Login ${result ? 'successful' : 'failed'}');
    return result;
  }

  @override
  Future<void> logout() async {
    print('UserViewModel: Logging out');
    await super.logout();
  }
}
