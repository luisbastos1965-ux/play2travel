import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'package:mobile_scanner/mobile_scanner.dart'; 
import '../app_settings.dart'; 
import 'code_validation_screen.dart'; 

class HomeScreen extends StatefulWidget {
  final String username;
  final String cargo;
  const HomeScreen({super.key, required this.username, required this.cargo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 2; // O índice 2 corresponde à aba "Jogar"
  
  // Lista para guardar os packs que o utilizador já descarregou para modo Offline
  List<String> _packsDescarregadosOffline = [];

  // ==========================================
  // 1. VARIÁVEIS E DADOS DO MENU JOGAR
  // ==========================================
  bool _iniciouDareToPlay = false;
  String? continenteSel, paisSel, cidadeSel, modoJogadoresSel, packSel;

  final Map<String, LatLng> _continentesCoords = {
    "América do Norte": const LatLng(45.0, -100.0),
    "América do Sul": const LatLng(-15.0, -60.0),
    "Europa": const LatLng(50.0, 15.0),
    "África": const LatLng(5.0, 20.0),
    "Ásia": const LatLng(45.0, 90.0),
    "Oceânia": const LatLng(-25.0, 140.0),
  };
  final Map<String, String> _abrevContinentes = {
    "América do Norte": "A. Norte", "América do Sul": "A. Sul", "Europa": "Europa", 
    "África": "África", "Ásia": "Ásia", "Oceânia": "Oceânia",
  };

  final Map<String, List<String>> _paises = {
    "Europa": ["Portugal", "Espanha", "França", "Itália", "Alemanha", "Reino Unido"],
    "América do Norte": ["Estados Unidos", "Canadá", "México"],
    "América do Sul": ["Brasil", "Argentina", "Colômbia", "Peru"],
    "Ásia": ["Japão", "China", "Índia", "Tailândia", "Emirados Árabes Unidos"],
    "África": ["África do Sul", "Egipto", "Marrocos", "Quénia"],
    "Oceânia": ["Austrália", "Nova Zelândia"],
  };
  final Map<String, String> _bandeiras = {
    "Portugal": "🇵🇹", "Espanha": "🇪🇸", "França": "🇫🇷", "Itália": "🇮🇹", "Alemanha": "🇩🇪", "Reino Unido": "🇬🇧",
    "Estados Unidos": "🇺🇸", "Canadá": "🇨🇦", "México": "🇲🇽", "Brasil": "🇧🇷", "Argentina": "🇦🇷", 
    "Colômbia": "🇨🇴", "Peru": "🇵🇪", "Japão": "🇯🇵", "China": "🇨🇳", "Índia": "🇮🇳", "Tailândia": "🇹🇭", "Emirados Árabes Unidos": "🇦🇪",
    "África do Sul": "🇿🇦", "Egipto": "🇪🇬", "Marrocos": "🇲🇦", "Quénia": "🇰🇪", "Austrália": "🇦🇺", "Nova Zelândia": "🇳🇿"
  };
  final Map<String, List<String>> _cidades = {
    "Portugal": ["Porto", "Lisboa", "Braga", "Coimbra", "Faro"],
    "Espanha": ["Madrid", "Barcelona", "Sevilha", "Valência", "Bilbau"],
    "França": ["Paris", "Lyon", "Marselha", "Nice", "Bordéus"],
    "Estados Unidos": ["Nova Iorque", "Los Angeles", "Chicago", "Miami", "São Francisco"],
    "Brasil": ["Rio de Janeiro", "São Paulo", "Salvador", "Florianópolis", "Brasília"],
    "Japão": ["Tóquio", "Quioto", "Osaka", "Hiroshima", "Sapporo"],
  };

  List<Map<String, dynamic>> _obterPacks() {
    List<Map<String, dynamic>> packs = [];
    if (modoJogadoresSel == "Solo") {
      packs.add({'nome': 'Pack Heritage Hunt', 'tipo': 'Regular', 'jogos': '1. Radar Curiosidades\n2. Bingo Património\n3. Câmara de Época', 'tempo': '08:00 horas', 'preco': '20€', 'tamanho': '45 MB'});
      packs.add({'nome': 'Pack Urban Hero', 'tipo': 'Regular', 'jogos': '1. Diário Explorador\n2. Narrativa Episódica\n3. Enigma do Mestre', 'tempo': '10:00 horas', 'preco': '20€', 'tamanho': '38 MB'});
    } else if (modoJogadoresSel == "Duo") {
      packs.add({'nome': 'Pack Duo Bond', 'tipo': 'Regular', 'jogos': '1. Puzzle de Par\n2. Quiz Afinidade\n3. Bússola Humana', 'tempo': '06:00 horas', 'preco': '30€', 'tamanho': '25 MB'});
      packs.add({'nome': 'Pack Story & Senses', 'tipo': 'Regular', 'jogos': '1. Destino Partilhado\n2. Missão Romeu e Julieta\n3. Prisma da Saudade', 'tempo': '07:00 horas', 'preco': '40€', 'tamanho': '55 MB'});
    } else if (modoJogadoresSel == "Team") {
      packs.add({'nome': 'Pack Map Clash', 'tipo': 'Regular', 'jogos': '1. Domínio Bairro\n2. Corrida Pistas Elite\n3. Logística Grupo', 'tempo': '16:00 horas', 'preco': '90€', 'tamanho': '80 MB'});
      packs.add({'nome': 'Pack Fest Vibes', 'tipo': 'Regular', 'jogos': '1. S. João Challenge\n2. Aftermovie Coletivo\n3. Tokens de Evento', 'tempo': '2 dias', 'preco': '90€', 'tamanho': '120 MB'});
    } else if (modoJogadoresSel == "Especiais") {
      packs.add({'nome': "60' of Tourism", 'tipo': 'Especial', 'jogos': 'Contra-relógio pelos marcos principais. Ideal para visitas rápidas.', 'tempo': '01:00 hora', 'preco': '15€', 'tamanho': '12 MB'});
      packs.add({'nome': 'Pack United Experiences', 'tipo': 'Especial', 'jogos': 'Experiência imersiva e multicultural única.', 'tempo': 'Sem limite', 'preco': '10€', 'tamanho': '40 MB'});
      if (cidadeSel == "Porto") {
        packs.add({'nome': 'Quiet Edition (Porto)', 'tipo': 'Regional', 'jogos': 'Exploração ASMR por Museus, Parques e Bibliotecas.', 'tempo': 'Sem limite', 'preco': '10€', 'tamanho': '65 MB (Áudio HQ)'});
      }
    }
    return packs;
  }

  // ==========================================
  // 2. VARIÁVEIS E DADOS DOS RANKINGS
  // ==========================================
  String _rankCategoria = 'Pontos'; 
  String _rankLocalizacao = 'Global'; 

  final List<Map<String, dynamic>> _rankingGlobal = [
    {'nome': 'Kenji Sato', 'pais': '🇯🇵', 'pontos': 25420, 'packs': 82, 'img': 'https://randomuser.me/api/portraits/men/32.jpg'},
    {'nome': 'Emma Watson', 'pais': '🇬🇧', 'pontos': 24100, 'packs': 78, 'img': 'https://randomuser.me/api/portraits/women/44.jpg'},
    {'nome': 'John Smith', 'pais': '🇺🇸', 'pontos': 23850, 'packs': 75, 'img': 'https://randomuser.me/api/portraits/men/45.jpg'},
    {'nome': 'Chen Wei', 'pais': '🇨🇳', 'pontos': 22100, 'packs': 70, 'img': 'https://randomuser.me/api/portraits/men/67.jpg'},
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 21800, 'packs': 68, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'}, 
    {'nome': 'Ana Garcia', 'pais': '🇪🇸', 'pontos': 20500, 'packs': 65, 'img': 'https://randomuser.me/api/portraits/women/24.jpg'},
    {'nome': 'Luigi Rossi', 'pais': '🇮🇹', 'pontos': 19900, 'packs': 61, 'img': 'https://randomuser.me/api/portraits/men/22.jpg'},
  ];
  final List<Map<String, dynamic>> _rankingNacional = [
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 21800, 'packs': 68, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'nome': 'Maria Santos', 'pais': '🇵🇹', 'pontos': 18200, 'packs': 55, 'img': 'https://randomuser.me/api/portraits/women/68.jpg'},
    {'nome': 'Hans Müller', 'pais': '🇩🇪', 'pontos': 17500, 'packs': 52, 'img': 'https://randomuser.me/api/portraits/men/70.jpg'}, 
    {'nome': 'João Costa', 'pais': '🇵🇹', 'pontos': 16400, 'packs': 48, 'img': 'https://randomuser.me/api/portraits/men/85.jpg'},
    {'nome': 'Sarah Lee', 'pais': '🇺🇸', 'pontos': 15100, 'packs': 45, 'img': 'https://randomuser.me/api/portraits/women/33.jpg'},
  ];
  final List<Map<String, dynamic>> _rankingLocal = [
    {'nome': 'Hans Müller', 'pais': '🇩🇪', 'pontos': 17500, 'packs': 52, 'img': 'https://randomuser.me/api/portraits/men/70.jpg'}, 
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 16800, 'packs': 50, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'nome': 'Sarah Lee', 'pais': '🇺🇸', 'pontos': 15100, 'packs': 45, 'img': 'https://randomuser.me/api/portraits/women/33.jpg'},
    {'nome': 'Inês Faria', 'pais': '🇵🇹', 'pontos': 12100, 'packs': 33, 'img': 'https://randomuser.me/api/portraits/women/19.jpg'},
  ];

