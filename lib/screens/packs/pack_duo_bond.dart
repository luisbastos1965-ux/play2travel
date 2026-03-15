import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

// ==========================================
// JOGO 1: PUZZLE DE PAR (DUO BOND)
// ==========================================
class PuzzleDePar extends StatefulWidget {
  const PuzzleDePar({super.key});

  @override
  State<PuzzleDePar> createState() => _PuzzleDeParState();
}

class _PuzzleDeParState extends State<PuzzleDePar> {
  String _faseAtual = 'INSTRUCOES'; 
  int _localAtualIndex = 0;
  int _xpAcumulado = 0;

  final List<Map<String, dynamic>> _locais = [
    {
      'nome': 'Capela das Almas',
      'dicaJ1': 'Caminha em direção a Norte pela rua mais movimentada do comércio tradicional (Rua de Santa Catarina). Procura o cruzamento com a Rua Fernandes Tomás.\n\n📍 COORDENADAS:\n41.1498° N, 8.6056° W',
      'iconeJ1': Icons.explore,
      'imgJ2': 'https://images.unsplash.com/photo-1542273917363-3b1817f69a5d?w=600&q=80', 
      'padraoJ2': 'Procura o painel exterior que mostra a morte de São Francisco de Assis. Foca-te no padrão floral que envolve a borda inferior dos azulejos.',
    },
    {
      'nome': 'Estação de S. Bento',
      'dicaJ1': 'Desce a colina em direção ao coração histórico. Deves procurar o grande edifício central por onde entram e saem os comboios diariamente.\n\n📍 COORDENADAS:\n41.1456° N, 8.6115° W',
      'iconeJ1': Icons.train,
      'imgJ2': 'https://images.unsplash.com/photo-1620311497232-613d9865f3bc?w=600&q=80',
      'padraoJ2': 'Entrem no hall principal. Encontra o painel da "Batalha de Arcos de Valdevez". Repara no detalhe das lanças cruzadas no topo da imagem.',
    },
    {
      'nome': 'Igreja do Carmo',
      'dicaJ1': 'Sobe a rua que ladeia a icónica Torre (Rua dos Clérigos) e vira para a Praça dos Leões. O teu destino está quase colado a outra igreja.\n\n📍 COORDENADAS:\n41.1472° N, 8.6162° W',
      'iconeJ1': Icons.account_balance,
      'imgJ2': 'https://images.unsplash.com/photo-1596711585261-2a1e1cc714a5?w=600&q=80', 
      'padraoJ2': 'Observa a imensa fachada lateral toda em azulejo azul e branco. O vosso objetivo é encontrar a figura da Virgem do Carmo mesmo no topo.',
    },
    {
      'nome': 'Mural de Joana Vasconcelos',
      'dicaJ1': 'Não muito longe dos Clérigos, esconde-se uma obra moderna e vibrante numa empena lateral de um edifício.\n\n📍 COORDENADAS:\n41.1465° N, 8.6144° W',
      'iconeJ1': Icons.format_paint,
      'imgJ2': 'https://images.unsplash.com/photo-1577083165241-1cb118a1a91e?w=600&q=80', 
      'padraoJ2': 'Este painel é gigante e tem 8000 azulejos pintados à mão! Procurem a secção com os tons amarelos e vermelhos mais vibrantes que formam um coração.',
    }
  ];

