import 'package:flutter/material.dart';
import 'package:werwolf/controller/RegistrationViewController.dart';
import 'widgets/RegistrationLoginBackgroundWrapper.dart';
import 'widgets/DynamicAuthForm.dart';
import 'widgets/AuthenticationFormField.dart';

class Registrationview extends StatefulWidget {
  const Registrationview({super.key});

  @override
  State<Registrationview> createState() => _LoginViewState();
}

class _LoginViewState extends State<Registrationview> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);

    final error = await RegistrationViewController.registerUser(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(error ?? "Registrierung erfolgreich"),
        backgroundColor: error == null ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (error == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegistrationBackgroundWrapper(
      child: DynamicAuthForm(
        formKey: _formKey,
        submitButtonText: "Registrieren",
        onSubmit: _handleRegistration,
        fields: [

          //Username
          AuthenticationFormField(
            controller: _usernameController,
            label: "Username",
            hint: "Gib einen Usernamen ein",
            icon: Icons.person_3,
            validator: (value) => RegistrationViewController.validateUsername(value)
          ),

          // E-Mail Feld
          AuthenticationFormField(
            controller: _emailController,
            label: "E-Mail",
            hint: "Gib deine E-Mail ein",
            icon: Icons.email,
            validator: (value) => RegistrationViewController.validateMail(value)
          ),

          // Passwort Feld
          AuthenticationFormField(
            controller: _passwordController,
            label: "Passwort",
            hint: "Gib ein Passwort ein",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) => RegistrationViewController.validatePassword(value)
          ),

          // Passwort wiederholen Feld
          AuthenticationFormField(
            controller: _passwordRepeatController,
            label: "Passwort",
            hint: "Dein Passwort",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) => RegistrationViewController.checkMatch(value, _passwordController.text)
          ),
        ],
      ),
    );
  }
}