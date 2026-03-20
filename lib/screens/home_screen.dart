import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import '../app_settings.dart';

import 'tab_perfil.dart';
import 'tab_social.dart';
import 'tab_jogar.dart';
import 'tab_mural.dart';
import 'tab_rankings.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String cargo;
  
  const HomeScreen({super.key, required this.username, required this.cargo});

  static List<String> packsDesbloqueadosNestaSessao = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✨ A APP AGORA ARRANCA DIRETAMENTE NO JOGAR (Índice 2) ✨
  int _indiceAtual = 2; 
  bool _tutorialMostrado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_tutorialMostrado) {
        _mostrarTutorialDoJuri();
        _tutorialMostrado = true;
      }
    });
  }

  void _mostrarTutorialDoJuri() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TutorialInterativoOverlay(),
    );
  }

  Widget? _obterFAB() {
    if (_indiceAtual == 3) {
      return FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Partilha IA: Em breve..."))),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text("Partilhar com IA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> paginas = [
      TabPerfil(username: widget.username, cargo: widget.cargo),
      const TabSocial(),
      const TabJogar(),
      const TabMural(), 
      const TabRankings(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: paginas[_indiceAtual],
      floatingActionButton: _obterFAB(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, 
        onTap: (i) => setState(() => _indiceAtual = i), 
        type: BottomNavigationBarType.fixed, 
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white, 
        selectedItemColor: Colors.deepOrange, 
        unselectedItemColor: Colors.grey, 
        selectedFontSize: 12, 
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          const BottomNavigationBarItem(icon: Icon(Icons.people), label: "Social"),
          BottomNavigationBarItem(icon: Container(margin: const EdgeInsets.only(bottom: 4), decoration: BoxDecoration(boxShadow: _indiceAtual == 2 ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)] : [], shape: BoxShape.circle), child: const Icon(Icons.play_circle_fill, size: 42)), label: "Jogar"),
          const BottomNavigationBarItem(icon: Icon(Icons.landscape), label: "Mural"), 
          const BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Rankings"),
        ],
      ),
    );
  }
}

class TutorialInterativoOverlay extends StatefulWidget {
  const TutorialInterativoOverlay({super.key});
  @override State<TutorialInterativoOverlay> createState() => _TutorialInterativoOverlayState();
}

class _TutorialInterativoOverlayState extends State<TutorialInterativoOverlay> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<Map<String, dynamic>> _passos = [
    {'titulo': 'Bem-vindo ao\nPlay2Travel!', 'desc': 'O Mundo é o teu tabuleiro de jogo. Transforma as tuas viagens em aventuras épicas com inteligência artificial.', 'icon': Icons.public, 'cor': Colors.deepOrange},
    {'titulo': 'Explora Pelo Mundo', 'desc': 'Na aba JOGAR podes selecionar o teu destino, comprar roteiros interativos e desvendar enigmas nas ruas.', 'icon': Icons.play_circle_fill, 'cor': Colors.green},
    {'titulo': 'Conquista Troféus', 'desc': 'No teu PERFIL, podes ver o teu Passaporte crescer, subir de nível (XP) e desbloquear as tuas conquistas.', 'icon': Icons.workspace_premium, 'cor': Colors.amber},
    {'titulo': 'Social & Mural', 'desc': 'Adiciona amigos, cria a tua Squad e partilha as tuas melhores memórias no Mural Público da cidade.', 'icon': Icons.landscape, 'cor': Colors.blueAccent}
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.all(20),
      child: Container(
        height: 450, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.deepOrange, width: 2), boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController, onPageChanged: (i) => setState(() => _paginaAtual = i), itemCount: _passos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: _passos[index]['cor'].withOpacity(0.2), shape: BoxShape.circle), child: Icon(_passos[index]['icon'], size: 70, color: _passos[index]['cor'])),
                        const SizedBox(height: 30), Text(_passos[index]['titulo'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
                        const SizedBox(height: 15), Text(_passos[index]['desc'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: List.generate(_passos.length, (index) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.only(right: 5), height: 8, width: _paginaAtual == index ? 24 : 8, decoration: BoxDecoration(color: _paginaAtual == index ? Colors.deepOrange : Colors.white24, borderRadius: BorderRadius.circular(4))))),
                  ElevatedButton(
                    onPressed: () { if (_paginaAtual < _passos.length - 1) { _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); } else { Navigator.pop(context); } },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: Text(_paginaAtual < _passos.length - 1 ? "SEGUINTE" : "COMEÇAR!", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

// ... PAINEL BACKOFFICE E QR SCANNER MANTIDOS ...
class BackofficeScreen extends StatelessWidget {
  const BackofficeScreen({super.key});
  @override Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark; Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!; Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white; Color textColor = isDark ? Colors.white : Colors.black87;
    return Scaffold(backgroundColor: bgColor, appBar: AppBar(backgroundColor: Colors.blueAccent, elevation: 0, title: const Text("Sala de Comando", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), body: Center(child: Text("Painel de Admin", style: TextStyle(color: textColor))));
  }
}
class QRScannerScreen extends StatefulWidget { const QRScannerScreen({super.key}); @override State<QRScannerScreen> createState() => _QRScannerScreenState(); }
class _QRScannerScreenState extends State<QRScannerScreen> { @override Widget build(BuildContext context) { return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Scanner", style: TextStyle(color: Colors.white)))); } }