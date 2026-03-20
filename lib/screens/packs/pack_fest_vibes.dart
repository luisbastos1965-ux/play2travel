import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// ==========================================
// PACK: FEST VIBES (ESPECIAL SÃO JOÃO & EVENTOS)
// ==========================================

// ------------------------------------------
// JOGO 1: S. JOÃO CHALLENGE (3 em 1)
// ------------------------------------------
class SJoaoChallenge extends StatefulWidget {
  const SJoaoChallenge({super.key});
  @override
  State<SJoaoChallenge> createState() => _SJoaoChallengeState();
}

class _SJoaoChallengeState extends State<SJoaoChallenge> {
  int _abaAtual = 0; 
  int _minhasSardinhas = 0;
  int _minhasMarteladas = 0;
  bool _fotoTirada = false;
  int _meusVotos = 0;

  final List<Map<String, dynamic>> _grupoSardinhas = [{'nome': 'João', 'pontos': 5, 'icone': '🧔'}, {'nome': 'Maria', 'pontos': 3, 'icone': '👩'}, {'nome': 'Rui', 'pontos': 7, 'icone': '🧑'}];
  final List<Map<String, dynamic>> _grupoMartelos = [{'nome': 'João', 'pontos': 45, 'icone': '🧔'}, {'nome': 'Maria', 'pontos': 112, 'icone': '👩'}, {'nome': 'Rui', 'pontos': 89, 'icone': '🧑'}];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _obterCorFundo(),
      child: Column(children: [_buildBarraNavegacaoInterna(), Expanded(child: _construirAbaAtiva())]),
    );
  }

  Color _obterCorFundo() {
    if (_abaAtual == 0) return const Color(0xFF100800); 
    if (_abaAtual == 1) return const Color(0xFF00101A); 
    return Colors.black; 
  }

  Widget _buildBarraNavegacaoInterna() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), color: Colors.black54,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_botaoAba(0, "🐟", "SARDINHAS", Colors.orange), _botaoAba(1, "🔨", "MARTELOS", Colors.cyanAccent), _botaoAba(2, "🎆", "FOGO", Colors.purpleAccent)]),
    );
  }

  Widget _botaoAba(int index, String emoji, String titulo, Color corAtiva) {
    bool ativo = _abaAtual == index;
    return GestureDetector(
      onTap: () => setState(() => _abaAtual = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(color: ativo ? corAtiva.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: ativo ? corAtiva : Colors.white10)),
        child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 16)), if (ativo) ...[const SizedBox(width: 8), Text(titulo, style: TextStyle(color: corAtiva, fontWeight: FontWeight.bold, fontSize: 12))]]),
      ),
    );
  }

  Widget _construirAbaAtiva() {
    switch (_abaAtual) {
      case 0: return _buildSardinhas();
      case 1: return _buildMartelos();
      case 2: return _buildFogoArtificio();
      default: return _buildSardinhas();
    }
  }

  Widget _buildSardinhas() {
    List<Map<String, dynamic>> r = [..._grupoSardinhas, {'nome': 'TU', 'pontos': _minhasSardinhas, 'icone': '😎', 'isMe': true}];
    r.sort((a, b) => b['pontos'].compareTo(a['pontos']));
    return Column(children: [
      _cabecalhoFestivo("REI DA SARDINHA", "Quem come mais esta noite?", Icons.local_fire_department, Colors.orange), const SizedBox(height: 20),
      GestureDetector(onTap: () => setState(() => _minhasSardinhas++), child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.2), border: Border.all(color: Colors.orange, width: 4), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 30)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("🐟", style: TextStyle(fontSize: 50)), Text("$_minhasSardinhas", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 30), const Text("RANKING DO GRUPO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
      Expanded(child: _buildListaRanking(r, Colors.orange, "🐟")),
    ]);
  }

  Widget _buildMartelos() {
    List<Map<String, dynamic>> r = [..._grupoMartelos, {'nome': 'TU', 'pontos': _minhasMarteladas, 'icone': '😎', 'isMe': true}];
    r.sort((a, b) => b['pontos'].compareTo(a['pontos']));
    return Column(children: [
      _cabecalhoFestivo("MESTRE DO MARTELO", "Distribui amor em forma de plástico!", Icons.hardware, Colors.cyanAccent), const SizedBox(height: 20),
      GestureDetector(onTap: () => setState(() => _minhasMarteladas++), child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent.withOpacity(0.1), border: Border.all(color: Colors.cyanAccent, width: 4), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 30)]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("🔨", style: TextStyle(fontSize: 50)), Text("$_minhasMarteladas", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 30), const Text("RANKING DE MARTELADAS", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
      Expanded(child: _buildListaRanking(r, Colors.cyanAccent, "🔨")),
    ]);
  }

  Widget _buildFogoArtificio() {
    return Column(children: [
      _cabecalhoFestivo("FOGO DE ARTIFÍCIO", "Encontra o melhor ângulo à meia-noite.", Icons.camera, Colors.purpleAccent),
      Expanded(child: _fotoTirada ? _buildGaleriaVotacao() : _buildEcraCamera())
    ]);
  }

  Widget _buildEcraCamera() {
    return Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(height: 250, width: double.infinity, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5), width: 2)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.photo_camera_back, color: Colors.white24, size: 60), SizedBox(height: 20), Text("A aguardar a obra de arte...", style: TextStyle(color: Colors.white54))])),
      const SizedBox(height: 30),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _fotoTirada = true), icon: const Icon(Icons.camera_alt, color: Colors.black), label: const Text("TIRAR FOTO E PARTILHAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 20))))
    ]));
  }

  Widget _buildGaleriaVotacao() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("A TUA CAPTURA", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
      Container(height: 180, width: double.infinity, decoration: BoxDecoration(color: Colors.purple.withOpacity(0.2), borderRadius: BorderRadius.circular(15), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1533504859868-b32c63283f5c?w=600&q=80'), fit: BoxFit.cover)), child: Align(alignment: Alignment.bottomRight, child: Padding(padding: const EdgeInsets.all(10), child: Chip(backgroundColor: Colors.black87, label: Text("$_meusVotos Votos", style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)))))),
      const SizedBox(height: 20), const Text("GALERIA DO GRUPO (VOTA NA MELHOR)", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 15),
      _fotoAmigo('https://images.unsplash.com/photo-1498429152472-9a433d9ddf3b?w=600&q=80', 'João', 3), const SizedBox(height: 15), _fotoAmigo('https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&q=80', 'Maria', 5),
    ]));
  }

  Widget _fotoAmigo(String url, String nome, int votos) {
    bool votado = false;
    return StatefulBuilder(builder: (context, setLocalState) {
      return Container(height: 130, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)), padding: const EdgeInsets.all(15), child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Foto de $nome", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), ElevatedButton.icon(onPressed: () => setLocalState(() { votado = !votado; if(votado) _meusVotos++; else _meusVotos--; }), icon: Icon(votado ? Icons.favorite : Icons.favorite_border, color: votado ? Colors.redAccent : Colors.white, size: 16), label: Text(votado ? "${votos + 1}" : "$votos", style: TextStyle(color: votado ? Colors.redAccent : Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.black54, padding: const EdgeInsets.symmetric(horizontal: 10)))]) ) );
    });
  }

  Widget _buildListaRanking(List<Map<String, dynamic>> ranking, Color corAcento, String emojiStr) {
    return ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 30), itemCount: ranking.length, itemBuilder: (context, index) {
      final r = ranking[index]; bool isMe = r['isMe'] == true;
      return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: isMe ? corAcento.withOpacity(0.2) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: isMe ? corAcento : Colors.transparent)), child: Row(children: [Text("#${index + 1}", style: TextStyle(color: index == 0 ? Colors.amber : Colors.white54, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(width: 15), Text(r['icone'], style: const TextStyle(fontSize: 24)), const SizedBox(width: 15), Expanded(child: Text(r['nome'], style: TextStyle(color: isMe ? corAcento : Colors.white, fontWeight: FontWeight.bold, fontSize: 18))), Text("${r['pontos']} $emojiStr", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]) );
    });
  }

  Widget _cabecalhoFestivo(String titulo, String subtitulo, IconData icone, Color cor) {
    return Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), decoration: BoxDecoration(gradient: LinearGradient(colors: [cor.withOpacity(0.3), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Row(children: [Icon(icone, color: cor, size: 40), const SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 5), Text(subtitulo, style: const TextStyle(color: Colors.white70, fontSize: 12))]))]));
  }
}

