abstract class AppStrings {
  // App
  static const String appName = 'My App';

  // Auth
  static const String login          = 'Login';
  static const String register       = 'Register';
  static const String logout         = 'Logout';
  static const String email          = 'Email';
  static const String password       = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount      = "Don't have an account?";
  static const String haveAccount    = 'Already have an account?';

  // Error messages
  static const String errorGeneral     = 'Something went wrong. Please try again.';
  static const String errorNetwork     = 'No internet connection.';
  static const String errorUnauth      = 'Session expired. Please login again.';
  static const String errorEmailEmpty  = 'Email cannot be empty';
  static const String errorEmailInvalid = 'Enter a valid email';
  static const String errorPassEmpty   = 'Password cannot be empty';
  static const String errorPassShort   = 'Password must be at least 8 characters';

  // Success messages
  static const String successLogin    = 'Login successful!';
  static const String successRegister = 'Account created successfully!';
  static const String successLogout   = 'Logged out successfully.';
}
