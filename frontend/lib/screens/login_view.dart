import 'package:flutter/material.dart';
import 'package:werwolf/controllers/login_view_controller.dart';
import 'package:werwolf/screens/home_screen.dart';

import 'package:werwolf/widgets/registration_login_background_wrapper.dart';
import 'package:werwolf/widgets/dynamic_auth_form.dart';
import 'package:werwolf/widgets/authentication_form_field.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {

      final success = await LoginViewController.loginUser(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login fehlgeschlagen. Bitte überprüfe deine Zugangsdaten.'),
          ),
        );
      }
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
                controller: _usernameController,
                label: "Benutzername",
                hint: "Gib deinen Benutzernamen ein",
                icon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? "Bitte gib deinen Benutzernamen ein" : null,
              ),

              AuthenticationFormField(
                controller: _passwordController,
                label: "Passwort",
                hint: "Dein Passwort",
                icon: Icons.lock,
                isPassword: true,
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