// ------------------------------------------
// JOGO 2: AFTERMOVIE COLETIVO
// ------------------------------------------
class AftermovieColetivo extends StatefulWidget {
  const AftermovieColetivo({super.key});
  @override
  State<AftermovieColetivo> createState() => _AftermovieColetivoState();
}

class _AftermovieColetivoState extends State<AftermovieColetivo> {
  String _faseAtual = 'MENU'; 
  Map<String, String>? _cartaSelecionada;
  int _clipesGravados = 0;
  bool _aGravar = false;

  final List<Map<String, String>> _cartas = [
    {'titulo': 'Luz, Câmara, Ação!', 'instrucao': 'Quando chegar a um ponto icónico, levanta esta carta e todos preparam-se para filmar.', 'efeito': 'Sinaliza o início da gravação coletiva.', 'icone': '🎬'},
    {'titulo': 'Plano Geral', 'instrucao': 'Afasta-te 5 metros do grupo e filma toda a equipa com o local ao fundo.', 'efeito': 'Mostra o contexto e o cenário completo.', 'icone': '⛰️'},
    {'titulo': 'Plano Orbital', 'instrucao': 'Rodeia lentamente um colega enquanto filmas.', 'efeito': 'Cria movimento cinematográfico fluido.', 'icone': '🔄'},
    {'titulo': 'Dolly Zoom', 'instrucao': 'Caminha para trás enquanto fazes zoom na frente (efeito Vertigo).', 'efeito': 'O vídeo ganha filtro dourado especial.', 'icone': '😵‍💫'},
    {'titulo': 'Close-Up', 'instrucao': 'Capta as expressões faciais de um colega ou detalhe emocional.', 'efeito': 'Adiciona emoção e foco no vídeo final.', 'icone': '👁️'},
    {'titulo': 'Plano Detalhe', 'instrucao': 'Filma mãos, pés ou objetos importantes durante a atividade.', 'efeito': 'Dá dinamismo e variedade de planos.', 'icone': '🔍'},
    {'titulo': 'Time-lapse Humano', 'instrucao': 'Fiquem imóveis como estátuas por 30s enquanto outro filma.', 'efeito': 'Mostra a cidade em movimento e o grupo parado.', 'icone': '🗽'},
    {'titulo': 'VOX POP', 'instrucao': 'Entrevista um transeunte ou faz uma pergunta surpresa a um colega.', 'efeito': 'Traz humor e espontaneidade ao filme.', 'icone': '🎤'},
    {'titulo': 'StoryBoard', 'instrucao': 'Escolhe previamente o tipo de plano que vais filmar e indica aos colegas.', 'efeito': 'Garante variedade de ângulos no aftermovie.', 'icone': '📋'},
    {'titulo': 'Cartão Musical', 'instrucao': 'Escolhe a música que combina com o cenário e dancem.', 'efeito': 'A música dá ritmo ao vídeo final.', 'icone': '🎵'},
    {'titulo': 'Efeito Cinemático', 'instrucao': 'Experimenta movimentos criativos: slow motion ou panorâmica.', 'efeito': 'Adiciona estilo e dinamismo.', 'icone': '✨'},
    {'titulo': 'Estreia do filme', 'instrucao': 'No final do percurso, reúne o grupo, mostra o vídeo final e celebra!', 'efeito': 'Marca o encerramento da experiência.', 'icone': '🍿'},
  ];

