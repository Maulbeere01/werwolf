import 'package:flutter/material.dart';
import 'package:werwolf/controller/RegistrationViewController.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
          title: Text("Registrierung",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold
          ),
          ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //NameFeld
                    Center(
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Gib einen Usernamen ein",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                        ),
                        validator: RegistrationViewController.validateUsername,
                      ),
                    ),

                    //MailAdresseFeld
                    Center(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email-Adresse",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Gib deine E-Mail ein",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                        ),
                        validator: RegistrationViewController.validateMail,
                      ),
                    ),

                    //Passwort
                    Center(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Passwort eingeben",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Gib ein Passwort ein",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.password, color: Colors.grey),
                        ),
                        validator: RegistrationViewController.validatePassword,
                      ),
                    ),

                    //Passwort Wiederholen
                    Center(
                      child: TextFormField(
                        controller: _passwordRepeatController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Passwort wiederholen",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Gib das Passwort ein",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.password, color: Colors.grey),
                        ),
                        validator: (value) {
                          return RegistrationViewController.checkMatch(
                              value, _passwordController.text,
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              ),

              //Registrieren Knopf
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {

                    String name = _usernameController.text;
                    String mail = _emailController.text;
                    String pw = _passwordController.text;

                    print("Starte Registrierung für: $name");

                    await RegistrationViewController.registerUser(name,mail, pw);

                    print("Registrierungs-Prozess abgeschlossen");

                  } else {
                    print("Validierung fehlgeschlagen - Bitte Fehler korrigieren");
                  }
                },
                  child: Text("Registrieren"),

              )
            ],
          ),
        ),
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright, color: Theme.of(context).colorScheme.onPrimary),
              Text(
                " 2026",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, // Passend zum Icon
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ),
      ),

    );
  }
}