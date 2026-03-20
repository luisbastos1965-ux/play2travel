import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

// ==========================================
// PACK: MAP CLASH (HUB DE JOGOS)
// ==========================================

class MapClashHub extends StatefulWidget {
  const MapClashHub({super.key});

  @override
  State<MapClashHub> createState() => _MapClashHubState();
}

class _MapClashHubState extends State<MapClashHub> {
  String _jogoAtivo = 'SELECAO'; 

  @override
  Widget build(BuildContext context) {
    if (_jogoAtivo == 'DOMINIO') return const DominioDeBairro();
    if (_jogoAtivo == 'ELITE') return const CorridaPistasElite();
    if (_jogoAtivo == 'LOGISTICA') return const LogisticaDeGrupo();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1A0000), Color(0xFF000000)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gps_fixed, color: Colors.redAccent, size: 60),
          const SizedBox(height: 15),
          const Text("MAP CLASH", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const Text("PORTO BATTLE ROYALE", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 40),
          
          _cardHub("DOMÍNIO DE BAIRRO", "Conquista as 7 freguesias através da caderneta de cromos.", Icons.map, () => setState(() => _jogoAtivo = 'DOMINIO')),
          const SizedBox(height: 15),
          _cardHub("CORRIDA DE ELITE", "Missões icónicas com sabotadores infiltrados no grupo.", Icons.local_fire_department, () => setState(() => _jogoAtivo = 'ELITE')),
          const SizedBox(height: 15),
          _cardHub("LOGÍSTICA DE GRUPO", "Contra-relógio! 3 pontos, trivia e equipa unida.", Icons.timer, () => setState(() => _jogoAtivo = 'LOGISTICA')),
        ],
      ),
    );
  }

  Widget _cardHub(String t, String d, IconData i, VoidCallback a) {
    return GestureDetector(
      onTap: a,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25), padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Row(children: [
          Icon(i, color: Colors.redAccent, size: 35), const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(d, style: const TextStyle(color: Colors.white54, fontSize: 12))])),
        ]),
      ),
    );
  }
}

// ==========================================
// JOGO 1: DOMÍNIO DE BAIRRO
// ==========================================
class DominioDeBairro extends StatefulWidget {
  const DominioDeBairro({super.key});
  @override
  State<DominioDeBairro> createState() => _DominioDeBairroState();
}

class _DominioDeBairroState extends State<DominioDeBairro> {
  String _faseAtual = 'SETUP'; 
  int _xpEquipa = 0;
  
  // Variáveis para o temporizador
  bool _modoContraRelogio = false;
  int _tempoRestante = 36000; // 10 horas em segundos
  Timer? _timer;
  
