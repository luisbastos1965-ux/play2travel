import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// ==========================================
// PACK ESPECIAL: UNITED EXPERIENCES
// ==========================================

class UnitedExperiences extends StatefulWidget {
  const UnitedExperiences({super.key});

  @override
  State<UnitedExperiences> createState() => _UnitedExperiencesState();
}

class _UnitedExperiencesState extends State<UnitedExperiences> {
  String _faseAtual = 'SETUP'; 
  int _qtdJogadores = 2;
  
  List<TextEditingController> _nomeControllers = [];
  List<String> _nomesJogadores = [];
  String _jogoAtivoNome = '';

  final List<Map<String, dynamic>> _jogosSeniores = [
    {'nome': 'Jogo do Galo', 'icone': Icons.close},
    {'nome': 'Jogo da Memória', 'icone': Icons.psychology},
    {'nome': 'Bingo Turístico', 'icone': Icons.grid_on},
    {'nome': 'Sueca', 'icone': Icons.style},
    {'nome': 'Dominó de Viagem', 'icone': Icons.view_comfy},
  ];

  final List<Map<String, dynamic>> _jogosJuniores = [
    {'nome': 'Fake', 'icone': Icons.masks},
    {'nome': 'Livro de Colorir', 'icone': Icons.format_paint},
    {'nome': 'UNO (Marcador)', 'icone': Icons.layers},
    {'nome': 'Cards Against Humanity', 'icone': Icons.sentiment_very_dissatisfied},
    {'nome': 'Quem-é-Quem', 'icone': Icons.person_search},
  ];

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP') return _buildSetup();
    if (_faseAtual == 'NOMES') return _buildNomes();
    if (_faseAtual == 'MENU_MODOS') return _buildSplitScreen();
    if (_faseAtual == 'JOGO') return _buildEcraJogo();
    return const SizedBox.shrink();
  }

  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0A0A0A)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.family_restroom, color: Colors.tealAccent, size: 80), const SizedBox(height: 20),
        const Text("UNITED EXPERIENCES", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const Text("GERAÇÕES UNIDAS", style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 50),
        const Text("Quantos elementos vão jogar?", style: TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(icon: const Icon(Icons.remove_circle, color: Colors.tealAccent, size: 40), onPressed: () => setState(() => _qtdJogadores = (_qtdJogadores - 1).clamp(2, 10))), Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: Text("$_qtdJogadores", style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold))), IconButton(icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 40), onPressed: () => setState(() => _qtdJogadores = (_qtdJogadores + 1).clamp(2, 10)))]), const SizedBox(height: 60),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { _nomeControllers = List.generate(_qtdJogadores, (i) => TextEditingController(text: "Jogador ${i + 1}")); setState(() => _faseAtual = 'NOMES'); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("AVANÇAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))))
      ]),
    );
  }

  Widget _buildNomes() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(20, 50, 20, 20), decoration: const BoxDecoration(color: Color(0xFF151515)), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.tealAccent), onPressed: () => setState(() => _faseAtual = 'SETUP')), const Text("IDENTIFICAÇÃO", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(20), itemCount: _qtdJogadores, itemBuilder: (context, index) { return Padding(padding: const EdgeInsets.only(bottom: 15), child: TextField(controller: _nomeControllers[index], style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold), decoration: InputDecoration(labelText: 'Nome do Jogador ${index + 1}', labelStyle: const TextStyle(color: Colors.white54), filled: true, fillColor: Colors.white.withOpacity(0.05), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white10)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.tealAccent)), prefixIcon: const Icon(Icons.person, color: Colors.tealAccent)))); })),
        Padding(padding: const EdgeInsets.all(20), child: SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { _nomesJogadores = _nomeControllers.map((c) => c.text).toList(); setState(() => _faseAtual = 'MENU_MODOS'); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("ENTRAR NA SALA DE JOGOS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))))
      ]),
    );
  }

  Widget _buildSplitScreen() {
    return Column(children: [
      Expanded(child: Container(width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3E2723), Color(0xFF1F1209)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.fromLTRB(20, 40, 20, 10), child: Row(children: [Icon(Icons.history_edu, color: Colors.amber, size: 30), SizedBox(width: 10), Text("CLÁSSICOS (SENIORES)", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1))])), const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("A sabedoria dita as regras. Jogos intemporais.", style: TextStyle(color: Colors.white54, fontSize: 12))), const SizedBox(height: 20), Expanded(child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: _jogosSeniores.length, itemBuilder: (context, index) => _cartaoJogo(_jogosSeniores[index], Colors.amber))), const SizedBox(height: 20)]) )),
      Container(height: 4, color: Colors.white24),
      Expanded(child: Container(width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF311B92), Color(0xFF150940)], begin: Alignment.bottomRight, end: Alignment.topLeft)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 10), child: Row(children: [Icon(Icons.smart_toy, color: Colors.cyanAccent, size: 30), SizedBox(width: 10), Text("MODERNOS (JUNIORES)", style: TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1))])), const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Regras novas, caos e diversão rápida.", style: TextStyle(color: Colors.white54, fontSize: 12))), const SizedBox(height: 20), Expanded(child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 15), itemCount: _jogosJuniores.length, itemBuilder: (context, index) => _cartaoJogo(_jogosJuniores[index], Colors.cyanAccent))), const SizedBox(height: 40)]) )),
    ]);
  }

  Widget _cartaoJogo(Map<String, dynamic> jogo, Color corAcento) {
    return GestureDetector(
      onTap: () => setState(() { _jogoAtivoNome = jogo['nome']; _faseAtual = 'JOGO'; }),
      child: Container(width: 140, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: corAcento.withOpacity(0.3))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(jogo['icone'], color: corAcento, size: 40), const SizedBox(height: 15), Text(jogo['nome'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))])),
    );
  }

  Widget _buildEcraJogo() {
    return Container(
      color: const Color(0xFF101010),
      child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(10, 40, 10, 10), decoration: const BoxDecoration(color: Colors.black), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.tealAccent), onPressed: () => setState(() => _faseAtual = 'MENU_MODOS')), Expanded(child: Text(_jogoAtivoNome.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))])),
        Expanded(child: _carregarJogoSelecionado()),
      ]),
    );
  }

  Widget _carregarJogoSelecionado() {
    switch (_jogoAtivoNome) {
      case 'Jogo do Galo': return JogoDoGalo(nomes: _nomesJogadores);
      case 'Jogo da Memória': return const JogoDaMemoriaTurismo();
      case 'Fake': return JogoFake(nomes: _nomesJogadores);
      case 'Bingo Turístico': return const BingoTuristico();
      case 'Dominó de Viagem': return const DominoTuristico();
      case 'Sueca': return const JogoSueca();
      case 'Livro de Colorir': return const QuadroDesenho();
      default: return _buildFerramentaSimples();
    }
  }

  Widget _buildFerramentaSimples() {
    return Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.construction, color: Colors.white24, size: 80), const SizedBox(height: 20), Text("FERRAMENTA: $_jogoAtivoNome", textAlign: TextAlign.center, style: const TextStyle(color: Colors.tealAccent, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 10), const Text("Em breve!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 16))])));
  }
}

