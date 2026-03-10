import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String cargo;
  final Color cor;

  const ProfileScreen({super.key, required this.username, required this.cargo, required this.cor});

  void _abrirAtivacao(BuildContext context) {
    TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Código de Início"),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(hintText: "PAPTUR26"),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (codeController.text.toUpperCase() == "PAPTUR26") {
                Navigator.pop(context);
                // AQUI CHAMAS O TEU GAMEPLAY OU HOME
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jogo Iniciado!")));
              }
            }, 
            child: const Text("ATIVAR")
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(title: const Text("A MINHA CONTA"), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(child: CircleAvatar(radius: 50, backgroundColor: cor, child: const Icon(Icons.person, size: 50))),
          Text(username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(cargo.toUpperCase(), style: TextStyle(color: cor)),
          const SizedBox(height: 40),
          
          if (cargo == 'pap')
            ListTile(
              leading: const Icon(Icons.play_circle, color: Colors.orange),
              title: const Text("Iniciar Roteiro"),
              onTap: () => _abrirAtivacao(context),
            ),
          // ... Resto dos botões de Admin/Júri que já tínhamos
        ],
      ),
    );
  }
}