  final List<Map<String, dynamic>> _bairros = [
    {'freguesia': 'Bonfim', 'cor': Colors.orange, 'conquistado': false, 'missoes': [{'local': 'Museu Militar', 'tarefa': 'Identificar a estátua que lá está.', 'tipo': 'TEXTO', 'concluida': false}, {'local': 'Campo 24 de Agosto', 'tarefa': 'Ver os nomes dos soldados homenageados na Junta.', 'tipo': 'TEXTO', 'concluida': false}]},
    {'freguesia': 'Campanhã', 'cor': Colors.green, 'conquistado': false, 'missoes': [{'local': 'Estádio do Dragão', 'tarefa': 'Ver as estátuas que se situam dentro do museu.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Parque de São Roque', 'tarefa': 'Completar o labirinto.', 'tipo': 'GPS', 'concluida': false}, {'local': 'TIC', 'tarefa': 'Vídeo mostrando os principais meios de transporte.', 'tipo': 'VIDEO', 'concluida': false}]},
    {'freguesia': 'Paranhos', 'cor': Colors.blue, 'conquistado': false, 'missoes': [{'local': "Jardim de Arca D'Água", 'tarefa': 'Tirar uma foto criativa no centro do jardim.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Marquês', 'tarefa': 'Observar a população que costuma jogar jogos.', 'tipo': 'TEXTO', 'concluida': false}]},
    {'freguesia': 'Ramalde', 'cor': Colors.purple, 'conquistado': false, 'missoes': [{'local': 'Estádio do Bessa', 'tarefa': 'Foto criativa com a pantera.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Sheraton', 'tarefa': 'Descobrir os serviços de luxo do hotel.', 'tipo': 'TEXTO', 'concluida': false}, {'local': 'Casa da Música', 'tarefa': 'Descobrir quem foi o arquiteto.', 'tipo': 'TEXTO', 'concluida': false}]},
    {'freguesia': 'Aldoar/Foz/Nevogilde', 'cor': Colors.cyan, 'conquistado': false, 'missoes': [{'local': 'Forte de São João', 'tarefa': 'Identificar para que servia o edifício antigamente.', 'tipo': 'TEXTO', 'concluida': false}, {'local': 'Farol', 'tarefa': 'Observar e colocar uma imagem da PAP.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Jardim Passeio Alegre', 'tarefa': 'Tirar várias fotos criativas.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Serralves', 'tarefa': 'Observar as artes que lá se encontram.', 'tipo': 'TEXTO', 'concluida': false}]},
    {'freguesia': 'Lordelo do Ouro/Massarelos', 'cor': Colors.teal, 'conquistado': false, 'missoes': [{'local': 'Palácio de Cristal', 'tarefa': 'Encontrar os pavões.', 'tipo': 'FOTO', 'concluida': false}]},
    {'freguesia': 'Cedofeita/Santo Ildefonso/...', 'cor': Colors.red, 'conquistado': false, 'missoes': [{'local': 'Fontainhas', 'tarefa': 'Tirar uma foto com a melhor vista.', 'tipo': 'FOTO', 'concluida': false}, {'local': 'Teatro Nac. São João', 'tarefa': 'Mostrar por que é uma das principais salas do país.', 'tipo': 'TEXTO', 'concluida': false}, {'local': 'Igreja Sto. Ildefonso', 'tarefa': 'Ver os azulejos e a sua história.', 'tipo': 'TEXTO', 'concluida': false}]},
  ];
  Map<String, dynamic>? _missaoSelecionada;

