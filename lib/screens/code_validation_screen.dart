import 'package:flutter/material.dart';
import 'gameplay_screen.dart'; // Importa o ecrã do jogo para onde vamos a seguir

class CodeValidationScreen extends StatefulWidget {
  final String nomePack;
  
  const CodeValidationScreen({super.key, required this.nomePack});

  @override
  State<CodeValidationScreen> createState() => _CodeValidationScreenState();
}

class _CodeValidationScreenState extends State<CodeValidationScreen> {
  final TextEditingController _codigoController = TextEditingController();
  String _mensagemErro = '';

  void _validarCodigo() {
    // Verifica se o código é TUR26 (ignora se a pessoa puser minúsculas ou espaços sem querer)
    if (_codigoController.text.trim().toUpperCase() == 'TUR26') {
      // Se estiver correto, avança para o jogo e apaga este ecrã do histórico (pushReplacement)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameplayScreen(nomePack: widget.nomePack)),
      );
    } else {
      // Se errar, mostra o erro
      setState(() {
        _mensagemErro = 'Código inválido. Verifica no teu pack físico e tenta novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ícone de Cadeado/Pack
            const Center(
              child: Icon(Icons.lock_person_rounded, size: 80, color: Colors.deepOrange),
            ),
            const SizedBox(height: 30),
            
            // Título
            Text(
              "DESBLOQUEAR PACK:\n${widget.nomePack.toUpperCase()}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
            ),
            const SizedBox(height: 30),

            // O teu texto instrucional
            const Text(
              "Para iniciar o pack que selecionaste na Play2Travel, precisas primeiro de adquirir o pack de jogo físico.\n\n"
              "Dirige-te a um dos nossos parceiros oficiais na cidade e compra o pack correspondente. Dentro dele encontrarás tudo o que precisas para a tua aventura — incluindo um código de jogo exclusivo.\n\n"
              "✨ Esse código desbloqueia os desafios na app, permitindo iniciar os jogos e explorar a cidade de uma forma totalmente nova.\n\n"
              "Depois de adquirires o pack:\n"
              "• Abre novamente este jogo na app.\n"
              "• Introduz o código presente no pack físico.\n"
              "• A tua aventura começará imediatamente.\n\n"
              "🏙️ Cada pack foi pensado para te levar a descobrir a cidade de forma interativa, com desafios, histórias e experiências únicas.\n\n"
              "Boa exploração… e boa sorte na tua missão!",
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Caixa de Texto para o Código
            TextField(
              controller: _codigoController,
              textCapitalization: TextCapitalization.characters, // Força as letras grandes
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "INSERE AQUI O TEU CÓDIGO",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 14, letterSpacing: 1),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.deepOrange, width: 2)),
              ),
            ),
            
            // Mensagem de Erro (só aparece se o utilizador errar)
            if (_mensagemErro.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_mensagemErro, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
            ],

            const SizedBox(height: 20),

            // Botão de Validar
            ElevatedButton(
              onPressed: _validarCodigo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("VALIDAR CÓDIGO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}