  // ==========================================
  // 3. VARIÁVEIS DA REDE SOCIAL
  // ==========================================
  bool _mostrarGrupos = false;

  final List<Map<String, dynamic>> _pedidosPendentes = [
    {'nome': 'João Silva', 'user': '@joaos', 'img': 'https://randomuser.me/api/portraits/men/15.jpg'},
    {'nome': 'Sofia Costa', 'user': '@sofiac', 'img': 'https://randomuser.me/api/portraits/women/12.jpg'},
  ];

  final List<Map<String, dynamic>> _listaAmigos = [
    {'nome': 'Lourenço', 'user': '@lourenco', 'nivel': 0, 'isOnline': true, 'status': 'A jogar: Pack Histórico', 'img': 'https://randomuser.me/api/portraits/men/22.jpg'},
    {'nome': 'Maria', 'user': '@maria', 'nivel': 0, 'isOnline': false, 'status': 'Visto há 2h', 'img': 'https://randomuser.me/api/portraits/women/24.jpg'},
    {'nome': 'Nádia', 'user': '@nadiam', 'nivel': 0, 'isOnline': true, 'status': 'A explorar a Ribeira', 'img': 'https://randomuser.me/api/portraits/women/31.jpg'},
    {'nome': 'Paula', 'user': '@paula', 'nivel': 0, 'isOnline': true, 'status': 'No Menu Principal', 'img': 'https://randomuser.me/api/portraits/women/42.jpg'},
    {'nome': 'Membro do Júri 1', 'user': '@juri1', 'nivel': 0, 'isOnline': false, 'status': 'Visto ontem', 'img': 'https://randomuser.me/api/portraits/men/50.jpg'},
    {'nome': 'Membro do Júri 2', 'user': '@juri2', 'nivel': 0, 'isOnline': false, 'status': 'Visto há 5h', 'img': 'https://randomuser.me/api/portraits/women/51.jpg'},
    {'nome': 'Membro do Júri 3', 'user': '@juri3', 'nivel': 0, 'isOnline': true, 'status': 'A planear viagem...', 'img': 'https://randomuser.me/api/portraits/men/52.jpg'},
  ];