// ==========================================
// 1. JOGO DO GALO
// ==========================================
class JogoDoGalo extends StatefulWidget {
  final List<String> nomes;
  const JogoDoGalo({super.key, required this.nomes});
  @override
  State<JogoDoGalo> createState() => _JogoDoGaloState();
}
class _JogoDoGaloState extends State<JogoDoGalo> {
  List<String> _tabuleiro = List.filled(9, ''); bool _turnoX = true; String _vencedor = '';
  void _jogar(int i) { if (_tabuleiro[i] == '' && _vencedor == '') setState(() { _tabuleiro[i] = _turnoX ? 'X' : 'O'; _turnoX = !_turnoX; _vencedor = _verificarVitoria(); }); }
  String _verificarVitoria() { List<List<int>> l = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]; for (var p in l) { if (_tabuleiro[p[0]] != '' && _tabuleiro[p[0]] == _tabuleiro[p[1]] && _tabuleiro[p[1]] == _tabuleiro[p[2]]) return _tabuleiro[p[0]]; } return _tabuleiro.contains('') ? '' : 'Empate'; }
  @override
  Widget build(BuildContext context) {
    String nomeX = widget.nomes.isNotEmpty ? widget.nomes[0] : "Jog. 1"; String nomeO = widget.nomes.length > 1 ? widget.nomes[1] : "Jog. 2";
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_vencedor != '' ? (_vencedor == 'Empate' ? "Empate!" : "Venceu: ${_vencedor == 'X' ? nomeX : nomeO} 🎉") : "Turno: ${_turnoX ? nomeX : nomeO} (${_turnoX ? 'X' : 'O'})", style: TextStyle(color: _vencedor != '' ? Colors.amber : Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 30), SizedBox(width: 300, height: 300, child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: 9, physics: const NeverScrollableScrollPhysics(), itemBuilder: (context, i) => GestureDetector(onTap: () => _jogar(i), child: Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)), child: Center(child: Text(_tabuleiro[i], style: TextStyle(fontSize: 60, color: _tabuleiro[i] == 'X' ? Colors.cyanAccent : Colors.amber))))))), const SizedBox(height: 40), ElevatedButton(onPressed: () => setState((){ _tabuleiro=List.filled(9,''); _turnoX=true; _vencedor='';}), child: const Text("RECOMEÇAR"))]);
  }
}

