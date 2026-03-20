import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'dart:math'; 
import 'dart:async'; 
import 'home_screen.dart'; 
import 'code_validation_screen.dart'; 
import 'gameplay_screen.dart'; 
import 'checkout_screen.dart'; 

class TabJogar extends StatefulWidget {
  const TabJogar({super.key});

  @override
  State<TabJogar> createState() => _TabJogarState();
}

class _TabJogarState extends State<TabJogar> with TickerProviderStateMixin {
  bool _iniciouDareToPlay = false;
  String? continenteSel, paisSel, cidadeSel, modoJogadoresSel, packSel;
  final List<String> _packsDescarregadosOffline = [];

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  final MapController _mapController = MapController();

  int _currentImageIndex = 0;
  Timer? _timerBg;
  final List<String> _bgImages = [
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800&q=80',
    'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?w=800&q=80',
    'https://images.unsplash.com/photo-1504150558240-1bdf2a0b6a47?w=800&q=80',
    'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=800&q=80',
    'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
  ];

  final Map<String, LatLng> _continentesCentros = {
    "América do Norte": const LatLng(45.0, -100.0),
    "América do Sul": const LatLng(-15.0, -60.0),
    "Europa": const LatLng(50.0, 10.0),
    "África": const LatLng(0.0, 20.0),
    "Ásia": const LatLng(35.0, 90.0),
    "Oceânia": const LatLng(-25.0, 135.0),
  };

  final Map<String, List<String>> _paises = {
    "Europa": ["Portugal", "Espanha", "França", "Itália", "Alemanha", "Reino Unido"],
    "América do Norte": ["Estados Unidos", "Canadá", "México"],
    "América do Sul": ["Brasil", "Argentina", "Colômbia", "Peru"],
    "Ásia": ["Japão", "China", "Índia", "Tailândia", "Emirados Árabes Unidos"],
  };
  
  final Map<String, String> _bandeiras = {
    "Portugal": "🇵🇹", "Espanha": "🇪🇸", "França": "🇫🇷", "Itália": "🇮🇹", "Alemanha": "🇩🇪", "Reino Unido": "🇬🇧",
    "Estados Unidos": "🇺🇸", "Canadá": "🇨🇦", "México": "🇲🇽", "Brasil": "🇧🇷", "Argentina": "🇦🇷", 
    "Colômbia": "🇨🇴", "Peru": "🇵🇪", "Japão": "🇯🇵", "China": "🇨🇳", "Índia": "🇮🇳", "Tailândia": "🇹🇭", "Emirados Árabes Unidos": "🇦🇪",
  };
  
  final Map<String, List<String>> _cidades = {
    "Portugal": ["Porto", "Lisboa", "Braga", "Coimbra", "Faro"],
    "Espanha": ["Madrid", "Barcelona", "Sevilha", "Valência", "Bilbau"],
    "França": ["Paris", "Lyon", "Marselha", "Nice", "Bordéus"],
    "Estados Unidos": ["Nova Iorque", "Los Angeles", "Chicago", "Miami", "São Francisco"],
    "Brasil": ["Rio de Janeiro", "São Paulo", "Salvador", "Florianópolis", "Brasília"],
    "Japão": ["Tóquio", "Quioto", "Osaka", "Hiroshima", "Sapporo"],
  };

