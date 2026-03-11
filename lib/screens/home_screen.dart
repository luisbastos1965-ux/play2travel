import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'code_validation_screen.dart'; 

class HomeScreen extends StatefulWidget {
  final String username;
  final String cargo;
  const HomeScreen({super.key, required this.username, required this.cargo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 2; // O índice 2 corresponde à aba "Jogar" (o botão central!)

  // ==========================================
  // 1. VARIÁVEIS E DADOS DO MENU JOGAR
  // ==========================================
  bool _iniciouDareToPlay = false;
  String? continenteSel, paisSel, cidadeSel, modoJogadoresSel, packSel;

  // Mapa com as coordenadas de cada continente para colocar os botões no Mapa-Múndi
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
    packs.add({'nome': "60' of Tourism", 'tipo': 'Especial', 'jogos': 'Contra-relógio pelos marcos principais. Ideal para visitas rápidas.', 'tempo': '01:00 hora', 'preco': '15€'});
    if (cidadeSel == "Porto") packs.add({'nome': 'Quiet Edition (Porto)', 'tipo': 'Regional', 'jogos': 'Exploração ASMR por Museus, Parques e Bibliotecas.', 'tempo': 'Sem limite', 'preco': '10€'});
    if (modoJogadoresSel == "Solo") {
      packs.add({'nome': 'Pack Heritage Hunt', 'tipo': 'Regular', 'jogos': '1. Radar Curiosidades\n2. Bingo Património\n3. Câmara de Época', 'tempo': '08:00 horas', 'preco': '20€'});
      packs.add({'nome': 'Pack Urban Hero', 'tipo': 'Regular', 'jogos': '1. Diário Explorador\n2. Narrativa Episódica\n3. Enigma do Mestre', 'tempo': '10:00 horas', 'preco': '20€'});
    } else if (modoJogadoresSel == "Duo") {
      packs.add({'nome': 'Pack Duo Bond', 'tipo': 'Regular', 'jogos': '1. Puzzle de Par\n2. Quiz Afinidade\n3. Bússola Humana', 'tempo': '06:00 horas', 'preco': '30€'});
      packs.add({'nome': 'Pack Story & Senses', 'tipo': 'Regular', 'jogos': '1. Destino Partilhado\n2. Missão Romeu e Julieta\n3. Prisma da Saudade', 'tempo': '07:00 horas', 'preco': '40€'});
    } else if (modoJogadoresSel == "Team") {
      packs.add({'nome': 'Pack Map Clash', 'tipo': 'Regular', 'jogos': '1. Domínio Bairro\n2. Corrida Pistas Elite\n3. Logística Grupo', 'tempo': '16:00 horas', 'preco': '90€'});
      packs.add({'nome': 'Pack Fest Vibes', 'tipo': 'Regular', 'jogos': '1. S. João Challenge\n2. Aftermovie Coletivo\n3. Tokens de Evento', 'tempo': '2 dias', 'preco': '90€'});
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
  // 3. VARIÁVEIS E DADOS DO TOURISMGRAM
  // ==========================================
  final List<Map<String, dynamic>> _stories = [
    {'nome': 'O Teu Roteiro', 'img': 'https://randomuser.me/api/portraits/men/11.jpg', 'isUser': true},
    {'nome': 'Lourenço', 'img': 'https://randomuser.me/api/portraits/men/22.jpg', 'isUser': false},
    {'nome': 'Maria', 'img': 'https://randomuser.me/api/portraits/women/24.jpg', 'isUser': false},
    {'nome': 'Nádia', 'img': 'https://randomuser.me/api/portraits/women/31.jpg', 'isUser': false},
    {'nome': 'Paula', 'img': 'https://randomuser.me/api/portraits/women/42.jpg', 'isUser': false},
    {'nome': 'Júri 1', 'img': 'https://randomuser.me/api/portraits/men/50.jpg', 'isUser': false},
  ];

  final List<Map<String, dynamic>> _feedPosts = [
    {
      'user': 'Lourenço', 'userImg': 'https://randomuser.me/api/portraits/men/22.jpg',
      'local': 'Ribeira, Porto 🇵🇹', 'pack': 'Pack Fest Vibes',
      'img': 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80',
      'likes': 342, 'caption': 'A descobrir os segredos das ruelas da Ribeira! O desafio fotográfico foi incrível. 🕵️‍♀️🍷',
      'tags': '#Porto #Play2Travel #Ribeira', 'isLiked': false, 'isSaved': false
    },
    {
      'user': 'Júri 3', 'userImg': 'https://randomuser.me/api/portraits/men/52.jpg',
      'local': 'Jardim do Morro, Gaia 🇵🇹', 'pack': "Pack Duo Bond",
      'img': 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=600&q=80',
      'likes': 891, 'caption': 'Bússola Humana concluída ao pôr do sol. Uma perspetiva totalmente nova da cidade invicta! 🌉🧭',
      'tags': '#Gaia #Sunset #Travel', 'isLiked': true, 'isSaved': true
    },
    {
      'user': 'Nádia', 'userImg': 'https://randomuser.me/api/portraits/women/31.jpg',
      'local': 'Livraria Lello, Porto 🇵🇹', 'pack': 'Quiet Edition (Porto)',
      'img': 'https://images.unsplash.com/photo-1620311497232-613d9865f3bc?w=600&q=80',
      'likes': 1204, 'caption': 'Missão ASMR completa. O silêncio e a história deste lugar são mágicos. 📚✨',
      'tags': '#Lello #QuietEdition #HarryPotter', 'isLiked': false, 'isSaved': false
    },
  ];

  // ==========================================
  // 4. VARIÁVEIS E DADOS DA REDE SOCIAL (AMIGOS)
  // ==========================================
  final List<Map<String, dynamic>> _listaAmigos = [
    {'nome': 'Lourenço', 'nivel': 14, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/men/22.jpg'},
    {'nome': 'Maria', 'nivel': 12, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/24.jpg'},
    {'nome': 'Nádia', 'nivel': 9, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/women/31.jpg'},
    {'nome': 'Paula', 'nivel': 11, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/42.jpg'},
    {'nome': 'Membro do Júri 1', 'nivel': 20, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/men/50.jpg'},
    {'nome': 'Membro do Júri 2', 'nivel': 18, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/51.jpg'},
    {'nome': 'Membro do Júri 3', 'nivel': 15, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/men/52.jpg'},
    {'nome': 'Membro do Júri 4', 'nivel': 17, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/53.jpg'},
    {'nome': 'Membro do Júri 5', 'nivel': 21, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/men/54.jpg'},
    {'nome': 'Membro do Júri 6', 'nivel': 16, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/55.jpg'},
    {'nome': 'Membro do Júri 7', 'nivel': 19, 'isOnline': true, 'img': 'https://randomuser.me/api/portraits/men/56.jpg'},
    {'nome': 'Membro do Júri 8', 'nivel': 22, 'isOnline': false, 'img': 'https://randomuser.me/api/portraits/women/57.jpg'},
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
  final List<Map<String, dynamic>> _listaBadges = [{'nome': 'Mochileiro', 'icone': Icons.backpack}, {'nome': 'Cidadão Mundo', 'icone': Icons.public}, {'nome': 'Guia Local', 'icone': Icons.map}, {'nome': 'Fotógrafo', 'icone': Icons.camera_alt}];

  // ==========================================
  // WIDGET: JOGAR (ABA 3 - COM MAPA INTERATIVO E ÍCONES)
  // ==========================================
  Widget _menuJogar() {
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Text("CONFIGURAR VIAGEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)), IconButton(icon: const Icon(Icons.refresh, color: Colors.grey), onPressed: () => setState(() { _iniciouDareToPlay = false; continenteSel = null; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; })) ]),
          const SizedBox(height: 30),
          
          // MAPA-MÚNDI INTERATIVO PARA CONTINENTES
          const Text("1. Continente", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          _buildMapaContinentes(),
          
          if (continenteSel != null) ...[ const SizedBox(height: 25), const Text("2. País", style: TextStyle(color: Colors.white70, fontSize: 14)), const SizedBox(height: 10), _buildCarrosselPaises(_paises[continenteSel] ?? []) ],
          if (paisSel != null) ...[ const SizedBox(height: 20), _buildDropdown("3. Cidade", _cidades[paisSel] ?? [], cidadeSel, (v) => setState(() { cidadeSel = v; modoJogadoresSel = null; packSel = null; })) ],
          
          if (cidadeSel != null) ...[ 
            const SizedBox(height: 25), 
            const Text("4. Jogadores", style: TextStyle(color: Colors.white70, fontSize: 14)), 
            const SizedBox(height: 10), 
            // BOTÕES DE ÍCONES PARA MODO DE JOGO
            _buildBotoesModoJogo() 
          ],
          
          if (modoJogadoresSel != null) ...[ const SizedBox(height: 30), const Text("5. Packs Disponíveis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)), const SizedBox(height: 15), ..._obterPacks().map((pack) => _cardPackCompleto(pack)).toList() ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: packSel != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => CodeValidationScreen(nomePack: packSel!))) : null, 
            style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey[900], backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: Text(packSel != null ? "INICIAR JOGO: $packSel" : "SELECIONA UM PACK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: packSel != null ? Colors.white : Colors.grey)),
          ),
        ],
      ),
    );
  }

  // Mapa-Múndi
  Widget _buildMapaContinentes() {
    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(25.0, 10.0), 
            initialZoom: 1.0, 
            interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
            MarkerLayer(
              markers: _continentesCoords.entries.map((entry) {
                bool isSelected = continenteSel == entry.key;
                return Marker(
                  point: entry.value,
                  width: 80, height: 40,
                  child: GestureDetector(
                    onTap: () => setState(() { continenteSel = entry.key; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrange : Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.white : Colors.deepOrange, width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.5), blurRadius: 10)] : [],
                      ),
                      child: Center(
                        child: Text(_abrevContinentes[entry.key]!, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
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

  // Botões de Modo de Jogo
  Widget _buildBotoesModoJogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _btnModoUnico("Solo", Icons.person),
        _btnModoUnico("Duo", Icons.people),
        _btnModoUnico("Team", Icons.groups),
      ],
    );
  }

  Widget _btnModoUnico(String modo, IconData icon) {
    bool isSelected = modoJogadoresSel == modo;
    return GestureDetector(
      onTap: () => setState(() { modoJogadoresSel = modo; packSel = null; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100, padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.withOpacity(0.2) : Colors.white10,
          border: Border.all(color: isSelected ? Colors.deepOrange : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.deepOrange : Colors.white54, size: 35),
            const SizedBox(height: 8),
            Text(modo, style: TextStyle(color: isSelected ? Colors.deepOrange : Colors.white54, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCarrosselPaises(List<String> paisesDisponiveis) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, itemCount: paisesDisponiveis.length,
        itemBuilder: (context, index) {
          String pais = paisesDisponiveis[index];
          bool isSelecionado = paisSel == pais;
          return GestureDetector(
            onTap: () => setState(() { paisSel = pais; cidadeSel = null; modoJogadoresSel = null; packSel = null; }),
            child: Container(
              width: 85, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: isSelecionado ? Colors.deepOrange.withOpacity(0.2) : Colors.white10, border: Border.all(color: isSelecionado ? Colors.deepOrange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(_bandeiras[pais] ?? "🏳️", style: const TextStyle(fontSize: 32)), const SizedBox(height: 6), Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(pais, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelecionado ? Colors.deepOrange : Colors.white70, fontSize: 11))) ]),
            ),
          );
        },
      ),
    );
  }

  Widget _cardPackCompleto(Map<String, dynamic> pack) {
    bool isSelecionado = packSel == pack['nome'];
    Color corBorda = isSelecionado ? Colors.deepOrange : (pack['tipo'] == 'Especial' ? Colors.blue : (pack['tipo'] == 'Regional' ? Colors.purple : Colors.white10));
    return GestureDetector(
      onTap: () => setState(() => packSel = pack['nome']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: isSelecionado ? Colors.deepOrange.withOpacity(0.1) : Colors.white.withOpacity(0.05), border: Border.all(color: corBorda, width: isSelecionado ? 2 : 1), borderRadius: BorderRadius.circular(15)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Expanded(child: Text(pack['nome'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))), Text(pack['preco'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)) ]), const SizedBox(height: 8), Row(children: [const Icon(Icons.access_time, color: Colors.grey, size: 16), const SizedBox(width: 5), Text(pack['tempo'], style: const TextStyle(color: Colors.grey, fontSize: 13))]), const SizedBox(height: 10), Text(pack['jogos'], style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)) ]),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? valor, Function(String?) onChange) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      dropdownColor: Colors.grey[900], value: valor, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(color: Colors.white)))).toList(), onChanged: items.isEmpty ? null : onChange,
    );
  }

  // ==========================================
  // WIDGET: RANKINGS
  // ==========================================
  Widget _menuRankings() {
    List<Map<String, dynamic>> dadosAtuais;
    if (_rankLocalizacao == 'Global') dadosAtuais = List.from(_rankingGlobal);
    else if (_rankLocalizacao == 'Nacional') dadosAtuais = List.from(_rankingNacional);
    else dadosAtuais = List.from(_rankingLocal);

    String chaveOrdem = _rankCategoria == 'Pontos' ? 'pontos' : 'packs';
    dadosAtuais.sort((a, b) => b[chaveOrdem].compareTo(a[chaveOrdem]));

    return Column(
      children: [
        const SizedBox(height: 60), const Text("LEADERBOARD", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [ Expanded(child: _btnFiltroGeral('Pontos/Nível', _rankCategoria == 'Pontos', () => setState(() => _rankCategoria = 'Pontos'))), const SizedBox(width: 10), Expanded(child: _btnFiltroGeral('Packs Concluídos', _rankCategoria == 'Packs', () => setState(() => _rankCategoria = 'Packs'))) ])),
        const SizedBox(height: 15),
        Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: Row(children: [ Expanded(child: _btnFiltroSecundario('Local', _rankLocalizacao == 'Local', () => setState(() => _rankLocalizacao = 'Local'))), Expanded(child: _btnFiltroSecundario('Nacional', _rankLocalizacao == 'Nacional', () => setState(() => _rankLocalizacao = 'Nacional'))), Expanded(child: _btnFiltroSecundario('Global', _rankLocalizacao == 'Global', () => setState(() => _rankLocalizacao = 'Global'))) ])),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [ _buildLugarPodio(dadosAtuais[1], 2, 80, Colors.grey[400]!), const SizedBox(width: 15), _buildLugarPodio(dadosAtuais[0], 1, 110, Colors.amber), const SizedBox(width: 15), _buildLugarPodio(dadosAtuais[2], 3, 70, Colors.brown[300]!) ]),
        const SizedBox(height: 30),
        Expanded(child: Container(padding: const EdgeInsets.only(top: 10), decoration: const BoxDecoration(color: Color(0xFF121212), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))), child: ListView.builder(padding: const EdgeInsets.all(20), itemCount: dadosAtuais.length - 3, itemBuilder: (context, index) { return _buildLinhaRanking(dadosAtuais[index + 3], index + 4); }))),
      ],
    );
  }

  Widget _btnFiltroGeral(String titulo, bool ativo, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: ativo ? Colors.deepOrange : Colors.transparent, border: Border.all(color: ativo ? Colors.deepOrange : Colors.white24), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(titulo, style: TextStyle(color: ativo ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)))));
  }

  Widget _btnFiltroSecundario(String titulo, bool ativo, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: ativo ? Colors.white24 : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(titulo, style: TextStyle(color: ativo ? Colors.white : Colors.white54, fontSize: 13, fontWeight: ativo ? FontWeight.bold : FontWeight.normal)))));
  }

  Widget _buildLugarPodio(Map<String, dynamic> user, int posicao, double altura, Color corMedalha) {
    String valor = _rankCategoria == 'Pontos' ? '${user['pontos']} XP' : '${user['packs']} Packs';
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(alignment: Alignment.bottomCenter, children: [ Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: corMedalha, width: 3)), child: ClipOval(child: Image.network(user['img'], width: posicao == 1 ? 75 : 60, height: posicao == 1 ? 75 : 60, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white))))), Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: corMedalha, shape: BoxShape.circle), child: Text('$posicao', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))) ]),
        const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(user['pais'], style: const TextStyle(fontSize: 14)), const SizedBox(width: 4), Text(user['nome'].split(' ')[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)) ]), const SizedBox(height: 4), Text(valor, style: TextStyle(color: corMedalha, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        Container(width: posicao == 1 ? 80 : 70, height: altura, decoration: BoxDecoration(gradient: LinearGradient(colors: [corMedalha.withOpacity(0.5), corMedalha.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)))),
      ],
    );
  }

  Widget _buildLinhaRanking(Map<String, dynamic> user, int posicao) {
    String valor = _rankCategoria == 'Pontos' ? '${user['pontos']} XP' : '${user['packs']} Packs';
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('#$posicao', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16))),
          ClipOval(child: Image.network(user['img'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 40, height: 40, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white)))),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Row(children: [Text(user['pais'], style: const TextStyle(fontSize: 16)), const SizedBox(width: 6), Text(user['nome'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))]) ])),
          Text(valor, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET: TOURISMGRAM
  // ==========================================
  Widget _menuTourismgram() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tourismgram", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                Row(children: [ IconButton(icon: const Icon(Icons.add_box_outlined, color: Colors.white, size: 28), onPressed: () {}), IconButton(icon: const Icon(Icons.map_outlined, color: Colors.white, size: 28), onPressed: () {}) ]),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10), itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, gradient: story['isUser'] ? null : const LinearGradient(colors: [Colors.deepOrange, Colors.amber], begin: Alignment.topRight, end: Alignment.bottomLeft), color: story['isUser'] ? Colors.white24 : null), child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Color(0xFF0A0A0A), shape: BoxShape.circle), child: ClipOval(child: Image.network(story['img'], width: 65, height: 65, fit: BoxFit.cover)))),
                          if (story['isUser']) Container(decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 20))
                        ],
                      ),
                      const SizedBox(height: 6), Text(story['nome'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white10, thickness: 1, height: 1),
          Expanded(child: ListView.builder(itemCount: _feedPosts.length, itemBuilder: (context, index) => _buildPostTourismgram(_feedPosts[index], index))),
        ],
      ),
    );
  }

  Widget _buildPostTourismgram(Map<String, dynamic> post, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ ClipOval(child: Image.network(post['userImg'], width: 40, height: 40, fit: BoxFit.cover)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(post['user'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), Text(post['local'], style: const TextStyle(color: Colors.white54, fontSize: 12)) ]) ]),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
        ),
        Image.network(post['img'], width: double.infinity, height: 350, fit: BoxFit.cover),
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15), color: Colors.deepOrange.withOpacity(0.9),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Row(children: [ const Icon(Icons.gamepad, color: Colors.white, size: 18), const SizedBox(width: 8), Text("A jogar: ${post['pack']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)) ]), const Text("JOGAR >", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)) ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [ IconButton(icon: Icon(post['isLiked'] ? Icons.favorite : Icons.favorite_border, color: post['isLiked'] ? Colors.red : Colors.white, size: 28), onPressed: () => setState(() => _feedPosts[index]['isLiked'] = !_feedPosts[index]['isLiked'])), IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26), onPressed: () {}), IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 26), onPressed: () {}) ]),
              IconButton(icon: Icon(post['isSaved'] ? Icons.bookmark : Icons.bookmark_border, color: post['isSaved'] ? Colors.amber : Colors.white, size: 28), onPressed: () => setState(() => _feedPosts[index]['isSaved'] = !_feedPosts[index]['isSaved'])),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${post['likes'] + (post['isLiked'] ? 1 : 0)} gostos", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              RichText(text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4), children: [ TextSpan(text: "${post['user']} ", style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: post['caption']) ])),
              const SizedBox(height: 4), Text(post['tags'], style: const TextStyle(color: Colors.blue, fontSize: 13)), const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET: SOCIAL / AMIGOS
  // ==========================================
  Widget _menuSocial() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text("OS TEUS AMIGOS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _listaAmigos.length,
              itemBuilder: (context, index) {
                final amigo = _listaAmigos[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipOval(child: Image.network(amigo['img'], width: 50, height: 50, fit: BoxFit.cover)),
                          if (amigo['isOnline'])
                            Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF121212), width: 2))))
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(amigo['nome'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("Nível ${amigo['nivel']}", style: const TextStyle(color: Colors.deepOrange, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.gamepad, color: Colors.deepOrange), onPressed: () {}),
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
  // WIDGET: PERFIL
  // ==========================================
  Widget _menuPerfil() {
    int passAMostrar = _mostrarTodosPassaportes ? _listaPassaportes.length : 6;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ const Icon(Icons.share, color: Colors.grey), CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.deepOrange, fontWeight: FontWeight.bold))), const Icon(Icons.settings, color: Colors.grey) ]),
          ),
          const SizedBox(height: 15),
          Text(widget.username, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 25),
          const Text("NÍVEL 0 - Turista Iniciante", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: const LinearProgressIndicator(value: 0.0, minHeight: 12, backgroundColor: Colors.white10))),
          const SizedBox(height: 30),
          
          _tituloSeccao("Locais Já Jogados"),
          Container(
            height: 200, margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FlutterMap(
                options: const MapOptions(initialCenter: LatLng(41.153360, -8.608516), initialZoom: 15.0, interactionOptions: InteractionOptions(flags: InteractiveFlag.none)),
                children: [
                  TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
                  MarkerLayer(markers: [Marker(point: const LatLng(41.153360, -8.608516), width: 40, height: 40, child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 40))])
                ],
              ),
            ),
          ),

          _tituloSeccao("Passaportes Carimbados"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
              itemCount: passAMostrar,
              itemBuilder: (context, index) {
                final passaporte = _listaPassaportes[index];
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(passaporte['img']!), fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.9), Colors.transparent, Colors.transparent])),
                    alignment: Alignment.bottomCenter, padding: const EdgeInsets.all(8),
                    child: Text(passaporte['cidade']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          TextButton.icon(onPressed: () => setState(() => _mostrarTodosPassaportes = !_mostrarTodosPassaportes), icon: Icon(_mostrarTodosPassaportes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.deepOrange), label: Text(_mostrarTodosPassaportes ? "Ver Menos" : "Ver Mais", style: const TextStyle(color: Colors.deepOrange))),

          _tituloSeccao("Galeria Privada"),
          Container(height: 120, margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24, width: 1)), child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.photo_library_outlined, color: Colors.white24, size: 40), SizedBox(height: 10), Text("Ainda sem fotos", style: TextStyle(color: Colors.white30))]))),

          _tituloSeccao("Galeria de Badges (${_listaBadges.length})"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 6, mainAxisSpacing: 10),
              itemCount: _listaBadges.length,
              itemBuilder: (context, index) {
                final badge = _listaBadges[index];
                return Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(badge['icone'], color: Colors.white24, size: 18), const SizedBox(height: 4), Text(badge['nome'], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white24, fontSize: 6))]));
              },
            ),
          ),
          const SizedBox(height: 40),
          TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.exit_to_app, color: Colors.redAccent), label: const Text("Terminar Sessão", style: TextStyle(color: Colors.redAccent))),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _tituloSeccao(String titulo) {
    return Padding(padding: const EdgeInsets.fromLTRB(20, 30, 20, 15), child: Align(alignment: Alignment.centerLeft, child: Text(titulo.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2))));
  }

  // ==========================================
  // BUILD PRINCIPAL E BARRA DE NAVEGAÇÃO
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // Ordem das páginas
    final List<Widget> paginas = [
      _menuPerfil(),
      _menuSocial(),
      _menuJogar(),
      _menuTourismgram(),
      _menuRankings()
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: paginas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, 
        onTap: (i) => setState(() => _indiceAtual = i),
        type: BottomNavigationBarType.fixed, 
        backgroundColor: const Color(0xFF121212), 
        selectedItemColor: Colors.deepOrange, 
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          const BottomNavigationBarItem(icon: Icon(Icons.people), label: "Social"),
          
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                boxShadow: _indiceAtual == 2 
                    ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)]
                    : [],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_circle_fill, size: 42),
            ), 
            label: "Jogar"
          ),
          
          const BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Tourismgram"),
          const BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Rankings"),
        ],
      ),
    );
  }
}