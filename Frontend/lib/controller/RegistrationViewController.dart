class RegistrationViewController {

  //Kontrolliert, ob Benutzername nicht leer und kürzer als 13 Zeichen ist
  static String? validateUsername (String? value) {
    if (value == null || value.isEmpty) {
       return "Bitte gib einen Benutzernamen ein";
   }
    if(value.length > 12) {
      return "Benutzername darf nicht mehr als 12 Zeichen beinhalten";
   }
    else {
      return null;
    }
  }

  //Kontrolliert, ob Email-Adresse das richtige Format hat
  static String? validateMail (String? value) {
    if (value == null || value.isEmpty) {
      return "Bitte gib eine gültige E-Mail Adresse ein";
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if(!emailRegExp.hasMatch(value)) {
      return "Ungültiges E-Mail Format";
    }
    return null;
  }

  //Kontrolliert, ob Passwort ausreichend stark ist
  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      return "Bitte wähle ein Passwort";
    }

    if(value.length < 10) {
      return "Das Passwort muss länger als 9 Zeichen sein";
    }
    return null;
  }

  //Kontrolliert, ob die Passwörter identisch sind
  static String? checkMatch(String? repeatPasswort, String? setPasswort) {
    if(repeatPasswort == null || repeatPasswort.isEmpty) {
      return "Bitte das vorher gewählte Passwort eingeben";
    }

    if(repeatPasswort != setPasswort) {
      return "Die Passwörter stimmen nicht überein";
    }

    return null;
  }
}