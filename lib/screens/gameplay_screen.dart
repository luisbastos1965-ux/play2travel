import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ✨ IMPORTAÇÃO DOS JOGOS DOS PACKS ✨
import 'packs/pack_heritage_hunt.dart'; 
import 'packs/pack_urban_hero.dart'; 
import 'packs/pack_duo_bond.dart'; 
import 'packs/pack_story_senses.dart'; 

class GameplayScreen extends StatefulWidget {
  final String nomePack;

  const GameplayScreen({super.key, required this.nomePack});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int _jogoSelecionado = 0;
  List<Map<String, dynamic>> _jogosAtuais = [];
  
  bool _modoEscolhido = false; 
  bool _todosAoMesmoTempo = true;

  final LatLng _localizacaoJogador = const LatLng(41.1450, -8.6140);
  final LatLng _localizacaoObjetivo = const LatLng(41.1458, -8.6139); 

  // ==========================================
  // O GRANDE DICIONÁRIO DE PACKS E JOGOS
  // ==========================================
  final Map<String, List<Map<String, dynamic>>> _baseDeDadosPacks = {
    'Pack Heritage Hunt': [
      {'nome': 'Radar de Curiosidade', 'tipo': 'mapa', 'missao': 'Encontra datas gravadas, brasões ou azulejos específicos.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Bingo do Património', 'tipo': 'mapa', 'missao': 'Encontra os elementos da grelha (igreja, ponte, estátua...).', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'Câmara de Época', 'tipo': 'camara', 'missao': 'Cria uma foto inspirada em épocas históricas da cidade.', 'progresso': 0.0, 'feitos': 0, 'total': 12},
    ],
    'Pack Urban Hero': [
      {'nome': 'Diário do Explorador', 'tipo': 'narrativa', 'missao': 'Regista algo inesperado e descreve este local.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
      {'nome': 'Narrativa Episódica', 'tipo': 'narrativa', 'missao': 'Toma uma decisão para avançar na história deste local.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Enigma do Mestre', 'tipo': 'narrativa', 'missao': 'Resolve o enigma usando as pistas espalhadas.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Duo Bond': [
      {'nome': 'Puzzle de Par', 'tipo': 'narrativa', 'missao': 'Comunica com o teu parceiro para juntar as metades das pistas.', 'progresso': 0.0, 'feitos': 0, 'total': 4},
      {'nome': 'Quiz de Afinidade', 'tipo': 'quiz', 'missao': 'Responde sobre as tuas preferências. O que escolheu o parceiro?', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'Bússola Humana', 'tipo': 'mapa', 'missao': 'Guia o teu parceiro até ao destino usando estas instruções.', 'progresso': 0.0, 'feitos': 0, 'total': 6},
    ],
    'Pack Story & Senses': [
      {'nome': 'Destino Partilhado', 'tipo': 'narrativa', 'missao': 'Adiciona um elemento à vossa narrativa conjunta neste local.', 'progresso': 0.0, 'feitos': 0, 'total': 7},
      {'nome': 'Missão Romeu e Julieta', 'tipo': 'mapa', 'missao': 'Cumpre a tua missão separadamente até ao ponto de reencontro.', 'progresso': 0.0, 'feitos': 0, 'total': 6},
      {'nome': 'Prisma da Saudade', 'tipo': 'quiz', 'missao': 'Que emoção, som ou cheiro associas a este lugar?', 'progresso': 0.0, 'feitos': 0, 'total': 5}, // Atualizado o total para 5 locais
    ],
    'Pack Map Clash': [
      {'nome': 'Domínio de Bairro', 'tipo': 'mapa', 'missao': 'Completa a tarefa rápida para conquistar esta zona!', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Corrida de Elite', 'tipo': 'mapa', 'missao': 'Segue a pista até ao próximo local estratégico.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'Logística de Grupo', 'tipo': 'narrativa', 'missao': 'Coordena a tua tarefa específica com o resto da equipa.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Fest Vibes': [
      {'nome': 'S. João Challenge', 'tipo': 'quiz', 'missao': 'Dá uma martelada simbólica e encontra a sardinha!', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Aftermovie Coletivo', 'tipo': 'camara', 'missao': 'Grava um pequeno clip da equipa neste momento da exploração.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
      {'nome': 'Tokens de Evento', 'tipo': 'mapa', 'missao': 'Procura os tokens digitais espalhados pela cidade.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
    ],
  };

  @override
  void initState() {
    super.initState();
    _jogosAtuais = _baseDeDadosPacks[widget.nomePack] ?? _baseDeDadosPacks['Pack Heritage Hunt']!;
  }

  // ==========================================
  // O ECRÃ DE SELEÇÃO INICIAL
  // ==========================================
  Widget _buildEcraSelecaoModo() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.deepOrange)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.explore, color: Colors.deepOrange, size: 60), const SizedBox(height: 20),
            const Text("Como queres explorar?", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2)), const SizedBox(height: 10),
            const Text("Escolhe a tua dinâmica de jogo para este pack.", style: TextStyle(color: Colors.white54, fontSize: 16)), const SizedBox(height: 50),

            GestureDetector(
              onTap: () => setState(() { _todosAoMesmoTempo = false; _modoEscolhido = true; }),
              child: Container(
                padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                child: const Row(children: [Icon(Icons.looks_one, color: Colors.blueAccent, size: 40), SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Modo Focado", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 5), Text("Joga um desafio de cada vez. Só avanças quando concluíres o atual.", style: TextStyle(color: Colors.white54, fontSize: 13))]))]),
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => setState(() { _todosAoMesmoTempo = true; _modoEscolhido = true; }),
              child: Container(
                padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                child: const Row(children: [Icon(Icons.dashboard_customize, color: Colors.deepOrange, size: 40), SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Modo Livre", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 5), Text("Alterna livremente entre os jogos do pack através do menu superior.", style: TextStyle(color: Colors.white54, fontSize: 13))]))]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // O ECRÃ DE JOGO PRINCIPAL
  // ==========================================
  @override
  Widget build(BuildContext context) {
    if (!_modoEscolhido) return _buildEcraSelecaoModo();

    final jogoAtual = _jogosAtuais[_jogoSelecionado];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212), elevation: 0, iconTheme: const IconThemeData(color: Colors.deepOrange),
        title: Text(_todosAoMesmoTempo ? widget.nomePack.toUpperCase() : "${widget.nomePack.toUpperCase()} (${_jogoSelecionado + 1}/${_jogosAtuais.length})", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
      body: Column(
        children: [
          if (_todosAoMesmoTempo)
            Container(
              height: 100, padding: const EdgeInsets.only(top: 15, bottom: 5), color: const Color(0xFF121212),
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: _jogosAtuais.length,
                itemBuilder: (context, index) {
                  final jogo = _jogosAtuais[index];
                  bool isSelected = _jogoSelecionado == index;

                  return GestureDetector(
                    onTap: () => setState(() => _jogoSelecionado = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), width: 200, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: isSelected ? const Color(0xFF1E1E1E) : Colors.black87, borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? Colors.deepOrange : Colors.white10, width: isSelected ? 2 : 1), boxShadow: isSelected ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.2), blurRadius: 10)] : []),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(jogo['nome'], style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)), Text("${jogo['feitos']}/${jogo['total']}", style: TextStyle(color: isSelected ? Colors.deepOrange : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold))]),
                          const SizedBox(height: 10), ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: jogo['progresso'], backgroundColor: Colors.white10, color: isSelected ? Colors.deepOrange : Colors.grey, minHeight: 4)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          
          Expanded(child: _construirModuloInterface(jogoAtual)),
        ],
      ),
      
      floatingActionButton: !_todosAoMesmoTempo && _jogoSelecionado < _jogosAtuais.length - 1
          ? FloatingActionButton.extended(onPressed: () => setState(() => _jogoSelecionado++), backgroundColor: Colors.deepOrange, icon: const Icon(Icons.arrow_forward, color: Colors.white), label: const Text("Próximo Jogo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
          : null,
    );
  }

  // ==========================================
  // O "CÉREBRO": DECIDE QUE INTERFACE CARREGAR
  // ==========================================
  Widget _construirModuloInterface(Map<String, dynamic> jogoAtual) {
    
    // PACK HERITAGE HUNT
    if (jogoAtual['nome'] == 'Radar de Curiosidade') {
      return const RadarCuriosidades(); 
    } else if (jogoAtual['nome'] == 'Bingo do Património') {
      return const BingoPatrimonio(); 
    } else if (jogoAtual['nome'] == 'Câmara de Época') {
      return const CamaraDeEpoca(); 
    } 
    
    // PACK URBAN HERO
    else if (jogoAtual['nome'] == 'Diário do Explorador') {
      return const DiarioExplorador(); 
    } else if (jogoAtual['nome'] == 'Narrativa Episódica') {
      return const NarrativaEpisodica(); 
    } else if (jogoAtual['nome'] == 'Enigma do Mestre') {
      return const EnigmaMestre(); 
    }

    // PACK DUO BOND
    else if (jogoAtual['nome'] == 'Puzzle de Par') {
      return const PuzzleDePar(); 
    } else if (jogoAtual['nome'] == 'Quiz de Afinidade') {
      return const QuizAfinidade(); 
    } else if (jogoAtual['nome'] == 'Bússola Humana') {
      return const BussolaHumana(); 
    }

    // PACK STORY & SENSES
    else if (jogoAtual['nome'] == 'Destino Partilhado') {
      return const DestinoPartilhado(); 
    } else if (jogoAtual['nome'] == 'Missão Romeu e Julieta') {
      return const MissaoRomeuJulieta(); 
    } 
    // ✨ LIGAÇÃO AO PRISMA DA SAUDADE ✨
    else if (jogoAtual['nome'] == 'Prisma da Saudade') {
      return const PrismaDaSaudade(); 
    }

    // Templates antigos (backups)
    switch (jogoAtual['tipo']) {
      case 'mapa': return _buildModuloMapa(jogoAtual);
      case 'camara': return _buildModuloCamara(jogoAtual);
      case 'narrativa': return _buildModuloNarrativa(jogoAtual);
      case 'quiz': return _buildModuloQuiz(jogoAtual);
      default: return _buildModuloMapa(jogoAtual);
    }
  }

  // ==========================================
  // TEMPLATES DE INTERFACE (BACKUPS INTACTOS)
  // ==========================================
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
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))]),
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
                const Icon(Icons.center_focus_weak, color: Colors.white54, size: 60), const SizedBox(height: 20),
                Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("Alinha a câmara...", style: TextStyle(color: Colors.white, fontSize: 12)))
              ],
            ),
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Column(
              children: [
                Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 5)])), const SizedBox(height: 30),
                GestureDetector(onTap: () {}, child: Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: Colors.white24), child: Center(child: Container(width: 55, height: 55, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModuloNarrativa(Map<String, dynamic> jogoAtual) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, color: Colors.deepOrange, size: 60), const SizedBox(height: 30),
          Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Opção A: Seguir a Pista da Esquerda", style: TextStyle(color: Colors.white, fontSize: 14)))), const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Opção B: Investigar o Símbolo", style: TextStyle(color: Colors.white, fontSize: 14)))),
        ],
      ),
    );
  }

  Widget _buildModuloQuiz(Map<String, dynamic> jogoAtual) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2E1A47), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
            child: Column(children: [const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 50), const SizedBox(height: 20), Text(jogoAtual['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4))]),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Eu!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))), const SizedBox(width: 15),
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("O Parceiro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
            ],
          )
        ],
      ),
    );
  }
}