// ==========================================
// 2. MEMÓRIA TURÍSTICA
// ==========================================
class JogoDaMemoriaTurismo extends StatefulWidget {
  const JogoDaMemoriaTurismo({super.key});
  @override
  State<JogoDaMemoriaTurismo> createState() => _JogoDaMemoriaTurismoState();
}
class _JogoDaMemoriaTurismoState extends State<JogoDaMemoriaTurismo> {
  final List<String> _icones = ['🌉', '🍷', '🚋', '🏰', '🧳', '✈️', '📸', '🗺️'];
  late List<String> _cartas; late List<bool> _reveladas, _encontradas;
  int _pares = 0, _ant = -1; bool _bloq = false;
  @override void initState() { super.initState(); _iniciar(); }
  void _iniciar() { _cartas = [..._icones, ..._icones]..shuffle(); _reveladas = List.filled(16, false); _encontradas = List.filled(16, false); _pares = 0; _ant = -1; _bloq = false; }
  void _virar(int i) {
    if (_bloq || _reveladas[i] || _encontradas[i]) return;
    setState(() => _reveladas[i] = true);
    if (_ant == -1) { _ant = i; } else {
      _bloq = true;
      if (_cartas[_ant] == _cartas[i]) { setState(() { _encontradas[_ant] = _encontradas[i] = true; _pares++; _bloq = false; _ant = -1; }); } 
      else { Future.delayed(const Duration(milliseconds: 800), () { if(mounted) setState(() { _reveladas[_ant] = _reveladas[i] = false; _bloq = false; _ant = -1; }); }); }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [const SizedBox(height: 20), Text(_pares == 8 ? "TURISMO COMPLETO! 🏆" : "Pares: $_pares/8", style: TextStyle(color: _pares == 8 ? Colors.amber : Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Expanded(child: Padding(padding: const EdgeInsets.all(20), child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: 16, itemBuilder: (c, i) { bool vis = _reveladas[i] || _encontradas[i]; return GestureDetector(onTap: () => _virar(i), child: AnimatedContainer(duration: const Duration(milliseconds: 300), decoration: BoxDecoration(color: vis ? Colors.white : Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber)), child: Center(child: Text(vis ? _cartas[i] : "?", style: TextStyle(fontSize: 30, color: vis ? Colors.black : Colors.amber))))); }))), if (_pares == 8) ElevatedButton(onPressed: () => setState(()=>_iniciar()), child: const Text("JOGAR NOVAMENTE"))]);
  }
}

