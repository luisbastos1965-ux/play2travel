import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        title: const Text("Criar Conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Junta-te à Aventura! 🌍", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Preenche os dados abaixo para criares o teu perfil de turista e começares a jogar.", style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 40),

            _buildRegField(Icons.person_outline, "Nome Completo"),
            const SizedBox(height: 15),
            _buildRegField(Icons.alternate_email, "Nome de Utilizador (Username)"),
            const SizedBox(height: 15),
            _buildRegField(Icons.email_outlined, "Endereço de Email"),
            const SizedBox(height: 15),
            _buildRegField(Icons.public, "País de Origem"),
            const SizedBox(height: 15),
            _buildRegField(Icons.lock_outline, "Palavra-passe", isPassword: true),
            const SizedBox(height: 15),
            _buildRegField(Icons.lock_reset, "Confirmar Palavra-passe", isPassword: true),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Para a demo, volta apenas ao login
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada com sucesso! Faz login para entrar.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("CRIAR CONTA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegField(IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true, fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.deepOrange, width: 2)),
      ),
    );
  }
}