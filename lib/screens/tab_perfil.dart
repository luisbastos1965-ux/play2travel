import 'package:flutter/material.dart';
import '../app_settings.dart';
import 'home_screen.dart'; 
import 'dart:math';

class TabPerfil extends StatefulWidget {
  final String username;
  final String cargo;

  const TabPerfil({super.key, required this.username, required this.cargo});

  @override
  State<TabPerfil> createState() => _TabPerfilState();
}

class _TabPerfilState extends State<TabPerfil> with SingleTickerProviderStateMixin {
  late AnimationController _controllerSettings;
  bool _mostrarTodosBadges = false;
  bool _isXpExpanded = false; 
  bool _isPremium = false; 
  
  String _letraSelecionada = 'P'; 
  bool _expandirPaises = false;
  String _paisSelecionadoPerfil = 'Portugal';

  final Map<String, String> _todasBandeiras = {
    "Alemanha": "🇩🇪", "Angola": "🇦🇴", "Argentina": "🇦🇷", "Austrália": "🇦🇺",
    "Brasil": "🇧🇷", "Bélgica": "🇧🇪", "Canadá": "🇨🇦", "China": "🇨🇳", "Colômbia": "🇨🇴",
    "Dinamarca": "🇩🇰", "Espanha": "🇪🇸", "Estados Unidos": "🇺🇸", "Equador": "🇪🇨", "Egito": "🇪🇬",
    "França": "🇫🇷", "Finlândia": "🇫🇮", "Grécia": "🇬🇷", "Holanda": "🇳🇱",
    "Itália": "🇮🇹", "Índia": "🇮🇳", "Inglaterra": "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "Japão": "🇯🇵",
    "Marrocos": "🇲🇦", "México": "🇲🇽", "Moçambique": "🇲🇿", "Noruega": "🇳🇴",
    "Portugal": "🇵🇹", "Peru": "🇵🇪", "Polónia": "🇵🇱", "Paquistão": "🇵🇰",
    "Reino Unido": "🇬🇧", "Rússia": "🇷🇺", "Suíça": "🇨🇭", "Suécia": "🇸🇪", "Turquia": "🇹🇷",
  };

