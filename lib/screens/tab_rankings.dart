import 'package:flutter/material.dart';

class TabRankings extends StatefulWidget {
  const TabRankings({super.key});

  @override
  State<TabRankings> createState() => _TabRankingsState();
}

class _TabRankingsState extends State<TabRankings> {
  String _rankCategoria = 'Pontos'; 
  String _rankLocalizacao = 'Global'; 

  final List<Map<String, dynamic>> _rankingGlobal = [
    {'nome': 'Kenji Sato', 'pais': '🇯🇵', 'pontos': 25420, 'packs': 82, 'img': 'https://randomuser.me/api/portraits/men/32.jpg'},
    {'nome': 'Emma Watson', 'pais': '🇬🇧', 'pontos': 24100, 'packs': 78, 'img': 'https://randomuser.me/api/portraits/women/44.jpg'},
    {'nome': 'John Smith', 'pais': '🇺🇸', 'pontos': 23850, 'packs': 75, 'img': 'https://randomuser.me/api/portraits/men/45.jpg'},
    {'nome': 'Chen Wei', 'pais': '🇨🇳', 'pontos': 22100, 'packs': 70, 'img': 'https://randomuser.me/api/portraits/men/67.jpg'},
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 21800, 'packs': 68, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'}, 
    {'nome': 'Ana Garcia', 'pais': '🇪🇸', 'pontos': 20500, 'packs': 65, 'img': 'https://randomuser.me/api/portraits/women/24.jpg'},
  ];
  
