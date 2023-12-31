import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

//local
import './auth_view.form.dart';
import 'auth_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'userName'),
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class AuthView extends StackedView<AuthViewModel> with $AuthView {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AuthViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: viewModel.isBusy
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (viewModel.isRegisterState)
                        viewModel.isLoadingImage
                            ? const CircularProgressIndicator.adaptive()
                            : GestureDetector(
                                onTap: viewModel.selectImage,
                                child: CircleAvatar(
                                  radius: 100,
                                  foregroundImage: viewModel.file != null
                                      ? FileImage(viewModel.file!)
                                      : null,
                                  child: const Icon(
                                    Icons.add,
                                    size: 35,
                                  ),
                                ),
                              ),
                      const SizedBox(height: 20),
                      if (viewModel.isRegisterState) ...[
                        MyTextField(
                          label: 'User Name',
                          controller: userNameController,
                        ),
                        if (viewModel.hasUserNameValidationMessage)
                          errorTextBuilder(
                              viewModel.userNameValidationMessage!),
                      ],
                      MyTextField(
                        label: 'Email',
                        controller: emailController,
                      ),
                      if (viewModel.hasEmailValidationMessage)
                        errorTextBuilder(viewModel.emailValidationMessage!),
                      if (!viewModel.isForgetPassowrdState) ...[
                        MyTextField(
                          label: 'Password',
                          controller: passwordController,
                          isObsecure: true,
                        ),
                        if (viewModel.hasPasswordValidationMessage)
                          errorTextBuilder(viewModel.passwordValidationMessage!)
                      ],
                      const SizedBox(height: 5),
                      if (!viewModel.isForgetPassowrdState)
                        GestureDetector(
                          onTap: () => viewModel.changeAuthState(
                            viewModel.isForgetPassowrdState
                                ? AuthState.login
                                : AuthState.forgetPassword,
                          ),
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: viewModel.onFormSubmit,
                        child: Text(viewModel.isLoginState
                            ? 'Login'
                            : viewModel.isRegisterState
                                ? 'Register'
                                : 'Reset Password'),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(),
                      ),
                      ElevatedButton(
                        onPressed: () => viewModel.changeAuthState(
                            viewModel.isLoginState
                                ? AuthState.register
                                : AuthState.login),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondary,
                          ),
                          foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.background,
                          ),
                        ),
                        child:
                            Text(viewModel.isLoginState ? 'Register' : 'Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Text errorTextBuilder(String errorText) {
    return Text(
      errorText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AuthViewModel();

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(AuthViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }
}

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isObsecure;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isObsecure = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool obsecure = false;

  @override
  void initState() {
    obsecure = widget.isObsecure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: 60,
      child: TextFormField(
        controller: widget.controller,
        obscureText: obsecure,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        decoration: InputDecoration(
          label: Text(widget.label),
          suffixIcon: widget.isObsecure
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obsecure = !obsecure;
                    });
                  },
                  child:
                      Icon(obsecure ? Icons.visibility_off : Icons.visibility),
                )
              : null,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