  final Map<String, Map<String, dynamic>> _infoDetalhadaPacks = {
    'Pack Heritage Hunt': {
      'desc': 'Descobre as raízes e a história mais profunda da cidade.',
      'jogos': [
        {'nome': 'Radar Curiosidades', 'desc': 'Deteta anomalias históricas.', 'icon': Icons.radar},
        {'nome': 'Bingo Património', 'desc': 'Encontra azulejos, estátuas e brasões reais.', 'icon': Icons.grid_on},
        {'nome': 'Câmara de Época', 'desc': 'Recria o passado em fotografias.', 'icon': Icons.camera_alt},
      ]
    },
    'Pack Urban Hero': {
      'desc': 'Resolve quebra-cabeças complexos nas ruas.',
      'jogos': [
        {'nome': 'Diário Explorador', 'desc': 'Segue anotações perdidas.', 'icon': Icons.menu_book},
        {'nome': 'Narrativa Episódica', 'desc': 'Uma história revelada passo a passo.', 'icon': Icons.auto_stories},
        {'nome': 'Enigma do Mestre', 'desc': 'Desvenda o código final.', 'icon': Icons.extension},
      ]
    },
    'Pack Duo Bond': {
      'desc': 'Perfeito para casais ou melhores amigos.',
      'jogos': [
        {'nome': 'Puzzle de Par', 'desc': 'Cada um recebe metade das pistas.', 'icon': Icons.favorite},
        {'nome': 'Quiz Afinidade', 'desc': 'Respondam a perguntas sobre vocês.', 'icon': Icons.quiz},
        {'nome': 'Bússola Humana', 'desc': 'Confiança total para chegar ao destino!', 'icon': Icons.explore},
      ]
    },
    'Pack Story & Senses': {
      'desc': 'Uma jornada focada nas emoções e nos cheiros da cidade.',
      'jogos': [
        {'nome': 'Destino Partilhado', 'desc': 'Decisões que mudam a lenda.', 'icon': Icons.signpost},
        {'nome': 'Missão Romeu e Julieta', 'desc': 'A carta de amor escondida.', 'icon': Icons.mail},
        {'nome': 'Prisma da Saudade', 'desc': 'Ouve os sons antigos nos miradouros.', 'icon': Icons.headphones},
      ]
    },
    'Pack Map Clash': {
      'desc': 'Grupos grandes? Dividam-se em equipas e dominem a zona.',
      'jogos': [
        {'nome': 'Domínio Bairro', 'desc': 'Faz check-in para conquistar território.', 'icon': Icons.flag},
        {'nome': 'Corrida Pistas Elite', 'desc': 'Apenas a equipa mais rápida vence.', 'icon': Icons.directions_run},
        {'nome': 'Logística Grupo', 'desc': 'Gerem os vossos recursos virtuais.', 'icon': Icons.inventory},
      ]
    },
    'Pack Fest Vibes': {
      'desc': 'Energia, música e tradição. Feito para épocas de festa.',
      'jogos': [
        {'nome': 'S. João Challenge', 'desc': 'Missões físicas: sobe as escadas rápido!', 'icon': Icons.local_fire_department},
        {'nome': 'Aftermovie Coletivo', 'desc': 'Pequenos vídeos para o filme final.', 'icon': Icons.videocam},
        {'nome': 'Tokens de Evento', 'desc': 'Colecionem moedas nas zonas de festa.', 'icon': Icons.monetization_on},
      ]
    },
    "60' of Tourism": {
      'desc': 'O roteiro sprint. Vê o principal da cidade numa hora cravada.',
      'jogos': [
        {'nome': 'Contra-Relógio', 'desc': 'Tens 60 minutos para 5 pontos obrigatórios.', 'icon': Icons.timer},
      ]
    },
    'Pack United Experiences': {
      'desc': 'Uma experiência focada na diversidade cultural.',
      'jogos': [
        {'nome': 'Cidadão do Mundo', 'desc': 'Influência de países na arquitetura local.', 'icon': Icons.public},
      ]
    },
    'Quiet Edition': {
      'desc': 'Focado no bem-estar, na natureza e na desconexão digital.',
      'jogos': [
        {'nome': 'Desintoxicação', 'desc': 'Ouve a natureza sem olhar para o ecrã.', 'icon': Icons.nature_people},
      ]
    },
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _timerBg = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (mounted) setState(() => _currentImageIndex = (_currentImageIndex + 1) % _bgImages.length);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerBg?.cancel(); 
    super.dispose();
  }

  void _abrirInfoDosJogos(BuildContext context, String packNome) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;

