import 'package:flutter/material.dart';
// Importa o teu Hub aqui para ele o reconhecer
import 'school_choice_screen.dart'; 

class LanguageSelector extends StatelessWidget {
  final String username;
  final String cargo;

  const LanguageSelector({
    super.key, 
    required this.username, 
    required this.cargo
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Language / Selecionar Língua")),
      body: ListView(
        children: [
          ListTile(
            leading: const Text("🇵ᴛ", style: TextStyle(fontSize: 30)),
            title: const Text("Português"),
            onTap: () {
              // Quando escolhes a língua, ele volta para o Hub 
              // mas LEVA os dados contigo para não dar erro!
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolChoiceScreen(
                    username: username,
                    cargo: cargo,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Text("🇬ʙ", style: TextStyle(fontSize: 30)),
            title: const Text("English"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SchoolChoiceScreen(
                    username: username,
                    cargo: cargo,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}