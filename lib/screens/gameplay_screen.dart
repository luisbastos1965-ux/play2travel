import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// IMPORTAÇÃO DE TODOS OS PACKS
import 'packs/pack_heritage_hunt.dart'; 
import 'packs/pack_urban_hero.dart'; 
import 'packs/pack_duo_bond.dart'; 
import 'packs/pack_story_senses.dart';
import 'packs/pack_map_clash.dart'; 
import 'packs/pack_fest_vibes.dart'; 
import 'packs/pack_60_tourism.dart'; 
import 'packs/pack_united_experiences.dart';
import 'packs/pack_quiet_edition.dart'; 

class GameplayScreen extends StatefulWidget {
  final String nomePack;

  // ✨ COFRE GLOBAL PARA GUARDAR OS PACKS GERADOS POR IA OU PERSONALIZADOS
  static Map<String, List<Map<String, dynamic>>> packsDinamicos = {};

  const GameplayScreen({super.key, required this.nomePack});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int _jogoSelecionado = 0;
  List<Map<String, dynamic>> _jogosAtuais = [];
  
  bool _modoEscolhido = false; 
  bool _todosAoMesmoTempo = true;

  final LatLng _localizacaoObjetivo = const LatLng(41.1458, -8.6139); 

  final Map<String, List<Map<String, dynamic>>> _baseDeDadosPacks = {
    'Pack Heritage Hunt': [
      {'nome': 'Radar de Curiosidade', 'tipo': 'mapa', 'missao': 'Encontra datas gravadas, brasões ou azulejos.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Bingo do Património', 'tipo': 'mapa', 'missao': 'Encontra os elementos da grelha.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'Câmara de Época', 'tipo': 'camara', 'missao': 'Cria uma foto inspirada em épocas históricas.', 'progresso': 0.0, 'feitos': 0, 'total': 12},
    ],
    'Pack Urban Hero': [
      {'nome': 'Diário do Explorador', 'tipo': 'narrativa', 'missao': 'Regista algo inesperado.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
      {'nome': 'Narrativa Episódica', 'tipo': 'narrativa', 'missao': 'Toma uma decisão para avançar.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Enigma do Mestre', 'tipo': 'narrativa', 'missao': 'Resolve o enigma usando pistas.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Duo Bond': [
      {'nome': 'Puzzle de Par', 'tipo': 'narrativa', 'missao': 'Comunica com o parceiro para juntar pistas.', 'progresso': 0.0, 'feitos': 0, 'total': 4},
      {'nome': 'Quiz de Afinidade', 'tipo': 'quiz', 'missao': 'O que escolheu o teu parceiro?', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'Bússola Humana', 'tipo': 'mapa', 'missao': 'Guia o teu parceiro até ao destino.', 'progresso': 0.0, 'feitos': 0, 'total': 6},
    ],
    'Pack Story & Senses': [
      {'nome': 'Destino Partilhado', 'tipo': 'narrativa', 'missao': 'Adiciona um elemento à vossa narrativa.', 'progresso': 0.0, 'feitos': 0, 'total': 7},
      {'nome': 'Missão Romeu e Julieta', 'tipo': 'mapa', 'missao': 'Cumpre a missão até ao reencontro.', 'progresso': 0.0, 'feitos': 0, 'total': 6},
      {'nome': 'Prisma da Saudade', 'tipo': 'quiz', 'missao': 'Que emoção associas a este lugar?', 'progresso': 0.0, 'feitos': 0, 'total': 5},
    ],
    'Pack Map Clash': [
      {'nome': 'Domínio de Bairro', 'tipo': 'especifico', 'missao': 'Conquista as freguesias do Porto.', 'progresso': 0.0, 'feitos': 0, 'total': 7},
      {'nome': 'Corrida de Elite', 'tipo': 'especifico', 'missao': 'Missões com sabotadores no grupo.', 'progresso': 0.0, 'feitos': 0, 'total': 7},
      {'nome': 'Logística de Grupo', 'tipo': 'especifico', 'missao': 'Coordenação e rapidez em 3 pontos.', 'progresso': 0.0, 'feitos': 0, 'total': 3},
    ],
    'Pack Fest Vibes': [
      {'nome': 'S. João Challenge', 'tipo': 'especifico', 'missao': 'A grande competição de S. João!', 'progresso': 0.0, 'feitos': 0, 'total': 3},
      {'nome': 'Aftermovie Coletivo', 'tipo': 'especifico', 'missao': 'Grava os melhores planos para o vosso filme.', 'progresso': 0.0, 'feitos': 0, 'total': 12},
      {'nome': 'Tokens de Evento', 'tipo': 'especifico', 'missao': 'Gere o orçamento da tua equipa.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
    ],
    'Quiet Edition (Rural)': [
      {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Quiet Edition': [
      {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Quiet Edition': [
      {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'United Experiences': [
      {'nome': 'United Experiences', 'tipo': 'especifico', 'missao': 'Gerações Unidas pelo Jogo.', 'progresso': 0.0, 'feitos': 0, 'total': 10},
    ],
    'Pack United Experiences': [
      {'nome': 'United Experiences', 'tipo': 'especifico', 'missao': 'Gerações Unidas pelo Jogo.', 'progresso': 0.0, 'feitos': 0, 'total': 10},
    ],
    'Pack Especiais': [
      {'nome': "60' of Tourism", 'tipo': 'especifico', 'missao': 'Desbloqueia os 5 Sentidos em apenas 1 hora.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'United Experiences', 'tipo': 'especifico', 'missao': 'Gerações Unidas pelo Jogo.', 'progresso': 0.0, 'feitos': 0, 'total': 10},
      {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    'Pack Especial': [
      {'nome': "60' of Tourism", 'tipo': 'especifico', 'missao': 'Desbloqueia os 5 Sentidos em apenas 1 hora.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
      {'nome': 'United Experiences', 'tipo': 'especifico', 'missao': 'Gerações Unidas pelo Jogo.', 'progresso': 0.0, 'feitos': 0, 'total': 10},
      {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1},
    ],
    "60' of Tourism": [
      {'nome': "60' of Tourism", 'tipo': 'especifico', 'missao': 'Desbloqueia os 5 Sentidos em apenas 1 hora.', 'progresso': 0.0, 'feitos': 0, 'total': 5},
    ],
  };

  @override
  void initState() {
    super.initState();
    
    // ✨ PRIMEIRO VERIFICA SE O PACK FOI GERADO DINAMICAMENTE (Random/Personalizado)
    if (GameplayScreen.packsDinamicos.containsKey(widget.nomePack)) {
      _jogosAtuais = GameplayScreen.packsDinamicos[widget.nomePack]!;
    } else {
      // SE NÃO, PROCURA NA BASE DE DADOS FIXA
      _jogosAtuais = _baseDeDadosPacks[widget.nomePack] ?? _baseDeDadosPacks['Pack Heritage Hunt']!;
    }

    List<String> packsEspeciais = ['Pack Especiais', 'Pack Especial', "60' of Tourism", 'United Experiences', 'Pack United Experiences', 'Quiet Edition', 'Pack Quiet Edition', 'Quiet Edition (Rural)'];
    
    // Packs especiais saltam a pergunta do modo de jogo
    if (packsEspeciais.contains(widget.nomePack)) {
      _modoEscolhido = true;
      _todosAoMesmoTempo = false;
    }
  }

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

            _cardModo("Modo Focado", "Joga um desafio de cada vez.", Icons.looks_one, Colors.blueAccent, false),
            const SizedBox(height: 20),
            _cardModo("Modo Livre", "Alterna livremente entre os jogos.", Icons.dashboard_customize, Colors.deepOrange, true),
          ],
        ),
      ),
    );
  }

  Widget _cardModo(String t, String d, IconData i, Color c, bool livre) {
    return GestureDetector(
      onTap: () => setState(() { _todosAoMesmoTempo = livre; _modoEscolhido = true; }),
      child: Container(
        padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
        child: Row(children: [Icon(i, color: c, size: 40), const SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text(d, style: const TextStyle(color: Colors.white54, fontSize: 13))]))]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_modoEscolhido) return _buildEcraSelecaoModo();

    if (widget.nomePack == 'Pack Map Clash' && !_todosAoMesmoTempo) {
        return const Scaffold(backgroundColor: Color(0xFF0A0A0A), body: MapClashHub());
    }

    final jogoAtual = _jogosAtuais[_jogoSelecionado];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212), elevation: 0, iconTheme: const IconThemeData(color: Colors.deepOrange),
        title: Text(widget.nomePack.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
      body: Column(
        children: [
          if (_todosAoMesmoTempo && _jogosAtuais.length > 1)
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
                      duration: const Duration(milliseconds: 300), width: 180, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: isSelected ? const Color(0xFF1E1E1E) : Colors.black87, borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? Colors.deepOrange : Colors.white10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(jogo['nome'], style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, maxLines: 1),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: jogo['progresso'] ?? 0.0, backgroundColor: Colors.white10, color: Colors.deepOrange, minHeight: 3),
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
      
      // APENAS O BOTÃO DE PRÓXIMO JOGO SE FOR SEQUENCIAL
      floatingActionButton: !_todosAoMesmoTempo && _jogoSelecionado < _jogosAtuais.length - 1
          ? FloatingActionButton.extended(onPressed: () => setState(() => _jogoSelecionado++), backgroundColor: Colors.deepOrange, icon: const Icon(Icons.arrow_forward), label: const Text("Próximo Jogo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
          : null,
    );
  }

  Widget _construirModuloInterface(Map<String, dynamic> jogoAtual) {
    String nome = jogoAtual['nome'];

    // O sistema inteligente lê a string e chama a interface correspondente!
    if (nome == 'Radar de Curiosidade') return const RadarCuriosidades();
    if (nome == 'Bingo do Património') return const BingoPatrimonio();
    if (nome == 'Câmara de Época') return const CamaraDeEpoca();
    if (nome == 'Diário do Explorador') return const DiarioExplorador();
    if (nome == 'Narrativa Episódica') return const NarrativaEpisodica();
    if (nome == 'Enigma do Mestre') return const EnigmaMestre();
    if (nome == 'Puzzle de Par') return const PuzzleDePar();
    if (nome == 'Quiz de Afinidade') return const QuizAfinidade();
    if (nome == 'Bússola Humana') return const BussolaHumana();
    if (nome == 'Destino Partilhado') return const DestinoPartilhado();
    if (nome == 'Missão Romeu e Julieta') return const MissaoRomeuJulieta();
    if (nome == 'Prisma da Saudade') return const PrismaDaSaudade();
    if (nome == 'Domínio de Bairro') return const DominioDeBairro();
    if (nome == 'Corrida de Elite') return const CorridaPistasElite();
    if (nome == 'Logística de Grupo') return const LogisticaDeGrupo();
    if (nome == 'S. João Challenge') return const SJoaoChallenge();
    if (nome == 'Aftermovie Coletivo') return const AftermovieColetivo();
    if (nome == 'Tokens de Evento') return const TokensDeEvento();
    if (nome == "60' of Tourism") return const SessentaMinutosTurismo();
    if (nome == 'United Experiences') return const UnitedExperiences();
    if (nome == 'Quiet Edition') return const QuietEdition();

    switch (jogoAtual['tipo']) {
      case 'mapa': return _buildModuloMapa(jogoAtual);
      case 'camara': return _buildModuloCamara(jogoAtual);
      default: return _buildModuloMapa(jogoAtual);
    }
  }

  Widget _buildModuloMapa(Map<String, dynamic> jogo) {
    return Stack(children: [
      FlutterMap(options: const MapOptions(initialCenter: LatLng(41.1458, -8.6139), initialZoom: 17), children: [
        TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
        MarkerLayer(markers: [Marker(point: _localizacaoObjetivo, width: 50, height: 50, child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 50))])
      ]),
      Positioned(bottom: 20, left: 20, right: 20, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(20)), child: Text(jogo['missao'] ?? "", style: const TextStyle(color: Colors.white70))))
    ]);
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
                const Icon(Icons.videocam, color: Colors.white54, size: 60), const SizedBox(height: 20),
                Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("Prepara a câmara...", style: TextStyle(color: Colors.white, fontSize: 12)))
              ],
            ),
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Column(
              children: [
                Text(jogoAtual['missao'] ?? "", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 30),
                GestureDetector(onTap: () {}, child: Container(width: 70, height: 70, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: Colors.white24), child: Center(child: Container(width: 55, height: 55, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))))),
              ],
            ),
          )
        ],
      ),
    );
  }
}