    Map<String, dynamic>? info = _infoDetalhadaPacks[packNome];
    if (info == null) {
      info = {
        'desc': 'Este roteiro foi gerado e adaptado exclusivamente para ti.',
        'jogos': [
          {'nome': 'Seleção Dinâmica', 'desc': 'Múltiplos jogos combinados para o teu estilo.', 'icon': Icons.casino}
        ]
      };
    }

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Mecânica do: $packNome", style: TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold))),
                IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 10),
            Text(info!['desc'], style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text("OS MINI-JOGOS:", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 15),
            ...info['jogos'].map<Widget>((jogo) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), shape: BoxShape.circle), child: Icon(jogo['icon'], color: Colors.deepOrange, size: 24)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(jogo['nome'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(jogo['desc'], style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("ENTENDIDO!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _mostrarOpcoesDePagamento(String pack, String preco) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context, backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Desbloquear $pack", style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text("Como preferes ativar o teu roteiro?", style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14)),
            const SizedBox(height: 25),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CodeValidationScreen(nomePack: pack)));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.deepOrange.withOpacity(0.3))), tileColor: isDark ? Colors.white10 : Colors.grey[100],
              leading: const CircleAvatar(backgroundColor: Colors.deepOrange, child: Icon(Icons.storefront, color: Colors.white)), title: Text("Pagar num Parceiro Local", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), subtitle: Text("Usa o código de ativação do voucher.", style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11)), trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 15),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(nomePack: pack, preco: preco)));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.green.withOpacity(0.3))), tileColor: isDark ? Colors.white10 : Colors.grey[100],
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.credit_card, color: Colors.white)), title: Text("Pagamento Digital", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), subtitle: Text("Seguro com MBWay, Cartão ou Pay.", style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11)), trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

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
      packs.add({'nome': "60' of Tourism", 'tipo': 'Especial', 'jogos': 'Contra-relógio pelos marcos principais.', 'tempo': '01:00 hora', 'preco': '15€', 'tamanho': '12 MB'});
      packs.add({'nome': 'Pack United Experiences', 'tipo': 'Especial', 'jogos': 'Experiência imersiva e multicultural única.', 'tempo': 'Sem limite', 'preco': '10€', 'tamanho': '40 MB'});
      packs.add({'nome': 'Quiet Edition', 'tipo': 'Especial', 'jogos': 'Desconexão digital, relaxamento e natureza.', 'tempo': 'Sem limite', 'preco': '120€', 'tamanho': '20 MB'});
    } else if (modoJogadoresSel == "Personalizar") {
      packs.add({'nome': 'Pack Personalizado', 'tipo': 'Custom', 'jogos': 'Seleciona os 3 jogos que mais combinam contigo.', 'tempo': 'À tua medida', 'preco': '100€', 'tamanho': 'Variável'});
    } else if (modoJogadoresSel == "Aleatório") {
      packs.add({'nome': 'Roleta Aleatória', 'tipo': 'Random', 'jogos': 'Deixa o destino escolher 3 jogos surpreendentes.', 'tempo': 'Surpresa', 'preco': '80€', 'tamanho': 'Variável'});
    }
    return packs;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;

    if (!_iniciouDareToPlay) {
      return Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500), 
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.network(_bgImages[_currentImageIndex], key: ValueKey<int>(_currentImageIndex), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore, color: Colors.deepOrange, size: 60), const SizedBox(height: 20),
              const Text("O MUNDO É O\nTEU TABULEIRO", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2, height: 1.2), textAlign: TextAlign.center), const SizedBox(height: 15),
              Text("Desbloqueia roteiros secretos, ganha XP\ne domina a tua cidade.", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16), textAlign: TextAlign.center), const SizedBox(height: 60),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.5), blurRadius: 25, spreadRadius: 2)], borderRadius: BorderRadius.circular(30)),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _iniciouDareToPlay = true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: const Text("DARE TO PLAY", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O TOB está a analisar o teu perfil..."))),
        backgroundColor: Colors.deepPurpleAccent, elevation: 8,
        icon: const Icon(Icons.rocket_launch, color: Colors.white),
        label: const Text("Falar com o TOB", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 100), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text("CONFIGURAR VIAGEM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)), IconButton(icon: const Icon(Icons.refresh, color: Colors.grey), onPressed: () => setState(() { _iniciouDareToPlay = false; continenteSel = null; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; })) ]),
            const SizedBox(height: 30), Text("1. Toca no Continente", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)), const SizedBox(height: 10),
            _buildMapaContinentes(),
            if (continenteSel != null) ...[ const SizedBox(height: 25), Text("2. País", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)), const SizedBox(height: 10), _buildCarrosselPaises(_paises[continenteSel] ?? []) ],
            if (paisSel != null) ...[ const SizedBox(height: 20), _buildDropdown("3. Cidade", _cidades[paisSel] ?? [], cidadeSel, (v) => setState(() { cidadeSel = v; modoJogadoresSel = null; packSel = null; })) ],
            if (cidadeSel != null) ...[ const SizedBox(height: 25), Text("4. Jogadores / Estilo", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)), const SizedBox(height: 10), _buildBotoesModoJogo() ],
            if (modoJogadoresSel != null) ...[ const SizedBox(height: 30), const Text("5. Packs Disponíveis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)), const SizedBox(height: 15), ..._obterPacks().map((pack) => _cardPackCompleto(pack)) ],
            
            if (packSel != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _abrirInfoDosJogos(context, packSel!),
                icon: const Icon(Icons.lightbulb, color: Colors.amber),
                label: const Text("SABER MAIS SOBRE OS JOGOS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.amber), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: packSel != null ? () {
                if (packSel == "Pack Personalizado") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomPackBuilderScreen()));
                } else if (packSel == "Roleta Aleatória") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RandomPackQuizScreen()));
                } else if (HomeScreen.packsDesbloqueadosNestaSessao.contains(packSel)) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(nomePack: packSel!)));
                } else {
                  String precoPack = _obterPacks().firstWhere((p) => p['nome'] == packSel)['preco'];
                  _mostrarOpcoesDePagamento(packSel!, precoPack); 
                }
              } : null, 
              style: ElevatedButton.styleFrom(disabledBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[300], backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: Text(packSel != null ? "INICIAR: $packSel" : "SELECIONA UM PACK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: packSel != null ? Colors.white : Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapaContinentes() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 200, 
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: isDark ? Colors.white24 : Colors.grey[300]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlutterMap(
          mapController: _mapController,
          options: const MapOptions(initialCenter: LatLng(20.0, 0.0), initialZoom: 1.0, interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate)),
          children: [
            TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
            MarkerLayer(
              markers: _continentesCentros.entries.map((e) {
                bool isSelected = continenteSel == e.key;
                return Marker(
                  point: e.value, width: 60, height: 60,
                  child: GestureDetector(
                    onTap: () {
                      setState(() { continenteSel = e.key; paisSel = null; cidadeSel = null; modoJogadoresSel = null; packSel = null; });
                      _mapController.move(e.value, 2.5);
                    },
                    child: isSelected ? ScaleTransition(scale: _scaleAnimation, child: const Icon(Icons.location_searching, color: Colors.deepOrange, size: 40)) : Container(margin: const EdgeInsets.all(20), decoration: BoxDecoration(color: isDark ? Colors.white30 : Colors.black26, shape: BoxShape.circle)),
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
      child: Row(
        children: [
          _btnModoUnico("Solo", Icons.person), const SizedBox(width: 8), 
          _btnModoUnico("Duo", Icons.people), const SizedBox(width: 8), 
          _btnModoUnico("Team", Icons.groups), const SizedBox(width: 8), 
          _btnModoUnico("Especiais", Icons.star), const SizedBox(width: 8),
          _btnModoUnico("Personalizar", Icons.tune), const SizedBox(width: 8),
          _btnModoUnico("Aleatório", Icons.casino),
        ]
      ),
    );
  }

  Widget _btnModoUnico(String modo, IconData icon) {
    bool isSelected = modoJogadoresSel == modo;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color corAtiva = (modo == "Personalizar") ? Colors.orange : (modo == "Aleatório" ? Colors.pink : Colors.deepOrange);

    return GestureDetector(
      onTap: () => setState(() { modoJogadoresSel = modo; packSel = null; }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), width: 85, padding: const EdgeInsets.symmetric(vertical: 15), 
        decoration: BoxDecoration(color: isSelected ? corAtiva.withOpacity(0.2) : (isDark ? Colors.white10 : Colors.grey[200]), border: Border.all(color: isSelected ? corAtiva : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)), 
        child: Column(children: [ Icon(icon, color: isSelected ? corAtiva : Colors.grey, size: 30), const SizedBox(height: 8), Text(modo, style: TextStyle(color: isSelected ? corAtiva : Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis) ])
      ),
    );
  }

  Widget _buildCarrosselPaises(List<String> paisesDisponiveis) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 90, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal, itemCount: paisesDisponiveis.length, 
        itemBuilder: (context, index) { 
          String pais = paisesDisponiveis[index]; bool isSelecionado = paisSel == pais; 
          return GestureDetector(
            onTap: () => setState(() { paisSel = pais; cidadeSel = null; modoJogadoresSel = null; packSel = null; }), 
            child: Container(
              width: 85, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: isSelecionado ? Colors.deepOrange.withOpacity(0.2) : (isDark ? Colors.white10 : Colors.grey[200]), border: Border.all(color: isSelecionado ? Colors.deepOrange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)), 
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(_bandeiras[pais] ?? "🏳️", style: const TextStyle(fontSize: 32)), const SizedBox(height: 6), Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Text(pais, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelecionado ? Colors.deepOrange : Colors.grey, fontSize: 11))) ])
            )
          ); 
        }
      )
    );
  }

  Widget _cardPackCompleto(Map<String, dynamic> pack) {
    bool isSelecionado = packSel == pack['nome'];
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isDownloaded = _packsDescarregadosOffline.contains(pack['nome']);
    
    Color corBorda = isSelecionado ? Colors.deepOrange : (pack['tipo'] == 'Especial' ? Colors.blue : (pack['tipo'] == 'Regional' ? Colors.purple : (pack['tipo'] == 'Custom' ? Colors.orange : (pack['tipo'] == 'Random' ? Colors.pink : (isDark ? Colors.white10 : Colors.grey[300]!)))));
    
    return GestureDetector(
      onTap: () => setState(() => packSel = pack['nome']), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15), 
        decoration: BoxDecoration(color: isSelecionado ? corBorda.withOpacity(0.1) : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]), border: Border.all(color: corBorda, width: isSelecionado ? 2 : 1), borderRadius: BorderRadius.circular(15)), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Expanded(child: Text(pack['nome'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87))), Text(pack['preco'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)) ]), 
            const SizedBox(height: 8), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.access_time, color: Colors.grey, size: 16), const SizedBox(width: 5), Text(pack['tempo'], style: const TextStyle(color: Colors.grey, fontSize: 13))]),
                GestureDetector(
                  onTap: () {
                    if (!isDownloaded) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A descarregar ${pack['tamanho']} para Modo Offline..."), backgroundColor: Colors.blueAccent));
                      setState(() => _packsDescarregadosOffline.add(pack['nome']));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Este roteiro já está guardado no telemóvel para jogar sem GPS/Internet!")));
                    }
                  },
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDownloaded ? Colors.green.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(isDownloaded ? Icons.cloud_done : Icons.cloud_download, color: isDownloaded ? Colors.green : Colors.blueAccent, size: 14), const SizedBox(width: 4), Text(isDownloaded ? "Descarregado" : pack['tamanho'], style: TextStyle(color: isDownloaded ? Colors.green : Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold))])),
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
}

