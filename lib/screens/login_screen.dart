import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final Map<String, Map<String, dynamic>> _baseDados = {
    'Juri1': {'cargo': 'juri'}, 'Juri2': {'cargo': 'juri'}, 'Juri3': {'cargo': 'juri'},
    'Juri4': {'cargo': 'juri'}, 'Juri5': {'cargo': 'juri'}, 'Juri6': {'cargo': 'juri'},
    'Juri7': {'cargo': 'juri'}, 'Juri8': {'cargo': 'juri'},
    'Lourenço_Aluai': {'cargo': 'pap'}, 'Maria_Americano': {'cargo': 'pap'},
    'Nadia_Magalhães': {'cargo': 'pap'}, 'Paula_Pereira': {'cargo': 'pap'},
    'Barbara_Monteiro': {'cargo': 'turista'},
    'Admin': {'cargo': 'admin'}, 'Tiago_Castro': {'cargo': 'admin'},
  };

  void _login() {
    final String user = _userController.text.trim();
    final String pass = _passController.text.trim();

    if (_baseDados.containsKey(user) && pass == "turismo") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: user,
            cargo: _baseDados[user]!['cargo'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados incorretos"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // LOGO RESTAURADO
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 40),
              
              _buildTextField(_userController, "Username", Icons.person, false),
              const SizedBox(height: 15),
              _buildTextField(_passController, "Password", Icons.lock, true),
              
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                  onPressed: _login,
                  child: const Text("ENTRAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 30),
              const Text("OU", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              // BOTÕES DE LOGIN ESCOLA / SOCIAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialIcon(Icons.school, "Escola", Colors.blue),
                  _socialIcon(Icons.g_mobiledata, "Google", Colors.red),
                  _socialIcon(Icons.apple, "Apple", Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, bool obscure) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.white10, child: Icon(icon, color: color)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}