// ==========================================
// 3. FAKE (SPYFALL)
// ==========================================
class JogoFake extends StatefulWidget {
  final List<String> nomes;
  const JogoFake({super.key, required this.nomes});
  @override
  State<JogoFake> createState() => _JogoFakeState();
}
class _JogoFakeState extends State<JogoFake> {
  int _idx = 0, _idxFake = -1; bool _mostrar = false, _fim = false; String _loc = '';
  final List<String> _lista = ['S. Bento', 'Aliados', 'Ribeira', 'Clérigos', 'Lello'];
  @override void initState() { super.initState(); _iniciar(); }
  void _iniciar() { _loc = _lista[Random().nextInt(_lista.length)]; _idxFake = Random().nextInt(widget.nomes.length); _idx = 0; _mostrar = _fim = false; }
  @override Widget build(BuildContext context) {
    if (_fim) return Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.forum, color: Colors.cyanAccent, size: 80), const SizedBox(height: 20), const Text("COMEÇA O JOGO!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), const Padding(padding: EdgeInsets.all(30), child: Text("O Fake não sabe onde estão. Façam perguntas uns aos outro!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70))), ElevatedButton(onPressed: () => setState(()=>_iniciar()), child: const Text("NOVA RONDA"))]);
    bool isFake = _idx == _idxFake;
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Passar o telemóvel a:", style: const TextStyle(color: Colors.white54)), Text(widget.nomes[_idx], style: const TextStyle(color: Colors.cyanAccent, fontSize: 30, fontWeight: FontWeight.bold)), const SizedBox(height: 40), if (!_mostrar) ElevatedButton(onPressed: () => setState(() => _mostrar = true), child: const Text("MOSTRAR PAPEL")) else ...[Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: isFake ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: isFake ? Colors.red : Colors.green)), child: Column(children: [Text(isFake ? "🕵️ TU ÉS O FAKE!" : "📍 LOCAL SECRETO:", style: TextStyle(color: isFake ? Colors.redAccent : Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text(isFake ? "Tenta adivinhar onde estão." : _loc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))])), const SizedBox(height: 40), ElevatedButton(onPressed: () { setState(() { _mostrar = false; if (_idx < widget.nomes.length - 1) _idx++; else _fim = true; }); }, child: Text(_idx < widget.nomes.length - 1 ? "ESCONDER E PASSAR" : "COMEÇAR"))]]));
  }
}

// ==========================================
// 4. BINGO TURÍSTICO (Cartão 4x4 + Globo Dinâmico)
// ==========================================
class BingoTuristico extends StatefulWidget {
  const BingoTuristico({super.key});
  @override
  State<BingoTuristico> createState() => _BingoTuristicoState();
}
class _BingoTuristicoState extends State<BingoTuristico> {
  final List<String> _todasPalavras = ["Clérigos", "Ribeira", "S. Bento", "Bolhão", "Francesinha", "Vinho Porto", "Majestic", "Foz", "Serralves", "Música", "Aliados", "D. Luís", "Caves", "Rabelo", "Tripas", "Elétrico", "Azulejo", "Lello", "Sé", "Virtudes"];
  List<String> _cartao = []; List<bool> _marcados = [];
  List<String> _sorteados = []; String _ultimoSorteado = "Preparado?";
  Timer? _timer; bool _aRodar = false;
  Color _corCartao = Colors.deepOrange; 