  final List<Map<String, dynamic>> _listaGrupos = [
    {'nome': 'Turismo', 'membros': 12, 'img': 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=200&q=80', 'status': 'A jogar: Defesa de PAP'},
    {'nome': 'Turma da Profitecla', 'membros': 14, 'img': 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=200&q=80', 'status': 'A planear próxima viagem...'},
    {'nome': 'Os Aventureiros', 'membros': 4, 'img': 'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?w=200&q=80', 'status': 'A jogar: Pack Fest Vibes'},
  ];

  final List<Map<String, dynamic>> _todosPacksInfo = [
    {"nome": "Pack Heritage Hunt", "icon": Icons.account_balance},
    {"nome": "Pack Urban Hero", "icon": Icons.location_city},
    {"nome": "Pack Duo Bond", "icon": Icons.people},
    {"nome": "Pack Story & Senses", "icon": Icons.menu_book},
    {"nome": "Pack Map Clash", "icon": Icons.map},
    {"nome": "Pack Fest Vibes", "icon": Icons.festival},
    {"nome": "60' of Tourism", "icon": Icons.timer},
    {"nome": "United Experiences", "icon": Icons.public},
    {"nome": "Quiet Edition (Porto)", "icon": Icons.headphones},
  ];

  // ==========================================
  // 4. VARIÁVEIS DO NOVO "MURAL DOS EXPLORADORES"
  // ==========================================
  bool _verMapaMural = false;
  String _filtroAtual = 'Todos';
  final List<String> _filtrosMural = ['Todos', 'Fest Vibes', 'Duo Bond', 'Quiet Edition', 'Urban Hero'];

  final List<Map<String, dynamic>> _expedicoesAtivas = [
    {'equipa': 'Os Aventureiros', 'pack': 'Fest Vibes', 'distancia': 'a 200m', 'cor': Colors.purple},
    {'equipa': 'Turma Profitecla', 'pack': 'Map Clash', 'distancia': 'a 1.2km', 'cor': Colors.blueAccent},
    {'equipa': 'Nádia', 'pack': 'Quiet Edition', 'distancia': 'a 50m', 'cor': Colors.teal},
  ];

  final Map<String, dynamic> _postalDeOuro = {
    'user': 'Júri 3', 'userImg': 'https://randomuser.me/api/portraits/men/52.jpg',
    'local': 'Jardim do Morro, Gaia 🇵🇹', 'pack': 'Pack Duo Bond',
    'coords': const LatLng(41.1378, -8.6094),
    'img': 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=600&q=80',
    'boosts': 891, 'xp_ganho': 100, 
    'caption': 'Bússola Humana concluída ao pôr do sol. Sincronia perfeita na equipa! 🌉🧭',
    'isBoosted': true, 'carimboColor': Colors.blue, 'isSpoiler': false, 'isRevealed': true,
  };

  final List<Map<String, dynamic>> _postais = [
    {
      'user': 'Lourenço', 'userImg': 'https://randomuser.me/api/portraits/men/22.jpg',
      'local': 'Ribeira, Porto 🇵🇹', 'pack': 'Pack Fest Vibes',
      'coords': const LatLng(41.1403, -8.6116),
      'img': 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80',
      'boosts': 34, 'xp_ganho': 50, 
      'caption': 'Missão fotográfica concluída! Os segredos das ruelas da Ribeira foram desvendados. 🕵️‍♀️🍷',
      'isBoosted': false, 'carimboColor': Colors.purple, 'isSpoiler': false, 'isRevealed': true,
    },
    {
      'user': 'Nádia', 'userImg': 'https://randomuser.me/api/portraits/women/31.jpg',
      'local': 'Livraria Lello, Porto 🇵🇹', 'pack': 'Quiet Edition',
      'coords': const LatLng(41.1469, -8.6148),
      'img': 'https://images.unsplash.com/photo-1620311497232-613d9865f3bc?w=600&q=80',
      'boosts': 89, 'xp_ganho': 75, 
      'caption': 'Missão ASMR concluída. Encontrei a resposta secreta por trás da estante central! 🤫📚',
      'isBoosted': false, 'carimboColor': Colors.teal, 
      'isSpoiler': true, 
      'isRevealed': false,
    },
  ];

  // ==========================================
  // 5. VARIÁVEIS E DADOS DO PERFIL
  // ==========================================
  bool _mostrarTodosPassaportes = false;
  final List<Map<String, String>> _listaPassaportes = [
    {'cidade': 'Paris', 'img': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=300&q=80'},
    {'cidade': 'Nova Iorque', 'img': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=300&q=80'},
    {'cidade': 'Tóquio', 'img': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300&q=80'},
    {'cidade': 'Roma', 'img': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=300&q=80'},
    {'cidade': 'Londres', 'img': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=300&q=80'},
    {'cidade': 'Rio', 'img': 'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?w=300&q=80'},
  ];
  final List<Map<String, dynamic>> _listaBadges = [
    {'nome': 'Mochileiro', 'icone': Icons.backpack}, 
    {'nome': 'Cidadão Mundo', 'icone': Icons.public}, 
    {'nome': 'Guia Local', 'icone': Icons.map}, 
    {'nome': 'Fotógrafo', 'icone': Icons.camera_alt}
  ];

  // ==========================================
  // MÉTODOS DO JOGAR (ABA 3) - COM MODO OFFLINE
  // ==========================================
  Widget _menuJogar() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;

    if (!_iniciouDareToPlay) {
      return Center(
        child: ElevatedButton(
          onPressed: () => setState(() => _iniciouDareToPlay = true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          child: const Text("DARE TO PLAY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text("CONFIGURAR VIAGEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)), IconButton(icon: const Icon(Icons.refresh, color: Colors.grey), onPressed: () => setState(() { _iniciouDareToPlay = false; continenteSel = null; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; })) ]),
          const SizedBox(height: 30),
          Text("1. Continente", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)),
          const SizedBox(height: 10),
          _buildMapaContinentes(),
          if (continenteSel != null) ...[ const SizedBox(height: 25), Text("2. País", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)), const SizedBox(height: 10), _buildCarrosselPaises(_paises[continenteSel] ?? []) ],
          if (paisSel != null) ...[ const SizedBox(height: 20), _buildDropdown("3. Cidade", _cidades[paisSel] ?? [], cidadeSel, (v) => setState(() { cidadeSel = v; modoJogadoresSel = null; packSel = null; })) ],
          if (cidadeSel != null) ...[ const SizedBox(height: 25), Text("4. Jogadores", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)), const SizedBox(height: 10), _buildBotoesModoJogo() ],
          if (modoJogadoresSel != null) ...[ const SizedBox(height: 30), const Text("5. Packs Disponíveis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)), const SizedBox(height: 15), ..._obterPacks().map((pack) => _cardPackCompleto(pack)) ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: packSel != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => CodeValidationScreen(nomePack: packSel!))) : null, 
            style: ElevatedButton.styleFrom(disabledBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[300], backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: Text(packSel != null ? "INICIAR JOGO: $packSel" : "SELECIONA UM PACK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: packSel != null ? Colors.white : Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildMapaContinentes() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 200, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: isDark ? Colors.white24 : Colors.grey[300]!)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          options: const MapOptions(initialCenter: LatLng(25.0, 10.0), initialZoom: 1.0, interactionOptions: InteractionOptions(flags: InteractiveFlag.none)),
          children: [
            TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
            MarkerLayer(
              markers: _continentesCoords.entries.map((entry) {
                bool isSelected = continenteSel == entry.key;
                return Marker(
                  point: entry.value, width: 80, height: 40,
                  child: GestureDetector(
                    onTap: () => setState(() { continenteSel = entry.key; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; }),
                    child: Container(
                      decoration: BoxDecoration(color: isSelected ? Colors.deepOrange : (isDark ? Colors.black87 : Colors.white), borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? Colors.white : Colors.deepOrange, width: isSelected ? 2 : 1)),
                      child: Center(child: Text(_abrevContinentes[entry.key]!, style: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotoesModoJogo() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_btnModoUnico("Solo", Icons.person), const SizedBox(width: 8), _btnModoUnico("Duo", Icons.people), const SizedBox(width: 8), _btnModoUnico("Team", Icons.groups), const SizedBox(width: 8), _btnModoUnico("Especiais", Icons.star)]),
    );
  }

  Widget _btnModoUnico(String modo, IconData icon) {
    bool isSelected = modoJogadoresSel == modo;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() { modoJogadoresSel = modo; packSel = null; }),
      child: AnimatedContainer(duration: const Duration(milliseconds: 300), width: 85, padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: isSelected ? Colors.deepOrange.withOpacity(0.2) : (isDark ? Colors.white10 : Colors.grey[200]), border: Border.all(color: isSelected ? Colors.deepOrange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)), child: Column(children: [ Icon(icon, color: isSelected ? Colors.deepOrange : Colors.grey, size: 30), const SizedBox(height: 8), Text(modo, style: TextStyle(color: isSelected ? Colors.deepOrange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)) ])),
    );
  }

  Widget _buildCarrosselPaises(List<String> paisesDisponiveis) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(height: 90, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: paisesDisponiveis.length, itemBuilder: (context, index) { String pais = paisesDisponiveis[index]; bool isSelecionado = paisSel == pais; return GestureDetector(onTap: () => setState(() { paisSel = pais; cidadeSel = null; modoJogadoresSel = null; packSel = null; }), child: Container(width: 85, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: isSelecionado ? Colors.deepOrange.withOpacity(0.2) : (isDark ? Colors.white10 : Colors.grey[200]), border: Border.all(color: isSelecionado ? Colors.deepOrange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(_bandeiras[pais] ?? "🏳️", style: const TextStyle(fontSize: 32)), const SizedBox(height: 6), Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(pais, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelecionado ? Colors.deepOrange : Colors.grey, fontSize: 11))) ]))); }));
  }

  // ✨ MODIFICADO PARA INCLUIR O BOTÃO DE MODO OFFLINE ✨
  Widget _cardPackCompleto(Map<String, dynamic> pack) {
    bool isSelecionado = packSel == pack['nome'];
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isDownloaded = _packsDescarregadosOffline.contains(pack['nome']);
    Color corBorda = isSelecionado ? Colors.deepOrange : (pack['tipo'] == 'Especial' ? Colors.blue : (pack['tipo'] == 'Regional' ? Colors.purple : (isDark ? Colors.white10 : Colors.grey[300]!)));
    
    return GestureDetector(
      onTap: () => setState(() => packSel = pack['nome']), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), 
        decoration: BoxDecoration(color: isSelecionado ? Colors.deepOrange.withOpacity(0.1) : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]), border: Border.all(color: corBorda, width: isSelecionado ? 2 : 1), borderRadius: BorderRadius.circular(15)), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [ 
                Expanded(child: Text(pack['nome'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87))), 
                Text(pack['preco'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)) 
              ]
            ), 
            const SizedBox(height: 8), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.access_time, color: Colors.grey, size: 16), const SizedBox(width: 5), Text(pack['tempo'], style: const TextStyle(color: Colors.grey, fontSize: 13))]),
                