  void _iniciarTimer() {
    _timer?.cancel();
    _tempoRestante = 36000; 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() => _tempoRestante--);
      } else {
        _timer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O tempo esgotou!"), backgroundColor: Colors.red));
      }
    });
  }

  String _formatarTempo(int segundos) {
    int h = segundos ~/ 3600;
    int m = (segundos % 3600) ~/ 60;
    int s = segundos % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP') return _buildSetup();
    if (_faseAtual == 'MAPA') return _buildMapaGuerra();
    if (_faseAtual == 'CADERNETA') return _buildCaderneta();
    if (_faseAtual == 'MISSAO') return _buildEcraMissao();
    return const SizedBox.shrink();
  }

  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0F0F0F)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.security, color: Colors.redAccent, size: 80), const SizedBox(height: 20),
        const Text("DOMÍNIO DE BAIRRO", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
        
        // Botões Selecionáveis
        _setupCard("MODO CLÁSSICO", "Conquista os 7 bairros ao teu ritmo.", Icons.map, !_modoContraRelogio, () => setState(() => _modoContraRelogio = false)), 
        const SizedBox(height: 15),
        _setupCard("CONTRA-RELÓGIO", "Tens 10 horas para dominar o Porto.", Icons.timer, _modoContraRelogio, () => setState(() => _modoContraRelogio = true)), 
        
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity, 
          child: ElevatedButton(
            onPressed: () {
              if (_modoContraRelogio) _iniciarTimer();
              setState(() => _faseAtual = 'MAPA');
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 20)), 
            child: const Text("INICIAR BATTLE ROYALE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
          )
        )
      ]),
    );
  }

  Widget _setupCard(String t, String d, IconData i, bool selecionado, VoidCallback onTap) { 
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20), 
        decoration: BoxDecoration(
          color: selecionado ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05), 
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: selecionado ? Colors.redAccent : Colors.white10, width: 2)
        ), 
        child: Row(children: [
          Icon(i, color: selecionado ? Colors.redAccent : Colors.white54), 
          const SizedBox(width: 20), 
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: TextStyle(color: selecionado ? Colors.white : Colors.white70, fontWeight: FontWeight.bold)), 
            Text(d, style: TextStyle(color: selecionado ? Colors.white70 : Colors.white54, fontSize: 12))
          ])
        ])
      ),
    ); 
  }

  Widget _buildMapaGuerra() {
    return Stack(children: [
      FlutterMap(options: const MapOptions(initialCenter: LatLng(41.1579, -8.6291), initialZoom: 13.0), children: [TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd'])]),
      Positioned(
        top: 20, left: 20, right: 20, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            _statusChip("EQUIPA ALPHA", Icons.group), 
            Row(
              children: [
                if (_modoContraRelogio) ...[
                  _statusChip(_formatarTempo(_tempoRestante), Icons.timer, color: Colors.redAccent),
                  const SizedBox(width: 8),
                ],
                _statusChip("$_xpEquipa XP", Icons.star, color: Colors.amber),
              ]
            )
          ]
        )
      ),
      Positioned(bottom: 30, right: 20, left: 20, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'CADERNETA'), icon: const Icon(Icons.book, color: Colors.black), label: const Text("ABRIR CADERNETA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))))
    ]);
  }

  Widget _statusChip(String t, IconData i, {Color color = Colors.white}) { 
    return Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(i, color: color, size: 16), const SizedBox(width: 8), Text(t, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))])); 
  }

  Widget _buildCaderneta() {
    return Container(
      color: const Color(0xFF121212), 
      child: Column(children: [
        _appBarSimples("CADERNETA DE DOMÍNIO", () => setState(() => _faseAtual = 'MAPA')),
        Expanded(
          // ✨ SOLUÇÃO DO ERRO: Adicionado o Material para os ExpansionTiles não colapsarem! ✨
          child: Material(
            color: Colors.transparent,
            child: ListView.builder(
              padding: const EdgeInsets.all(20), 
              itemCount: _bairros.length, 
              itemBuilder: (context, index) {
                final b = _bairros[index]; 
                final missoes = b['missoes'] as List;
                double p = missoes.where((m) => m['concluida'] == true).length / missoes.length;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15), 
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)), 
                  child: ExpansionTile(
                    leading: Icon(Icons.shield, color: p == 1.0 ? b['cor'] : Colors.white24), 
                    title: Text(b['freguesia'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
                    subtitle: LinearProgressIndicator(value: p, backgroundColor: Colors.white10, color: b['cor']), 
                    children: missoes.map<Widget>((m) => ListTile(
                      title: Text(m['local'], style: TextStyle(color: m['concluida'] ? Colors.green : Colors.white70)), 
                      trailing: Icon(m['concluida'] ? Icons.check_circle : Icons.lock_outline, color: m['concluida'] ? Colors.green : Colors.white24), 
                      onTap: m['concluida'] ? null : () => setState(() { _missaoSelecionada = m; _faseAtual = 'MISSAO'; })
                    )).toList()
                  )
                );
              }
            ),
          )
        )
      ])
    );
  }

  Widget _buildEcraMissao() {
    return Container(color: Colors.black, child: Column(children: [
      _appBarSimples("MISSÃO: ${_missaoSelecionada!['local']}", () => setState(() => _faseAtual = 'CADERNETA')),
      Expanded(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.explore, color: Colors.redAccent, size: 60), const SizedBox(height: 30), Text(_missaoSelecionada!['tarefa'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 50), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() { _missaoSelecionada!['concluida'] = true; _xpEquipa += 100; _faseAtual = 'CADERNETA'; }); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("CONCLUIR MISSÃO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))])))
    ]));
  }

  Widget _appBarSimples(String t, VoidCallback v) { 
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 40, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1A1A1A)), 
      child: Row(children: [
        IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: v), 
        Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        if (_modoContraRelogio)
          Text(_formatarTempo(_tempoRestante), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16))
      ])
    ); 
  }
}

