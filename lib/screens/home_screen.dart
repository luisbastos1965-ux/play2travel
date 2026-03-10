import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'gameplay_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String cargo;
  const HomeScreen({super.key, required this.username, required this.cargo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 0;

  // --- VARIÁVEIS DO MENU JOGAR ---
  bool _iniciouDareToPlay = false;
  String? continenteSel, paisSel, cidadeSel, modoJogadoresSel, packSel;

  final List<String> _continentes = ["Europa", "América do Norte", "América do Sul", "Ásia", "África", "Oceânia"];
  
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
    "Colômbia": "🇨🇴", "Peru": "🇵🇪", "Japão": "🇯🇵", "China": "🇨🇳", "Índia": "🇮🇳", "Tailândia": "🇹🇭", 
    "Emirados Árabes Unidos": "🇦🇪", "África do Sul": "🇿🇦", "Egipto": "🇪🇬", "Marrocos": "🇲🇦", 
    "Quénia": "🇰🇪", "Austrália": "🇦🇺", "Nova Zelândia": "🇳🇿",
  };

  final Map<String, List<String>> _cidades = {
    "Portugal": ["Porto", "Lisboa", "Braga", "Coimbra", "Faro"],
    "Espanha": ["Madrid", "Barcelona", "Sevilha", "Valência", "Bilbau"],
    "França": ["Paris", "Lyon", "Marselha", "Nice", "Bordéus"],
    "Estados Unidos": ["Nova Iorque", "Los Angeles", "Chicago", "Miami", "São Francisco"],
    "Brasil": ["Rio de Janeiro", "São Paulo", "Salvador", "Florianópolis", "Brasília"],
    "Japão": ["Tóquio", "Quioto", "Osaka", "Hiroshima", "Sapporo"],
  };

  final List<String> _modosJogo = ["Solo", "Duo", "Team"];

  // --- LÓGICA DOS PACKS ---
  List<Map<String, dynamic>> _obterPacks() {
    List<Map<String, dynamic>> packs = [];

    // 1. Pack Permanente (Aparece sempre)
    packs.add({
      'nome': "60' of Tourism",
      'tipo': 'Especial',
      'jogos': 'Contra-relógio pelos marcos principais. Ideal para visitas rápidas.',
      'tempo': '01:00 hora',
      'preco': '15€'
    });

    // 2. Pack Regional (Exclusivo Porto)
    if (cidadeSel == "Porto") {
      packs.add({
        'nome': 'Quiet Edition (Porto Exclusive)',
        'tipo': 'Regional',
        'jogos': 'Exploração ASMR por Museus, Parques e Bibliotecas históricas do Porto.',
        'tempo': 'Sem limite',
        'preco': '10€'
      });
    }

    // 3. Packs Regulares mediante os Jogadores
    if (modoJogadoresSel == "Solo") {
      packs.add({
        'nome': 'Pack Heritage Hunt',
        'tipo': 'Regular',
        'jogos': '1. Radar de Curiosidades (QR Codes com lendas)\n2. Bingo do Património\n3. Câmara de Época (Antigo sobre Novo)',
        'tempo': '08:00 horas',
        'preco': '20€'
      });
      packs.add({
        'nome': 'Pack Urban Hero',
        'tipo': 'Regular',
        'jogos': '1. Diário do Explorador\n2. Narrativa Episódica\n3. Enigma do Mestre (Código Morse)',
        'tempo': '10:00 horas',
        'preco': '20€'
      });
    } else if (modoJogadoresSel == "Duo") {
      packs.add({
        'nome': 'Pack Duo Bond',
        'tipo': 'Regular',
        'jogos': '1. Puzzle de Par\n2. Quiz de Afinidade\n3. Bússola Humana',
        'tempo': '06:00 horas',
        'preco': '30€'
      });
      packs.add({
        'nome': 'Pack Story & Senses',
        'tipo': 'Regular',
        'jogos': '1. Destino Partilhado\n2. Missão Romeu e Julieta\n3. Prisma da Saudade',
        'tempo': '07:00 horas',
        'preco': '40€'
      });
    } else if (modoJogadoresSel == "Team") {
      packs.add({
        'nome': 'Pack Map Clash',
        'tipo': 'Regular',
        'jogos': '1. Domínio de Bairro\n2. Corrida de Pistas Elite\n3. Logística de Grupo',
        'tempo': '16:00 horas',
        'preco': '90€'
      });
      packs.add({
        'nome': 'Pack Fest Vibes',
        'tipo': 'Regular',
        'jogos': '1. S. João Challenge\n2. Aftermovie Coletivo\n3. Tokens de Evento',
        'tempo': '2 dias',
        'preco': '90€'
      });
    }
    return packs;
  }

  // --- ECRÃ 1: MENU DE JOGAR ---
  Widget _menuJogar() {
    if (!_iniciouDareToPlay) {
      return Center(
        child: ElevatedButton(
          onPressed: () => setState(() => _iniciouDareToPlay = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("DARE TO PLAY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("CONFIGURAR VIAGEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.grey),
                onPressed: () => setState(() {
                  _iniciouDareToPlay = false;
                  continenteSel = null; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null;
                }),
              )
            ],
          ),
          const SizedBox(height: 30),

          _buildDropdown("1. Continente", _continentes, continenteSel, (v) {
            setState(() { continenteSel = v; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; });
          }),

          if (continenteSel != null) ...[
            const SizedBox(height: 20),
            const Text("2. País", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 10),
            _buildCarrosselPaises(_paises[continenteSel] ?? []),
          ],

          if (paisSel != null) ...[
            const SizedBox(height: 20),
            _buildDropdown("3. Cidade Principal", _cidades[paisSel] ?? ["Sem cidades registadas"], cidadeSel, (v) {
              setState(() { cidadeSel = v; modoJogadoresSel = null; packSel = null; });
            }),
          ],

          if (cidadeSel != null) ...[
            const SizedBox(height: 15),
            _buildDropdown("4. Jogadores", _modosJogo, modoJogadoresSel, (v) {
              setState(() { modoJogadoresSel = v; packSel = null; });
            }),
          ],

          if (modoJogadoresSel != null) ...[
            const SizedBox(height: 30),
            const Text("5. Packs Disponíveis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const SizedBox(height: 15),
            ..._obterPacks().map((pack) => _cardPackCompleto(pack)).toList(),
          ],

          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: packSel != null ? () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(nomePack: packSel!)));
            } : null, 
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.grey[900],
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(packSel != null ? "INICIAR JOGO: $packSel" : "SELECIONA UM PACK PARA JOGAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: packSel != null ? Colors.white : Colors.grey)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCarrosselPaises(List<String> paisesDisponiveis) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: paisesDisponiveis.length,
        itemBuilder: (context, index) {
          String pais = paisesDisponiveis[index];
          bool isSelecionado = paisSel == pais;
          return GestureDetector(
            onTap: () => setState(() { paisSel = pais; cidadeSel = null; modoJogadoresSel = null; packSel = null; }),
            child: Container(
              width: 85,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelecionado ? Colors.deepOrange.withOpacity(0.2) : Colors.white10,
                border: Border.all(color: isSelecionado ? Colors.deepOrange : Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_bandeiras[pais] ?? "🏳️", style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      pais, 
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: isSelecionado ? Colors.deepOrange : Colors.white70, fontSize: 11)
                    ),
                  ),
                ],
              ),
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
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isSelecionado ? Colors.deepOrange.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          border: Border.all(color: corBorda, width: isSelecionado ? 2 : 1),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(pack['nome'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                Text(pack['preco'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 16),
                const SizedBox(width: 5),
                Text(pack['tempo'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            Text(pack['jogos'], style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }

  // --- ECRÃ 2 E 3 (MANTIDOS VAZIOS PARA JÁ) ---
  Widget _menuRankings() => const Center(child: Text("RANKINGS", style: TextStyle(color: Colors.white)));
  Widget _menuTourismgram() => const Center(child: Text("TOURISMGRAM", style: TextStyle(color: Colors.white)));

  // --- ECRÃ 4: PERFIL (FORMATADO SEM ERROS) ---
  bool _mostrarTodosPassaportes = false;
  final List<String> _listaPassaportes = ['Paris', 'Nova Iorque', 'Tóquio', 'Roma', 'Londres', 'Sydney', 'Rio de Janeiro', 'Berlim', 'Banguecoque', 'Dubai', 'Lisboa', 'Madrid', 'Barcelona', 'Amesterdão', 'Viena', 'Praga', 'Budapeste', 'Atenas', 'Istambul', 'Cairo', 'Cidade do Cabo', 'Buenos Aires', 'Santiago', 'Lima', 'Bogotá', 'Cidade do México', 'Toronto', 'Vancouver', 'Los Angeles', 'São Francisco', 'Chicago', 'Miami', 'Seul', 'Pequim', 'Xangai', 'Hong Kong', 'Singapura', 'Kuala Lumpur', 'Jacarta', 'Nova Deli', 'Mumbai', 'Reiquiavique', 'Oslo', 'Estocolmo', 'Copenhaga', 'Helsínquia', 'Varsóvia', 'Moscovo', 'Dublin', 'Mais passaportes'];
  final List<Map<String, dynamic>> _listaBadges = [{'nome': 'Mochileiro', 'icone': Icons.backpack}, {'nome': 'Cidadão Mundo', 'icone': Icons.public}, {'nome': 'Milhas Aéreas', 'icone': Icons.flight_takeoff}, {'nome': 'Nómada Digital', 'icone': Icons.laptop_mac}, {'nome': 'Fotógrafo', 'icone': Icons.camera_alt}, {'nome': 'Mergulhador', 'icone': Icons.scuba_diving}, {'nome': 'Alpinista', 'icone': Icons.terrain}, {'nome': 'Poliglota', 'icone': Icons.translate}, {'nome': 'Guia Local', 'icone': Icons.map}, {'nome': 'Campista', 'icone': Icons.holiday_village}, {'nome': 'Rei da Praia', 'icone': Icons.beach_access}, {'nome': 'Rota Vinhos', 'icone': Icons.wine_bar}, {'nome': 'Caçador Auroras', 'icone': Icons.ac_unit}, {'nome': 'Explorador Urbano', 'icone': Icons.location_city}, {'nome': 'Ciclista', 'icone': Icons.directions_bike}, {'nome': 'Marinheiro', 'icone': Icons.sailing}, {'nome': 'Gastrónomo', 'icone': Icons.restaurant}, {'nome': 'Historiador', 'icone': Icons.account_balance}, {'nome': 'Fã Museus', 'icone': Icons.museum}, {'nome': 'Amante Arte', 'icone': Icons.palette}, {'nome': 'Aventureiro', 'icone': Icons.explore}, {'nome': 'Viajante Solo', 'icone': Icons.person_outline}, {'nome': 'Eco-Turista', 'icone': Icons.eco}, {'nome': 'Caminhante', 'icone': Icons.directions_walk}, {'nome': 'Surfista', 'icone': Icons.surfing}, {'nome': 'Fã de Neve', 'icone': Icons.snowboarding}, {'nome': 'Amante Comboios', 'icone': Icons.train}, {'nome': 'Fã Autocarros', 'icone': Icons.directions_bus}, {'nome': 'Piloto', 'icone': Icons.local_airport}, {'nome': 'Madrugador', 'icone': Icons.wb_sunny}, {'nome': 'Coruja Noturna', 'icone': Icons.nights_stay}, {'nome': 'Festivaleiro', 'icone': Icons.celebration}, {'nome': 'Fazedor Amigos', 'icone': Icons.people}, {'nome': 'Rei do Hostel', 'icone': Icons.hotel}, {'nome': 'Mestre Glamping', 'icone': Icons.cabin}, {'nome': 'Perito Selva', 'icone': Icons.park}, {'nome': 'Sobrevivente', 'icone': Icons.wb_twilight}, {'nome': 'Astrónomo', 'icone': Icons.star}, {'nome': 'Fã Cascatas', 'icone': Icons.water_drop}, {'nome': 'Amigo Animais', 'icone': Icons.pets}, {'nome': 'Fã Castelos', 'icone': Icons.fort}, {'nome': 'Mala Cheia', 'icone': Icons.luggage}, {'nome': 'Souvenirs', 'icone': Icons.shopping_bag}, {'nome': 'Provador Café', 'icone': Icons.local_cafe}, {'nome': 'Explora Ruínas', 'icone': Icons.broken_image}, {'nome': 'Rei do Táxi', 'icone': Icons.local_taxi}, {'nome': 'Mestre Bússola', 'icone': Icons.explore_off}, {'nome': 'Lobo do Mar', 'icone': Icons.directions_boat}, {'nome': 'Parques Diversão', 'icone': Icons.attractions}, {'nome': 'Embaixador', 'icone': Icons.verified}];

  Widget _menuPerfil() {
    int passAMostrar = _mostrarTodosPassaportes ? _listaPassaportes.length : 6;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.share, color: Colors.grey),
                CircleAvatar(
                  radius: 50, 
                  backgroundColor: Colors.white10, 
                  child: Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.deepOrange, fontWeight: FontWeight.bold))
                ),
                const Icon(Icons.settings, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(widget.username, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 25),
          const Text("NÍVEL 0 - Turista Iniciante", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(value: 0.0, minHeight: 12, backgroundColor: Colors.white10),
            ),
          ),
          const SizedBox(height: 30),
          
          _tituloSeccao("Locais Já Jogados"),
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(41.153360, -8.608516),
                  initialZoom: 15.0,
                  interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: const LatLng(41.153360, -8.608516),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 40),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          _tituloSeccao("Passaportes Carimbados"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.65
              ),
              itemCount: passAMostrar,
              itemBuilder: (context, index) {
                bool isLast = (index == 49);
                return Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isLast ? Icons.add_circle_outline : Icons.menu_book, color: Colors.white24, size: 35),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(_listaPassaportes[index], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white24, fontSize: 11)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _mostrarTodosPassaportes = !_mostrarTodosPassaportes),
            icon: Icon(_mostrarTodosPassaportes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.deepOrange),
            label: Text(_mostrarTodosPassaportes ? "Ver Menos" : "Ver Mais", style: const TextStyle(color: Colors.deepOrange)),
          ),

          _tituloSeccao("Galeria Privada"),
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03), 
              borderRadius: BorderRadius.circular(15), 
              border: Border.all(color: Colors.white24, width: 1)
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library_outlined, color: Colors.white24, size: 40),
                  SizedBox(height: 10),
                  Text("Ainda sem fotos", style: TextStyle(color: Colors.white30))
                ],
              ),
            ),
          ),

          _tituloSeccao("Galeria de Badges (${_listaBadges.length})"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, crossAxisSpacing: 6, mainAxisSpacing: 10
              ),
              itemCount: _listaBadges.length,
              itemBuilder: (context, index) {
                final badge = _listaBadges[index];
                return Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(badge['icone'], color: Colors.white24, size: 18), 
                      const SizedBox(height: 4),
                      Text(badge['nome'], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white24, fontSize: 6))
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            label: const Text("Terminar Sessão", style: TextStyle(color: Colors.redAccent)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- FUNÇÕES AUXILIARES ---
  Widget _tituloSeccao(String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(titulo.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? valor, Function(String?) onChange) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label, 
        filled: true, 
        fillColor: Colors.white10, 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
      ),
      dropdownColor: Colors.grey[900], 
      value: valor,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(color: Colors.white)))).toList(),
      onChanged: items.isEmpty ? null : onChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [_menuJogar(), _menuRankings(), _menuTourismgram(), _menuPerfil()];
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Jogar"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Rankings"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Tourismgram"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}