import 'package:flutter/material.dart';
import 'package:werwolf/controller/LoginViewController.dart';
import 'package:werwolf/Homescreen.dart';

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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {

      await LoginViewController.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  Homescreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegistrationBackgroundWrapper(
      child: Column(
        children: [

          DynamicAuthForm(
            formKey: _formKey,
            submitButtonText: "Einloggen",
            onSubmit: _handleLogin,
            fields: [
              AuthenticationFormField(
                controller: _emailController,
                label: "Mail-Adresse",
                hint: "Gib eine E-Mail Adresse ein",
                icon: Icons.email,
                validator: (value) =>
                    LoginViewController.validateMail(value),
              ),

              AuthenticationFormField(
                controller: _passwordController,
                label: "Passwort",
                hint: "Dein Passwort",
                icon: Icons.lock,
                isPassword: true,
                validator: (value) =>
                    LoginViewController.validateMail(value),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homescreen(),
                  ),
                );
              },
              child: const Text("Ohne Login fortfahren"),
            ),
          ),

        ],
      ),
    );
  }
}