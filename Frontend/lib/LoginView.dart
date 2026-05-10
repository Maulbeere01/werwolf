import 'package:flutter/material.dart';
import 'package:werwolf/controller/LoginViewController.dart';
import 'widgets/RegistrationLoginBackgroundWrapper.dart';
import 'widgets/DynamicAuthForm.dart';
import 'widgets/AuthenticationFormField.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print("Login-Versuch mit: ${_emailController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {

    return RegistrationBackgroundWrapper(
      child: DynamicAuthForm(
        formKey: _formKey,
        submitButtonText: "Einloggen",
        onSubmit: _handleLogin,
        fields: [
          AuthenticationFormField(
            controller: _emailController,
            label: "Mail-Adresse",
            hint: "Gib eine E-Mail Adresse ein",
            icon: Icons.email,
            validator: (value) => LoginViewController.validateMail(value)
          ),

          // Passwort Feld
          AuthenticationFormField(
            controller: _passwordController,
            label: "Passwort",
            hint: "Dein Passwort",
            icon: Icons.lock,
            isPassword: true, // Verdeckt die Eingabe
            validator: (value) => LoginViewController.validateMail(value)
          ),
        ],
      ),
    );
  }
}