  @override void initState() { super.initState(); _gerarCartao(); }
  void _gerarCartao() { _cartao = (List.of(_todasPalavras)..shuffle()).take(16).toList(); _marcados = List.filled(16, false); _sorteados = []; _ultimoSorteado = "Preparado?"; _aRodar = false; _timer?.cancel(); }
  void _toggleRolar() {
    if (_aRodar) { _timer?.cancel(); setState(() => _aRodar = false); }
    else {
      setState(() => _aRodar = true);
      _timer = Timer.periodic(const Duration(seconds: 4), (t) {
        var disponiveis = _todasPalavras.where((p) => !_sorteados.contains(p)).toList();
        if (disponiveis.isEmpty) { _timer?.cancel(); setState(() { _aRodar = false; _ultimoSorteado = "FIM!"; }); return; }
        setState(() { _ultimoSorteado = disponiveis[Random().nextInt(disponiveis.length)]; _sorteados.insert(0, _ultimoSorteado); });
      });
    }
  }
  @override void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ✨ GLOBO DINÂMICO E ANIMADO ✨
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _aRodar ? _corCartao.withOpacity(0.4) : _corCartao.withOpacity(0.1),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(_aRodar ? 30 : 0), bottomRight: Radius.circular(_aRodar ? 30 : 0)),
          boxShadow: _aRodar ? [BoxShadow(color: _corCartao.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)] : [],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("GLOBO", style: TextStyle(color: _aRodar ? Colors.white : _corCartao, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 300), style: TextStyle(color: Colors.white, fontSize: _aRodar ? 26 : 22, fontWeight: FontWeight.bold), child: Text(_ultimoSorteado))])),
          FloatingActionButton(onPressed: _toggleRolar, backgroundColor: _aRodar ? Colors.red : _corCartao, child: Icon(_aRodar ? Icons.pause : Icons.play_arrow, color: Colors.white))
        ])
      ),
      Container(height: 50, color: Colors.black, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _sorteados.length, itemBuilder: (c, i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15), child: Text(_sorteados[i], style: const TextStyle(color: Colors.white54))))),
      
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Colors.deepOrange, Colors.blueAccent, Colors.purpleAccent, Colors.greenAccent].map((c) => 
          GestureDetector(onTap: () => setState(() { _corCartao = c; _gerarCartao(); } ), child: Container(margin: const EdgeInsets.symmetric(horizontal: 5), width: 30, height: 30, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: _corCartao == c ? Colors.white : Colors.transparent, width: 2))))
        ).toList()),
      ),
      
      Expanded(child: Padding(padding: const EdgeInsets.all(15), child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1),
        itemCount: 16, itemBuilder: (c, i) => GestureDetector(
          onTap: () => setState(() => _marcados[i] = !_marcados[i]),
          child: Container(decoration: BoxDecoration(color: _marcados[i] ? Colors.green : _corCartao, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withOpacity(0.2))), child: Center(child: Text(_cartao[i], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))))
        )
      ))),
      Padding(padding: const EdgeInsets.all(10), child: ElevatedButton.icon(onPressed: () => setState(()=>_gerarCartao()), icon: const Icon(Icons.refresh, color: Colors.black), label: const Text("NOVO CARTÃO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white)))
    ]);
  }
}

// ==========================================
// 5. DOMINÓ DE VIAGEM (Mais Fluido e Dinâmico)
// ==========================================
class PecaDomino { final String esq, dir; PecaDomino(this.esq, this.dir); }
class DominoTuristico extends StatefulWidget { const DominoTuristico({super.key}); @override State<DominoTuristico> createState() => _DominoTuristicoState(); }
class _DominoTuristicoState extends State<DominoTuristico> {
  final List<String> _simbolos = ['🧳', '📸', '🗺️', '✈️', '🍷', '🚋', '🌉'];
  List<PecaDomino> _mao = [], _mesa = [], _bot = [];
  String _msg = "Clica numa peça para jogar.";

  @override void initState() { super.initState(); _iniciar(); }
  void _iniciar() {
    List<PecaDomino> todas = [];
    for(int i=0; i<7; i++) for(int j=i; j<7; j++) todas.add(PecaDomino(_simbolos[i], _simbolos[j]));
    todas.shuffle(); _mao = todas.sublist(0, 7); _bot = todas.sublist(7, 14); _mesa = []; _msg = "O teu turno!";
  }
  
