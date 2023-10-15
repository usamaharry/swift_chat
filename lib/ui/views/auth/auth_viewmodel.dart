import 'package:stacked/stacked.dart';
import 'package:swift_chat/ui/views/auth/auth_view.form.dart';

enum AuthState {
  login,
  register,
  forgetPassword,
}

class AuthViewModel extends FormViewModel {
  var _authState = AuthState.register;

  bool get isLoginState => _authState == AuthState.login;
  bool get isRegisterState => _authState == AuthState.register;
  bool get isForgetPassowrdState => _authState == AuthState.forgetPassword;

  void changeAuthState(AuthState state) {
    _authState = state;
    rebuildUi();
  }

  void onFormSubmit() {
    //Returning if any value is not entered or invalid inputs
    if (_checkIfAnyValueIsNotEntered() || !_validateInputs()) return;
  }

  bool _checkIfAnyValueIsNotEntered() {
    var isAnyValueNotEntered = false;

    if (isRegisterState && userNameValue!.isEmpty) {
      setUserNameValidationMessage('Please enter a username');
      isAnyValueNotEntered = true;
    }
    if (emailValue!.isEmpty) {
      setEmailValidationMessage('Please enter a email');
      isAnyValueNotEntered = true;
    }
    if (!isForgetPassowrdState && passwordValue!.isEmpty) {
      setPasswordValidationMessage('Please enter a password');
      isAnyValueNotEntered = true;
    }

    if (isAnyValueNotEntered) {
      rebuildUi();
      return true;
    }
    return false;
  }

  bool _validateInputs() {
    var areInputsAreValid = true;

    var userNameValidation = _validateUserName();
    var emailValidation = _validateEmail();
    var passwordValidation = _validatePassword();

    if (userNameValidation != null && isRegisterState) {
      areInputsAreValid = false;
      setUserNameValidationMessage(userNameValidation);
    }

    if (emailValidation != null) {
      areInputsAreValid = false;
      setEmailValidationMessage(emailValidation);
    }

    if (passwordValidation != null && !isForgetPassowrdState) {
      areInputsAreValid = false;
      setPasswordValidationMessage(passwordValidation);
    }

    if (!areInputsAreValid) rebuildUi();

    return areInputsAreValid;
  }

  String? _validateUserName() {
    if (userNameValue!.length < 3) return 'Please enter atleast 3 characters';

    return null;
  }

  String? _validateEmail() {
    if (!emailValue!.contains('@')) return 'Please enter a valid email';

    return null;
  }

  String? _validatePassword() {
    if (passwordValue!.length < 8) return 'Passowrd must be of 8 characters';

    if (!passwordValue!.contains(RegExp(r'[0-9]'))) {
      return 'Password must have 1 number';
    }

    return null;
  }
}