                // MODO OFFLINE (DOWNLOAD DO ROTEIRO)
                GestureDetector(
                  onTap: () {
                    if (!isDownloaded) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A descarregar ${pack['tamanho']} para Modo Offline..."), backgroundColor: Colors.blueAccent));
                      setState(() => _packsDescarregadosOffline.add(pack['nome']));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Este roteiro já está guardado no telemóvel para jogar sem GPS/Internet!")));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: isDownloaded ? Colors.green.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [Icon(isDownloaded ? Icons.cloud_done : Icons.cloud_download, color: isDownloaded ? Colors.green : Colors.blueAccent, size: 14), const SizedBox(width: 4), Text(isDownloaded ? "Descarregado" : pack['tamanho'], style: TextStyle(color: isDownloaded ? Colors.green : Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold))]),
                  ),
                ),
              ]
            ), 
            const SizedBox(height: 10), 
            Text(pack['jogos'], style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13, height: 1.4)) 
          ]
        )
      )
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? valor, Function(String?) onChange) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<String>(decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54), filled: true, fillColor: isDark ? Colors.white10 : Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), dropdownColor: isDark ? Colors.grey[900] : Colors.white, initialValue: valor, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: TextStyle(color: isDark ? Colors.white : Colors.black87)))).toList(), onChanged: items.isEmpty ? null : onChange);
  }

  // ==========================================
  // WIDGET: SOCIAL (CHATS E SQUADS)
  // ==========================================
  void _abrirChat(Map<String, dynamic> amigo) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    List<Map<String, dynamic>> mensagens = [
      {'isMe': false, 'text': 'Olá! Estás pronto para o próximo roteiro?'},
    ];
    TextEditingController msgController = TextEditingController();

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(_mostrarGrupos ? 8 : 50), child: Image.network(amigo["img"], width: 45, height: 45, fit: BoxFit.cover)),
                  const SizedBox(width: 15),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(amigo["nome"], style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)), Text(amigo["status"], style: TextStyle(color: Colors.green[400], fontSize: 12))])),
                  IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context)),
                ]),
                const Divider(height: 15),
                
                Container(
                  height: 250, alignment: Alignment.topCenter,
                  child: ListView.builder(
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      bool isMe = mensagens[index]['isMe'];
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(color: isMe ? Colors.deepOrange : boxColor, borderRadius: BorderRadius.circular(15)),
                          child: Text(mensagens[index]['text'], style: TextStyle(color: isMe ? Colors.white : textColor)),
                        ),
                      );
                    },
                  ),
                ),

                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: msgController, style: TextStyle(color: textColor), 
                      decoration: InputDecoration(hintText: AppSettings.instance.t('type_message'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))
                    )
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent, radius: 25, 
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white), 
                      onPressed: () { 
                        if (msgController.text.isNotEmpty) {
                          setModalState(() {
                            mensagens.add({'isMe': true, 'text': msgController.text});
                            msgController.clear();
                          });
                        }
                      }
                    )
                  )
                ]),
                const SizedBox(height: 20),
              ]
            ),
          );
        }
      )
    );
  }

  void _abrirConviteJogo(Map<String, dynamic> amigo) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25), 
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text("Desafiar ${amigo["nome"]}", style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 5),
            Text("Escolhe o pack para jogar em conjunto.", style: TextStyle(color: textColor.withOpacity(0.7))), const SizedBox(height: 20),
            
            SizedBox(
              height: 400, 
              child: ListView.builder(
                itemCount: _todosPacksInfo.length,
                itemBuilder: (context, index) {
                  final packInfo = _todosPacksInfo[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: boxColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                      leading: Icon(packInfo["icon"], color: Colors.deepOrange),
                      title: Text(packInfo["nome"], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), 
                        onPressed: () { 
                          Navigator.pop(context); 
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Convite para ${packInfo["nome"]} enviado!"), backgroundColor: Colors.green)); 
                        }, 
                        child: const Text("CONVIDAR", style: TextStyle(color: Colors.white, fontSize: 11))
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
        )
      )
    );
  }

  Widget _menuSocial() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(AppSettings.instance.t(_mostrarGrupos ? 'travel_squads' : 'your_friends'), style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 45, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)),
              child: Stack(
                children: [
                  AnimatedAlign(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: _mostrarGrupos ? Alignment.centerRight : Alignment.centerLeft, child: FractionallySizedBox(widthFactor: 0.5, heightFactor: 1.0, child: Container(decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(15))))),
                  Row(children: [
                    Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => setState(() => _mostrarGrupos = false), child: Center(child: Text(AppSettings.instance.t('friends_tab'), style: TextStyle(color: _mostrarGrupos ? textColor.withOpacity(0.5) : Colors.white, fontWeight: FontWeight.bold))))),
                    Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => setState(() => _mostrarGrupos = true), child: Center(child: Text(AppSettings.instance.t('groups_tab'), style: TextStyle(color: !_mostrarGrupos ? textColor.withOpacity(0.5) : Colors.white, fontWeight: FontWeight.bold))))),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: AppSettings.instance.t(_mostrarGrupos ? 'search_groups' : 'search_friends'),
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.5)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O teu código QR foi gerado!"))), 
                      child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.qr_code_2, color: Colors.blueAccent, size: 20))
                    ),
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScannerScreen()));
                      }, 
                      child: Container(margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4), padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20))
                    ),
                  ],
                ),
                filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 15),

          if (_mostrarGrupos)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menu de Criação de Squad Aberto!"))),
                icon: const Icon(Icons.add_moderator, color: Colors.white),
                label: const Text("CRIAR NOVO SQUAD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
          
          if (_mostrarGrupos) const SizedBox(height: 15),

          if (!_mostrarGrupos && _pedidosPendentes.isNotEmpty) ...[
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text("${AppSettings.instance.t('pending_requests')} (${_pedidosPendentes.length})", style: TextStyle(color: textColor.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 13))),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _pedidosPendentes.length,
                itemBuilder: (context, index) {
                  final pedido = _pedidosPendentes[index];
                  return Container(
                    width: 250, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.03) : Colors.white, border: Border.all(color: Colors.blueAccent.withOpacity(0.3)), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        ClipOval(child: Image.network(pedido['img'], width: 40, height: 40, fit: BoxFit.cover)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(pedido['nome'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis), Text(pedido['user'], style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 11))])),
                        Row(children: [
                          GestureDetector(onTap: () => setState(() => _pedidosPendentes.removeAt(index)), child: const CircleAvatar(radius: 14, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white, size: 16))),
                          const SizedBox(width: 8),
                          GestureDetector(onTap: () => setState(() => _pedidosPendentes.removeAt(index)), child: const CircleAvatar(radius: 14, backgroundColor: Colors.redAccent, child: Icon(Icons.close, color: Colors.white, size: 16))),
                        ])
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Divider(color: textColor.withOpacity(0.1), thickness: 1, indent: 20, endIndent: 20),
            const SizedBox(height: 5),
          ],

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _mostrarGrupos ? _listaGrupos.length : _listaAmigos.length,
              itemBuilder: (context, index) {
                final item = _mostrarGrupos ? _listaGrupos[index] : _listaAmigos[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(_mostrarGrupos ? 10 : 50), child: Image.network(item['img'], width: 55, height: 55, fit: BoxFit.cover)),
                          if (!_mostrarGrupos && item['isOnline']) Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: isDark ? const Color(0xFF121212) : Colors.white, width: 2))))
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['nome'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(item['status'], style: TextStyle(color: (item['status'] as String).contains('jogar') ? Colors.blueAccent : textColor.withOpacity(0.6), fontSize: 12, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 4),
                            if (!_mostrarGrupos)
                              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(5)), child: Text("Nível ${item['nivel']}", style: const TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold)))
                            else
                              Text("${item['membros']} Membros", style: const TextStyle(color: Colors.deepOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.chat_bubble_outline), color: Colors.blueAccent, onPressed: () => _abrirChat(item)),
                      IconButton(icon: Icon(_mostrarGrupos ? Icons.group_add : Icons.gamepad), color: Colors.deepOrange, onPressed: () => _abrirConviteJogo(item)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET: PERFIL E DEFINIÇÕES (ACESSIBILIDADE ADICIONADA)
  // ==========================================
  void _abrirAtivacao(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text("Código de Início", style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        content: TextField(controller: codeController, style: TextStyle(color: isDark ? Colors.white : Colors.black87), decoration: InputDecoration(hintText: "PAPTUR26", hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38)), textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            onPressed: () {
              if (codeController.text.toUpperCase() == "PAPTUR26") { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jogo Iniciado!"))); }
            }, 
            child: const Text("ATIVAR", style: TextStyle(color: Colors.white))
          )
        ],
      ),
    );
  }

  void _abrirDefinicoes(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    bool somAtivo = true, notifsAtivas = true, ttsAtivo = false;

    showModalBottomSheet(
      context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool currentDark = Theme.of(context).brightness == Brightness.dark;
          return Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Row(children: [const Icon(Icons.settings, color: Colors.deepOrange), const SizedBox(width: 10), Text("SALA DE CONTROLO", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5))]), IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context)) ]),
                const SizedBox(height: 20),
                SwitchListTile(title: Text("Modo Escuro (Gamer)", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), subtitle: Text("Altera o esquema de cores da app", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)), value: currentDark, activeColor: Colors.deepOrange, secondary: Icon(currentDark ? Icons.dark_mode : Icons.light_mode, color: currentDark ? Colors.deepOrange : Colors.amber), onChanged: (val) { AppSettings.instance.toggleTheme(); setModalState((){}); }),
                SwitchListTile(title: Text("Efeitos Sonoros e Vibração", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), value: somAtivo, activeColor: Colors.deepOrange, secondary: Icon(somAtivo ? Icons.volume_up : Icons.volume_off, color: textColor.withOpacity(0.7)), onChanged: (val) => setModalState(() => somAtivo = val)),
                SwitchListTile(title: Text("Notificações Push", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), subtitle: Text("Avisos de jogos e eventos próximos", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)), value: notifsAtivas, activeColor: Colors.deepOrange, secondary: Icon(notifsAtivas ? Icons.notifications_active : Icons.notifications_off, color: textColor.withOpacity(0.7)), onChanged: (val) => setModalState(() => notifsAtivas = val)),
                
                // ✨ NOVO: BOTÃO ACESSIBILIDADE TTS ✨
                SwitchListTile(title: Text("Acessibilidade (Guia Áudio)", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), subtitle: Text("Lê as missões e histórias em voz alta (Text-to-Speech)", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)), value: ttsAtivo, activeColor: Colors.blueAccent, secondary: Icon(ttsAtivo ? Icons.record_voice_over : Icons.voice_over_off, color: Colors.blueAccent), onChanged: (val) => setModalState(() => ttsAtivo = val)),

                const Divider(height: 30),
                ListTile(leading: Icon(Icons.edit, color: textColor.withOpacity(0.7)), title: Text("Editar Perfil / Password", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Funcionalidade disponível brevemente!"))); }),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildCartaoJogadorRPG(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [const Color(0xFF1E1E1E), const Color(0xFF0A0A0A)] : [Colors.white, Colors.grey[100]!], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 2), boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)]),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 55, height: 55, decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.deepOrange, width: 2)), child: const Center(child: Text("0", style: TextStyle(color: Colors.deepOrange, fontSize: 24, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.cargo.toUpperCase() == "TURISTA" ? "TURISTA INICIANTE" : widget.cargo.toUpperCase(), style: const TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)), const SizedBox(height: 5), Text("0 / 500 XP", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13, fontWeight: FontWeight.bold))])),
              const Icon(Icons.stars, color: Colors.amber, size: 35), 
            ],
          ),
          const SizedBox(height: 15),
          Stack(children: [ Container(height: 12, decoration: BoxDecoration(color: isDark ? Colors.black54 : Colors.grey[300], borderRadius: BorderRadius.circular(10))), Container(width: 40, height: 12, decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 5)])) ]),
        ],
      ),
    );
  }

  Widget _menuPerfil() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;
    bool isAdmin = widget.cargo.toLowerCase() == 'pap' || widget.cargo.toLowerCase() == 'turismo' || widget.username.toLowerCase() == 'admin';

    int passAMostrar = _mostrarTodosPassaportes ? _listaPassaportes.length : 6;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Icon(Icons.share, color: Colors.grey), CircleAvatar(radius: 50, backgroundColor: isDark ? Colors.white10 : Colors.grey[200], child: Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.deepOrange, fontWeight: FontWeight.bold))), IconButton(icon: const Icon(Icons.settings, color: Colors.grey, size: 28), onPressed: () => _abrirDefinicoes(context)) ])),
          const SizedBox(height: 15),
          Text(widget.username, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 25),
          
          _buildCartaoJogadorRPG(isDark),
          const SizedBox(height: 30),
          
          // ✨ NOVO: BOTÃO DO BACKOFFICE EXCLUSIVO PARA O ADMIN ✨
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BackofficeScreen())),
                icon: const Icon(Icons.dashboard, color: Colors.white),
                label: const Text("PAINEL DE CONTROLO (BACKOFFICE)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),

          if (isAdmin)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), child: ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), tileColor: Colors.deepOrange.withOpacity(0.1), leading: const Icon(Icons.play_circle, color: Colors.deepOrange, size: 30), title: Text("Iniciar Roteiro (Teste)", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepOrange), onTap: () => _abrirAtivacao(context))),
          
          _tituloSeccao("Locais Já Jogados", textColor),
          Container(
            height: 200, margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: isDark ? Colors.white10 : Colors.grey[300]!)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FlutterMap(
                options: const MapOptions(initialCenter: LatLng(41.153360, -8.608516), initialZoom: 15.0, interactionOptions: InteractionOptions(flags: InteractiveFlag.none)),
                children: [
                  TileLayer(urlTemplate: isDark ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
                  const MarkerLayer(markers: [Marker(point: LatLng(41.153360, -8.608516), width: 40, height: 40, child: Icon(Icons.location_on, color: Colors.deepOrange, size: 40))])
                ],
              ),
            ),
          ),

          _tituloSeccao("Passaportes Carimbados", textColor),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: GridView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8), itemCount: passAMostrar, itemBuilder: (context, index) { final passaporte = _listaPassaportes[index]; return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(passaporte['img']!), fit: BoxFit.cover)), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.9), Colors.transparent, Colors.transparent])), alignment: Alignment.bottomCenter, padding: const EdgeInsets.all(8), child: Text(passaporte['cidade']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))); })),
          TextButton.icon(onPressed: () => setState(() => _mostrarTodosPassaportes = !_mostrarTodosPassaportes), icon: Icon(_mostrarTodosPassaportes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.deepOrange), label: Text(_mostrarTodosPassaportes ? "Ver Menos" : "Ver Mais", style: const TextStyle(color: Colors.deepOrange))),

          _tituloSeccao("Galeria Privada", textColor),
          Container(height: 120, margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)), child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.photo_library_outlined, color: Colors.grey, size: 40), SizedBox(height: 10), Text("Ainda sem fotos", style: TextStyle(color: Colors.grey))]))),

          _tituloSeccao("Galeria de Badges (${_listaBadges.length})", textColor),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: GridView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 6, mainAxisSpacing: 10), itemCount: _listaBadges.length, itemBuilder: (context, index) { final badge = _listaBadges[index]; return Container(decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey[200], shape: BoxShape.circle), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(badge['icone'], color: Colors.grey, size: 18), const SizedBox(height: 4), Text(badge['nome'], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 6))])); })),
          const SizedBox(height: 40),
          TextButton.icon(onPressed: () => Navigator.pushReplacementNamed(context, '/'), icon: const Icon(Icons.exit_to_app, color: Colors.redAccent), label: const Text("Terminar Sessão", style: TextStyle(color: Colors.redAccent))),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _tituloSeccao(String titulo, Color textColor) {
    return Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 15), child: Align(alignment: Alignment.centerLeft, child: Text(titulo.toUpperCase(), style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2))));
  }

  // ==========================================
  // WIDGET: MURAL DOS EXPLORADORES 
  // ==========================================
  Widget _menuMuralExploradores() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;

    List<Map<String, dynamic>> postaisVisiveis = _filtroAtual == 'Todos' 
        ? _postais 
        : _postais.where((p) => p['pack'] == _filtroAtual || p['pack'].contains(_filtroAtual)).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mural", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Container(
                  decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      GestureDetector(onTap: () => setState(() => _verMapaMural = false), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: !_verMapaMural ? Colors.deepOrange : Colors.transparent, borderRadius: BorderRadius.circular(20)), child: Icon(Icons.view_agenda, color: !_verMapaMural ? Colors.white : Colors.grey, size: 18))),
                      GestureDetector(onTap: () => setState(() => _verMapaMural = true), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _verMapaMural ? Colors.deepOrange : Colors.transparent, borderRadius: BorderRadius.circular(20)), child: Icon(Icons.map, color: _verMapaMural ? Colors.white : Colors.grey, size: 18))),
                    ],
                  ),
                )
              ],
            ),
          ),

          if (!_verMapaMural)
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: _filtrosMural.length,
                itemBuilder: (context, index) {
                  bool isSel = _filtroAtual == _filtrosMural[index];
                  return GestureDetector(
                    onTap: () => setState(() => _filtroAtual = _filtrosMural[index]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5), padding: const EdgeInsets.symmetric(horizontal: 15), alignment: Alignment.center,
                      decoration: BoxDecoration(color: isSel ? Colors.deepOrange : (isDark ? Colors.white10 : Colors.grey[200]), borderRadius: BorderRadius.circular(20)),
                      child: Text(_filtrosMural[index], style: TextStyle(color: isSel ? Colors.white : textColor.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
          
          if (!_verMapaMural) const SizedBox(height: 15),

          Expanded(
            child: _verMapaMural 
              ? _buildMapaDoMural(isDark) 
              : ListView(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text("EXPEDIÇÕES ATIVAS", style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: _expedicoesAtivas.length,
                        itemBuilder: (context, index) {
                          final exp = _expedicoesAtivas[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5), padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, border: Border.all(color: exp['cor'].withOpacity(0.5)), borderRadius: BorderRadius.circular(15), boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                            child: Row(
                              children: [
                                Container(width: 10, height: 10, decoration: BoxDecoration(color: exp['cor'], shape: BoxShape.circle, boxShadow: [BoxShadow(color: exp['cor'], blurRadius: 5)])),
                                const SizedBox(width: 10),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(exp['equipa'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text("${exp['pack']} • ${exp['distancia']}", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 11)),
                                ])
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_filtroAtual == 'Todos')
                      _buildPostalDeOuro(isDark, textColor),
                    
                    if (_filtroAtual == 'Todos')
                       Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 10), child: Text("RECENTES", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),

                    ...postaisVisiveis.asMap().entries.map((entry) {
                      return _buildPostalAventureiro(entry.value, entry.key, isDark, textColor);
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapaDoMural(bool isDark) {
    return FlutterMap(
      options: const MapOptions(initialCenter: LatLng(41.143, -8.612), initialZoom: 14.0),
      children: [
        TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
        MarkerLayer(
          markers: _postais.map((postal) {
            return Marker(
              point: postal['coords'], width: 50, height: 50,
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Postal de ${postal['user']}!"))),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: postal['carimboColor'], width: 3), boxShadow: [BoxShadow(color: postal['carimboColor'].withOpacity(0.5), blurRadius: 10)]),
                  child: ClipOval(child: Image.network(postal['img'], fit: BoxFit.cover)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPostalDeOuro(bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1A1A) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber, width: 2), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8), decoration: const BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.workspace_premium, color: Colors.black, size: 18), SizedBox(width: 5), Text("EXPLORADOR DA SEMANA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5))])),
          Padding(padding: const EdgeInsets.all(15), child: Row(children: [ ClipOval(child: Image.network(_postalDeOuro['userImg'], width: 40, height: 40, fit: BoxFit.cover)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(_postalDeOuro['user'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)), Row(children: [const Icon(Icons.location_on, color: Colors.deepOrange, size: 12), const SizedBox(width: 4), Text(_postalDeOuro['local'], style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12))]) ])) ])),
          Stack(children: [ ClipRRect(child: Image.network(_postalDeOuro['img'], width: double.infinity, height: 250, fit: BoxFit.cover)), Positioned(top: 15, right: 15, child: Transform.rotate(angle: 0.2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _postalDeOuro['carimboColor'].withOpacity(0.9), border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(5)), child: Text(_postalDeOuro['pack'].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1))))) ]),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Row(children: [ Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange)), child: Row(children: [const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 18), const SizedBox(width: 6), Text("${_postalDeOuro['boosts']} Boosts", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12))])), const SizedBox(width: 10), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.stars, color: Colors.amber, size: 18), const SizedBox(width: 6), Text("+${_postalDeOuro['xp_ganho']} XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12))])) ]), IconButton(icon: const Icon(Icons.directions, color: Colors.blueAccent), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A traçar rota para ${_postalDeOuro['local']}..."), backgroundColor: Colors.blueAccent))) ]),
                const SizedBox(height: 15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("REGISTO DA MISSÃO:", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    // ✨ NOVO: BOTÃO ACESSIBILIDADE DE AUDIO ✨
                    GestureDetector(onTap: ()=> ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A reproduzir áudio: Bússola Humana concluída..."))), child: const Icon(Icons.volume_up, color: Colors.blueAccent, size: 18)),
                  ],
                ), 
                const SizedBox(height: 5), Text(_postalDeOuro['caption'], style: TextStyle(color: textColor, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostalAventureiro(Map<String, dynamic> postal, int index, bool isDark, Color textColor) {
    bool showSpoiler = postal['isSpoiler'] == true && postal['isRevealed'] == false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1A1A1A) : Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ClipOval(child: Image.network(postal['userImg'], width: 40, height: 40, fit: BoxFit.cover)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(postal['user'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)), Row(children: [const Icon(Icons.location_on, color: Colors.deepOrange, size: 12), const SizedBox(width: 4), Text(postal['local'], style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12))]) ])),
                Icon(Icons.more_horiz, color: textColor.withOpacity(0.5)),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () {
              if (showSpoiler) setState(() { _postais[index]['isRevealed'] = true; });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(postal['img'], width: double.infinity, height: 300, fit: BoxFit.cover)),
                if (showSpoiler)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        width: double.infinity, height: 300, color: Colors.black.withOpacity(0.4),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_off, color: Colors.deepOrange, size: 50),
                            SizedBox(height: 10),
                            Text("SPOILER DE MISSÃO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2)),
                            SizedBox(height: 5),
                            Text("Toca para revelar", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 15, right: 15,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: postal['carimboColor'].withOpacity(0.9), border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(5)), child: Text(postal['pack'].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1))),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() { _postais[index]['isBoosted'] = !_postais[index]['isBoosted']; }),
                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: postal['isBoosted'] ? Colors.deepOrange.withOpacity(0.2) : (isDark ? Colors.white10 : Colors.grey[200]), borderRadius: BorderRadius.circular(20), border: Border.all(color: postal['isBoosted'] ? Colors.deepOrange : Colors.transparent)), child: Row(children: [Icon(Icons.local_fire_department, color: postal['isBoosted'] ? Colors.deepOrange : Colors.grey, size: 18), const SizedBox(width: 6), Text("${postal['boosts'] + (postal['isBoosted'] ? 1 : 0)} Boosts", style: TextStyle(color: postal['isBoosted'] ? Colors.deepOrange : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))])),
                        ),
                        const SizedBox(width: 10),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.stars, color: Colors.amber, size: 18), const SizedBox(width: 6), Text("+${postal['xp_ganho']} XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12))])),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.directions, color: Colors.blueAccent), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A traçar rota para ${postal['local']}..."), backgroundColor: Colors.blueAccent))),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("REGISTO DA MISSÃO:", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    // ✨ NOVO: BOTÃO ACESSIBILIDADE DE AUDIO ✨
                    GestureDetector(onTap: ()=> ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A reproduzir áudio da história..."))), child: const Icon(Icons.volume_up, color: Colors.blueAccent, size: 18)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(showSpoiler ? "Conteúdo oculto pelo filtro de spoiler." : postal['caption'], style: TextStyle(color: textColor, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET: RANKINGS
  // ==========================================
  Widget _menuRankings() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;

    List<Map<String, dynamic>> dadosAtuais;
    if (_rankLocalizacao == 'Global') dadosAtuais = List.from(_rankingGlobal);
    else if (_rankLocalizacao == 'Nacional') dadosAtuais = List.from(_rankingNacional);
    else dadosAtuais = List.from(_rankingLocal);

    String chaveOrdem = _rankCategoria == 'Pontos' ? 'pontos' : 'packs';
    dadosAtuais.sort((a, b) => b[chaveOrdem].compareTo(a[chaveOrdem]));

    return Column(
      children: [
        const SizedBox(height: 60), Text("LEADERBOARD", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [ Expanded(child: _btnFiltroGeral('Pontos/Nível', _rankCategoria == 'Pontos', () => setState(() => _rankCategoria = 'Pontos'))), const SizedBox(width: 10), Expanded(child: _btnFiltroGeral('Packs Concluídos', _rankCategoria == 'Packs', () => setState(() => _rankCategoria = 'Packs'))) ])),
        const SizedBox(height: 15),
        Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[200], borderRadius: BorderRadius.circular(10)), child: Row(children: [ Expanded(child: _btnFiltroSecundario('Local', _rankLocalizacao == 'Local', () => setState(() => _rankLocalizacao = 'Local'))), Expanded(child: _btnFiltroSecundario('Nacional', _rankLocalizacao == 'Nacional', () => setState(() => _rankLocalizacao = 'Nacional'))), Expanded(child: _btnFiltroSecundario('Global', _rankLocalizacao == 'Global', () => setState(() => _rankLocalizacao = 'Global'))) ])),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [ _buildLugarPodio(dadosAtuais[1], 2, 80, Colors.grey[400]!), const SizedBox(width: 15), _buildLugarPodio(dadosAtuais[0], 1, 110, Colors.amber), const SizedBox(width: 15), _buildLugarPodio(dadosAtuais[2], 3, 70, Colors.brown[300]!) ]),
        const SizedBox(height: 30),
        Expanded(child: Container(padding: const EdgeInsets.only(top: 10), decoration: BoxDecoration(color: isDark ? const Color(0xFF121212) : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]), child: ListView.builder(padding: const EdgeInsets.all(20), itemCount: dadosAtuais.length - 3, itemBuilder: (context, index) { return _buildLinhaRanking(dadosAtuais[index + 3], index + 4); }))),
      ],
    );
  }

  Widget _btnFiltroGeral(String titulo, bool ativo, VoidCallback onTap) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: ativo ? Colors.deepOrange : Colors.transparent, border: Border.all(color: ativo ? Colors.deepOrange : (isDark ? Colors.white24 : Colors.grey[300]!)), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(titulo, style: TextStyle(color: ativo ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)))));
  }

  Widget _btnFiltroSecundario(String titulo, bool ativo, VoidCallback onTap) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: ativo ? (isDark ? Colors.white24 : Colors.grey[300]) : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(titulo, style: TextStyle(color: ativo ? (isDark ? Colors.white : Colors.black87) : Colors.grey, fontSize: 13, fontWeight: ativo ? FontWeight.bold : FontWeight.normal)))));
  }

  Widget _buildLugarPodio(Map<String, dynamic> user, int posicao, double altura, Color corMedalha) {
    String valor = _rankCategoria == 'Pontos' ? '${user['pontos']} XP' : '${user['packs']} Packs';
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(alignment: Alignment.bottomCenter, children: [ Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: corMedalha, width: 3)), child: ClipOval(child: Image.network(user['img'], width: posicao == 1 ? 75 : 60, height: posicao == 1 ? 75 : 60, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white))))), Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: corMedalha, shape: BoxShape.circle), child: Text('$posicao', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))) ]),
        const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(user['pais'], style: const TextStyle(fontSize: 14)), const SizedBox(width: 4), Text(user['nome'].split(' ')[0], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)) ]), const SizedBox(height: 4), Text(valor, style: TextStyle(color: corMedalha, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        Container(width: posicao == 1 ? 80 : 70, height: altura, decoration: BoxDecoration(gradient: LinearGradient(colors: [corMedalha.withOpacity(0.5), corMedalha.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)))),
      ],
    );
  }

  Widget _buildLinhaRanking(Map<String, dynamic> user, int posicao) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String valor = _rankCategoria == 'Pontos' ? '${user['pontos']} XP' : '${user['packs']} Packs';
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('#$posicao', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16))),
          ClipOval(child: Image.network(user['img'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 40, height: 40, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white)))),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Row(children: [Text(user['pais'], style: const TextStyle(fontSize: 16)), const SizedBox(width: 6), Text(user['nome'], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 15))]) ])),
          Text(valor, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // ==========================================
  // BUILD PRINCIPAL E BARRA DE NAVEGAÇÃO
  // ==========================================
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> paginas = [
      _menuPerfil(),
      _menuSocial(),
      _menuJogar(),
      _menuMuralExploradores(), 
      _menuRankings()
    ];

    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: paginas[_indiceAtual],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _indiceAtual, onTap: (i) => setState(() => _indiceAtual = i), type: BottomNavigationBarType.fixed, 
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.white, selectedItemColor: Colors.deepOrange, unselectedItemColor: Colors.grey, selectedFontSize: 12, unselectedFontSize: 10,
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
    );
  }
}