  void _validarLocal(String tipoValidacao) {
    String msgProgresso = tipoValidacao == 'FOTO' ? "A abrir a câmara... 📸" : "A verificar sinal de GPS... 📍";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msgProgresso), duration: const Duration(seconds: 1)));
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _xpAcumulado += 50);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tipoValidacao == 'FOTO' ? "Trabalho de equipa! Foto validada! ✅ (+50 XP)" : "Trabalho de equipa! Localização Confirmada! ✅ (+50 XP)"), backgroundColor: Colors.green));
      
      if (_localAtualIndex < _locais.length - 1) {
        Future.delayed(const Duration(seconds: 1), () => setState(() { _localAtualIndex++; _faseAtual = 'ESCOLHA'; }));
      } else {
        Future.delayed(const Duration(seconds: 1), () => _mostrarVitoria());
      }
    });
  }

  void _mostrarVitoria() {
    int bonusFinal = 200;
    int xpTotal = _xpAcumulado + bonusFinal;
    showGeneralDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.95), barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.handshake, color: Colors.cyanAccent, size: 100), const SizedBox(height: 20), const Text("DUPLA IMBATÍVEL!", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 40),
                  Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.cyanAccent.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA SINTONIA", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Puzzles Resolvidos:", style: TextStyle(color: Colors.white)), Text("${_locais.length} / ${_locais.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP de Cooperação:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bónus Duo:", style: TextStyle(color: Colors.white)), Text("+$bonusFinal XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL DA DUPLA:", style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold))])])),
                  const SizedBox(height: 50),
                  ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEcraInstrucoes() {
    return Container(
      width: double.infinity, height: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.extension, color: Colors.cyanAccent, size: 70), const SizedBox(height: 20),
            const Text("PUZZLE DE PAR", style: TextStyle(color: Colors.cyanAccent, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 3)), const SizedBox(height: 10),
            const Text("A comunicação é a chave. Decidam quem assume cada função. Cada um terá informações únicas que o outro não consegue ver.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)), const SizedBox(height: 40),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent.withOpacity(0.5))), child: const Row(children: [Icon(Icons.map, color: Colors.blueAccent, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("JOGADOR 1: O GUIA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 5), Text("Recebe as coordenadas e as direções para encontrar o local escondido.", style: TextStyle(color: Colors.white70, fontSize: 13))]))])), const SizedBox(height: 15),
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pinkAccent.withOpacity(0.5))), child: const Row(children: [Icon(Icons.visibility, color: Colors.pinkAccent, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("JOGADOR 2: O DETETIVE", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 5), Text("Recebe o padrão visual ou o azulejo que a dupla tem de encontrar no local.", style: TextStyle(color: Colors.white70, fontSize: 13))]))])), const SizedBox(height: 50),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'ESCOLHA'), icon: const Icon(Icons.play_arrow, color: Colors.black), label: const Text("COMEÇAR AVENTURA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))), const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEcraEscolha() {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("LOCAL ATUAL", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("${_localAtualIndex + 1} de ${_locais.length}", style: const TextStyle(color: Colors.white, fontSize: 18))]), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)))])),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), const Text("QUEM ESTÁ A SEGURAR O ECRÃ?", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 30),
                  GestureDetector(onTap: () => setState(() => _faseAtual = 'JOGADOR1'), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(15)), child: const Row(children: [Icon(Icons.map, color: Colors.blueAccent, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOU O JOGADOR 1", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)), SizedBox(height: 5), Text("O Guia (Ver Pistas e Rota)", style: TextStyle(color: Colors.white54, fontSize: 13))])), Icon(Icons.arrow_forward_ios, color: Colors.blueAccent)]))), const SizedBox(height: 20),
                  GestureDetector(onTap: () => setState(() => _faseAtual = 'JOGADOR2'), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.1), border: Border.all(color: Colors.pinkAccent.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(15)), child: const Row(children: [Icon(Icons.visibility, color: Colors.pinkAccent, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOU O JOGADOR 2", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 18)), SizedBox(height: 5), Text("O Detetive (Ver Padrão Oculto)", style: TextStyle(color: Colors.white54, fontSize: 13))])), Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent)]))),
                ],
              )
            )
          ),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
            child: Column(
              children: [
                const Text("JÁ SE ENCONTRARAM NO LOCAL?", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 15),
                Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('FOTO'), icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18), label: const Text("FOTOGRAFIA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))), const SizedBox(width: 15), Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('GPS'), icon: const Icon(Icons.gps_fixed, color: Colors.white, size: 18), label: const Text("SINAL GPS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[700], padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))]),
              ],
            ),
          )
        ]
      )
    );
  }

  Widget _buildEcraJogador1(Map<String, dynamic> local) {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.blueAccent.withOpacity(0.3)))), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.blueAccent), onPressed: () => setState(() => _faseAtual = 'ESCOLHA')), const Text("ECRÃ DO JOGADOR 1", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Icon(local['iconeJ1'], color: Colors.blueAccent, size: 80)), const SizedBox(height: 20), const Center(child: Text("O TEU OBJETIVO É GUIAR", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 2))), const SizedBox(height: 40), Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.directions_walk, color: Colors.white), SizedBox(width: 10), Text("INSTRUÇÕES DE ROTA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Text(local['dicaJ1'], style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5))])), const SizedBox(height: 40), const Text("Lê estas pistas em voz alta para o teu parceiro, mas não lhe mostres o teu ecrã!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)) ])))
        ]
      )
    );
  }

  Widget _buildEcraJogador2(Map<String, dynamic> local) {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)))), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.pinkAccent), onPressed: () => setState(() => _faseAtual = 'ESCOLHA')), const Text("ECRÃ DO JOGADOR 2", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(30), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: ClipRRect(borderRadius: BorderRadius.circular(15), child: ColorFiltered(colorFilter: const ColorFilter.matrix([0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0,0,0,1,0]), child: Image.network(local['imgJ2'], width: 150, height: 150, fit: BoxFit.cover)))), const SizedBox(height: 30), const Center(child: Text("O TEU OBJETIVO É ENCONTRAR", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, letterSpacing: 2))), const SizedBox(height: 40), Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pinkAccent.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.search, color: Colors.white), SizedBox(width: 10), Text("PADRÃO A PROCURAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Text(local['padraoJ2'], style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5))])), const SizedBox(height: 40), const Text("O teu parceiro não sabe o que tens de procurar. Avisa-o quando encontrares este detalhe no local!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic))])))
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'INSTRUCOES') return _buildEcraInstrucoes();
    if (_faseAtual == 'ESCOLHA') return _buildEcraEscolha();
    if (_faseAtual == 'JOGADOR1') return _buildEcraJogador1(_locais[_localAtualIndex]);
    if (_faseAtual == 'JOGADOR2') return _buildEcraJogador2(_locais[_localAtualIndex]);
    return const SizedBox.shrink();
  }
}