// BASE DE DADOS COMPLETA DOS JOGOS PARA A IA SORTEAR OU MONTAR
final List<Map<String, dynamic>> _masterGames = [
  {'nome': 'Radar de Curiosidade', 'tipo': 'mapa', 'missao': 'Encontra datas gravadas, brasões ou azulejos.', 'progresso': 0.0, 'feitos': 0, 'total': 3, 'icon': Icons.radar, 'tema': 'História'},
  {'nome': 'Bingo do Património', 'tipo': 'mapa', 'missao': 'Encontra os elementos da grelha.', 'progresso': 0.0, 'feitos': 0, 'total': 5, 'icon': Icons.grid_on, 'tema': 'História'},
  {'nome': 'Câmara de Época', 'tipo': 'camara', 'missao': 'Cria uma foto inspirada em épocas históricas.', 'progresso': 0.0, 'feitos': 0, 'total': 12, 'icon': Icons.camera_alt, 'tema': 'História'},
  {'nome': 'Diário do Explorador', 'tipo': 'narrativa', 'missao': 'Regista algo inesperado.', 'progresso': 0.0, 'feitos': 0, 'total': 1, 'icon': Icons.menu_book, 'tema': 'Urbano'},
  {'nome': 'Narrativa Episódica', 'tipo': 'narrativa', 'missao': 'Toma uma decisão para avançar.', 'progresso': 0.0, 'feitos': 0, 'total': 3, 'icon': Icons.auto_stories, 'tema': 'Urbano'},
  {'nome': 'Enigma do Mestre', 'tipo': 'narrativa', 'missao': 'Resolve o enigma usando pistas.', 'progresso': 0.0, 'feitos': 0, 'total': 1, 'icon': Icons.extension, 'tema': 'Urbano'},
  {'nome': 'Puzzle de Par', 'tipo': 'narrativa', 'missao': 'Comunica com o parceiro para juntar pistas.', 'progresso': 0.0, 'feitos': 0, 'total': 4, 'icon': Icons.favorite, 'tema': 'Duo'},
  {'nome': 'Quiz de Afinidade', 'tipo': 'quiz', 'missao': 'O que escolheu o teu parceiro?', 'progresso': 0.0, 'feitos': 0, 'total': 5, 'icon': Icons.quiz, 'tema': 'Duo'},
  {'nome': 'Bússola Humana', 'tipo': 'mapa', 'missao': 'Guia o teu parceiro até ao destino.', 'progresso': 0.0, 'feitos': 0, 'total': 6, 'icon': Icons.explore, 'tema': 'Duo'},
  {'nome': 'Destino Partilhado', 'tipo': 'narrativa', 'missao': 'Adiciona um elemento à vossa narrativa.', 'progresso': 0.0, 'feitos': 0, 'total': 7, 'icon': Icons.signpost, 'tema': 'Emoções'},
  {'nome': 'Prisma da Saudade', 'tipo': 'quiz', 'missao': 'Que emoção associas a este lugar?', 'progresso': 0.0, 'feitos': 0, 'total': 5, 'icon': Icons.headphones, 'tema': 'Emoções'},
  {'nome': 'S. João Challenge', 'tipo': 'especifico', 'missao': 'A grande competição de S. João!', 'progresso': 0.0, 'feitos': 0, 'total': 3, 'icon': Icons.festival, 'tema': 'Festa'},
  {'nome': 'Tokens de Evento', 'tipo': 'especifico', 'missao': 'Gere o orçamento da tua equipa.', 'progresso': 0.0, 'feitos': 0, 'total': 5, 'icon': Icons.monetization_on, 'tema': 'Festa'},
  {'nome': 'Quiet Edition', 'tipo': 'especifico', 'missao': 'Desliga-te do ecrã e vive a natureza.', 'progresso': 0.0, 'feitos': 0, 'total': 1, 'icon': Icons.nature_people, 'tema': 'Relax'},
];