  void _jogar(PecaDomino p) {
    if (_mesa.isEmpty) { _mesa.add(p); _mao.remove(p); _turnoBot(); return; }
    if (p.dir == _mesa.first.esq) { _mesa.insert(0, PecaDomino(p.esq, p.dir)); _mao.remove(p); _turnoBot(); }
    else if (p.esq == _mesa.first.esq) { _mesa.insert(0, PecaDomino(p.dir, p.esq)); _mao.remove(p); _turnoBot(); }
    else if (p.esq == _mesa.last.dir) { _mesa.add(PecaDomino(p.esq, p.dir)); _mao.remove(p); _turnoBot(); }
    else if (p.dir == _mesa.last.dir) { _mesa.add(PecaDomino(p.dir, p.esq)); _mao.remove(p); _turnoBot(); }
    else { setState(() => _msg = "Essa peça não encaixa!"); }
  }

  void _turnoBot() {
    if (_mao.isEmpty) { setState(() => _msg = "GANHASTE!"); return; }
    Future.delayed(const Duration(milliseconds: 800), () {
      if(!mounted) return;
      for (var p in _bot) {
        if (p.dir == _mesa.first.esq) { _mesa.insert(0, PecaDomino(p.esq, p.dir)); _bot.remove(p); setState((){_msg="O Guia jogou!";}); return; }
        if (p.esq == _mesa.first.esq) { _mesa.insert(0, PecaDomino(p.dir, p.esq)); _bot.remove(p); setState((){_msg="O Guia jogou!";}); return; }
        if (p.esq == _mesa.last.dir) { _mesa.add(PecaDomino(p.esq, p.dir)); _bot.remove(p); setState((){_msg="O Guia jogou!";}); return; }
        if (p.dir == _mesa.last.dir) { _mesa.add(PecaDomino(p.dir, p.esq)); _bot.remove(p); setState((){_msg="O Guia jogou!";}); return; }
      }
      setState(() => _msg = "O Guia passou o turno.");
    });
  }

  @override Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: const EdgeInsets.all(15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("O Guia tem ${_bot.length} peças", style: const TextStyle(color: Colors.white54)), Text(_msg, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))])),
      
      // ✨ MESA FLUIDA COM EFEITO WRAP ✨
      Expanded(child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 4, runSpacing: 10,
            children: _mesa.map((p) => Container(
              width: 80, height: 40, 
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2))]), 
              child: Row(children: [Expanded(child: Center(child: Text(p.esq, style: const TextStyle(fontSize: 20)))), Container(width: 2, color: Colors.black87), Expanded(child: Center(child: Text(p.dir, style: const TextStyle(fontSize: 20))))])
            )).toList()
          )
        )
      )),
      
      Container(height: 100, color: Colors.white10, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(10), itemCount: _mao.length, itemBuilder: (c, i) => GestureDetector(onTap: () => _jogar(_mao[i]), child: Container(margin: const EdgeInsets.only(right: 10), width: 40, decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5, offset: Offset(2, 2))]), child: Column(children: [Expanded(child: Center(child: Text(_mao[i].esq, style: const TextStyle(fontSize: 20)))), Container(height: 2, color: Colors.black87), Expanded(child: Center(child: Text(_mao[i].dir, style: const TextStyle(fontSize: 20))))]))))),
      Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(onPressed: _iniciar, child: const Text("REINICIAR")))
    ]);
  }
}

// ==========================================
// 6. A GRANDE SUECA (Mesa Oval Clássica)
// ==========================================
class CartaSueca { final String naipe, valor; final int pts, rank; CartaSueca(this.naipe, this.valor, this.pts, this.rank); }
class JogoSueca extends StatefulWidget { const JogoSueca({super.key}); @override State<JogoSueca> createState() => _JogoSuecaState(); }
class _JogoSuecaState extends State<JogoSueca> {
  final List<String> _naipes = ['♠', '♥', '♣', '♦'];
  final List<Map<String, dynamic>> _valores = [{'v':'A','p':11,'r':10}, {'v':'7','p':10,'r':9}, {'v':'K','p':4,'r':8}, {'v':'J','p':3,'r':7}, {'v':'Q','p':2,'r':6}, {'v':'6','p':0,'r':5}, {'v':'5','p':0,'r':4}, {'v':'4','p':0,'r':3}, {'v':'3','p':0,'r':2}, {'v':'2','p':0,'r':1}];
  