// ==========================================
// ECRÃ DO SCANNER DE QR CODE (CÂMARA REAL)
// ==========================================
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanned = false; // Evita ler o mesmo código 50 vezes num segundo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("Ler QR Code", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (!_isScanned) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() => _isScanned = true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("QR Lido com Sucesso: ${barcode.rawValue}"), backgroundColor: Colors.green, duration: const Duration(seconds: 4))
                  );
                  break; 
                }
              }
            },
          ),
          Container(
            width: 250, height: 250,
            decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange, width: 4), borderRadius: BorderRadius.circular(20)),
            child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.white54, size: 80)),
          ),
          Positioned(bottom: 50, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: const Text("Alinha o código QR dentro da margem laranja", style: TextStyle(color: Colors.white))))
        ],
      ),
    );
  }
}

// ==========================================
// ✨ NOVO: ECRÃ DE BACKOFFICE (SÓ PARA ADMINS)
// ==========================================
class BackofficeScreen extends StatelessWidget {
  const BackofficeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Painel de Controlo (Turismo)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Métricas em Tempo Real", style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Cartões de Estatísticas
            Row(
              children: [
                Expanded(child: _buildEstatisticaCard("Jogadores Ativos", "1,248", Icons.people, Colors.blueAccent, cardColor, textColor)),
                const SizedBox(width: 15),
                Expanded(child: _buildEstatisticaCard("Packs Vendidos", "356", Icons.shopping_cart, Colors.green, cardColor, textColor)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildEstatisticaCard("Receita Hoje", "4,200€", Icons.euro, Colors.amber, cardColor, textColor)),
                const SizedBox(width: 15),
                Expanded(child: _buildEstatisticaCard("Avaliação Média", "4.8/5", Icons.star, Colors.deepOrange, cardColor, textColor)),
              ],
            ),
            const SizedBox(height: 30),