  final List<Map<String, dynamic>> _rankingNacional = [
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 21800, 'packs': 68, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'nome': 'Maria Santos', 'pais': '🇵🇹', 'pontos': 18200, 'packs': 55, 'img': 'https://randomuser.me/api/portraits/women/68.jpg'},
    {'nome': 'João Costa', 'pais': '🇵🇹', 'pontos': 16400, 'packs': 48, 'img': 'https://randomuser.me/api/portraits/men/85.jpg'},
    {'nome': 'Inês Faria', 'pais': '🇵🇹', 'pontos': 12100, 'packs': 33, 'img': 'https://randomuser.me/api/portraits/women/19.jpg'},
  ];
  
  final List<Map<String, dynamic>> _rankingLocal = [
    {'nome': 'Hans Müller', 'pais': '🇩🇪', 'pontos': 17500, 'packs': 52, 'img': 'https://randomuser.me/api/portraits/men/70.jpg'}, 
    {'nome': 'Tiago B.', 'pais': '🇵🇹', 'pontos': 16800, 'packs': 50, 'img': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'nome': 'Sarah Lee', 'pais': '🇺🇸', 'pontos': 15100, 'packs': 45, 'img': 'https://randomuser.me/api/portraits/women/33.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;

    List<Map<String, dynamic>> dadosAtuais;
    if (_rankLocalizacao == 'Global') { 
      dadosAtuais = List.from(_rankingGlobal); 
    } else if (_rankLocalizacao == 'Nacional') {
      dadosAtuais = List.from(_rankingNacional);
    } else {
      dadosAtuais = List.from(_rankingLocal);
    }

    String chaveOrdem = _rankCategoria == 'Pontos' ? 'pontos' : 'packs';
    dadosAtuais.sort((a, b) => b[chaveOrdem].compareTo(a[chaveOrdem]));
    
    int maxValor = dadosAtuais.isNotEmpty ? dadosAtuais[0][chaveOrdem] : 1;

    return Column(
      children: [
        const SizedBox(height: 60), 
        Text("LEADERBOARD", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), 
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Row(
            children: [ 
              Expanded(child: _btnFiltroGeral('Pontos/Nível', _rankCategoria == 'Pontos', () => setState(() => _rankCategoria = 'Pontos'))), 
              const SizedBox(width: 10), 
              Expanded(child: _btnFiltroGeral('Packs Concluídos', _rankCategoria == 'Packs', () => setState(() => _rankCategoria = 'Packs'))) 
            ]
          )
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20), 
          decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[200], borderRadius: BorderRadius.circular(10)), 
          child: Row(
            children: [ 
              Expanded(child: _btnFiltroSecundario('Local', _rankLocalizacao == 'Local', () => setState(() => _rankLocalizacao = 'Local'))), 
              Expanded(child: _btnFiltroSecundario('Nacional', _rankLocalizacao == 'Nacional', () => setState(() => _rankLocalizacao = 'Nacional'))), 
              Expanded(child: _btnFiltroSecundario('Global', _rankLocalizacao == 'Global', () => setState(() => _rankLocalizacao = 'Global'))) 
            ]
          )
        ),
        const SizedBox(height: 30),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, 
          children: [ 
            if (dadosAtuais.length > 1) _buildLugarPodio(dadosAtuais[1], 2, 80, const Color(0xFFC0C0C0)), // PRATA
            const SizedBox(width: 15), 
            if (dadosAtuais.isNotEmpty) _buildLugarPodio(dadosAtuais[0], 1, 110, const Color(0xFFFFD700)), // OURO
            const SizedBox(width: 15), 
            if (dadosAtuais.length > 2) _buildLugarPodio(dadosAtuais[2], 3, 60, const Color(0xFFCD7F32)), // BRONZE
          ]
        ),
        
        const SizedBox(height: 30),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 10), 
            decoration: BoxDecoration(color: isDark ? const Color(0xFF121212) : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]), 
            child: ListView.builder(
              padding: const EdgeInsets.all(20), 
              itemCount: dadosAtuais.length > 3 ? dadosAtuais.length - 3 : 0, 
              itemBuilder: (context, index) { 
                return _buildLinhaRanking(dadosAtuais[index + 3], index + 4, maxValor); 
              }
            )
          )
        ),
      ],
    );
  }

  Widget _btnFiltroGeral(String titulo, bool ativo, VoidCallback onTap) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12), 
        decoration: BoxDecoration(color: ativo ? Colors.deepOrange : Colors.transparent, border: Border.all(color: ativo ? Colors.deepOrange : (isDark ? Colors.white24 : Colors.grey[300]!)), borderRadius: BorderRadius.circular(10)), 
        child: Center(child: Text(titulo, style: TextStyle(color: ativo ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)))
      )
    );
  }

  Widget _btnFiltroSecundario(String titulo, bool ativo, VoidCallback onTap) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10), 
        decoration: BoxDecoration(color: ativo ? (isDark ? Colors.white24 : Colors.grey[300]) : Colors.transparent, borderRadius: BorderRadius.circular(10)), 
        child: Center(child: Text(titulo, style: TextStyle(color: ativo ? (isDark ? Colors.white : Colors.black87) : Colors.grey, fontSize: 13, fontWeight: ativo ? FontWeight.bold : FontWeight.normal)))
      )
    );
  }

  Widget _buildLugarPodio(Map<String, dynamic> user, int posicao, double altura, Color corMedalha) {
    String valor = _rankCategoria == 'Pontos' ? '${user['pontos']} XP' : '${user['packs']} Packs';
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double size = posicao == 1 ? 85 : 65;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (posicao == 1) const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 30),
        Stack(
          alignment: Alignment.bottomCenter, 
          children: [ 
            Container(
              margin: const EdgeInsets.only(bottom: 10), 
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: corMedalha, width: posicao == 1 ? 4 : 2), boxShadow: [BoxShadow(color: corMedalha.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)]), 
              child: ClipOval(child: Image.network(user['img'], width: size, height: size, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: size, height: size, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white))))
            ), 
            Container(
              padding: const EdgeInsets.all(6), 
              decoration: BoxDecoration(color: corMedalha, shape: BoxShape.circle, border: Border.all(color: isDark ? const Color(0xFF121212) : Colors.white, width: 2)), 
              child: Text('$posicao', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
            ) 
          ]
        ),
        const SizedBox(height: 8), 
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(user['pais'], style: const TextStyle(fontSize: 14)), const SizedBox(width: 4), Text(user['nome'].split(' ')[0], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)) ]), 
        const SizedBox(height: 4), 
        Text(valor, style: TextStyle(color: corMedalha, fontSize: 12, fontWeight: FontWeight.bold)), 
        const SizedBox(height: 10),
        Container(
          width: posicao == 1 ? 80 : 70, height: altura, 
          decoration: BoxDecoration(gradient: LinearGradient(colors: [corMedalha.withOpacity(0.4), corMedalha.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        ),
      ],
    );
  }

  Widget _buildLinhaRanking(Map<String, dynamic> user, int posicao, int maxValor) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    String chaveOrdem = _rankCategoria == 'Pontos' ? 'pontos' : 'packs';
    int valorAtual = user[chaveOrdem];
    double percentagem = (valorAtual / maxValor).clamp(0.0, 1.0);
    String textoValor = _rankCategoria == 'Pontos' ? '$valorAtual XP' : '$valorAtual Packs';

    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), 
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          SizedBox(width: 35, child: Text('#$posicao', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontWeight: FontWeight.bold, fontSize: 16))),
          ClipOval(child: Image.network(user['img'], width: 45, height: 45, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 45, height: 45, color: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white)))),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Row(children: [Text(user['pais'], style: const TextStyle(fontSize: 16)), const SizedBox(width: 6), Text(user['nome'], style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 15))]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: percentagem, minHeight: 6, color: Colors.deepOrange, backgroundColor: isDark ? Colors.black45 : Colors.grey[300]))),
                    const SizedBox(width: 10),
                    Text(textoValor, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}