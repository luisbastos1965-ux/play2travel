import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:flutter_tts/flutter_tts.dart'; 

class TabMural extends StatefulWidget {
  const TabMural({super.key});

  @override
  State<TabMural> createState() => _TabMuralState();
}

class _TabMuralState extends State<TabMural> {
  bool _verMapaMural = false;
  String _filtroAtual = 'Todos';
  final List<String> _filtrosMural = ['Todos', 'Fest Vibes', 'Duo Bond', 'Heritage Hunt', 'Urban Hero', 'Map Clash', "60' of Tourism"];

  final FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop(); 
    super.dispose();
  }

  Future<void> _abrirGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(url)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao abrir o mapa.')));
    }
  }

  Future<void> _falarTexto(String texto) async {
    await flutterTts.setLanguage("pt-PT");
    await flutterTts.setSpeechRate(0.5); 
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(texto);
  }

  final List<Map<String, dynamic>> _expedicoesAtivas = [
    {'nome': 'Lourenço', 'img': 'assets/lourenco.jpg', 'pack': 'Heritage Hunt', 'distancia': 'a 200m', 'cor': Colors.brown},
    {'nome': 'Maria', 'img': 'assets/maria.jpg', 'pack': 'Duo Bond', 'distancia': 'a 1.2km', 'cor': Colors.pink},
    {'nome': 'Paula', 'img': 'assets/paula.jpg', 'pack': "60' of Tourism", 'distancia': 'a 500m', 'cor': Colors.amber},
  ];

  final Map<String, dynamic> _postalDeOuro = {
    'user': 'Nádia', 'userImg': 'assets/nadia.jpg',
    'local': 'Livraria Lello, Porto 🇵🇹', 'pack': 'Story & Senses',
    'coords': const LatLng(41.1469, -8.6148),
    'img': 'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?w=600&q=80', 
    'boosts': 891, 'xp_ganho': 100, 
    'caption': 'A magia da Lello e um enigma que quase nos fez perder a cabeça! A não perder. 📚✨',
    'isBoosted': true, 'carimboColor': Colors.purple,
  };

  final List<Map<String, dynamic>> _postais = [
    {
      'user': 'Lourenço', 'userImg': 'assets/lourenco.jpg',
      'local': 'Ribeira, Porto 🇵🇹', 'pack': 'Fest Vibes',
      'coords': const LatLng(41.1403, -8.6116),
      'img': 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80',
      'boosts': 34, 'xp_ganho': 50, 
      'caption': 'Missão fotográfica concluída! Os segredos das ruelas da Ribeira foram desvendados. 🕵️‍♀️🍷',
      'isBoosted': false, 'carimboColor': Colors.orangeAccent,
    },
    {
      'user': 'Maria', 'userImg': 'assets/maria.jpg',
      'local': 'Jardins do Palácio de Cristal 🇵🇹', 'pack': 'Duo Bond',
      'coords': const LatLng(41.1481, -8.6258),
      'img': 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=600&q=80', 
      'boosts': 112, 'xp_ganho': 75, 
      'caption': 'Puzzle de par no meio dos pavões. Que vista incrível para o Douro! 🦚🌳',
      'isBoosted': true, 'carimboColor': Colors.pink,
    },
    {
      'user': 'Paula', 'userImg': 'assets/paula.jpg',
      'local': 'Sé do Porto 🇵🇹', 'pack': 'Urban Hero',
      'coords': const LatLng(41.1428, -8.6111),
      'img': 'https://images.unsplash.com/photo-1570698473651-b2de99bae12f?w=600&q=80',
      'boosts': 45, 'xp_ganho': 60, 
      'caption': 'O Enigma do Mestre foi difícil, mas as fundações da Sé não têm segredos para mim. 🏰⚔️',
      'isBoosted': false, 'carimboColor': Colors.blueGrey,
    },
    {
      'user': 'Lourenço', 'userImg': 'assets/lourenco.jpg',
      'local': 'Avenida dos Aliados 🇵🇹', 'pack': "60' of Tourism",
      'coords': const LatLng(41.1466, -8.6110), 
      'img': 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=600&q=80',
      'boosts': 210, 'xp_ganho': 80, 
      'caption': 'Sprint final nos Aliados! Acabámos com 2 minutos no relógio. Coração a mil! ⏱️🏃‍♂️',
      'isBoosted': true, 'carimboColor': Colors.amber,
    },
    {
      'user': 'Maria', 'userImg': 'assets/maria.jpg',
      'local': 'Mercado do Bolhão 🇵🇹', 'pack': 'Map Clash',
      'coords': const LatLng(41.1488, -8.6067), 
      // ✨ FOTO SUBSTITUÍDA POR UMA 100% GARANTIDA (Mercado/Rua)
      'img': 'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?w=600&q=80', 
      'boosts': 67, 'xp_ganho': 90, 
      'caption': 'Domínio do Bairro garantido. Ninguém conhece os cantos ao Bolhão como nós! 🛒🏆',
      'isBoosted': false, 'carimboColor': Colors.redAccent,
    },
  ];

  Widget _construirAvatar(String imgPath, double tamanho) {
    if (imgPath.startsWith('http')) {
      return Image.network(imgPath, width: tamanho, height: tamanho, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: tamanho, height: tamanho, color: Colors.grey, child: const Icon(Icons.person)));
    } else {
      return Image.asset(imgPath, width: tamanho, height: tamanho, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: tamanho, height: tamanho, color: Colors.grey, child: const Icon(Icons.person)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("EXPEDIÇÕES ATIVAS", style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
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
                                ClipOval(child: _construirAvatar(exp['img'], 35)),
                                const SizedBox(width: 10),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(exp['nome'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
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
                    const SizedBox(height: 80),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapaDoMural(bool isDark) {
    List<Map<String, dynamic>> todosPostais = [_postalDeOuro, ..._postais];
    Map<String, Map<String, dynamic>> postaisUnicos = {};
    
    for (var postal in todosPostais) {
      if (!postaisUnicos.containsKey(postal['user'])) {
        postaisUnicos[postal['user']] = postal; 
      }
    }

    return FlutterMap(
      options: const MapOptions(initialCenter: LatLng(41.144, -8.613), initialZoom: 14.0),
      children: [
        TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
        MarkerLayer(
          markers: postaisUnicos.values.map((postal) {
            bool isOuro = postal['user'] == _postalDeOuro['user'];
            
            return Marker(
              point: postal['coords'], 
              width: isOuro ? 60 : 45, 
              height: isOuro ? 60 : 45,
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Explorador(a): ${postal['user']}"))),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    border: Border.all(color: postal['carimboColor'], width: isOuro ? 3 : 2), 
                    boxShadow: [BoxShadow(color: postal['carimboColor'].withOpacity(isOuro ? 0.8 : 0.5), blurRadius: isOuro ? 15 : 8)]
                  ),
                  child: ClipOval(child: _construirAvatar(postal['userImg'], isOuro ? 60 : 45)),
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
          Padding(padding: const EdgeInsets.all(15), child: Row(children: [ ClipOval(child: _construirAvatar(_postalDeOuro['userImg'], 40)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(_postalDeOuro['user'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)), Row(children: [const Icon(Icons.location_on, color: Colors.deepOrange, size: 12), const SizedBox(width: 4), Expanded(child: Text(_postalDeOuro['local'], style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12), overflow: TextOverflow.ellipsis))]) ])) ])),
          Stack(children: [ ClipRRect(child: Image.network(_postalDeOuro['img'], width: double.infinity, height: 250, fit: BoxFit.cover)), Positioned(top: 15, right: 15, child: Transform.rotate(angle: 0.2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _postalDeOuro['carimboColor'].withOpacity(0.9), border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(5)), child: Text(_postalDeOuro['pack'].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1))))) ]),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [ 
                    Row(children: [ Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange)), child: Row(children: [const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 18), const SizedBox(width: 6), Text("${_postalDeOuro['boosts']} Boosts", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12))])), const SizedBox(width: 10), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.stars, color: Colors.amber, size: 18), const SizedBox(width: 6), Text("+${_postalDeOuro['xp_ganho']} XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12))])) ]), 
                    IconButton(icon: const Icon(Icons.directions, color: Colors.blueAccent), onPressed: () => _abrirGoogleMaps(_postalDeOuro['coords'].latitude, _postalDeOuro['coords'].longitude)) 
                  ]
                ),
                const SizedBox(height: 15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("REGISTO DA MISSÃO:", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    GestureDetector(onTap: () => _falarTexto(_postalDeOuro['caption']), child: const Icon(Icons.volume_up, color: Colors.blueAccent, size: 22)),
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
                ClipOval(child: _construirAvatar(postal['userImg'], 40)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ Text(postal['user'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)), Row(children: [const Icon(Icons.location_on, color: Colors.deepOrange, size: 12), const SizedBox(width: 4), Expanded(child: Text(postal['local'], style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12), overflow: TextOverflow.ellipsis))]) ])),
                Icon(Icons.more_horiz, color: textColor.withOpacity(0.5)),
              ],
            ),
          ),
          
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(postal['img'], width: double.infinity, height: 300, fit: BoxFit.cover)),
              Positioned(
                top: 15, right: 15,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: postal['carimboColor'].withOpacity(0.9), border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(5)), child: Text(postal['pack'].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1))),
                ),
              ),
            ],
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
                    IconButton(icon: const Icon(Icons.directions, color: Colors.blueAccent), onPressed: () => _abrirGoogleMaps(postal['coords'].latitude, postal['coords'].longitude)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("REGISTO DA MISSÃO:", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    GestureDetector(onTap: () => _falarTexto(postal['caption']), child: const Icon(Icons.volume_up, color: Colors.blueAccent, size: 22)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(postal['caption'], style: TextStyle(color: textColor, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}