// ==========================================
// JOGO 2: CORRIDA DE PISTAS DE ELITE
// ==========================================
class CorridaPistasElite extends StatefulWidget {
  const CorridaPistasElite({super.key});
  @override
  State<CorridaPistasElite> createState() => _CorridaPistasEliteState();
}

class _CorridaPistasEliteState extends State<CorridaPistasElite> {
  String _faseAtual = 'SETUP_JOGADORES'; int _qtdJogadores = 4; int _localAtualIdx = 0; int _revelarIdx = 0; List<int> _indicesImpostores = [];
  final List<String> _icones = ['🦊', '🦉', '🤖', '👻', '👽', '🐙', '🦄', '🦁'];
  final List<Map<String, dynamic>> _roteiro = [
    {'local': 'Avenida dos Aliados', 'grupo': 'Encontrar: Algo azul, data antiga, ferro (2 min). Falha = 20 agachamentos.', 'i1': 'Questione as descobertas. Forçe os 20 agachamentos.', 'i2': 'Distraia com histórias, esconda objetos.'},
    {'local': 'Estação de São Bento', 'grupo': 'Observar azulejos (2 min). Estátua humana histórica (5 min prep). Silêncio.', 'i1': 'Sugira poses impossíveis e peça para repetir.', 'i2': 'Desequilibre a pose subtilmente.'},
    {'local': 'Clérigos', 'grupo': 'Guia sem GPS. Só se diz "Quente/Frio". 15 min.', 'i1': 'Diga "quente" quando estiver frio.', 'i2': 'Crie confusão direcional.'},
    {'local': 'Livraria Lello', 'grupo': 'Criar história "O Intruso do Porto" (1 min).', 'i1': 'Complique a história com reviravoltas.', 'i2': 'Esqueça a sua fala de propósito.'},
    {'local': 'Palácio da Bolsa', 'grupo': 'Dizer: "Não sou o intruso porque..." sem repetir.', 'i1': 'Aponte suspeitas noutros com confiança.', 'i2': 'Aponte suspeitas noutros com confiança.'},
    {'local': 'Ribeira/Douro', 'grupo': 'Criar jingle turístico com rima.', 'i1': 'Sugira rimas difíceis, cante mal.', 'i2': 'Bate palmas fora de ritmo.'},
    {'local': 'Ponte Luiz I', 'grupo': 'Atravessar em 1 minuto de silêncio.', 'i1': 'Faça caretas para fazer rir.', 'i2': 'Tropeça para forçar gritos.'},
  ];

