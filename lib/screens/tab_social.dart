import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; 
import '../app_settings.dart';
import 'home_screen.dart'; 

class TabSocial extends StatefulWidget {
  const TabSocial({super.key});

  @override
  State<TabSocial> createState() => _TabSocialState();
}

class _TabSocialState extends State<TabSocial> {
  bool _mostrarGrupos = false;

  final List<Map<String, dynamic>> _pedidosPendentes = [
    {'nome': 'João Silva', 'user': '@joaos', 'img': 'https://randomuser.me/api/portraits/men/15.jpg'},
    {'nome': 'Sofia Martins', 'user': '@sofiam', 'img': 'https://randomuser.me/api/portraits/women/12.jpg'},
    {'nome': 'Tiago Costa', 'user': '@tiagoc', 'img': 'https://randomuser.me/api/portraits/men/33.jpg'},
    {'nome': 'Inês Ribeiro', 'user': '@inesr', 'img': 'https://randomuser.me/api/portraits/women/45.jpg'},
  ];

  final List<Map<String, dynamic>> _listaAmigos = [
    {'nome': 'Lourenço', 'user': '@lourenco', 'nivel': 5, 'isOnline': true, 'status': 'A jogar: Pack Histórico', 'img': 'assets/lourenco.jpg'},
    {'nome': 'Maria', 'user': '@maria', 'nivel': 4, 'isOnline': false, 'status': 'Visto há 2h', 'img': 'assets/maria.jpg'},
    {'nome': 'Nádia', 'user': '@nadiam', 'nivel': 7, 'isOnline': true, 'status': 'A explorar a Ribeira', 'img': 'assets/nadia.jpg'},
    {'nome': 'Paula', 'user': '@paula', 'nivel': 3, 'isOnline': true, 'status': 'No Menu Principal', 'img': 'assets/paula.jpg'},
  ];

  final List<Map<String, dynamic>> _listaGrupos = [
    {'nome': 'Turismo', 'membros': 12, 'img': 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=200&q=80', 'status': 'A jogar: Defesa de PAP'},
    {'nome': 'Turma da Profitecla', 'membros': 14, 'img': 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=200&q=80', 'status': 'A planear próxima viagem...'},
    {'nome': 'Os Aventureiros', 'membros': 4, 'img': 'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?w=200&q=80', 'status': 'A jogar: Pack Fest Vibes'},
  ];

  final List<Map<String, dynamic>> _todosPacksInfo = [
    {"nome": "Pack Heritage Hunt", "icon": Icons.account_balance, "cor": Colors.brown},
    {"nome": "Pack Urban Hero", "icon": Icons.menu_book, "cor": Colors.blueGrey},
    {"nome": "Pack Duo Bond", "icon": Icons.favorite, "cor": Colors.pink},
    {"nome": "Pack Story & Senses", "icon": Icons.auto_awesome, "cor": Colors.purple},
    {"nome": "Pack Map Clash", "icon": Icons.map, "cor": Colors.redAccent},
    {"nome": "Pack Fest Vibes", "icon": Icons.festival, "cor": Colors.orangeAccent},
    {"nome": "60' of Tourism", "icon": Icons.timer, "cor": Colors.amber},
    {"nome": "Pack United Experiences", "icon": Icons.public, "cor": Colors.green},
  ];

  Widget _construirAvatar(String imgPath, double tamanho) {
    if (imgPath.startsWith('http')) {
      return Image.network(imgPath, width: tamanho, height: tamanho, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: tamanho, height: tamanho, color: Colors.grey, child: const Icon(Icons.person)));
    } else {
      return Image.asset(imgPath, width: tamanho, height: tamanho, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: tamanho, height: tamanho, color: Colors.grey, child: const Icon(Icons.person)));
    }
  }

  void _mostrarMeuQRCode(Color bgColor, Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("O Teu Código QR", style: TextStyle(color: textColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Pede aos teus amigos para lerem este código para te adicionarem ao Squad!", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 230,
              height: 230,
              child: QrImageView(
                data: "play2travel://addfriend/jogador_vip", 
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("FECHAR", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

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
                  ClipRRect(borderRadius: BorderRadius.circular(_mostrarGrupos ? 8 : 50), child: _construirAvatar(amigo["img"], 45)),
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
                      decoration: InputDecoration(hintText: 'Mensagem...', hintStyle: TextStyle(color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))
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
                      leading: Icon(packInfo["icon"], color: packInfo["cor"]),
                      title: Text(packInfo["nome"], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: packInfo["cor"], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), 
                        onPressed: () { 
                          Navigator.pop(context); 
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Convite para ${packInfo["nome"]} enviado!"), backgroundColor: Colors.green)); 
                        }, 
                        child: const Text("CONVIDAR", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
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

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
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
                      onTap: () => _mostrarMeuQRCode(bgColor, textColor), 
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
                        ClipOval(child: _construirAvatar(pedido['img'], 40)),
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
                          ClipRRect(borderRadius: BorderRadius.circular(_mostrarGrupos ? 10 : 50), child: _construirAvatar(item['img'], 55)),
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
}