  List<CartaSueca> _maoSul = []; List<List<CartaSueca>> _bots = [[],[],[]]; 
  String _trunfo = ''; List<CartaSueca?> _mesa = [null, null, null, null]; 
  int _turno = 0, _pontosEquipaSulNorte = 0, _pontosEquipaEsteOeste = 0;
  String _msg = "A dar as cartas...";

  @override void initState() { super.initState(); _darCartas(); }
  void _darCartas() {
    List<CartaSueca> baralho = [];
    for(var n in _naipes) { for(var v in _valores) { baralho.add(CartaSueca(n, v['v'], v['p'], v['r'])); } }
    baralho.shuffle(); _trunfo = baralho.last.naipe;
    _maoSul = baralho.sublist(0, 10); _maoSul.sort((a,b) => a.naipe.compareTo(b.naipe));
    _bots = [baralho.sublist(10, 20), baralho.sublist(20, 30), baralho.sublist(30, 40)];
    _pontosEquipaSulNorte = 0; _pontosEquipaEsteOeste = 0; _mesa = [null, null, null, null]; _turno = 0; _msg = "O Trunfo é $_trunfo. Tu começas!";
  }

  void _jogarCarta(int cartaIdx) {
    if (_turno != 0 || _mesa[0] != null) return;
    CartaSueca jogada = _maoSul[cartaIdx];
    
    String naipePuxado = '';
    for (var c in _mesa) { if (c != null) { naipePuxado = c.naipe; break; } }
    
    if (naipePuxado != '' && jogada.naipe != naipePuxado && _maoSul.any((c) => c.naipe == naipePuxado)) { setState((){_msg="Tens de assistir ao naipe ($naipePuxado)!";}); return; }
    
    setState(() { _mesa[0] = jogada; _maoSul.removeAt(cartaIdx); _turno = 1; _msg = "Aguardar os outros..."; });
    _jogarBots();
  }

  void _jogarBots() async {
    for (int i = 1; i <= 3; i++) {
      if (_mesa[i] != null) continue;
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      
      String puxado = '';
      for (var c in _mesa) { if (c != null) { puxado = c.naipe; break; } }
      
      List<CartaSueca> possiveis = puxado == '' ? _bots[i-1] : _bots[i-1].where((c) => c.naipe == puxado).toList();
      if (possiveis.isEmpty) possiveis = _bots[i-1];
      CartaSueca escolhida = possiveis[Random().nextInt(possiveis.length)];
      setState(() { _mesa[i] = escolhida; _bots[i-1].remove(escolhida); });
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    _avaliarVaza();
  }

  void _avaliarVaza() {
    if(!mounted) return;
    
    String puxado = '';
    for (var c in _mesa) { if (c != null) { puxado = c.naipe; break; } }
    
    int indexVencedor = 0; CartaSueca melhor = _mesa[0]!;
    for (int i = 1; i < 4; i++) {
      CartaSueca? c = _mesa[i];
      if (c == null) continue;
      bool isTrunfo = c.naipe == _trunfo; bool bestIsTrunfo = melhor.naipe == _trunfo;
      if (isTrunfo && !bestIsTrunfo) { melhor = c; indexVencedor = i; }
      else if (isTrunfo && bestIsTrunfo && c.rank > melhor.rank) { melhor = c; indexVencedor = i; }
      else if (!isTrunfo && !bestIsTrunfo && c.naipe == puxado && c.rank > melhor.rank) { melhor = c; indexVencedor = i; }
    }
    
    int ptsGanhos = 0;
    for (var c in _mesa) { if (c != null) ptsGanhos += c.pts; }
    
    setState(() {
      if (indexVencedor == 0 || indexVencedor == 2) _pontosEquipaSulNorte += ptsGanhos; else _pontosEquipaEsteOeste += ptsGanhos;
      _mesa = [null, null, null, null];
      if (_maoSul.isEmpty) { _msg = "FIM! Nós: $_pontosEquipaSulNorte | Eles: $_pontosEquipaEsteOeste"; } 
      else { _turno = indexVencedor; _msg = indexVencedor == 0 ? "Ganhámos a vaza! Joga tu." : "Bot ganhou a vaza."; if (_turno != 0) _jogarBots(); }
    });
  }

  Color _corNaipe(String n) => (n == '♥' || n == '♦') ? Colors.red : Colors.black;

  @override Widget build(BuildContext context) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), color: Colors.black, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Nós: $_pontosEquipaSulNorte  |  Eles: $_pontosEquipaEsteOeste", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)), child: Text("Trunfo: $_trunfo", style: TextStyle(color: _corNaipe(_trunfo), fontWeight: FontWeight.bold, fontSize: 16)))])),
      