  void _gerarPapeis() { List<int> p = List.generate(_qtdJogadores, (i) => i)..shuffle(); _indicesImpostores = p.take(_qtdJogadores >= 5 ? 2 : 1).toList(); setState(() => _faseAtual = 'REVELAR'); }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP_JOGADORES') return _buildSetup();
    if (_faseAtual == 'REVELAR') return _buildRevelar();
    if (_faseAtual == 'JOGO') return _buildJogo();
    if (_faseAtual == 'FIM') return _buildFim();
    return const SizedBox.shrink();
  }

  Widget _buildSetup() {
    return Container(color: const Color(0xFF0F0F0F), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.group_work, color: Colors.cyanAccent, size: 80), const SizedBox(height: 20),
      const Text("CORRIDA DE ELITE", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
      const Text("Quantos jogadores?", style: TextStyle(color: Colors.white54)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.remove_circle, color: Colors.cyanAccent), onPressed: () => setState(() => _qtdJogadores = (_qtdJogadores - 1).clamp(3, 8))),
        Text("$_qtdJogadores", style: const TextStyle(color: Colors.white, fontSize: 40)),
        IconButton(icon: const Icon(Icons.add_circle, color: Colors.cyanAccent), onPressed: () => setState(() => _qtdJogadores = (_qtdJogadores + 1).clamp(3, 8))),
      ]), const SizedBox(height: 50),
      ElevatedButton(onPressed: _gerarPapeis, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: const EdgeInsets.all(20)), child: const Text("DISTRIBUIR PAPÉIS SECRETOS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
    ]));
  }
  Widget _buildRevelar() {
    bool rev = false; bool imp = _indicesImpostores.contains(_revelarIdx);
    return StatefulBuilder(builder: (context, setS) {
      return Container(width: double.infinity, color: rev ? (imp ? const Color(0xFF300000) : const Color(0xFF001A30)) : const Color(0xFF1A1A1A), padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("JOGADOR ${_revelarIdx + 1}", style: const TextStyle(color: Colors.white54)), Text(_icones[_revelarIdx], style: const TextStyle(fontSize: 80)), const SizedBox(height: 40),
        if (!rev) ...[const Text("ENTREGA O TELEMÓVEL", style: TextStyle(color: Colors.white, fontSize: 20)), const SizedBox(height: 40), ElevatedButton(onPressed: () => setS(() => rev = true), child: const Text("REVELAR PAPEL"))],
        if (rev) ...[
          Icon(imp ? Icons.psychology : Icons.explore, color: imp ? Colors.redAccent : Colors.blueAccent, size: 60), const SizedBox(height: 20),
          Text(imp ? "TU ÉS O INTRUSO" : "ÉS UM EXPLORADOR", style: TextStyle(color: imp ? Colors.redAccent : Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
          Text(imp ? "Atrasa o grupo subtilmente. Vê as tuas missões secretas nos locais." : "Cumpre as missões e identifica os sabotadores.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)), const SizedBox(height: 40),
          ElevatedButton(onPressed: () { if (_revelarIdx < _qtdJogadores - 1) { setState(() => _revelarIdx++); } else { setState(() => _faseAtual = 'JOGO'); } }, child: Text(_revelarIdx < _qtdJogadores - 1 ? "PRÓXIMO JOGADOR" : "COMEÇAR JOGO"))
        ]
      ]));
    });
  }
  Widget _buildJogo() {
    final loc = _roteiro[_localAtualIdx];
    return Container(color: Colors.black, child: Column(children: [
      _appBar("CORRIDA: LOCAL ${_localAtualIdx + 1}"),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(30), child: Column(children: [
        Text(loc['local'].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 30),
        _card("MISSÃO DO GRUPO", loc['grupo'], Colors.cyanAccent), const SizedBox(height: 40),
        const Text("SABOTAGENS (APENAS INTRUSOS)", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), _sabotagem(loc), const SizedBox(height: 50),
        ElevatedButton(onPressed: () { if (_localAtualIdx < _roteiro.length - 1) { setState(() => _localAtualIdx++); } else { setState(() => _faseAtual = 'FIM'); } }, child: const Text("MISSÃO CONCLUÍDA"))
      ])))
    ]));
  }
  Widget _card(String t, String d, Color c) { return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.withOpacity(0.05), border: Border.all(color: c.withOpacity(0.2)), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(color: c, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text(d, style: const TextStyle(color: Colors.white, fontSize: 15))])); }
  Widget _sabotagem(Map l) {
    bool r1 = false; bool r2 = false;
    return StatefulBuilder(builder: (context, setS) {
      return Column(children: [
        TextButton.icon(onPressed: () => setS(() => r1 = !r1), icon: Icon(r1 ? Icons.visibility_off : Icons.visibility, size: 16), label: Text(r1 ? "ESCONDER I1" : "VER MISSÃO IMPOSTOR 1")),
        if (r1) Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(l['i1'], style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
        if (_indicesImpostores.length > 1) ...[const SizedBox(height: 10), TextButton.icon(onPressed: () => setS(() => r2 = !r2), icon: Icon(r2 ? Icons.visibility_off : Icons.visibility, size: 16), label: Text(r2 ? "ESCONDER I2" : "VER MISSÃO IMPOSTOR 2")), if (r2) Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(l['i2'], style: const TextStyle(color: Colors.redAccent, fontSize: 13)))]
      ]);
    });
  }
  Widget _buildFim() {
    return Container(color: Colors.black, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.emoji_events, color: Colors.amber, size: 80), const SizedBox(height: 20),
      const Text("FIM DA CORRIDA!", style: TextStyle(color: Colors.white, fontSize: 24)), const SizedBox(height: 40), const Text("OS INTRUSOS ERAM:", style: TextStyle(color: Colors.white54)), const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: _indicesImpostores.map((i) => Padding(padding: const EdgeInsets.all(10), child: Column(children: [Text(_icones[i], style: const TextStyle(fontSize: 40)), Text("JOGADOR ${i + 1}", style: const TextStyle(color: Colors.redAccent))]))).toList()),
      const SizedBox(height: 60), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("VOLTAR AO MENU"))
    ]));
  }
  Widget _appBar(String t) { return Container(padding: const EdgeInsets.fromLTRB(10, 40, 10, 15), decoration: const BoxDecoration(color: Color(0xFF1A1A1A)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])); }
}

