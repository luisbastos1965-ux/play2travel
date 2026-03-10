import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ou o ecrã que vem a seguir ao HUB

class SchoolChoiceScreen extends StatelessWidget {
  final String username;
  final String cargo;

  const SchoolChoiceScreen({
    super.key, 
    required this.username, 
    required this.cargo
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(title: const Text("HUB INICIAL"), backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem-vindo, $username", style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(username: username, cargo: cargo),
                  ),
                );
              },
              child: const Text("IR PARA O MAPA"),
            ),
          ],
        ),
      ),
    );
  }
}