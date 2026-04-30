import 'package:flutter/material.dart';
import 'package:werwolf/controller/RegistrationViewController.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        title: Text("Login",

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
                          controller: null,
                          decoration: const InputDecoration(
                            labelText: "Email-Adresse",
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: "Gib deine E-Mail Adresse ein",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          validator: RegistrationViewController.validateUsername,
                        ),
                      ),

                      //Hält die Border zwischen den Feldern
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border (
                            bottom: BorderSide(
                              color: Colors.black,
                            )
                          )
                        ),
                      ),

                      //MailAdresseFeld
                      Center(
                        child: TextFormField(
                          controller: null,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Passwort",
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: "Bitte Passwort eingeben",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.password, color: Colors.grey),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          validator: RegistrationViewController.validateMail,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(200,60),
                    foregroundColor: Colors.white,
                    overlayColor: Colors.white,
                  ),
                    onPressed: (){},
                    child: Text("Passwort vergessen")),

                SizedBox(
                  height: 40,
                ),

                //Registrieren Knopf
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: (){

                  },
                  child: Text("Login"),

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