// ==========================================
// JOGO 3: LOGÍSTICA DE GRUPO
// ==========================================
class LogisticaDeGrupo extends StatefulWidget {
  const LogisticaDeGrupo({super.key});
  @override
  State<LogisticaDeGrupo> createState() => _LogisticaDeGrupoState();
}

class _LogisticaDeGrupoState extends State<LogisticaDeGrupo> {
  String _faseAtual = 'INICIO'; // INICIO -> ROTA -> MISSAO -> FIM
  int _pontoAtualIdx = 0;
  int _tempoSegundos = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _pontos = [
    {
      'local': 'Torre dos Clérigos',
      'sabias': 'Foi durante anos o ponto mais alto do país.',
      'observa': 'Repara na verticalidade e no topo recortado.',
      'missao': 'Cada pessoa tira uma foto diferente da torre (ângulo único). No final escolhem a melhor.',
      'pergunta': 'O arquiteto era português ou italiano?',
      'opcoes': ['Português', 'Italiano'],
      'resposta': 'Italiano'
    },
    {
      'local': 'Centro Português de Fotografia',
      'sabias': 'O edifício foi uma prisão outrora.',
      'observa': 'Repara nas janelas pequenas e estrutura pesada.',
      'missao': 'Encontrar um detalhe arquitetónico que revele que foi prisão (ex: grade, parede). Cada pessoa aponta um detalhe.',
      'pergunta': 'Foi construído no Século XVIII ou XX?',
      'opcoes': ['Século XVIII', 'Século XX'],
      'resposta': 'Século XVIII'
    },
    {
      'local': 'Livraria Lello',
      'sabias': 'É uma das livrarias mais famosas do mundo.',
      'observa': 'Escadaria marcante e vitral imponente no teto.',
      'missao': 'Cada pessoa escolhe um livro que representaria esta viagem. Explicação rápida em 1 frase.',
      'pergunta': 'A arquitetura é neogótica ou contemporânea?',
      'opcoes': ['Neogótica', 'Contemporânea'],
      'resposta': 'Neogótica'
    }
  ];