      // ✨ MESA OVAL CLÁSSICA ✨
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(200), // Forma Oval
              border: Border.all(color: Colors.brown.shade800, width: 12), // Borda de madeira
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15, spreadRadius: 5)],
            ),
            child: Stack(alignment: Alignment.center, children: [
              // Norte
              if (_mesa[2] != null) Positioned(top: 20, child: _cartaUI(_mesa[2]!)), 
              // Este
              if (_mesa[1] != null) Positioned(right: 20, child: _cartaUI(_mesa[1]!)), 
              // Oeste
              if (_mesa[3] != null) Positioned(left: 20, child: _cartaUI(_mesa[3]!)), 
              // Sul (A tua jogada)
              if (_mesa[0] != null) Positioned(bottom: 20, child: _cartaUI(_mesa[0]!)), 
              
              if (_mesa.every((c) => c==null)) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(_msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
            ]),
          ),
        )
      ),
      Container(height: 120, color: Colors.black, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(10), itemCount: _maoSul.length, itemBuilder: (c, i) => GestureDetector(onTap: () => _jogarCarta(i), child: Padding(padding: const EdgeInsets.only(right: 5), child: _cartaUI(_maoSul[i]))))),
      if (_maoSul.isEmpty) ElevatedButton(onPressed: _darCartas, child: const Text("NOVO JOGO"))
    ]);
  }

  Widget _cartaUI(CartaSueca c) {
    return Container(width: 60, height: 90, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 1.5), boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(c.valor, style: TextStyle(color: _corNaipe(c.naipe), fontSize: 24, fontWeight: FontWeight.bold)), Text(c.naipe, style: TextStyle(color: _corNaipe(c.naipe), fontSize: 24))]));
  }
}

// ==========================================
// 7. LIVRO DE COLORIR
// ==========================================
class QuadroDesenho extends StatefulWidget { const QuadroDesenho({super.key}); @override State<QuadroDesenho> createState() => _QuadroDesenhoState(); }
class _QuadroDesenhoState extends State<QuadroDesenho> {
  List<Offset?> _pontos = [];
  @override Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: const EdgeInsets.all(15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Livro Livre", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 18)), IconButton(icon: const Icon(Icons.delete, color: Colors.white), onPressed: () => setState(() => _pontos.clear()))])),
      Expanded(child: Container(margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: GestureDetector(onPanUpdate: (detalhes) => setState(() => _pontos.add(detalhes.localPosition)), onPanEnd: (detalhes) => setState(() => _pontos.add(null)), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: CustomPaint(painter: _Pintor(_pontos), size: Size.infinite)))))
    ]);
  }
}
class _Pintor extends CustomPainter {
  final List<Offset?> pontos; _Pintor(this.pontos);
  @override void paint(Canvas canvas, Size size) { Paint tinta = Paint()..color = Colors.cyanAccent.shade700..strokeCap = StrokeCap.round..strokeWidth = 5.0; for (int i = 0; i < pontos.length - 1; i++) { if (pontos[i] != null && pontos[i + 1] != null) canvas.drawLine(pontos[i]!, pontos[i + 1]!, tinta); } }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}