  void _simularGravacao() {
    setState(() => _aGravar = true);
    Timer(const Duration(seconds: 3), () {
      setState(() { _aGravar = false; _clipesGravados++; _faseAtual = 'MENU'; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Clip adicionado à Timeline!"), backgroundColor: Colors.green)); });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'MENU') return _buildMenuCartas();
    if (_faseAtual == 'CAMERA') return _buildCameraSimulada();
    if (_faseAtual == 'ESTREIA') return _buildEstreia();
    return const SizedBox.shrink();
  }

  Widget _buildMenuCartas() {
    return Container(
      color: const Color(0xFF0F0F0F),
      child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Colors.black), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Row(children: [Icon(Icons.movie_creation, color: Colors.deepOrange), SizedBox(width: 10), Text("CARTAS DE REALIZADOR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), Chip(backgroundColor: Colors.deepOrange.withOpacity(0.2), side: const BorderSide(color: Colors.deepOrange), label: Text("$_clipesGravados CLIPS", style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)))])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(20), itemCount: _cartas.length, itemBuilder: (context, index) {
          final c = _cartas[index]; bool isEstreia = c['titulo'] == 'Estreia do filme';
          return GestureDetector(
            onTap: () { if (isEstreia) { if (_clipesGravados > 0) { setState(() => _faseAtual = 'ESTREIA'); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Grava pelo menos 1 clip!"), backgroundColor: Colors.red)); } } else { setState(() { _cartaSelecionada = c; _faseAtual = 'CAMERA'; }); } },
            child: Container(margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: isEstreia ? Colors.amber.withOpacity(0.1) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: isEstreia ? Colors.amber : Colors.white10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(c['icone']!, style: const TextStyle(fontSize: 24)), const SizedBox(width: 15), Expanded(child: Text(c['titulo']!, style: TextStyle(color: isEstreia ? Colors.amber : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))]), const SizedBox(height: 15), Text("Instrução:", style: TextStyle(color: isEstreia ? Colors.amber : Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(c['instrucao']!, style: const TextStyle(color: Colors.white70, fontSize: 14)), const SizedBox(height: 10), Text("Efeito no filme:", style: TextStyle(color: isEstreia ? Colors.amber : Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(c['efeito']!, style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic))])),
          );
        }))
      ]),
    );
  }

  Widget _buildCameraSimulada() {
    return Container(color: Colors.black, child: Stack(children: [
      Opacity(opacity: 0.5, child: Image.network('https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80', fit: BoxFit.cover, height: double.infinity, width: double.infinity)),
      Positioned(top: 20, left: 20, child: Row(children: [const Icon(Icons.videocam, color: Colors.white, size: 20), const SizedBox(width: 10), Text(_aGravar ? "REC 00:00:03" : "READY", style: TextStyle(color: _aGravar ? Colors.red : Colors.white, fontWeight: FontWeight.bold, fontSize: 16))])),
      Positioned(top: 20, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => !_aGravar ? setState(() => _faseAtual = 'MENU') : null)),
      Center(child: Container(padding: const EdgeInsets.all(20), margin: const EdgeInsets.symmetric(horizontal: 30), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.deepOrange)), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(_cartaSelecionada!['titulo']!.toUpperCase(), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10), Text(_cartaSelecionada!['instrucao']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14))]))),
      Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.only(bottom: 40), child: GestureDetector(onTap: () => !_aGravar ? _simularGravacao() : null, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: Colors.white24), child: Center(child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: _aGravar ? 30 : 60, height: _aGravar ? 30 : 60, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(_aGravar ? 10 : 30))))))))
    ]));
  }

  Widget _buildEstreia() {
    return Container(width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Colors.black), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.movie, color: Colors.amber, size: 80), const SizedBox(height: 20), const Text("ESTREIA DO FILME!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text("A vossa equipa compilou $_clipesGravados cenas.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 40),
      Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white24)), child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.play_circle_fill, color: Colors.amber, size: 60), SizedBox(height: 10), Text("REPRODUZIR AFTERMOVIE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 50), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.black), label: const Text("PARTILHAR OBRA-PRIMA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)))), const SizedBox(height: 15), TextButton(onPressed: () => setState(() => _faseAtual = 'MENU'), child: const Text("Voltar às gravações", style: TextStyle(color: Colors.white54))),
    ]));
  }
}

