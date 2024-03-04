abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent{
  final String email;

  ResetPasswordEvent(this.email);
}

class ChangePasswordEvent extends AuthEvent{
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent(this.currentPassword, this.newPassword);
}