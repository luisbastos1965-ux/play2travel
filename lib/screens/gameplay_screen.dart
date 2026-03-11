import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GameplayScreen extends StatefulWidget {
  final String nomePack;

  const GameplayScreen({super.key, required this.nomePack});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int _jogoSelecionado = 0;
  List<Map<String, dynamic>> _jogosAtuais = [];

  final LatLng _localizacaoJogador = const LatLng(41.1450, -8.6140);
  final LatLng _localizacaoObjetivo = const LatLng(41.1458, -8.6139); // Clérigos

  // ==========================================
  // O GRANDE DICIONÁRIO DE PACKS E JOGOS
  // ==========================================
  final Map<String, List<Map<String, dynamic>>> _baseDeDadosPacks = {
    // PACKS SOLO
    'Pack Heritage Hunt': [
      {'nome': 'Radar de Curiosidades', 'tipo': 'mapa', 'missao': 'Encontra a base da torre e descobre em que ano foi terminada.', 'progresso': 0.3, 'feitos': 1, 'total': 3},
      {'nome': 'Bingo Património', 'tipo': 'mapa', 'missao': 'Regista a tua localização nos 5 pontos históricos marcados no mapa.', 'progresso': 0.6, 'feitos': 3, 'total': 5},
      {'nome': 'Câmara de Época', 'tipo': 'camara', 'missao': 'Alinha a fotografia de 1920 com a vista atual do monumento.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Urban Hero': [
      {'nome': 'Diário Explorador', 'tipo': 'narrativa', 'missao': 'Lê a página rasgada do diário antigo e decide que caminho tomar.', 'progresso': 0.5, 'feitos': 1, 'total': 2},
      {'nome': 'Narrativa Episódica', 'tipo': 'narrativa', 'missao': 'Fala com o "Mercador" virtual e negoceia a próxima pista.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Enigma do Mestre', 'tipo': 'narrativa', 'missao': 'Decifra a inscrição na parede para abrires o cofre digital.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    // PACKS DUO
    'Pack Duo Bond': [
      {'nome': 'Puzzle de Par', 'tipo': 'narrativa', 'missao': 'Tu tens a Pergunta, o teu parceiro tem a Resposta. Juntem as peças!', 'progresso': 0.0, 'feitos': 0, 'total': 4},
      {'nome': 'Quiz Afinidade', 'tipo': 'quiz', 'missao': 'Quem é mais provável de se perder nas ruas do Porto?', 'progresso': 0.2, 'feitos': 1, 'total': 5},
      {'nome': 'Bússola Humana', 'tipo': 'mapa', 'missao': 'Usa o mapa para guiares o teu parceiro "cego" até ao destino.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Story & Senses': [
      {'nome': 'Destino Partilhado', 'tipo': 'narrativa', 'missao': 'Tomem uma decisão em conjunto que mudará o final da história.', 'progresso': 0.5, 'feitos': 1, 'total': 2},
      {'nome': 'Romeu e Julieta', 'tipo': 'mapa', 'missao': 'Começam em lados opostos da cidade. Encontrem-se no ponto central!', 'progresso': 0.8, 'feitos': 4, 'total': 5},
      {'nome': 'Prisma da Saudade', 'tipo': 'camara', 'missao': 'Capta a melancolia deste local usando o filtro "Saudade" (Azul).', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    // PACKS TEAM
    'Pack Map Clash': [
      {'nome': 'Domínio Bairro', 'tipo': 'mapa', 'missao': 'A vossa equipa tem de conquistar mais zonas que a equipa adversária!', 'progresso': 0.4, 'feitos': 2, 'total': 5},
      {'nome': 'Corrida Pistas Elite', 'tipo': 'narrativa', 'missao': 'Identifica o "Impostor" na tua equipa antes que acabe o tempo.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
      {'nome': 'Logística Grupo', 'tipo': 'quiz', 'missao': 'Distribui os recursos limitados pelos elementos da tua equipa.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
    ],
    'Pack Fest Vibes': [
      {'nome': 'S. João Challenge', 'tipo': 'quiz', 'missao': 'Qual a tradição mais antiga do São João? Responde rápido!', 'progresso': 0.0, 'feitos': 0, 'total': 10},
      {'nome': 'Aftermovie Coletivo', 'tipo': 'camara', 'missao': 'Grava 5 segundos de vídeo em Slow Motion com a tua equipa a saltar.', 'progresso': 0.2, 'feitos': 1, 'total': 5},
      {'nome': 'Tokens de Evento', 'tipo': 'mapa', 'missao': 'Caça aos Tokens dourados espalhados pelo recinto do festival.', 'progresso': 0.7, 'feitos': 7, 'total': 10},
    ],
    // ESPECIAIS
    "60' of Tourism": [
      {'nome': 'Contra-Relógio', 'tipo': 'mapa', 'missao': 'Tens 60 minutos para visitar os 5 marcos principais da cidade. Corre!', 'progresso': 0.2, 'feitos': 1, 'total': 5},
    ],
    'Quiet Edition (Porto)': [
      {'nome': 'Exploração ASMR', 'tipo': 'camara', 'missao': 'Grava o som ambiente silencioso nos Jardins do Palácio de Cristal.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
    ],
  };

  @override
  void initState() {
    super.initState();
    // Ao abrir a página, carregamos os jogos do pack que o turista escolheu!
    // Se por acaso houver um erro e o pack não existir, carrega um de reserva.
    _jogosAtuais = _baseDeDadosPacks[widget.nomePack] ?? _baseDeDadosPacks['Pack Heritage Hunt']!;
  }

  @override
  Widget build(BuildContext context) {
    final jogoAtual = _jogosAtuais[_jogoSelecionado];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        title: Text(
          widget.nomePack.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Stack(
        children: [
          // ==========================================
          // O "CÉREBRO": TROCA O FUNDO MEDIANTE O TIPO
          // ==========================================
          Positioned.fill(
            child: _construirModuloInterface(jogoAtual),
          ),

          // ==========================================
          // CARROSSEL DE SELEÇÃO (Fica sempre no topo)
          // ==========================================
          Positioned(
            top: 15, left: 0, right: 0,
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: _jogosAtuais.length,
                itemBuilder: (context, index) {
                  final jogo = _jogosAtuais[index];
                  bool isSelected = _jogoSelecionado == index;

                  return GestureDetector(
                    onTap: () => setState(() => _jogoSelecionado = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 200, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF121212).withOpacity(0.9) : Colors.black87.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? Colors.deepOrange : Colors.white10, width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.2), blurRadius: 10)] : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(jogo['nome'], style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Text("${jogo['feitos']}/${jogo['total']}", style: TextStyle(color: isSelected ? Colors.deepOrange : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: jogo['progresso'], backgroundColor: Colors.white10, color: isSelected ? Colors.deepOrange : Colors.grey, minHeight: 4)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função que decide que interface carregar
  Widget _construirModuloInterface(Map<String, dynamic> jogoAtual) {
    switch (jogoAtual['tipo']) {
      case 'mapa':
        return _buildModuloMapa(jogoAtual);
      case 'camara':
        return _buildModuloCamara(jogoAtual);
      case 'narrativa':
        return _buildModuloNarrativa(jogoAtual);
      case 'quiz':
        return _buildModuloQuiz(jogoAtual);
      default:
        return _buildModuloMapa(jogoAtual);
    }
  }

  // ==========================================
  // TEMPLATES DE INTERFACE (OS 4 MÓDULOS)
  // ==========================================

  // 1. MÓDULO MAPA (GPS e Navegação)
  Widget _buildModuloMapa(Map<String, dynamic> jogoAtual) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: _localizacaoObjetivo, initialZoom: 17.0),
          children: [
            TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
            MarkerLayer(markers: [
              Marker(point: _localizacaoJogador, width: 40, height: 40, child: Container(decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle), child: Center(child: Container(width: 15, height: 15, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))))),
              Marker(point: _localizacaoObjetivo, width: 50, height: 50, child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 50)),
            ]),
          ],
        ),
        Positioned(
          bottom: 20, left: 20, right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text("PONTO ATUAL", style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)), SizedBox(height: 4), Text("Ponto de Interesse", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)) ]),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: const Row(children: [ Icon(Icons.directions_walk, color: Colors.white54, size: 16), SizedBox(width: 5), Text("15m", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) ]))
                  ],
                ),
                const SizedBox(height: 15),
                Text(jogoAtual['missao'], style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 18), label: const Text("SCAN QR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                    const SizedBox(width: 15),
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.check, color: Colors.white, size: 18), label: const Text("CONCLUIR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. MÓDULO CÂMARA (Realidade Aumentada e Fotos)
  Widget _buildModuloCamara(Map<String, dynamic> jogoAtual) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.3, child: Image.network('https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80', fit: BoxFit.cover, height: double.infinity, width: double.infinity)),
          Container(
            width: 280, height: 400, decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.center_focus_weak, color: Colors.white54, size: 60),
                const SizedBox(height: 20),
                Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("Alinha a câmara...", style: TextStyle(color: Colors.white, fontSize: 12)))
              ],
            ),
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Column(
              children: [
                Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 5)])),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {},
                  child: Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: Colors.white24), child: Center(child: Container(width: 55, height: 55, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 3. MÓDULO NARRATIVA (Enigmas e História)
  Widget _buildModuloNarrativa(Map<String, dynamic> jogoAtual) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, color: Colors.deepOrange, size: 60),
          const SizedBox(height: 30),
          Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Opção A: Seguir a Pista da Esquerda", style: TextStyle(color: Colors.white, fontSize: 14))),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Opção B: Investigar o Símbolo", style: TextStyle(color: Colors.white, fontSize: 14))),
          ),
        ],
      ),
    );
  }

  // 4. MÓDULO QUIZ (Trivia e Afinidade)
  Widget _buildModuloQuiz(Map<String, dynamic> jogoAtual) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2E1A47), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter), // Fundo roxo místico
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
            child: Column(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 50),
                const SizedBox(height: 20),
                Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Eu!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 15),
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("O Parceiro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
            ],
          )
        ],
      ),
    );
  }
}