// ------------------------------------------
// JOGO 3: TOKENS DE EVENTO (NOVO)
// ------------------------------------------
class TokensDeEvento extends StatefulWidget {
  const TokensDeEvento({super.key});
  @override
  State<TokensDeEvento> createState() => _TokensDeEventoState();
}

class _TokensDeEventoState extends State<TokensDeEvento> {
  String _faseAtual = 'SETUP'; // SETUP -> GESTAO
  double _multiplicador = 1.0;
  
  final List<String> _historico = [];

  late Map<String, Map<String, dynamic>> _categorias;

  final List<Map<String, dynamic>> _eventosSurpresa = [
    {'nome': 'Festival de Rua!', 'desc': 'Encontraram música perto dos Aliados.', 'cat': 'Experiências', 'val': -1},
    {'nome': 'Miradouro Épico', 'desc': 'Vista incrível na Vitória.', 'cat': 'Pausas', 'val': -1},
    {'nome': 'Promoção Local', 'desc': 'A tasca fez um desconto de grupo.', 'cat': 'Gastronomia', 'val': 1},
    {'nome': 'Chuva Inesperada', 'desc': 'Precisam de um abrigo rápido.', 'cat': 'Transportes', 'val': -1},
  ];

  @override
  void initState() {
    super.initState();
    _inicializarCategorias();
  }