  void _iniciarContraRelogio() {
    setState(() { _faseAtual = 'ROTA'; _tempoSegundos = 0; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _tempoSegundos++);
    });
  }

  void _pararContraRelogio() {
    _timer?.cancel();
    setState(() => _faseAtual = 'FIM');
  }

  String _formatarTempo(int segundos) {
    int m = segundos ~/ 60;
    int s = segundos % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _verificarResposta(String escolhida, String correta) {
    if (escolhida == correta) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resposta Correta! Avancem!"), backgroundColor: Colors.green));
      if (_pontoAtualIdx < _pontos.length - 1) {
        setState(() { _pontoAtualIdx++; _faseAtual = 'ROTA'; });
      } else {
        _pararContraRelogio();
      }
    } else {
      setState(() => _tempoSegundos += 15); // Penalização!
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Errado! +15 Segundos de penalização!"), backgroundColor: Colors.redAccent));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'INICIO') return _buildInicio();
    if (_faseAtual == 'ROTA') return _buildRota();
    if (_faseAtual == 'MISSAO') return _buildMissao();
    if (_faseAtual == 'FIM') return _buildFim();
    return const SizedBox.shrink();
  }

  Widget _buildInicio() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0A0A0A)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("LOGÍSTICA DE GRUPO", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("1. Passem por 3 pontos específicos.\n2. Só conta quando TODOS estão juntos.\n3. Façam no menor tempo possível!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _iniciarContraRelogio,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20)),
              child: const Text("ARRANCAR O CRONÓMETRO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRota() {
    final loc = _pontos[_pontoAtualIdx];
    return Container(
      width: double.infinity, color: const Color(0xFF101010),
      child: Column(
        children: [
          _appBarTempo(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PRÓXIMO DESTINO:", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  Text(loc['local'].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  
                  _cardInfo("CURIOSIDADE", loc['sabias'], Icons.lightbulb),
                  const SizedBox(height: 20),
                  _cardInfo("OBSERVA", loc['observa'], Icons.visibility),
                  
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _faseAtual = 'MISSAO'),
                      icon: const Icon(Icons.group, color: Colors.black),
                      label: const Text("CHEGÁMOS TODOS JUNTOS!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMissao() {
    final loc = _pontos[_pontoAtualIdx];
    return Container(
      width: double.infinity, color: const Color(0xFF101010),
      child: Column(
        children: [
          _appBarTempo(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent)),
                    child: Column(children: [
                      const Icon(Icons.stars, color: Colors.blueAccent, size: 40), const SizedBox(height: 15),
                      const Text("MISSÃO RÁPIDA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
                      Text(loc['missao'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
                    ]),
                  ),
                  const SizedBox(height: 40),
                  const Center(child: Text("PERGUNTA DE VERIFICAÇÃO", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2))),
                  const SizedBox(height: 15),
                  Text(loc['pergunta'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...loc['opcoes'].map<Widget>((opcao) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _verificarResposta(opcao, loc['resposta']),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18)),
                        child: Text(opcao, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  )).toList(),
                  const SizedBox(height: 20),
                  const Center(child: Text("Atenção: Resposta errada adiciona 15s ao tempo!", style: TextStyle(color: Colors.redAccent, fontSize: 12))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFim() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flag, color: Colors.greenAccent, size: 80), const SizedBox(height: 20),
          const Text("ROTA CONCLUÍDA!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          const Text("TEMPO TOTAL DA EQUIPA", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(_formatarTempo(_tempoSegundos), style: const TextStyle(color: Colors.amber, fontSize: 60, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  Widget _cardInfo(String t, String d, IconData i) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(i, color: Colors.white54, size: 24), const SizedBox(width: 15),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(d, style: const TextStyle(color: Colors.white, fontSize: 15))]))
    ]);
  }

  Widget _appBarTempo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20), decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("PONTO ${_pontoAtualIdx + 1}/3", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber)), child: Row(children: [const Icon(Icons.timer, color: Colors.amber, size: 16), const SizedBox(width: 8), Text(_formatarTempo(_tempoSegundos), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))])),
        ],
      ),
    );
  }
}