// ==========================================
// JOGO 2: QUIZ DE AFINIDADE (DUO BOND)
// ==========================================
class QuizAfinidade extends StatefulWidget {
  const QuizAfinidade({super.key});

  @override
  State<QuizAfinidade> createState() => _QuizAfinidadeState();
}

class _QuizAfinidadeState extends State<QuizAfinidade> {
  String _faseAtual = 'SETUP'; 
  
  final TextEditingController _ctrlP1 = TextEditingController();
  final TextEditingController _ctrlP2 = TextEditingController();
  String _nomeP1 = "Jogador 1";
  String _nomeP2 = "Jogador 2";

  Map<String, dynamic>? _perguntaAtual;
  String? _respostaP1;
  String? _respostaP2;
  
  int _acertos = 0;
  int _totalJogadas = 0;
  List<Map<String, dynamic>> _perguntasJaJogadas = [];

  final List<Map<String, dynamic>> _todasAsPerguntas = [
    // --- CARTAS QUEM DE NÓS (8) ---
    {'categoria': 'Quem de Nós', 'local': 'Ponte Luiz I', 'texto': 'Seria mais provável saltar da ponte no verão?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Torre dos Clérigos', 'texto': 'Seria mais provável de subir os Clérigos?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Estação de São Bento', 'texto': 'Contaria os azulejos todos da Estação de S. Bento?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Palácio da Bolsa', 'texto': 'Aguentaria dormir uma noite no Palácio da Bolsa?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Ponte da Arrábida', 'texto': 'Escalava a Ponte da Arrábida?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Cais da Ribeira', 'texto': 'Passaria uma tarde a andar de barco no rio Douro?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Palácio de Cristal', 'texto': 'Iria atrás de uma galinha nos Jardins do Palácio de Cristal?', 'tipo': 'QUEM'},
    {'categoria': 'Quem de Nós', 'local': 'Foz do Douro', 'texto': 'Seria mais provável de andar de skate a alta velocidade nas rampas da Foz do Douro?', 'tipo': 'QUEM'},
    
    // --- CARTAS ESCOLHA FORÇADA (8) ---
    {'categoria': 'Escolha Forçada', 'local': 'Estação de São Bento', 'texto': 'Se tivéssemos que escolher hoje...', 'tipo': 'OPCOES', 'opcoes': ['A) Viajar sem plano', 'B) Ficar onde é seguro']},
    {'categoria': 'Escolha Forçada', 'local': 'Funicular dos Guindais', 'texto': 'Se tivéssemos que escolher hoje...', 'tipo': 'OPCOES', 'opcoes': ['A) Nunca mais andar no funicular por ter medo de alturas', 'B) Andar no funicular mesmo tendo medo de alturas']},
    {'categoria': 'Escolha Forçada', 'local': 'Casa da Música', 'texto': 'Se tivéssemos de escolher hoje...', 'tipo': 'OPCOES', 'opcoes': ['A) Beber um café e ver um espetáculo', 'B) Nunca mais ver espetáculos']},
    {'categoria': 'Escolha Forçada', 'local': 'Livraria Lello', 'texto': 'Se tivéssemos que recomeçar do zero...', 'tipo': 'OPCOES', 'opcoes': ['A) Comprar um livro', 'B) Nunca mais ler nenhum livro']},
    {'categoria': 'Escolha Forçada', 'local': 'Foz do Douro', 'texto': 'Se tivéssemos de recomeçar do zero...', 'tipo': 'OPCOES', 'opcoes': ['A) Atirar-me ao mar sem saber nadar', 'B) Comprar uma bicicleta sem saber usar']},
    {'categoria': 'Escolha Forçada', 'local': 'Mercado do Bolhão', 'texto': 'Se tivéssemos de recomeçar do zero...', 'tipo': 'OPCOES', 'opcoes': ['A) Comer peixe e ter alegria', 'B) Nunca mais comer']},
    {'categoria': 'Escolha Forçada', 'local': 'Jardim do Morro', 'texto': 'Futuramente gostavas...', 'tipo': 'OPCOES', 'opcoes': ['A) Ver o pôr-do-sol', 'B) Nunca mais ver o pôr-do-sol']},
    {'categoria': 'Escolha Forçada', 'local': 'General Torres', 'texto': 'Futuramente gostavas...', 'tipo': 'OPCOES', 'opcoes': ['A) De andar de comboio sem destino', 'B) Conduzir um comboio']},

    // --- CARTAS NARRATIVA (8) ---
    {'categoria': 'Narrativa', 'local': 'Livraria Lello', 'texto': 'Estamos a escrever um novo capítulo da nossa vida. Quem arrisca uma história mais imprevisível?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Avenida dos Aliados', 'texto': 'Estamos sob atenção pública. Quem se sente mais confortável a gritar no centro?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Jardim do Morro', 'texto': 'Estamos a observar a nossa vida de longe. Quem é mais capaz de dançar no meio de tanta gente?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Jardim Botânico do Porto', 'texto': 'Estamos a passar por uma fase de transformação no meio do jardim. Quem aceita melhor a mudança?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Sé do Porto', 'texto': 'Precisamos tomar uma decisão que exige convicção. Quem se mantém mais firme nos seus valores?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Ponte da Arrábida', 'texto': 'Temos de ligar dois lados que não se entendem. Quem consegue criar essa ligação?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Cordoaria', 'texto': 'Estamos numa fase de reflexão na faculdade. Quem aproveita melhor o silêncio para crescer e para aprender?', 'tipo': 'QUEM'},
    {'categoria': 'Narrativa', 'local': 'Cemitério de Agramonte', 'texto': 'Temos de deixar algo para trás. Quem consegue desapegar-se com mais facilidade?', 'tipo': 'QUEM'},

    // --- CARTAS ESPELHO (8) ---
    {'categoria': 'Cartas Espelho', 'local': 'Parque da Cidade', 'texto': 'Que parte minha precisa de mais espaço?', 'tipo': 'ADIVINHA', 'opcoes': ['O Meu Tempo Livre', 'O Meu Trabalho', 'A Minha Criatividade', 'O Meu Descanso']},
    {'categoria': 'Cartas Espelho', 'local': 'Capela das Almas', 'texto': 'Que emoção aqui presente está muito visível?', 'tipo': 'ADIVINHA', 'opcoes': ['Alegria', 'Paz', 'Ansiedade', 'Curiosidade']},
    {'categoria': 'Cartas Espelho', 'local': 'Serra do Pilar', 'texto': 'Terias coragem de saltar daqui?', 'tipo': 'ADIVINHA', 'opcoes': ['Saltava sem pensar', 'Nunca na vida', 'Só com pára-quedas', 'Só se saltasses comigo']},
    {'categoria': 'Cartas Espelho', 'local': 'Fundação de Serralves', 'texto': 'Conseguirias roubar algo da fundação?', 'tipo': 'ADIVINHA', 'opcoes': ['Uma obra de arte', 'Um livro', 'Uma flor/planta', 'Nada, nunca roubaria']},
    {'categoria': 'Cartas Espelho', 'local': 'Farol de Felgueiras', 'texto': 'Quando é que eu sou a tua luz e não percebo?', 'tipo': 'ADIVINHA', 'opcoes': ['Quando me fazes rir', 'Nas decisões difíceis', 'Quando me ouves', 'Nos momentos tristes']},
    {'categoria': 'Cartas Espelho', 'local': 'Miradouro da Vitória', 'texto': 'O que eu mais admiro em ti, mas raramente digo?', 'tipo': 'ADIVINHA', 'opcoes': ['A tua Força', 'A tua Paciência', 'A tua Inteligência', 'A tua Lealdade']},
    {'categoria': 'Cartas Espelho', 'local': 'Praça da Liberdade', 'texto': 'Em que momento eu não fui tão livre como parecia?', 'tipo': 'ADIVINHA', 'opcoes': ['Numa decisão difícil', 'Ao expressar algo', 'Ao seguir um sonho', 'Num relacionamento']},
    {'categoria': 'Cartas Espelho', 'local': 'Túnel de Ceuta', 'texto': 'Que fase escura da minha vida ainda não atravessei completamente?', 'tipo': 'ADIVINHA', 'opcoes': ['Perdas Antigas', 'Medo do Futuro', 'Inseguranças', 'Dúvidas de Carreira']},

    // --- CARTAS CURIOSIDADE (8) ---
    {'categoria': 'Curiosidade', 'local': 'Igreja do Carmo', 'texto': 'Acreditas em Deus?', 'tipo': 'OPCOES', 'opcoes': ['Sim', 'Não', 'Acredito numa força superior']},
    {'categoria': 'Curiosidade', 'local': 'Estádio do Dragão', 'texto': 'Eras capaz de entrar a correr dentro do campo do estádio?', 'tipo': 'OPCOES', 'opcoes': ['Sim', 'Não', 'Só por uma aposta']},
    {'categoria': 'Curiosidade', 'local': 'Mercado do Bom Sucesso', 'texto': 'Que verdade evitas dizer-me?', 'tipo': 'ADIVINHA', 'opcoes': ['Pequenas irritações', 'As minhas inseguranças', 'Preocupações financeiras', 'Nenhuma, sou transparente']},
    {'categoria': 'Curiosidade', 'local': 'Coliseu do Porto', 'texto': 'Em que momento te desiludi?', 'tipo': 'ADIVINHA', 'opcoes': ['Falta de apoio', 'Mentira ou omissão', 'Atrasos constantes', 'Nunca me desiludiste']},
    {'categoria': 'Curiosidade', 'local': 'Jardim de São Lázaro', 'texto': 'Que flores consegues observar?', 'tipo': 'OPCOES', 'opcoes': ['Coloridas e caóticas', 'Serenas e perfeitas', 'Resilientes', 'Não reparei em nenhuma']},
    {'categoria': 'Curiosidade', 'local': 'Ponte Maria Pia', 'texto': 'Num desafio complexo...', 'tipo': 'OPCOES', 'opcoes': ['A) Confiar na estrutura da ponte e andar de carro', 'B) Andar de skate na ponte']},
    {'categoria': 'Curiosidade', 'local': 'Muralha Fernandina', 'texto': 'Quem de nós… cria mais defesas quando se sente vulnerável?', 'tipo': 'QUEM'},
    {'categoria': 'Curiosidade', 'local': 'Museu Nacional Soares dos Reis', 'texto': 'Se pertencesses à realeza o que serias?', 'tipo': 'ADIVINHA', 'opcoes': ['Monarca Ditador', 'Conselheiro Sábio', 'Artista da Corte', 'O Rebelde']},
  ];