  void _inicializarCategorias() {
    _categorias = {
      'Gastronomia': {'icone': '🍽', 'tokensBase': 8, 'tokensAtual': 8, 'opcoes': [{'nome': 'Restaurante Típico', 'custo': 3}, {'nome': 'Tasca Local', 'custo': 2}, {'nome': 'Street Food', 'custo': 1}]},
      'Cultura': {'icone': '🏛', 'tokensBase': 6, 'tokensAtual': 6, 'opcoes': [{'nome': 'Museu Grande', 'custo': 3}, {'nome': 'Monumento', 'custo': 2}, {'nome': 'Galeria / Igreja', 'custo': 1}]},
      'Transportes': {'icone': '🚋', 'tokensBase': 6, 'tokensAtual': 6, 'opcoes': [{'nome': 'Tuk-Tuk', 'custo': 3}, {'nome': 'Elétrico Histórico', 'custo': 2}, {'nome': 'Metro / Autocarro', 'custo': 1}]},
      'Experiências': {'icone': '🎯', 'tokensBase': 5, 'tokensAtual': 5, 'opcoes': [{'nome': 'Tour Guiado', 'custo': 3}, {'nome': 'Prova de Vinhos', 'custo': 2}, {'nome': 'Miradouro Pago', 'custo': 1}]},
      'Pausas': {'icone': '☕', 'tokensBase': 4, 'tokensAtual': 4, 'opcoes': [{'nome': 'Café Histórico', 'custo': 2}, {'nome': 'Pastelaria Normal', 'custo': 1}]},
      'Extras': {'icone': '🎁', 'tokensBase': 3, 'tokensAtual': 3, 'opcoes': [{'nome': 'Souvenir Grande', 'custo': 2}, {'nome': 'Íman / Postal', 'custo': 1}]},
    };
  }

  void _iniciarJogo(double mult) {
    setState(() {
      _multiplicador = mult;
      _categorias.forEach((key, value) {
        value['tokensAtual'] = (value['tokensBase'] * _multiplicador).round();
      });
      _faseAtual = 'GESTAO';
    });
  }