// CONSTRUTOR DE PACK PERSONALIZADO
class CustomPackBuilderScreen extends StatefulWidget {
  const CustomPackBuilderScreen({super.key});
  @override State<CustomPackBuilderScreen> createState() => _CustomPackBuilderScreenState();
}
class _CustomPackBuilderScreenState extends State<CustomPackBuilderScreen> {
  final List<Map<String, dynamic>> _jogosSelecionados = [];

  void _toggleJogo(Map<String, dynamic> jogo) {
    setState(() {
      if (_jogosSelecionados.contains(jogo)) { _jogosSelecionados.remove(jogo); } 
      else if (_jogosSelecionados.length < 3) { _jogosSelecionados.add(jogo); } 
    });
  }

  void _concluirCriacao() {
    List<String> palavras = _jogosSelecionados.map((j) => (j['tema'] as String)).toSet().toList();
    String nomeGerado = "Pack ${palavras.join(' & ')}";
    GameplayScreen.packsDinamicos[nomeGerado] = _jogosSelecionados;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutScreen(nomePack: nomeGerado, preco: "100€")));
  }

  @override Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: textColor), title: Text("Cria a tua Aventura", style: TextStyle(color: textColor, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("A tua Viagem, As Tuas Regras.", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
            Text("Seleciona exatamente 3 experiências para adicionares ao teu Roteiro Premium. A nossa IA vai gerar o nome final.", style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14)), const SizedBox(height: 20),
            Row(children: [Text("Selecionados: ", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), Text("${_jogosSelecionados.length}/3", style: TextStyle(color: _jogosSelecionados.length == 3 ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 18))]), const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(itemCount: _masterGames.length, itemBuilder: (context, index) { 
                final jogo = _masterGames[index]; bool isSel = _jogosSelecionados.contains(jogo); 
                return GestureDetector(
                  onTap: () => _toggleJogo(jogo), 
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15), 
                    decoration: BoxDecoration(color: isSel ? Colors.orange.withOpacity(0.15) : (isDark ? Colors.white10 : Colors.white), border: Border.all(color: isSel ? Colors.orange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(15)), 
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isSel ? Colors.orange : (isDark ? Colors.white24 : Colors.grey[200]), shape: BoxShape.circle), child: Icon(jogo['icon'], color: isSel ? Colors.white : Colors.grey)), const SizedBox(width: 15), 
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(jogo['nome'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)), Text(jogo['tema'], style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))])), 
                        if (isSel) const Icon(Icons.check_circle, color: Colors.orange)
                      ]
                    )
                  )
                ); 
              })
            ),
            ElevatedButton(onPressed: _jogosSelecionados.length == 3 ? _concluirCriacao : null, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("GERAR ROTEIRO (100€)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))
          ],
        ),
      ),
    );
  }
}