  final List<Map<String, String>> _listaPassaportes = [
    {'cidade': 'Porto', 'pais': 'Portugal', 'img': 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=400&q=80'},
    {'cidade': 'Lisboa', 'pais': 'Portugal', 'img': 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=400&q=80'},
    {'cidade': 'Braga', 'pais': 'Portugal', 'img': 'https://images.unsplash.com/photo-1596700547743-690c5fa60111?w=400&q=80'},
    {'cidade': 'Coimbra', 'pais': 'Portugal', 'img': 'https://images.unsplash.com/photo-1624505030804-0994fbc11bc0?w=400&q=80'},
    {'cidade': 'Faro', 'pais': 'Portugal', 'img': 'https://images.unsplash.com/photo-1627885061730-10875c7b3992?w=400&q=80'},
    {'cidade': 'Madrid', 'pais': 'Espanha', 'img': 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=400&q=80'},
    {'cidade': 'Barcelona', 'pais': 'Espanha', 'img': 'https://images.unsplash.com/photo-1583422409516-15eba53492db?w=400&q=80'},
    {'cidade': 'Sevilha', 'pais': 'Espanha', 'img': 'https://images.unsplash.com/photo-1558642084-fd07fae5282e?w=400&q=80'},
    {'cidade': 'Paris', 'pais': 'França', 'img': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400&q=80'},
    {'cidade': 'Lyon', 'pais': 'França', 'img': 'https://images.unsplash.com/photo-1569910405244-63309257bd77?w=400&q=80'},
    {'cidade': 'Roma', 'pais': 'Itália', 'img': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400&q=80'},
    {'cidade': 'Berlim', 'pais': 'Alemanha', 'img': 'https://images.unsplash.com/photo-1560930950-5cc20e80e392?w=400&q=80'},
    {'cidade': 'Londres', 'pais': 'Reino Unido', 'img': 'https://images.unsplash.com/photo-1513635269975-5969336ac1cb?w=400&q=80'},
  ];

  final List<Map<String, dynamic>> _listaBadges = [
    {'nome': 'Primeiro Login', 'icone': Icons.login, 'desbloqueado': true, 'cor': Colors.amber},
    {'nome': 'Mochileiro', 'icone': Icons.backpack, 'desbloqueado': true, 'cor': Colors.brown},
    {'nome': 'Fotógrafo', 'icone': Icons.camera_alt, 'desbloqueado': false, 'cor': Colors.purple},
    {'nome': 'Cidadão Mundo', 'icone': Icons.public, 'desbloqueado': false, 'cor': Colors.green},
    {'nome': 'Guia Local', 'icone': Icons.map, 'desbloqueado': false, 'cor': Colors.red},
    {'nome': 'Historiador', 'icone': Icons.history_edu, 'desbloqueado': false, 'cor': Colors.orange},
    {'nome': 'Socializador', 'icone': Icons.people, 'desbloqueado': false, 'cor': Colors.teal},
    {'nome': 'Flash 60m', 'icone': Icons.flash_on, 'desbloqueado': false, 'cor': Colors.yellow},
    {'nome': 'Mestre Enigmas', 'icone': Icons.psychology, 'desbloqueado': false, 'cor': Colors.indigo},
    {'nome': 'Squad Leader', 'icone': Icons.groups, 'desbloqueado': false, 'cor': Colors.deepPurple},
    {'nome': 'Duo Perfeito', 'icone': Icons.favorite, 'desbloqueado': false, 'cor': Colors.pink},
    {'nome': 'Lenda PAP', 'icone': Icons.workspace_premium, 'desbloqueado': false, 'cor': Colors.amberAccent},
  ];

  @override
  void initState() {
    super.initState();
    _controllerSettings = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controllerSettings.dispose();
    super.dispose();
  }

  Widget _tituloSeccao(String titulo, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15), 
      child: Align(alignment: Alignment.centerLeft, child: Text(titulo.toUpperCase(), style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)))
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;
    bool isAdmin = widget.cargo.toLowerCase() == 'admin';
    
    List<Map<String, String>> passaportesFiltrados = _listaPassaportes.where((p) => p['pais'] == _paisSelecionadoPerfil).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [ 
                const SizedBox(width: 48), 
                // ✨ NOVA FOTO DE ADMIN AQUI
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    border: Border.all(color: _isPremium ? Colors.amber : Colors.deepOrange, width: 3), 
                    image: DecorationImage(
                      image: NetworkImage(isAdmin 
                          ? 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=400&q=80' 
                          : 'https://randomuser.me/api/portraits/lego/1.jpg'), 
                      fit: BoxFit.cover
                    )
                  ),
                ),
                RotationTransition(turns: _controllerSettings, child: IconButton(icon: const Icon(Icons.settings, color: Colors.deepOrange, size: 32), onPressed: () => _abrirDefinicoes(context, textColor, isDark))),
              ]
            )
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.username, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
              if (_isPremium) const Padding(padding: EdgeInsets.only(left: 8.0), child: Icon(Icons.verified, color: Colors.amber, size: 24)),
            ],
          ),
          const SizedBox(height: 25),
          
          _buildBannerPremium(isDark),
          const SizedBox(height: 20),
          _buildCartaoJogadorRPG(isDark, textColor), 
          const SizedBox(height: 30),
          
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BackofficeScreen())),
                icon: const Icon(Icons.dashboard, color: Colors.white),
                label: const Text("PAINEL DE CONTROLO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
          
          _tituloSeccao("Países Visitados", textColor),
          _buildPaisesComAlfabeto(textColor),

          _tituloSeccao("Passaportes - $_paisSelecionadoPerfil", textColor),
          _buildGradePassaportes(passaportesFiltrados),

          _tituloSeccao("Galeria Privada", textColor),
          _buildGaleriaPorto(),

          _tituloSeccao("Galeria de Troféus", textColor),
          _buildGaleriaTrofeus(textColor, isDark),
          
          const SizedBox(height: 40),
          TextButton.icon(onPressed: () => Navigator.pushReplacementNamed(context, '/'), icon: const Icon(Icons.exit_to_app, color: Colors.redAccent), label: const Text("Terminar Sessão", style: TextStyle(color: Colors.redAccent))),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBannerPremium(bool isDark) {
    if (_isPremium) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFFFDF00)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10)]),
        child: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.white, size: 30),
            SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Membro Viajante PRO", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)), Text("Acesso ilimitado ao TOB IA e GPS Nativo.", style: TextStyle(color: Colors.black54, fontSize: 12))])),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context, builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              title: const Text("Desbloqueia o Mundo"),
              content: const Text("Torna-te um Viajante PRO por apenas 4.99€/mês. Acesso ao TOB IA, bússola nativa e sem anúncios."),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                ElevatedButton(onPressed: () { setState(() => _isPremium = true); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: const Text("SUBSCREVER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              ],
            )
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[200], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber, width: 2)),
          child: const Row(
            children: [
              Icon(Icons.lock_open, color: Colors.amber, size: 30),
              SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Tornar Viajante PRO", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)), Text("Desbloqueia GPS Nativo e TOB IA (4.99€)", style: TextStyle(color: Colors.grey, fontSize: 12))])),
              Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 16),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCartaoJogadorRPG(bool isDark, Color textColor) {
    return GestureDetector(
      onTap: () => setState(() => _isXpExpanded = !_isXpExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[200], borderRadius: BorderRadius.circular(20), border: Border.all(color: _isPremium ? Colors.amber : Colors.deepOrange.withOpacity(0.5))),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: _isPremium ? Colors.amber : Colors.deepOrange, child: const Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("TURISTA INICIANTE", style: TextStyle(color: _isPremium ? Colors.amber : Colors.deepOrange, fontWeight: FontWeight.bold)), Text("0 / 500 XP", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13))])),
                Icon(_isXpExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.amber, size: 30), 
              ],
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(value: 0.0, backgroundColor: isDark ? Colors.black : Colors.grey[300], color: _isPremium ? Colors.amber : Colors.deepOrange),
            
            if (_isXpExpanded) ...[
              const SizedBox(height: 20), Divider(color: Colors.deepOrange.withOpacity(0.3)), const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Missões Concluídas:", style: TextStyle(color: textColor.withOpacity(0.7))), Text("0", style: TextStyle(color: textColor, fontWeight: FontWeight.bold))]), const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Precisão nos Enigmas:", style: TextStyle(color: textColor.withOpacity(0.7))), Text("0%", style: TextStyle(color: textColor, fontWeight: FontWeight.bold))]), const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Próximo Rank:", style: TextStyle(color: textColor.withOpacity(0.7))), const Text("Viajante (Nível 1)", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))]),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPaisesComAlfabeto(Color textColor) {
    List<String> paisesDaLetra = _todasBandeiras.keys.where((p) => p.startsWith(_letraSelecionada)).toList();
    List<Widget> widgetsDaFila = [];

    widgetsDaFila.add(
      GestureDetector(
        onTap: () => _abrirMenuLetras(),
        child: Container(
          width: 55, height: 55, margin: const EdgeInsets.only(left: 20, right: 15),
          decoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)]),
          child: Center(child: Text(_letraSelecionada, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
        ),
      )
    );

    int maxMostrar = _expandirPaises ? paisesDaLetra.length : min(3, paisesDaLetra.length);
    for (int i = 0; i < maxMostrar; i++) {
      String pais = paisesDaLetra[i];
      bool isPortugal = pais == 'Portugal';
      bool isSelected = pais == _paisSelecionadoPerfil;

      const ColorFilter grayscaleFilter = ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0,
      ]);

      Widget bandeira = Text(_todasBandeiras[pais]!, style: const TextStyle(fontSize: 28));

      widgetsDaFila.add(
        GestureDetector(
          onTap: () => setState(() => _paisSelecionadoPerfil = pais),
          child: Container(
            width: 55, height: 55, margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(color: isSelected ? Colors.deepOrange.withOpacity(0.2) : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: isSelected ? Colors.deepOrange : Colors.transparent, width: 2)),
            child: Center(child: isPortugal ? bandeira : ColorFiltered(colorFilter: grayscaleFilter, child: bandeira)),
          ),
        )
      );
    }

    if (!_expandirPaises && paisesDaLetra.length > 3) {
      widgetsDaFila.add(
        GestureDetector(
          onTap: () => setState(() => _expandirPaises = true),
          child: Container(
            width: 55, height: 55, margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle, border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: const Center(child: Icon(Icons.add, color: Colors.grey)),
          ),
        )
      );
    }

    return SizedBox(height: 60, child: ListView(scrollDirection: Axis.horizontal, children: widgetsDaFila));
  }

  void _abrirMenuLetras() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<String> alfabeto = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');

    showModalBottomSheet(
      context: context, backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Escolhe a Letra", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: alfabeto.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _letraSelecionada = alfabeto[index]; _expandirPaises = false;
                        var p = _todasBandeiras.keys.where((c) => c.startsWith(_letraSelecionada)).toList();
                        if (p.isNotEmpty) _paisSelecionadoPerfil = p.first;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.deepOrange.withOpacity(0.5))),
                      child: Center(child: Text(alfabeto[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange))),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradePassaportes(List<Map<String, String>> lista) {
    if (lista.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: Text("Sem cidades registadas com esta letra.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))));
    
    return Container(
      height: 180, padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, itemCount: lista.length,
        itemBuilder: (context, index) {
          final item = lista[index];
          bool isDesbloqueado = item['cidade'] == 'Porto'; 

          const ColorFilter grayscaleFilter = ColorFilter.matrix(<double>[
            0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0,
          ]);

          return GestureDetector(
            onTap: () { 
              if (isDesbloqueado) {
                _abrirPassaportePorto(context); 
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("O Passaporte de ${item['cidade']} ainda está bloqueado! Joga mais para o desbloquear.")));
              }
            },
            child: Container(
              width: 130, margin: const EdgeInsets.only(right: 15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: isDesbloqueado ? Colors.amber : Colors.grey, width: 2)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(13), child: isDesbloqueado ? Image.network(item['img']!, fit: BoxFit.cover) : ColorFiltered(colorFilter: grayscaleFilter, child: Image.network(item['img']!, fit: BoxFit.cover))),
                  ),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent])),
                    alignment: Alignment.bottomCenter, padding: const EdgeInsets.all(10),
                    child: Text(item['cidade']!, style: TextStyle(color: isDesbloqueado ? Colors.white : Colors.grey[400], fontWeight: FontWeight.bold)),
                  ),
                  if (!isDesbloqueado) Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(15)), child: const Center(child: Icon(Icons.lock, color: Colors.white70, size: 40)))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _abrirPassaportePorto(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: const Color(0xFF1E1E1E), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("PASSAPORTE: PORTO 🇵🇹", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _itemPassaporte(context, "Pack Heritage Hunt", "Solo"), 
            _itemPassaporte(context, "Pack Urban Hero", "Solo"),
            _itemPassaporte(context, "Pack Duo Bond", "Duo"), 
            _itemPassaporte(context, "Pack Story & Senses", "Duo"),
            _itemPassaporte(context, "Pack Map Clash", "Team"), 
            _itemPassaporte(context, "Pack Fest Vibes", "Team"),
            const Divider(color: Colors.white24),
            _itemPassaporte(context, "60' of Tourism", "Especial", cor: Colors.amber),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _itemPassaporte(BuildContext context, String nome, String categoria, {Color cor = Colors.white70}) {
    return ListTile(
      leading: Icon(Icons.confirmation_number, color: cor), title: Text(nome, style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
      subtitle: Text("Categoria: $categoria", style: const TextStyle(color: Colors.white38, fontSize: 11)), 
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), 
      onTap: () { Navigator.pop(context); _abrirDiarioBordo(context, nome); },
    );
  }

  void _abrirDiarioBordo(BuildContext context, String nomePack) {
    Map<String, dynamic> historia = {};
    if (nomePack.contains("Heritage Hunt")) {
      historia = { "titulo": "Diário: Uma Jornada pelas Raízes Invictas", "cor": Colors.brown, "locais": ["Sé do Porto", "Estação de S. Bento", "Ribeira"], "missoes": ["Radar de Curiosidades", "Bingo do Património", "Câmara de Época"], "texto": "Nesta exploração a solo, desbravaste os segredos das fundações do Porto..." };
    } else if (nomePack.contains("Urban Hero")) {
      historia = { "titulo": "Diário: O Herói que a Cidade Precisava", "cor": Colors.blueGrey, "locais": ["Aliados", "Torre dos Clérigos", "Passeio das Virtudes"], "missoes": ["Diário do Explorador", "Narrativa Episódica", "Enigma do Mestre"], "texto": "A cidade precisava de um herói urbano, e tu respondeste à chamada..." };
    } else if (nomePack.contains("Duo Bond")) {
      historia = { "titulo": "Diário: Sincronia a Dois", "cor": Colors.pink, "locais": ["Jardins do Palácio de Cristal", "Miradouro da Vitória"], "missoes": ["Puzzle de Par", "Quiz de Afinidade", "Bússola Humana"], "texto": "Em dupla, a vossa sincronia foi testada aos limites!..." };
    } else if (nomePack.contains("Story & Senses")) {
      historia = { "titulo": "Diário: Uma Aventura Sensorial", "cor": Colors.purple, "locais": ["Rua das Flores", "Ponte D. Luís I", "Caves de Gaia"], "missoes": ["Destino Partilhado", "Missão Romeu e Julieta", "Prisma da Saudade"], "texto": "Mais do que andar, vocês sentiram o Porto..." };
    } else if (nomePack.contains("Map Clash")) {
      historia = { "titulo": "Diário: O Domínio das Ruas", "cor": Colors.redAccent, "locais": ["Baixa", "Mercado do Bolhão", "Rua de Santa Catarina"], "missoes": ["Domínio de Bairro", "Corrida de Pistas Elite", "Logística de Grupo"], "texto": "Caos organizado e pura adrenalina! A vossa equipa provou quem manda..." };
    } else if (nomePack.contains("Fest Vibes")) {
      historia = { "titulo": "Diário: Alegria, Martelos e Alho-Porro", "cor": Colors.orangeAccent, "locais": ["Fontainhas", "Ribeira", "Avenida dos Aliados"], "missoes": ["S. João Challenge", "Aftermovie Coletivo", "Tokens de Evento"], "texto": "Que energia incrível! O S. João Challenge testou a vossa resistência..." };
    } else {
      historia = { "titulo": "Diário: Corrida Contra o Relógio", "cor": Colors.amber, "locais": ["Aliados", "São Bento", "Sé"], "missoes": ["Sprint Turístico", "Fotografia Flash"], "texto": "60 minutos frenéticos onde cada segundo contou..." };
    }

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: const Color(0xFF1E1E1E), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85, padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(historia['titulo'], style: TextStyle(color: historia['cor'], fontSize: 22, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: historia['cor'], width: 3)), child: Icon(Icons.airplanemode_active, color: historia['cor']))]),
              const SizedBox(height: 10), const Divider(color: Colors.white24, thickness: 2), const SizedBox(height: 20),
              Text("📜 A TUA HISTÓRIA", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 10),
              Text(historia['texto'], style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6, fontStyle: FontStyle.italic)), const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("📍 LOCAIS", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 10), ...historia['locais'].map<Widget>((l) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [Icon(Icons.location_on, color: historia['cor'], size: 14), const SizedBox(width: 5), Expanded(child: Text(l, style: const TextStyle(color: Colors.white70)))]))).toList()])),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("🎯 MISSÕES", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 10), ...historia['missoes'].map<Widget>((m) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Row(children: [Icon(Icons.check_circle, color: historia['cor'], size: 14), const SizedBox(width: 5), Expanded(child: Text(m, style: const TextStyle(color: Colors.white70)))]))).toList()])),
                ],
              ),
              const SizedBox(height: 40),
              Center(child: Transform.rotate(angle: -0.1, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(border: Border.all(color: historia['cor'].withOpacity(0.8), width: 4), borderRadius: BorderRadius.circular(10)), child: Column(children: [Text("OFICIAL - PORTO", style: TextStyle(color: historia['cor'].withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2)), const SizedBox(height: 5), Text("VISTO CONCEDIDO", style: TextStyle(color: historia['cor'].withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 12))])))),
              const SizedBox(height: 30),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: historia['cor'], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("FECHAR DIÁRIO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaleriaPorto() {
    final fotosPorto = ['https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=300&q=80', 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=300&q=80', 'https://images.unsplash.com/photo-1570698473651-b2de99bae12f?w=300&q=80'];
    return SizedBox(height: 120, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: fotosPorto.length, itemBuilder: (context, index) => Container(width: 120, margin: const EdgeInsets.only(right: 10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(fotosPorto[index]), fit: BoxFit.cover)))));
  }

  Widget _buildGaleriaTrofeus(Color textColor, bool isDark) {
    int maxBadges = _mostrarTodosBadges ? _listaBadges.length : min(6, _listaBadges.length);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8), 
            itemCount: maxBadges,
            itemBuilder: (context, index) {
              final badge = _listaBadges[index]; 
              bool isUnlocked = badge['desbloqueado'];
              Color badgeColor = badge['cor'];

              return Container(
                decoration: BoxDecoration(
                  gradient: isUnlocked 
                    ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [badgeColor.withOpacity(0.9), badgeColor.withOpacity(0.3)])
                    : LinearGradient(colors: [isDark ? Colors.white10 : Colors.grey[300]!, isDark ? Colors.white12 : Colors.grey[200]!]),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isUnlocked ? badgeColor.withOpacity(0.6) : Colors.transparent, width: 2),
                  boxShadow: isUnlocked ? [BoxShadow(color: badgeColor.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isUnlocked ? badge['icone'] : Icons.lock_outline, size: 35, color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(badge['nome'], style: TextStyle(fontSize: 10, color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.6), fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_listaBadges.length > 6) 
          TextButton(
            onPressed: () => setState(() => _mostrarTodosBadges = !_mostrarTodosBadges), 
            child: Text(_mostrarTodosBadges ? "Esconder Troféus" : "Ver Todos os Troféus", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold))
          ),
      ],
    );
  }

  void _abrirDefinicoes(BuildContext context, Color textColor, bool isAppDark) {
    bool isSomAtivo = true, isVibraAtivo = true, isMusicaAtiva = false, isAcessibilidade = false, isNotificacoes = true;
    showModalBottomSheet(
      context: context, backgroundColor: isAppDark ? const Color(0xFF1E1E1E) : Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool currentDark = Theme.of(context).brightness == Brightness.dark;
          Color localText = currentDark ? Colors.white : Colors.black87;
          return Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("SALA DE CONTROLO", style: TextStyle(color: localText, fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: Icon(Icons.close, color: localText.withOpacity(0.5)), onPressed: () => Navigator.pop(context))]),
                  const SizedBox(height: 20),
                  SwitchListTile(secondary: const Icon(Icons.dark_mode, color: Colors.deepOrange), title: Text("Modo Dark", style: TextStyle(color: localText)), value: currentDark, activeColor: Colors.deepOrange, onChanged: (v) { AppSettings.instance.toggleTheme(); }),
                  SwitchListTile(secondary: const Icon(Icons.volume_up, color: Colors.blueAccent), title: Text("Efeitos Sonoros", style: TextStyle(color: localText)), value: isSomAtivo, activeColor: Colors.blueAccent, onChanged: (v) => setModalState(() => isSomAtivo = v)),
                  SwitchListTile(secondary: const Icon(Icons.music_note, color: Colors.purpleAccent), title: Text("Música de Fundo", style: TextStyle(color: localText)), value: isMusicaAtiva, activeColor: Colors.purpleAccent, onChanged: (v) => setModalState(() => isMusicaAtiva = v)),
                  SwitchListTile(secondary: const Icon(Icons.vibration, color: Colors.green), title: Text("Vibração Haptic", style: TextStyle(color: localText)), value: isVibraAtivo, activeColor: Colors.green, onChanged: (v) => setModalState(() => isVibraAtivo = v)),
                  SwitchListTile(secondary: const Icon(Icons.notifications_active, color: Colors.amber), title: Text("Notificações Push", style: TextStyle(color: localText)), value: isNotificacoes, activeColor: Colors.amber, onChanged: (v) => setModalState(() => isNotificacoes = v)),
                  SwitchListTile(secondary: const Icon(Icons.accessibility_new, color: Colors.teal), title: Text("Acessibilidade / Voz", style: TextStyle(color: localText)), subtitle: Text("Lê as missões em voz alta", style: TextStyle(color: localText.withOpacity(0.5), fontSize: 11)), value: isAcessibilidade, activeColor: Colors.teal, onChanged: (v) => setModalState(() => isAcessibilidade = v)),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}