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
  int _indiceAtual = 3; 
  
  String? continenteSel, paisSel, cidadeSel;
  int numJogadores = 1;

  bool _mostrarTodosPassaportes = false;

  // 50 PASSAPORTES (CIDADES GLOBAIS REAIS)
  final List<String> _listaPassaportes = [
    'Paris', 'Nova Iorque', 'Tóquio', 'Roma', 'Londres', 'Sydney', 
    'Rio de Janeiro', 'Berlim', 'Banguecoque', 'Dubai', 'Lisboa', 
    'Madrid', 'Barcelona', 'Amesterdão', 'Viena', 'Praga', 'Budapeste', 
    'Atenas', 'Istambul', 'Cairo', 'Cidade do Cabo', 'Buenos Aires', 
    'Santiago', 'Lima', 'Bogotá', 'Cidade do México', 'Toronto', 
    'Vancouver', 'Los Angeles', 'São Francisco', 'Chicago', 'Miami', 
    'Seul', 'Pequim', 'Xangai', 'Hong Kong', 'Singapura', 'Kuala Lumpur', 
    'Jacarta', 'Nova Deli', 'Mumbai', 'Reiquiavique', 'Oslo', 'Estocolmo', 
    'Copenhaga', 'Helsínquia', 'Varsóvia', 'Moscovo', 'Dublin', 
    'Mais passaportes'
  ];

  // 50 BADGES DE TURISMO REAIS
  final List<Map<String, dynamic>> _listaBadges = [
    {'nome': 'Mochileiro', 'icone': Icons.backpack},
    {'nome': 'Cidadão Mundo', 'icone': Icons.public},
    {'nome': 'Milhas Aéreas', 'icone': Icons.flight_takeoff},
    {'nome': 'Nómada Digital', 'icone': Icons.laptop_mac},
    {'nome': 'Fotógrafo', 'icone': Icons.camera_alt},
    {'nome': 'Mergulhador', 'icone': Icons.scuba_diving},
    {'nome': 'Alpinista', 'icone': Icons.terrain},
    {'nome': 'Poliglota', 'icone': Icons.translate},
    {'nome': 'Guia Local', 'icone': Icons.map},
    {'nome': 'Campista', 'icone': Icons.holiday_village},
    {'nome': 'Rei da Praia', 'icone': Icons.beach_access},
    {'nome': 'Rota Vinhos', 'icone': Icons.wine_bar},
    {'nome': 'Caçador Auroras', 'icone': Icons.ac_unit},
    {'nome': 'Explorador Urbano', 'icone': Icons.location_city},
    {'nome': 'Ciclista', 'icone': Icons.directions_bike},
    {'nome': 'Marinheiro', 'icone': Icons.sailing},
    {'nome': 'Gastrónomo', 'icone': Icons.restaurant},
    {'nome': 'Historiador', 'icone': Icons.account_balance},
    {'nome': 'Fã Museus', 'icone': Icons.museum},
    {'nome': 'Amante Arte', 'icone': Icons.palette},
    {'nome': 'Aventureiro', 'icone': Icons.explore},
    {'nome': 'Viajante Solo', 'icone': Icons.person_outline},
    {'nome': 'Eco-Turista', 'icone': Icons.eco},
    {'nome': 'Caminhante', 'icone': Icons.directions_walk},
    {'nome': 'Surfista', 'icone': Icons.surfing},
    {'nome': 'Fã de Neve', 'icone': Icons.snowboarding},
    {'nome': 'Amante Comboios', 'icone': Icons.train},
    {'nome': 'Fã Autocarros', 'icone': Icons.directions_bus},
    {'nome': 'Piloto', 'icone': Icons.local_airport},
    {'nome': 'Madrugador', 'icone': Icons.wb_sunny},
    {'nome': 'Coruja Noturna', 'icone': Icons.nights_stay},
    {'nome': 'Festivaleiro', 'icone': Icons.celebration},
    {'nome': 'Fazedor Amigos', 'icone': Icons.people},
    {'nome': 'Rei do Hostel', 'icone': Icons.hotel},
    {'nome': 'Mestre Glamping', 'icone': Icons.cabin},
    {'nome': 'Perito Selva', 'icone': Icons.park},
    {'nome': 'Sobrevivente', 'icone': Icons.wb_twilight},
    {'nome': 'Astrónomo', 'icone': Icons.star},
    {'nome': 'Fã Cascatas', 'icone': Icons.water_drop},
    {'nome': 'Amigo Animais', 'icone': Icons.pets},
    {'nome': 'Fã Castelos', 'icone': Icons.fort},
    {'nome': 'Mala Cheia', 'icone': Icons.luggage},
    {'nome': 'Souvenirs', 'icone': Icons.shopping_bag},
    {'nome': 'Provador Café', 'icone': Icons.local_cafe},
    {'nome': 'Explora Ruínas', 'icone': Icons.broken_image},
    {'nome': 'Rei do Táxi', 'icone': Icons.local_taxi},
    {'nome': 'Mestre Bússola', 'icone': Icons.explore_off},
    {'nome': 'Lobo do Mar', 'icone': Icons.directions_boat},
    {'nome': 'Parques Diversão', 'icone': Icons.attractions},
    {'nome': 'Embaixador', 'icone': Icons.verified},
  ];

  // --- MENU 1: JOGAR ---
  Widget _menuJogar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.public, size: 60, color: Colors.deepOrange),
          const SizedBox(height: 20),
          const Text("CONFIGURAR VIAGEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 30),
          _buildDropdown("Continente", ["Europa", "América", "Ásia"], continenteSel, (v) => setState(() => continenteSel = v)),
          _buildDropdown("País", ["Portugal", "Espanha", "França"], paisSel, (v) => setState(() => paisSel = v)),
          _buildDropdown("Cidade", ["Porto", "Lisboa", "Madrid"], cidadeSel, (v) => setState(() => cidadeSel = v)),
          const SizedBox(height: 20),
          const Text("Número de Jogadores", style: TextStyle(color: Colors.grey)),
          Slider(
            value: numJogadores.toDouble(), min: 1, max: 5, divisions: 4,
            activeColor: Colors.deepOrange, label: "$numJogadores",
            onChanged: (v) => setState(() => numJogadores = v.toInt()),
          ),
          const SizedBox(height: 30),
          if (cidadeSel == "Porto") ...[
            const Text("PACKS DISPONÍVEIS NO PORTO", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10),
            _cardPack("Pack TOB (The Orange Box)", "Dificuldade: Média", true),
            _cardPack("Pack Ribeira Adventure", "Dificuldade: Alta", false),
          ],
        ],
      ),
    );
  }

  // --- MENU 2 & 3 ---
  Widget _menuRankings() => const Center(child: Text("RANKINGS", style: TextStyle(color: Colors.white)));
  Widget _menuTourismgram() => const Center(child: Text("TOURISMGRAM", style: TextStyle(color: Colors.white)));

  // --- MENU 4: PERFIL ---
  Widget _menuPerfil() {
    int passaportesAMostrar = _mostrarTodosPassaportes ? _listaPassaportes.length : 6;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          // CABEÇALHO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.share, color: Colors.grey),
                CircleAvatar(radius: 50, backgroundColor: Colors.white10, child: Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.deepOrange, fontWeight: FontWeight.bold))),
                const Icon(Icons.settings, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(widget.username, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          
          // NÍVEL
          const SizedBox(height: 25),
          const Text("NÍVEL 0 - Turista Iniciante", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(value: 0.0, minHeight: 12, backgroundColor: Colors.white10),
                ),
                const SizedBox(height: 5),
                const Text("0 / 2000 XP até ao Nível 1", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white10, thickness: 1),

          // SECÇÃO 1: MAPA REAL INTERATIVO (AGORA BLOQUEADO PARA SCROLL)
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
                  // ⚠️ AQUI ESTÁ A CORREÇÃO DO BLOQUEIO:
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.none, 
                  ),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SECÇÃO 2: PASSAPORTES 
          _tituloSeccao("Passaportes Carimbados"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10, 
                childAspectRatio: 0.65, 
              ),
              itemCount: passaportesAMostrar,
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
                        child: Text(_listaPassaportes[index], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
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

          // SECÇÃO 3: GALERIA PRIVADA 
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
                  Text("Ainda sem fotos", style: TextStyle(color: Colors.white30)),
                ],
              ),
            ),
          ),

          // SECÇÃO 4: BADGES 
          _tituloSeccao("Galeria de Badges (${_listaBadges.length})"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, 
                crossAxisSpacing: 6, 
                mainAxisSpacing: 10,
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
                      Text(badge['nome'], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white24, fontSize: 6)), 
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, filled: true, fillColor: Colors.white10),
        dropdownColor: Colors.black87, value: valor,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: onChange,
      ),
    );
  }

  Widget _cardPack(String nome, String desc, bool disponivel) {
    return Card(
      color: Colors.white10,
      child: ListTile(
        title: Text(nome, style: const TextStyle(color: Colors.white)),
        subtitle: Text(desc, style: const TextStyle(color: Colors.grey)),
        trailing: Icon(disponivel ? Icons.lock_open : Icons.lock, color: Colors.deepOrange),
        onTap: () => _dialogAtivacao(nome),
      ),
    );
  }

  void _dialogAtivacao(String pack) {
    TextEditingController codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ativar $pack"),
        content: TextField(controller: codeCtrl, decoration: const InputDecoration(hintText: "PAPTUR26")),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (codeCtrl.text.toUpperCase() == "PAPTUR26") {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(nomePack: pack)));
              }
            },
            child: const Text("VALIDAR"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [_menuJogar(), _menuRankings(), _menuTourismgram(), _menuPerfil()];
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: paginas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, onTap: (i) => setState(() => _indiceAtual = i),
        type: BottomNavigationBarType.fixed, backgroundColor: const Color(0xFF121212),
        selectedItemColor: Colors.deepOrange, unselectedItemColor: Colors.grey,
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