  void _iniciarQuiz() {
    if (_ctrlP1.text.isNotEmpty) _nomeP1 = _ctrlP1.text;
    if (_ctrlP2.text.isNotEmpty) _nomeP2 = _ctrlP2.text;
    setState(() {
      _faseAtual = 'DASHBOARD'; 
    });
  }

  void _puxarCarta(String categoriaDesejada) {
    var perguntasDisponiveis = _todasAsPerguntas.where((p) => p['categoria'] == categoriaDesejada && !_perguntasJaJogadas.contains(p)).toList();
    if (perguntasDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Já jogaste todas as cartas desta categoria! Escolhe outra."), backgroundColor: Colors.amber, duration: Duration(seconds: 2)));
      return;
    }
    perguntasDisponiveis.shuffle();
    setState(() {
      _perguntaAtual = perguntasDisponiveis.first;
      _perguntasJaJogadas.add(_perguntaAtual!);
      _respostaP1 = null;
      _respostaP2 = null;
      _faseAtual = 'P1_TURN';
    });
  }

  void _registarRespostaP1(String resposta) {
    setState(() {
      _respostaP1 = resposta;
      _faseAtual = 'TRANSICAO';
    });
  }

  void _registarRespostaP2(String resposta) {
    _respostaP2 = resposta;
    bool acertou = (_respostaP1 == _respostaP2);

    if (acertou) _acertos++;
    _totalJogadas++;

    setState(() {
      _faseAtual = 'RESULTADO';
    });
  }

  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF300018), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, color: Colors.pinkAccent, size: 80), const SizedBox(height: 20),
          const Text("QUIZ DE AFINIDADE", style: TextStyle(color: Colors.pinkAccent, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
          const Text("Será que vocês pensam em sintonia? Insiram os nomes para testar.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 40),
          
          TextField(controller: _ctrlP1, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Nome do Jogador 1", labelStyle: const TextStyle(color: Colors.white54), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.5)), borderRadius: BorderRadius.circular(15)), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.pinkAccent), borderRadius: BorderRadius.circular(15)), prefixIcon: const Icon(Icons.person, color: Colors.pinkAccent))), const SizedBox(height: 20),
          TextField(controller: _ctrlP2, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Nome do Jogador 2", labelStyle: const TextStyle(color: Colors.white54), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.5)), borderRadius: BorderRadius.circular(15)), focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.purpleAccent), borderRadius: BorderRadius.circular(15)), prefixIcon: const Icon(Icons.person_outline, color: Colors.purpleAccent))), const SizedBox(height: 50),
          
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _iniciarQuiz, icon: const Icon(Icons.play_arrow, color: Colors.white), label: const Text("COMEÇAR O TESTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    int percentagemSintonia = _totalJogadas == 0 ? 0 : ((_acertos / _totalJogadas) * 100).round();

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("A VOSSA SINTONIA", style: TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("$_acertos Acertos em $_totalJogadas", style: const TextStyle(color: Colors.white, fontSize: 16))]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$percentagemSintonia%", style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 18))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("O BARALHO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Escolham o tipo de carta que querem jogar agora.", style: TextStyle(color: Colors.white54, fontSize: 14)),
                  const SizedBox(height: 30),
                  _buildBotaoCategoria('Quem de Nós', Icons.people_alt, Colors.orangeAccent),
                  _buildBotaoCategoria('Escolha Forçada', Icons.call_split, Colors.redAccent),
                  _buildBotaoCategoria('Narrativa', Icons.auto_stories, Colors.purpleAccent),
                  _buildBotaoCategoria('Cartas Espelho', Icons.camera_front, Colors.cyanAccent),
                  _buildBotaoCategoria('Curiosidade', Icons.psychology, Colors.greenAccent),
                  const SizedBox(height: 40),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'FIM'), icon: const Icon(Icons.flag, color: Colors.white), label: const Text("TERMINAR JOGO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoCategoria(String nome, IconData icone, Color cor) {
    int restantes = _todasAsPerguntas.where((p) => p['categoria'] == nome && !_perguntasJaJogadas.contains(p)).length;

    return GestureDetector(
      onTap: () => _puxarCarta(nome),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: cor.withOpacity(0.5))),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 30), const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(nome, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("$restantes cartas disponíveis", style: const TextStyle(color: Colors.white54, fontSize: 12))])),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)
          ],
        ),
      ),
    );
  }

  Widget _buildTurno(String jogadorAtivo, bool isP1) {
    final pergunta = _perguntaAtual!;
    List<String> opcoesRenderizadas = [];

    if (pergunta['tipo'] == 'QUEM') {
      opcoesRenderizadas = [_nomeP1, _nomeP2];
    } else {
      opcoesRenderizadas = List<String>.from(pergunta['opcoes']);
    }

    String tituloAcao = "";
    if (pergunta['tipo'] == 'ADIVINHA') {
      tituloAcao = isP1 ? "Responde sobre ti. O(A) $_nomeP2 vai tentar adivinhar a tua escolha!" : "Tenta adivinhar o que o(a) $_nomeP1 respondeu!";
    } else {
      tituloAcao = "Qual é a tua resposta sincera?";
    }

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CARTA ATUAL", style: TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text(pergunta['categoria'], style: const TextStyle(color: Colors.white, fontSize: 16))]), IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => setState(() => _faseAtual = 'DASHBOARD'))])),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text("VEZ DE $jogadorAtivo", style: TextStyle(color: isP1 ? Colors.blueAccent : Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 30),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)), boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.1), blurRadius: 20)]),
                    child: Column(
                      children: [
                        Text(pergunta['categoria'].toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 5),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.location_on, color: Colors.pinkAccent, size: 14), const SizedBox(width: 5), Flexible(child: Text(pergunta['local'], style: const TextStyle(color: Colors.pinkAccent, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))]), const Divider(color: Colors.white24, height: 30),
                        Text(pergunta['texto'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(tituloAcao, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic)), const SizedBox(height: 20),
                  ...opcoesRenderizadas.map((opcao) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isP1) { _registarRespostaP1(opcao); } else { _registarRespostaP2(opcao); }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.white.withOpacity(0.1)))),
                          child: Text(opcao, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransicao() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(40), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.screen_lock_portrait, color: Colors.white54, size: 80), const SizedBox(height: 20),
          const Text("RESPOSTA BLOQUEADA!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
          Text("Passa o telemóvel ao(à) $_nomeP2 para que responda sem ver o que escolheste.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)), const SizedBox(height: 50),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'P2_TURN'), icon: const Icon(Icons.check, color: Colors.white), label: Text("SOU O(A) ${_nomeP2.toUpperCase()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  Widget _buildResultadoTurno() {
    bool acertou = (_respostaP1 == _respostaP2);
    final pergunta = _perguntaAtual!;
    
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(acertou ? Icons.favorite : Icons.heart_broken, color: acertou ? Colors.greenAccent : Colors.redAccent, size: 100), const SizedBox(height: 20),
          Text(acertou ? "SINTONIA PERFEITA!" : "PENSAMENTOS OPOSTOS...", textAlign: TextAlign.center, style: TextStyle(color: acertou ? Colors.greenAccent : Colors.redAccent, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
            child: Column(
              children: [
                Text(pergunta['texto'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic)), const Divider(color: Colors.white24, height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_nomeP1, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), Expanded(child: Text(_respostaP1 ?? '', textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]), const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_nomeP2, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), Expanded(child: Text(_respostaP2 ?? '', textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
              ],
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'DASHBOARD'), icon: const Icon(Icons.dashboard, color: Colors.white), label: const Text("VOLTAR AO BARALHO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  Widget _buildFimJogo() {
    int percentagemSintonia = _totalJogadas == 0 ? 0 : ((_acertos / _totalJogadas) * 100).round();
    String diagnostico = "";

    if (_totalJogadas == 0) diagnostico = "Não jogaram nenhuma carta... Voltem quando estiverem prontos!";
    else if (percentagemSintonia == 100) diagnostico = "ALMAS GÉMEAS EXPLORADORAS! Lêm os pensamentos um do outro perfeitamente.";
    else if (percentagemSintonia >= 60) diagnostico = "UMA DUPLA SÓLIDA! Estão no mesmo comprimento de onda a maior parte do tempo.";
    else if (percentagemSintonia >= 40) diagnostico = "OS OPOSTOS ATRAEM-SE! Têm perspetivas diferentes que se complementam.";
    else diagnostico = "DUPLA CAÓTICA E DIVERTIDA! O Porto testou as vossas diferenças hoje!";

    int xpFinal = _acertos * 20;

    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF300018), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("VEREDICTO FINAL", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)), const SizedBox(height: 10),
          Text("$percentagemSintonia%", style: const TextStyle(color: Colors.pinkAccent, fontSize: 60, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
          Text(diagnostico, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5, fontStyle: FontStyle.italic)), const SizedBox(height: 40),
          
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP GANHO DA DUPLA:", style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)), Text("+$xpFinal XP", style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 50),
          
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, icon: const Icon(Icons.home, color: Colors.white), label: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_faseAtual) {
      case 'SETUP': return _buildSetup();
      case 'DASHBOARD': return _buildDashboard();
      case 'P1_TURN': return _buildTurno(_nomeP1.toUpperCase(), true);
      case 'TRANSICAO': return _buildTransicao();
      case 'P2_TURN': return _buildTurno(_nomeP2.toUpperCase(), false);
      case 'RESULTADO': return _buildResultadoTurno();
      case 'FIM': return _buildFimJogo();
      default: return const SizedBox.shrink();
    }
  }
}

// ==========================================
// JOGO 3: BÚSSOLA HUMANA (DUO BOND)
// ==========================================
class BussolaHumana extends StatefulWidget {
  const BussolaHumana({super.key});

  @override
  State<BussolaHumana> createState() => _BussolaHumanaState();
}

class _BussolaHumanaState extends State<BussolaHumana> {
  // Fases do jogo: 'INSTRUCOES', 'ESCOLHA', 'BUSSOLA', 'EXPLORADOR'
  String _faseAtual = 'INSTRUCOES'; 
  int _localAtualIndex = 0;
  int _xpAcumulado = 0;
  IconData _direcaoAtual = Icons.help_outline;

  final List<Map<String, dynamic>> _locais = [
    {'nome': 'Avenida dos Aliados', 'coords': const LatLng(41.1466, -8.6110)},
    {'nome': 'Rua de Santa Catarina', 'coords': const LatLng(41.1498, -8.6056)},
    {'nome': 'Estação de São Bento', 'coords': const LatLng(41.1456, -8.6115)},
    {'nome': 'Torre dos Clérigos', 'coords': const LatLng(41.1458, -8.6139)},
    {'nome': 'Miradouro da Vitória', 'coords': const LatLng(41.1428, -8.6158)},
    {'nome': 'Jardins do P. de Cristal', 'coords': const LatLng(41.1481, -8.6258)},
  ];

  void _enviarDirecao(IconData dir) {
    setState(() {
      _direcaoAtual = dir;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Direção enviada ao Explorador! 🧭"), duration: Duration(seconds: 1), backgroundColor: Colors.blueAccent));
  }

  void _validarLocal(String tipo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tipo == 'GPS' ? "A verificar GPS... 📍" : "A abrir câmara... 📸"), duration: const Duration(seconds: 1)));
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _xpAcumulado += 50);
      _direcaoAtual = Icons.help_outline; // Reseta a seta para o local seguinte
      
      if (_localAtualIndex < _locais.length - 1) {
        _mostrarPopUpTroca();
      } else {
        _mostrarVitoria();
      }
    });
  }

  void _mostrarPopUpTroca() {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.greenAccent, width: 2)),
        title: const Column(children: [Icon(Icons.check_circle, color: Colors.greenAccent, size: 50), SizedBox(height: 10), Text("DESTINO ALCANÇADO!", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))]),
        content: const Text("Ganharam +50 XP.\n\nTroquem de papéis! Quem era a Bússola passa a ser o Explorador nesta próxima ronda.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        actions: [ElevatedButton(onPressed: () { Navigator.pop(context); setState(() { _localAtualIndex++; _faseAtual = 'ESCOLHA'; }); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black), child: const Center(child: Text("AVANÇAR PARA O PRÓXIMO", style: TextStyle(fontWeight: FontWeight.bold))))]
      )
    );
  }

  void _mostrarVitoria() {
    int xpTotal = _xpAcumulado + 300;
    showGeneralDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.95), barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(backgroundColor: Colors.transparent, body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.explore, color: Colors.amber, size: 100), const SizedBox(height: 20), const Text("MESTRES DA ORIENTAÇÃO!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 40), Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA MISSÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Locais:", style: TextStyle(color: Colors.white)), Text("${_locais.length} / ${_locais.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP Bússola:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Bónus Duo:", style: TextStyle(color: Colors.white)), Text("+300 XP", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL:", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold))])])), const SizedBox(height: 50), ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))]))));
      }
    );
  }

  // =====================================
  // TELAS DA BÚSSOLA HUMANA
  // =====================================

  Widget _buildEcraInstrucoes() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.screen_rotation, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("BÚSSOLA HUMANA", style: TextStyle(color: Colors.amber, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
          const Text("Decidam quem é a Bússola e quem é o Explorador neste local.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
          const Text("A BÚSSOLA vê o mapa e clica nas setas de direção. Não pode dizer o nome das ruas!\n\nO EXPLORADOR é cego. Não vê o mapa, apenas vê uma seta gigante no seu ecrã que lhe diz para onde virar.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)), const SizedBox(height: 40),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'ESCOLHA'), icon: const Icon(Icons.play_arrow, color: Colors.black), label: const Text("COMEÇAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  Widget _buildEcraEscolha() {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("LOCAL ATUAL", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("${_localAtualIndex + 1} de ${_locais.length}", style: const TextStyle(color: Colors.white, fontSize: 18))]), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)))])),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), const Text("QUEM ESTÁ A SEGURAR O ECRÃ?", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 30),
                  
                  GestureDetector(onTap: () => setState(() => _faseAtual = 'BUSSOLA'), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(15)), child: const Row(children: [Icon(Icons.map, color: Colors.blueAccent, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOU A BÚSSOLA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)), SizedBox(height: 5), Text("Ver o mapa e enviar direções", style: TextStyle(color: Colors.white54, fontSize: 13))])), Icon(Icons.arrow_forward_ios, color: Colors.blueAccent)]))), const SizedBox(height: 20),
                  GestureDetector(onTap: () => setState(() => _faseAtual = 'EXPLORADOR'), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1), border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 2), borderRadius: BorderRadius.circular(15)), child: const Row(children: [Icon(Icons.navigation, color: Colors.deepOrange, size: 40), SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOU O EXPLORADOR", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 18)), SizedBox(height: 5), Text("Ver a direção enviada pela bússola", style: TextStyle(color: Colors.white54, fontSize: 13))])), Icon(Icons.arrow_forward_ios, color: Colors.deepOrange)]))),
                ],
              )
            )
          ),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
            child: Column(
              children: [
                const Text("JÁ CHEGARAM AO DESTINO?", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 15),
                Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('FOTO'), icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18), label: const Text("FOTOGRAFIA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))), const SizedBox(width: 15), Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('GPS'), icon: const Icon(Icons.gps_fixed, color: Colors.white, size: 18), label: const Text("SINAL GPS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))]),
              ],
            ),
          )
        ]
      )
    );
  }

  Widget _buildEcraBussola(Map<String, dynamic> local) {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.blueAccent.withOpacity(0.3)))),
            child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.blueAccent), onPressed: () => setState(() => _faseAtual = 'ESCOLHA')), const Text("ECRÃ DA BÚSSOLA", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Center(child: Text("DESTINO: ${local['nome']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(initialCenter: local['coords'], initialZoom: 16.0, interactionOptions: const InteractionOptions(flags: InteractiveFlag.none)),
                  children: [
                    TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
                    MarkerLayer(markers: [Marker(point: local['coords'], width: 50, height: 50, child: const Icon(Icons.location_on, color: Colors.redAccent, size: 40))]),
                  ],
                ),
                Container(color: Colors.black.withOpacity(0.3)), // Escurece o mapa para focar nos botões
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _btnDirecao(Icons.arrow_upward, "FRENTE"),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [_btnDirecao(Icons.arrow_back, "ESQUERDA"), const SizedBox(width: 60), _btnDirecao(Icons.arrow_forward, "DIREITA")]),
                      _btnDirecao(Icons.arrow_downward, "TRÁS"),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEcraExplorador(Map<String, dynamic> local) {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
           Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.deepOrange.withOpacity(0.3)))),
            child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.deepOrange), onPressed: () => setState(() => _faseAtual = 'ESCOLHA')), const Text("ECRÃ DO EXPLORADOR", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("SEGUE A DIREÇÃO", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(_direcaoAtual, key: ValueKey<IconData>(_direcaoAtual), color: _direcaoAtual == Icons.help_outline ? Colors.white24 : Colors.amber, size: 150),
                  ),
                  const SizedBox(height: 50),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 40), child: Text("Pede à tua Bússola para clicar num botão e passa-lhe o telemóvel para atualizar esta seta!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)))
                ],
              ),
            ),
          ),
        ]
      )
    );
  }

  Widget _btnDirecao(IconData icone, String rotulo) {
    return GestureDetector(
      onTap: () => _enviarDirecao(icone),
      child: Container(
        margin: const EdgeInsets.all(5), width: 80, height: 80,
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.9), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)]),
        child: Icon(icone, color: Colors.white, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'INSTRUCOES') return _buildEcraInstrucoes();
    if (_faseAtual == 'ESCOLHA') return _buildEcraEscolha();
    if (_faseAtual == 'BUSSOLA') return _buildEcraBussola(_locais[_localAtualIndex]);
    if (_faseAtual == 'EXPLORADOR') return _buildEcraExplorador(_locais[_localAtualIndex]);
    return const SizedBox.shrink();
  }
}