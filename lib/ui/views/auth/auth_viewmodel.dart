import 'dart:io';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//local
import 'package:swift_chat/app/app.locator.dart';
import 'package:swift_chat/app/app.router.dart';
import 'package:swift_chat/services/auth.dart';
import 'package:swift_chat/ui/views/auth/auth_view.form.dart';

enum AuthState {
  login,
  register,
  forgetPassword,
}

class AuthViewModel extends FormViewModel {
  final _authService = locator<AuthService>();
  final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  File? file;
  var _authState = AuthState.register;

  bool get isLoginState => _authState == AuthState.login;
  bool get isRegisterState => _authState == AuthState.register;
  bool get isForgetPassowrdState => _authState == AuthState.forgetPassword;

  void selectImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (xFile == null) return;

    file = File(xFile.path);
    rebuildUi();
  }

  void changeAuthState(AuthState state) {
    _authState = state;
    rebuildUi();
  }

  void onFormSubmit() async {
    //Returning if any value is not entered or invalid inputs
    if (_checkIfAnyValueIsNotEntered() || !_validateInputs()) return;

    setBusy(true);
    if (isRegisterState) await _register();
    if (isLoginState) await _login();
    if (isForgetPassowrdState) await _resetPassword();
    setBusy(false);
  }

  Future _register() async {
    final error = await _authService.createUserWithEmailAndPassword(
      emailValue!,
      passwordValue!,
    );

    if (error != null) {
      _showSnackBar(error);
    } else {
      _navigationService.replaceWithHomeView();
    }
  }

  Future _login() async {
    final error = await _authService.signInUserWithEmailAndPassword(
      emailValue!,
      passwordValue!,
    );

    if (error != null) {
      _showSnackBar(error);
    } else {
      _navigationService.replaceWithHomeView();
    }
  }

  Future _resetPassword() async {
    final error = await _authService.resetPassword(
      emailValue!,
    );

    if (error != null) {
      _showSnackBar(error);
    } else {
      _showSnackBar('Reset linked has been sent to register email');
    }
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

    if (isRegisterState && file == null && !isAnyValueNotEntered) {
      _showSnackBar('Please select an image');
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

  void _showSnackBar(String message) {
    _snackBarService.closeSnackbar();
    _snackBarService.showSnackbar(
        message: message, duration: const Duration(seconds: 2));
  }
}
