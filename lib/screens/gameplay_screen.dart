import 'package:flutter/material.dart';

class GameplayScreen extends StatefulWidget {
  final String nomePack;
  const GameplayScreen({super.key, required this.nomePack});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int pontos = 0;
  String missaoAtual = "Encontra a Torre dos Clérigos e tira uma foto.";
  
  // Função para abrir o Pop-up do Desafio
  void _abrirDesafio() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("📷 CÂMARA DE ÉPOCA", style: TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
              "DESAFIO: Coloca a foto antiga (em baixo) sobre o monumento real e tira a foto perfeita do 'Antigo sobre o Novo'.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Simulação da Foto Antiga do Excel
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Torre_dos_Cl%C3%A9rigos_em_1900.jpg/800px-Torre_dos_Cl%C3%A9rigos_em_1900.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("ABRIR CÂMARA E CAPTURAR", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  _mostrarSucesso();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarSucesso() {
    setState(() => pontos += 100);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Excelente foto! Ganhaste 100 pontos!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Mapa (Simulado)
          CustomPaint(size: Size.infinite, painter: GamifiedMapPainter()),
          
          // HUD Topo
          Positioned(
            top: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(backgroundColor: Colors.black, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange)),
                  child: Text('$pontos PTS | ${widget.nomePack}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.my_location, color: Colors.deepOrange)),
              ],
            ),
          ),

          // Player
          const Center(child: Icon(Icons.navigation, color: Colors.deepOrange, size: 50)),

          // Card Missão
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange.withOpacity(0.5))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('PRÓXIMO POI: CLÉRIGOS', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(missaoAtual, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      onPressed: _abrirDesafio, // AGORA ABRE O DESAFIO!
                      child: const Text('RESPONDER / SCAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GamifiedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.deepOrange.withOpacity(0.1)..strokeWidth = 1.0;
    for (double i = 0; i < size.width; i += 40) { canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint); }
    for (double i = 0; i < size.height; i += 40) { canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}