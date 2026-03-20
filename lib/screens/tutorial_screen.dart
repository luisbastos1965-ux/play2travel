import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✨ PACOTE DE MEMÓRIA
import 'home_screen.dart';

class AppTutorialScreen extends StatefulWidget {
  final String username;
  final String cargo;

  const AppTutorialScreen({super.key, required this.username, required this.cargo});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<Map<String, dynamic>> _passosTutorial = [
    {
      "titulo": "Bem-vindo(a), Viajante!",
      "descricao": "Eu sou o TOB, o teu Guia Inteligente. Estou aqui para transformar a tua viagem numa verdadeira aventura.",
      "icone": Icons.smart_toy,
      "cor": Colors.deepPurpleAccent,
    },
    {
      "titulo": "🗺️ Escolhe o teu Destino",
      "descricao": "Navega pelo mapa global, escolhe um Pack de Missões e desbloqueia segredos que os turistas comuns nunca chegam a ver.",
      "icone": Icons.map,
      "cor": Colors.blueAccent,
    },
    {
      "titulo": "🤝 Reúne o teu Squad",
      "descricao": "Cria alianças! Usa o QR Code para adicionar amigos, formem equipas e completem desafios em conjunto.",
      "icone": Icons.groups,
      "cor": Colors.green,
    },
    {
      "titulo": "🏆 Ganha XP e Sobe no Ranking",
      "descricao": "Cada missão cumprida, cada foto épica no Mural, dá-te Pontos de Experiência (XP). Tens o que é preciso para chegar ao Topo?",
      "icone": Icons.emoji_events,
      "cor": Colors.amber,
    }
  ];

  // ✨ FUNÇÃO QUE GUARDA NA MEMÓRIA E VAI PARA A HOME ✨
  void _finalizarTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_visto', true); // Guarda que já viu!
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => HomeScreen(username: widget.username, cargo: widget.cargo))
    );
  }

  void _avancar() {
    if (_paginaAtual < _passosTutorial.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finalizarTutorial(); // Se for a última página, finaliza!
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finalizarTutorial, // ✨ SALTAR TAMBÉM GUARDA NA MEMÓRIA
                child: Text("Saltar", style: TextStyle(color: textColor.withOpacity(0.5), fontWeight: FontWeight.bold)),
              ),
            ),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _paginaAtual = index),
                itemCount: _passosTutorial.length,
                itemBuilder: (context, index) {
                  final passo = _passosTutorial[index];
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(color: passo['cor'].withOpacity(0.2), shape: BoxShape.circle, boxShadow: [BoxShadow(color: passo['cor'].withOpacity(0.5), blurRadius: 40, spreadRadius: 5)]),
                          child: Icon(passo['icone'], size: 100, color: passo['cor']),
                        ),
                        const SizedBox(height: 50),
                        Text(passo['titulo'], style: TextStyle(color: textColor, fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Text(passo['descricao'], style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16, height: 1.5), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _passosTutorial.length,
                      (index) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.only(right: 8), height: 8, width: _paginaAtual == index ? 24 : 8, decoration: BoxDecoration(color: _paginaAtual == index ? Colors.deepOrange : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _avancar,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 5),
                    child: Text(_paginaAtual == _passosTutorial.length - 1 ? "DARE TO PLAY" : "Avançar", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}