            // Mapa de Calor (Simulado)
            Text("Mapa de Calor (Densidade de Turistas)", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              height: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
                  options: const MapOptions(initialCenter: LatLng(41.1450, -8.6140), initialZoom: 14.0, interactionOptions: InteractionOptions(flags: InteractiveFlag.none)),
                  children: [
                    TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
                    // Simulação do Mapa de Calor com pontos vermelhos e laranjas
                    MarkerLayer(
                      markers: [
                        Marker(point: const LatLng(41.1458, -8.6139), width: 100, height: 100, child: Container(decoration: BoxDecoration(color: Colors.red.withOpacity(0.4), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.red, blurRadius: 20)]))), // Clérigos
                        Marker(point: const LatLng(41.1403, -8.6116), width: 150, height: 150, child: Container(decoration: BoxDecoration(color: Colors.orange.withOpacity(0.4), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.orange, blurRadius: 20)]))), // Ribeira
                        Marker(point: const LatLng(41.1469, -8.6148), width: 80, height: 80, child: Container(decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.4), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.yellow, blurRadius: 20)]))), // Lello
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Gráfico Simulado
            Text("Packs Mais Jogados", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  _buildBarraGrafico("Fest Vibes", 0.9, Colors.purple, textColor),
                  const SizedBox(height: 10),
                  _buildBarraGrafico("Duo Bond", 0.7, Colors.blue, textColor),
                  const SizedBox(height: 10),
                  _buildBarraGrafico("Heritage Hunt", 0.5, Colors.green, textColor),
                  const SizedBox(height: 10),
                  _buildBarraGrafico("Quiet Edition", 0.3, Colors.teal, textColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticaCard(String titulo, String valor, IconData icon, Color cor, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cor, size: 28),
          const SizedBox(height: 10),
          Text(valor, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(titulo, style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBarraGrafico(String titulo, double preenchimento, Color cor, Color textColor) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(titulo, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold))),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: preenchimento, minHeight: 10, color: cor, backgroundColor: Colors.grey.withOpacity(0.2)))),
        const SizedBox(width: 10),
        Text("${(preenchimento * 100).toInt()}%", style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}