  void _comprarExperiencia(String categoria, String nomeExp, int custo) {
    if (_categorias[categoria]!['tokensAtual'] >= custo) {
      setState(() {
        _categorias[categoria]!['tokensAtual'] -= custo;
        _historico.insert(0, "$nomeExp ($categoria) - Gastou $custo 🟡");
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Aprovado pelo gestor de $categoria!"), backgroundColor: Colors.green));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tokens insuficientes! Negoceiem!"), backgroundColor: Colors.red));
    }
  }

  void _puxarCartaEvento() {
    final random = Random();
    final evento = _eventosSurpresa[random.nextInt(_eventosSurpresa.length)];
    String cat = evento['cat'];
    int val = evento['val'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(children: [const Icon(Icons.warning_amber_rounded, color: Colors.amber), const SizedBox(width: 10), Expanded(child: Text(evento['nome'], style: const TextStyle(color: Colors.white)))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evento['desc'], style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Text(val < 0 ? "Custo: ${val.abs()} 🟡 de $cat" : "Bónus: +$val 🟡 para $cat", style: TextStyle(color: val < 0 ? Colors.redAccent : Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _categorias[cat]!['tokensAtual'] += val;
                // Impede que tokens fiquem negativos
                if (_categorias[cat]!['tokensAtual'] < 0) _categorias[cat]!['tokensAtual'] = 0;
                _historico.insert(0, "EVENTO: ${evento['nome']} ($val 🟡)");
              });
              Navigator.pop(context);
            },
            child: const Text("Aceitar Destino", style: TextStyle(color: Colors.amber)),
          )
        ],
      )
    );
  }

  void _abrirLoja(String categoria) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        List<dynamic> opcoes = _categorias[categoria]!['opcoes'];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Decisão de $categoria", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Tokens disponíveis: ${_categorias[categoria]!['tokensAtual']} 🟡", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...opcoes.map((op) => ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.white54),
                title: Text(op['nome'], style: const TextStyle(color: Colors.white)),
                trailing: Chip(backgroundColor: Colors.amber.withOpacity(0.2), label: Text("${op['custo']} 🟡", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                onTap: () => _comprarExperiencia(categoria, op['nome'], op['custo']),
              )).toList(),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP') return _buildSetup();
    return _buildGestao();
  }

  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF050510)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("TOKENS DE EVENTO", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Cada pessoa é o Gestor de uma categoria. O orçamento é limitado. Negoceiem!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 40),
          
          _botaoDuracao("VERSÃO CURTA", "3-4 Horas", 0.5), const SizedBox(height: 15),
          _botaoDuracao("STANDARD", "1 Dia Inteiro", 1.0), const SizedBox(height: 15),
          _botaoDuracao("EXPLORADOR", "2-3 Dias", 1.5),
        ],
      ),
    );
  }

  Widget _botaoDuracao(String t, String d, double mult) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _iniciarJogo(mult),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.1), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.white24))),
        child: Column(children: [Text(t, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)), Text(d, style: const TextStyle(color: Colors.white70, fontSize: 12))]),
      ),
    );
  }

  Widget _buildGestao() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20), decoration: BoxDecoration(border: const Border(bottom: BorderSide(color: Colors.white10)), color: Colors.amber.withOpacity(0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("GESTÃO DE GRUPO", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _puxarCartaEvento,
                  icon: const Icon(Icons.flash_on, color: Colors.black, size: 16),
                  label: const Text("EVENTO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.1),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                String key = _categorias.keys.elementAt(index);
                var cat = _categorias[key]!;
                return GestureDetector(
                  onTap: () => _abrirLoja(key),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.3))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['icone'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text(key, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("${cat['tokensAtual']} 🟡", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 150, width: double.infinity,
            padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Color(0xFF121212), border: Border(top: BorderSide(color: Colors.white10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("HISTÓRICO DA VIAGEM", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                const SizedBox(height: 10),
                Expanded(
                  child: _historico.isEmpty 
                    ? const Center(child: Text("Ainda não gastaram tokens.", style: TextStyle(color: Colors.white24)))
                    : ListView.builder(
                        itemCount: _historico.length,
                        itemBuilder: (context, i) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text("• ${_historico[i]}", style: const TextStyle(color: Colors.white70, fontSize: 14))),
                      ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}