// CONSTRUTOR DA ROLETA ALEATÓRIA
class RandomPackQuizScreen extends StatefulWidget {
  const RandomPackQuizScreen({super.key});
  @override State<RandomPackQuizScreen> createState() => _RandomPackQuizScreenState();
}
class _RandomPackQuizScreenState extends State<RandomPackQuizScreen> {
  int _step = 0;
  bool _aGerarMagia = false;

  final List<Map<String, dynamic>> _perguntas = [
    {"pergunta": "Qual é a tua Vibe hoje?", "opcoes": ["Exploradora", "Competitiva", "Relaxada", "Festeira"], "icon": Icons.psychology},
    {"pergunta": "Com quem estás a viajar?", "opcoes": ["Sozinho/a", "Com a minha alma gémea", "Com o meu grupo de amigos", "Em Família"], "icon": Icons.group},
    {"pergunta": "O que preferes fazer?", "opcoes": ["Resolver Quebra-Cabeças", "Tirar Fotos Épicas", "Caminhar e Ouvir Histórias"], "icon": Icons.directions_walk},
  ];

  void _responderEAvancar() async {
    if (_step < _perguntas.length - 1) {
      setState(() => _step++);
    } else {
      setState(() => _aGerarMagia = true);
      await Future.delayed(const Duration(seconds: 3));
      
      List<Map<String, dynamic>> copiaJogos = List.from(_masterGames);
      copiaJogos.shuffle();
      List<Map<String, dynamic>> tresSorteados = copiaJogos.sublist(0, 3);

      final List<String> adjetivos = ["Misterioso", "Supremo", "Oculto", "Épico", "Mágico"];
      final random = Random();
      String nomeSorteado = "Roleta: O Pack ${adjetivos[random.nextInt(adjetivos.length)]}";
      
      GameplayScreen.packsDinamicos[nomeSorteado] = tresSorteados;

      if (!mounted) return;
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutScreen(nomePack: nomeSorteado, preco: "80€")));
    }
  }

  @override Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: textColor)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _aGerarMagia 
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const SizedBox(height: 100, width: 100, child: CircularProgressIndicator(color: Colors.pink, strokeWidth: 8)), const SizedBox(height: 40), Text("O TOB está a analisar...", style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text("A selecionar 3 jogos aleatórios da base de dados e a montar o teu Pack Surpresa.", style: TextStyle(color: textColor.withOpacity(0.5)), textAlign: TextAlign.center)])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_perguntas[_step]['icon'], size: 60, color: Colors.pink), const SizedBox(height: 30), Text(_perguntas[_step]['pergunta'], style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center), const SizedBox(height: 40), ...(_perguntas[_step]['opcoes'] as List<String>).map((opcao) => Padding(padding: const EdgeInsets.only(bottom: 15), child: ElevatedButton(onPressed: _responderEAvancar, style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white10 : Colors.white, foregroundColor: Colors.pink, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text(opcao, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))))) ]),
        ),
      ),
    );
  }
}