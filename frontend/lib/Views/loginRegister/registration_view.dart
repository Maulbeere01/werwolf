import 'package:flutter/material.dart';
import 'package:werwolf/controller/RegistrationViewController.dart';
import '../../widgets/registration_login_background_wrapper.dart';
import '../../widgets/dynamic_auth_form.dart';
import '../../widgets/authentication_form_field.dart';

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
    if (_formKey.currentState!.validate()) {
      print("Registrierungs-Versuch mit: ${_emailController.text}");
      await RegistrationViewController.registerUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
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