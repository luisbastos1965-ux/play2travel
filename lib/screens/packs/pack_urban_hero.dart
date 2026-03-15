import 'package:flutter/material.dart';

// ==========================================
// JOGO 1: DIÁRIO DO EXPLORADOR (URBAN HERO)
// ==========================================
class DiarioExplorador extends StatefulWidget {
  const DiarioExplorador({super.key});

  @override
  State<DiarioExplorador> createState() => _DiarioExploradorState();
}

class _DiarioExploradorState extends State<DiarioExplorador> {
  String? _rotaEscolhida;
  int _xpAcumulado = 0;

  final Map<String, List<Map<String, dynamic>>> _rotas = {
    'ESTE': [
      {'nome': 'Mercado do Bolhão', 'missoes': ['Sinais que consegues encontrar do antigo mercado?', 'Consegues descobrir a origem do nome?'], 'isCompleted': false},
      {'nome': 'Capela das Almas', 'missoes': ['Identificar uma cena ou personagem representada nos azulejos?', 'Qual é o detalhe da fachada que mais te chama a atenção?'], 'isCompleted': false},
      {'nome': 'Igreja de Sto. Ildefonso e Batalha', 'missoes': ['O nome da praça vem de uma batalha que aconteceu aqui no século X. Consegues imaginar como seria este lugar nessa época?', 'Consegues identificar qual dos edifícios parece mais antigo na Praça? O que te faz pensar isso?', 'Consegues encontrar uma cena nos azulejos e tentar perceber o que está a acontecer?'], 'isCompleted': false},
    ],
    'SUL': [
      {'nome': 'Estação de São Bento', 'missoes': ['Que história conta um dos azulejos?', 'O que está escrito no teto da Estação?', 'Que tipos de transportes e viajantes passam por aqui hoje em dia?'], 'isCompleted': false},
      {'nome': 'Sé do Porto', 'missoes': ['Consegues encontrar alguma placa ou escudo que indique quem financiou ou construiu parte da catedral?', 'Qual o nome da estátua que está ao lado da Sé?', 'O que se manteve até hoje desde a sua construção?'], 'isCompleted': false},
      {'nome': 'Ponte Luiz I', 'missoes': ['Sabes o porquê da ponte se chamar Luiz I e não terem colocado o “Dom”?', 'Como se chama os barcos que passam por debaixo da ponte?', 'Em que ano foi construída?'], 'isCompleted': false},
      {'nome': 'Rua das Flores', 'missoes': ['Qual a palavra que está escrita numa varanda?', 'Qual o nome do largo onde a rua termina?', 'Qual o nome da mercearia mais tradicional da rua?'], 'isCompleted': false},
      {'nome': 'Praça do Infante D. Henrique', 'missoes': ['Qual o número cravado no Palácio da Bolsa?', 'Antigamente, qual era a função do edifício “Hard Club”?', 'Por que achas que a praça fica perto do rio?'], 'isCompleted': false},
      {'nome': 'Ribeira do Porto', 'missoes': ['Qual o animal representado no Cubo?', 'Como se chamam os barcos tradicionais que transportavam o vinho?', 'Porque existem dois pilares ao lado da Ponte Luiz I?'], 'isCompleted': false},
    ],
    'OESTE': [
      {'nome': 'Clérigos', 'missoes': ['Qual era a verdadeira função desta torre?', 'O que é facto histórico e o que é uma lenda?', 'Consegues localizar o relógio e reparar em algum detalhe decorativo à sua volta?'], 'isCompleted': false},
      {'nome': 'Carmo e Leões', 'missoes': ['Qual das igrejas tem o grande painel de azulejos? O que mostra?', 'Consegues identificar algum personagem ou evento histórico representado nos azulejos?', 'Qual é o nome que aparece na placa da praça?'], 'isCompleted': false},
      {'nome': 'Antiga Cadeia e Trib. da Relação', 'missoes': ['Existe alguma diferença na fachada do edifício?', 'A quem pertence atualmente?', 'Existiam 2 áreas distintas. Quais eram?'], 'isCompleted': false},
      {'nome': 'Miradouro da Vitória', 'missoes': ['Que monumentos conseguem ver a partir daqui?', 'Que partes das cidades se reconhecem na paisagem?'], 'isCompleted': false},
    ],
  };

  void _validarMissao(int indexLocal) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A abrir câmara... Fotografa a página do teu Diário Físico! 📸"), duration: Duration(seconds: 2)));
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _rotas[_rotaEscolhida]![indexLocal]['isCompleted'] = true; _xpAcumulado += 30; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registo validado! Ganhaste +30 XP! ✅"), backgroundColor: Colors.green));
      bool rotaCompleta = _rotas[_rotaEscolhida]!.every((local) => local['isCompleted'] == true);
      if (rotaCompleta) Future.delayed(const Duration(seconds: 1), () => _mostrarVitoriaRota());
    });
  }

  void _mostrarVitoriaRota() {
    int bonusRota = 200;
    setState(() => _xpAcumulado += bonusRota);
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF4EBD0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFF8B5A2B), width: 3)),
        title: const Column(children: [Icon(Icons.menu_book, color: Color(0xFF8B5A2B), size: 50), SizedBox(height: 10), Text("ROTA CONCLUÍDA!", style: TextStyle(color: Color(0xFF5C3A21), fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1))]),
        content: Text("O teu Diário do Explorador da Rota $_rotaEscolhida está completo. Guardaste memórias incríveis da cidade!\n\nRecebes um bónus de +$bonusRota XP.", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF5C3A21), fontSize: 16)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [ElevatedButton(onPressed: () { Navigator.pop(context); setState(() => _rotaEscolhida = null); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5A2B), foregroundColor: Colors.white), child: const Text("VOLTAR À ENCRUZILHADA", style: TextStyle(fontWeight: FontWeight.bold)))]
      ),
    );
  }

  Widget _buildEscolhaRota() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20), decoration: const BoxDecoration(gradient: RadialGradient(colors: [Color(0xFF2A2D34), Color(0xFF0A0A0A)], radius: 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signpost, color: Colors.amber, size: 80), const SizedBox(height: 20), const Text("A ENCRUZILHADA", style: TextStyle(color: Colors.amber, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 3)), const SizedBox(height: 10), const Text("Estás na Avenida dos Aliados. Pega no teu Diário Físico e escolhe o teu caminho.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)), const SizedBox(height: 50),
          _btnRota('ESTE', 'Mercado do Bolhão, Sto. Ildefonso...', Icons.east), const SizedBox(height: 15),
          _btnRota('SUL', 'São Bento, Sé, Ribeira...', Icons.south), const SizedBox(height: 15),
          _btnRota('OESTE', 'Clérigos, Carmo, Miradouro...', Icons.west),
        ],
      ),
    );
  }

  Widget _btnRota(String direcao, String desc, IconData icon) {
    bool concluida = _rotas[direcao]!.every((l) => l['isCompleted'] == true);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: concluida ? null : () => setState(() => _rotaEscolhida = direcao),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.all(20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: concluida ? Colors.green : Colors.white24))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: concluida ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2), shape: BoxShape.circle), child: Icon(concluida ? Icons.check : icon, color: concluida ? Colors.green : Colors.amber)), const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("ROTA $direcao", style: TextStyle(color: concluida ? Colors.green : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(concluida ? "Exploração Concluída!" : desc, style: TextStyle(color: concluida ? Colors.greenAccent : Colors.white54, fontSize: 12))])),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDiarioDaRota() {
    final locaisDaRota = _rotas[_rotaEscolhida]!;
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: Border(bottom: BorderSide(color: Colors.amber.withOpacity(0.3)))),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.amber), onPressed: () => setState(() => _rotaEscolhida = null)), const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("ROTA $_rotaEscolhida", style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)), const Text("Avenida dos Aliados", style: TextStyle(color: Colors.white54, fontSize: 12))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20), itemCount: locaisDaRota.length,
              itemBuilder: (context, index) {
                final local = locaisDaRota[index]; bool isDone = local['isCompleted'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 25), decoration: BoxDecoration(color: const Color(0xFFF4EBD0), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(4, 4))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Transform.translate(
                          offset: const Offset(0, -7),
                          child: Container(
                            width: 80, height: 15,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(2))
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(local['nome'].toUpperCase(), style: const TextStyle(color: Color(0xFF5C3A21), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1))), if (isDone) const Icon(Icons.verified, color: Colors.green, size: 28)]),
                            const Divider(color: Color(0xFFD4C4A8), thickness: 2, height: 20),
                            for (var pergunta in local['missoes'])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12), 
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  children: [
                                    const Text("• ", style: TextStyle(color: Color(0xFF8B5A2B), fontSize: 18, fontWeight: FontWeight.bold)), 
                                    Expanded(child: Text(pergunta.toString(), style: const TextStyle(color: Color(0xFF3E2723), fontSize: 15, height: 1.4, fontStyle: FontStyle.italic)))
                                  ]
                                )
                              ),
                            const SizedBox(height: 20),
                            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: isDone ? null : () => _validarMissao(index), icon: Icon(isDone ? Icons.check : Icons.camera_alt, color: isDone ? Colors.green[800] : Colors.white), label: Text(isDone ? "REGISTADO NO DIÁRIO" : "FOTOGRAFAR O TEU DIÁRIO", style: TextStyle(color: isDone ? Colors.green[800] : Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5A2B), disabledBackgroundColor: Colors.green.withOpacity(0.2), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), elevation: isDone ? 0 : 3)))
                          ],
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    if (_rotaEscolhida == null) return _buildEscolhaRota();
    return _buildDiarioDaRota();
  }
}

// ==========================================
// JOGO 2: NARRATIVA EPISÓDICA (URBAN HERO)
// ==========================================
class NarrativaEpisodica extends StatefulWidget {
  const NarrativaEpisodica({super.key});

  @override
  State<NarrativaEpisodica> createState() => _NarrativaEpisodicaState();
}

class _NarrativaEpisodicaState extends State<NarrativaEpisodica> {
  int? _historiaSelecionadaIndex;
  int _localAtualIndex = 0;
  int _xpAcumulado = 0;
  List<String> _caminhoEscolhido = []; 
  bool _mostrarNarrativa = false;
  String _textoNarrativaAtual = "";

  final List<Map<String, dynamic>> _historias = [
    {
      'titulo': 'Porto Histórico', 'icone': Icons.account_balance,
      'locais': [
        {'nome': 'Estação de São Bento', 'envA': 'Descobres o segredo do azulejo do canto inferior esquerdo.', 'envB': 'Ouviste o eco fantasma de um comboio a vapor de 1920.'},
        {'nome': 'Sé do Porto', 'envA': 'Encontraste uma passagem secreta nos claustros.', 'envB': 'Um monge contou-te uma lenda sobre as muralhas Fernandinas.'},
        {'nome': 'Torre dos Clérigos', 'envA': 'Subiste à torre e encontraste uma mensagem cravada na pedra.', 'envB': 'Ficaste cá em baixo e descobriste a ilusão de ótica da fachada.'},
        {'nome': 'Palácio da Bolsa', 'envA': 'Foste convidado para uma dança invisível no Salão Árabe.', 'envB': 'Negociaste com os mercadores fantasmas no Pátio das Nações.'},
        {'nome': 'Cais da Ribeira', 'envA': 'Bebeste um copo de vinho virtual com um velho marinheiro.', 'envB': 'Ajudaste a descarregar um Barco Rabelo na tua imaginação.'},
      ]
    },
    {
      'titulo': 'Porto e Douro', 'icone': Icons.water,
      'locais': [
        {'nome': 'Miradouro da Serra do Pilar', 'envA': 'O vento trouxe-te a canção das lavadeiras do rio.', 'envB': 'Tiraste uma fotografia mental do pôr do sol perfeito.'},
        {'nome': 'Jardim do Morro', 'envA': 'Descansaste sob a palmeira e tiveste uma visão do passado.', 'envB': 'Seguiste os carris do metro e encontraste uma moeda antiga.'},
        {'nome': 'Cais da Ribeira', 'envA': 'Atravessaste a ponte a pé e sentiste a vibração do metal.', 'envB': 'Um gaivota roubou-te o mapa, mas indicou-te o caminho.'},
        {'nome': 'Caves do Vinho do Porto', 'envA': 'O cheiro a carvalho levou-te a uma cave esquecida.', 'envB': 'Provou-se que o vinho mais antigo ainda guarda segredos.'},
        {'nome': 'Ponte D. Luis I', 'envA': 'Gritaste do tabuleiro inferior e o eco respondeu-te.', 'envB': 'Tocaste no ferro frio e sentiste a presença de Gustave Eiffel.'},
        {'nome': 'Cais da Ribeira (Regresso)', 'envA': 'A viagem terminou onde começou, mas tu mudaste.', 'envB': 'Deixaste uma mensagem numa garrafa a flutuar no Douro.'},
      ]
    },
    {
      'titulo': 'Porto Cultural', 'icone': Icons.theater_comedy,
      'locais': [
        {'nome': 'Jardim da Cordoaria', 'envA': 'As árvores de troncos grossos sussurraram-te um poema.', 'envB': 'Sentaste-te ao lado da estátua de Camilo Castelo Branco.'},
        {'nome': 'Livraria Lello', 'envA': 'Encontraste o livro que não tem título nem autor.', 'envB': 'A escadaria vermelha levou-te a uma dimensão literária.'},
        {'nome': 'Reitoria da UP', 'envA': 'Um professor fantasma deu-te uma aula de física quântica.', 'envB': 'Os estudantes finalistas cantaram-te o fado académico.'},
        {'nome': 'Museu Soares dos Reis', 'envA': 'O exilado quadro ganhou vida por um segundo.', 'envB': 'As esculturas de mármore piscaram-te o olho.'},
        {'nome': 'Teatro Nac. São João', 'envA': 'A cortina abriu-se só para ti numa plateia vazia.', 'envB': 'Encontraste uma máscara de comédia no chão da praça.'},
      ]
    },
    {
      'titulo': 'Porto Contemporâneo', 'icone': Icons.architecture,
      'locais': [
        {'nome': 'Casa da Música', 'envA': 'O edifício meteorito revelou-te uma sinfonia oculta.', 'envB': 'Andaste de skate na rampa infinita da imaginação.'},
        {'nome': 'Rua de Miguel Bombarda', 'envA': 'A arte de rua fundiu-se com a realidade à tua frente.', 'envB': 'Uma galeria secreta abriu-te as portas do futuro.'},
        {'nome': 'Mercado do Bolhão', 'envA': 'A peixeira gritou o teu nome e deu-te um conselho de vida.', 'envB': 'Compraste uma flor que nunca murcha no teu coração.'},
        {'nome': 'Foz do Douro', 'envA': 'O rio encontrou o mar e tu encontraste a paz.', 'envB': 'Caminhaste pelo paredão até te fundires com o nevoeiro.'},
        {'nome': 'Farol de Felgueiras', 'envA': 'A onda bateu no farol e batizou-te como Tripeiro.', 'envB': 'O faroleiro invisible piscou a luz verde para o teu sucesso.'},
      ]
    },
    {
      'titulo': 'Símbolos e Tradições', 'icone': Icons.local_fire_department,
      'locais': [
        {'nome': 'Capela das Almas', 'envA': 'Um dos santos no azulejo apontou-te a direção certa.', 'envB': 'O azul do azulejo tingiu o céu por uns minutos.'},
        {'nome': 'Praça da Liberdade', 'envA': 'O Rei D. Pedro IV montado no cavalo saudou-te.', 'envB': 'A estátua do ardina vendeu-te o jornal de amanhã.'},
        {'nome': 'Rua das Flores', 'envA': 'Um ourives ofereceu-te um fio invisível de filigrana.', 'envB': 'O cheiro a chocolate quente guiou os teus passos.'},
        {'nome': 'Igreja do Carmo', 'envA': 'O painel lateral contou-te o segredo das Carmelitas.', 'envB': 'Ficaste preso no trânsito dos elétricos antigos.'},
        {'nome': 'Igreja dos Carmelitas', 'envA': 'Descobriste a casa mais estreita da cidade.', 'envB': 'Os sinos tocaram uma melodia triunfal em tua honra.'},
      ]
    },
  ];

  void _escolherEnvelope(String escolha, String texto) {
    setState(() { _caminhoEscolhido.add(escolha); _textoNarrativaAtual = texto; _mostrarNarrativa = true; _xpAcumulado += 25; });
  }

  void _avancarHistoria() {
    final historia = _historias[_historiaSelecionadaIndex!];
    if (_localAtualIndex < historia['locais'].length - 1) {
      setState(() { _localAtualIndex++; _mostrarNarrativa = false; });
    } else {
      _mostrarDesfechoFinal();
    }
  }

  void _mostrarDesfechoFinal() {
    int totalA = _caminhoEscolhido.where((c) => c == 'A').length;
    int totalB = _caminhoEscolhido.where((c) => c == 'B').length;

    String tituloFinal = "";
    if (totalA > totalB + 2) tituloFinal = "O EXPLORADOR MÍSTICO";
    else if (totalB > totalA + 2) tituloFinal = "O OBSERVADOR URBANO";
    else tituloFinal = "O VIAJANTE EQUILIBRADO";

    int bonusFinal = 300;
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
                  const Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 100), const SizedBox(height: 20), const Text("FIM DA JORNADA", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)), const SizedBox(height: 10), Text(tituloFinal, textAlign: TextAlign.center, style: const TextStyle(color: Colors.purpleAccent, fontSize: 32, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
                  Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5))), child: Column(children: [const Text("A TUA HISTÓRIA ÚNICA", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Text("As tuas escolhas traçaram um caminho irrepetível. O teu percurso de decisão foi: ${_caminhoEscolhido.join(' ➔ ')}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP de Escolhas:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bónus Narrativo:", style: TextStyle(color: Colors.white)), Text("+$bonusFinal XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold))])])),
                  const SizedBox(height: 50),
                  ElevatedButton(onPressed: () { Navigator.pop(context); setState(() { _historiaSelecionadaIndex = null; _localAtualIndex = 0; _xpAcumulado = 0; _caminhoEscolhido.clear(); _mostrarNarrativa = false; }); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("ESCOLHER NOVA HISTÓRIA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelecaoHistoria() {
    return Container(
      color: const Color(0xFF1A1A24), padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("NARRATIVA EPISÓDICA", style: TextStyle(color: Colors.purpleAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 5), const Text("Que lenda queres viver hoje?", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _historias.length,
              itemBuilder: (context, index) {
                final hist = _historias[index];
                return GestureDetector(
                  onTap: () => setState(() => _historiaSelecionadaIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purpleAccent.withOpacity(0.3))),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), shape: BoxShape.circle), child: Icon(hist['icone'], color: Colors.purpleAccent, size: 30)), const SizedBox(width: 20),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(hist['titulo'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("${hist['locais'].length} Locais Interativos", style: const TextStyle(color: Colors.white54, fontSize: 13))])),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGameplayHistoria() {
    final historia = _historias[_historiaSelecionadaIndex!];
    final local = historia['locais'][_localAtualIndex];

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2A1A3A), Color(0xFF0F0A14)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => setState(() => _historiaSelecionadaIndex = null)),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [Text(historia['titulo'].toUpperCase(), style: const TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("Capítulo ${_localAtualIndex + 1} de ${historia['locais'].length}", style: const TextStyle(color: Colors.white, fontSize: 16))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: LinearProgressIndicator(value: (_localAtualIndex + 1) / historia['locais'].length, backgroundColor: Colors.white10, color: Colors.purpleAccent)),
          const SizedBox(height: 40),
          const Icon(Icons.location_on, color: Colors.deepOrange, size: 40), const SizedBox(height: 10),
          Text(local['nome'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), const SizedBox(height: 50),

          if (!_mostrarNarrativa) ...[
            const Text("Escolhe o teu destino:", style: TextStyle(color: Colors.white54, fontSize: 16, fontStyle: FontStyle.italic)), const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildEnvelope('A', local['envA']), const SizedBox(width: 20), _buildEnvelope('B', local['envB'])]),
          ] else ...[
            Container(margin: const EdgeInsets.symmetric(horizontal: 30), padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)), boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.1), blurRadius: 20)]), child: Column(children: [const Icon(Icons.auto_stories, color: Colors.amber, size: 40), const SizedBox(height: 20), Text(_textoNarrativaAtual, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5))])),
            const Spacer(),
            Padding(padding: const EdgeInsets.all(30), child: SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _avancarHistoria, icon: const Icon(Icons.directions_walk, color: Colors.white), label: Text(_localAtualIndex < historia['locais'].length - 1 ? "AVANÇAR PARA O PRÓXIMO LOCAL" : "CONCLUIR JORNADA", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))))
          ]
        ],
      ),
    );
  }

  Widget _buildEnvelope(String id, String textoNarrativa) {
    return GestureDetector(
      onTap: () => _escolherEnvelope(id, textoNarrativa),
      child: Container(
        width: 140, height: 180, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(4, 4))]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 0, left: 0, right: 0, child: Container(height: 70, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 2))))),
            Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]), child: Center(child: Text(id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
            Positioned(bottom: 20, child: Text("ENVELOPE $id", style: TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold, letterSpacing: 1))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_historiaSelecionadaIndex == null) return _buildSelecaoHistoria();
    return _buildGameplayHistoria();
  }
}

// ==========================================
// JOGO 3: ENIGMA DO MESTRE (URBAN HERO)
// ==========================================
class EnigmaMestre extends StatefulWidget {
  const EnigmaMestre({super.key});

  @override
  State<EnigmaMestre> createState() => _EnigmaMestreState();
}

class _EnigmaMestreState extends State<EnigmaMestre> {
  int? _localSelecionadoIndex;
  
  // NOVA VARIÁVEL: Para controlar em que palavra o utilizador vai no local atual
  int _palavraAtualIndex = 0; 
  int _xpAcumulado = 0;

  final Map<String, String> _dicionarioMorse = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.',
    'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.',
    'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-',
    'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--', 'Z': '--..',
    'Á': '.-', 'Â': '.-', 'Ã': '.-', 'À': '.-', 'É': '.', 'Ê': '.', 'Í': '..', 'Ó': '---', 'Ô': '---', 'Õ': '---', 'Ú': '..-', 'Ç': '-.-.',
  };

  // NOVA ESTRUTURA: Múltiplas palavras por local, com opções individuais para cada uma.
  final List<Map<String, dynamic>> _enigmas = [
    {
      'nome': 'Palácio da Bolsa',
      'frase': 'O [PALÁCIO] da [BOLSA] é um dos monumentos [MAIS] importantes do [PORTO], representando a riqueza comercial da cidade.',
      'palavras': [
        {'correta': 'PALÁCIO', 'opcoes': ['MERCADO', 'PALÁCIO', 'CASTELO']},
        {'correta': 'BOLSA', 'opcoes': ['BOLSA', 'CÂMARA', 'MÚSICA']},
        {'correta': 'MAIS', 'opcoes': ['MENOS', 'POUCO', 'MAIS']},
        {'correta': 'PORTO', 'opcoes': ['MUNDO', 'PAÍS', 'PORTO']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Torre dos Clérigos',
      'frase': 'A [TORRE] dos [CLÉRIGOS] eleva-me, mostrando o [PORTO] aos meus [OLHOS] e ao meu coração.',
      'palavras': [
        {'correta': 'TORRE', 'opcoes': ['CÚPULA', 'ESTÁTUA', 'TORRE']},
        {'correta': 'CLÉRIGOS', 'opcoes': ['PADRES', 'CLÉRIGOS', 'BISPOS']},
        {'correta': 'PORTO', 'opcoes': ['RIO', 'DOURO', 'PORTO']},
        {'correta': 'OLHOS', 'opcoes': ['PÉS', 'OLHOS', 'DEDOS']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Mosteiro da Serra do Pilar',
      'frase': 'A [SERRA] do Pilar mostra-me a [GRANDIOSIDADE] do [PORTO] com [VISTAS] que ficam gravadas no coração.',
      'palavras': [
        {'correta': 'SERRA', 'opcoes': ['MONTANHA', 'SERRA', 'COLINA']},
        {'correta': 'GRANDIOSIDADE', 'opcoes': ['BELEZA', 'MAGNITUDE', 'GRANDIOSIDADE']},
        {'correta': 'PORTO', 'opcoes': ['DOURO', 'GAIA', 'PORTO']},
        {'correta': 'VISTAS', 'opcoes': ['VISTAS', 'PAISAGENS', 'FOTOS']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Ponte Luis I',
      'frase': 'A [PONTE] Luiz I liga as [MARGENS] e [CORAÇÕES], unindo o [PORTO] numa só vista.',
      'palavras': [
        {'correta': 'PONTE', 'opcoes': ['PONTE', 'ESTRADA', 'LINHA']},
        {'correta': 'MARGENS', 'opcoes': ['CIDADES', 'MARGENS', 'TERRAS']},
        {'correta': 'CORAÇÕES', 'opcoes': ['ALMAS', 'MENTES', 'CORAÇÕES']},
        {'correta': 'PORTO', 'opcoes': ['NORTE', 'PORTO', 'MUNDO']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Sé do Porto',
      'frase': 'A [CIDADE] do [PORTO] guarda [HISTÓRIA] e fé, inspirando [TODOS] que a visitam.',
      'palavras': [
        {'correta': 'CIDADE', 'opcoes': ['IGREJA', 'CIDADE', 'RUA']},
        {'correta': 'PORTO', 'opcoes': ['PORTO', 'PAÍS', 'CONCELHO']},
        {'correta': 'HISTÓRIA', 'opcoes': ['MAGIA', 'HISTÓRIA', 'ARTE']},
        {'correta': 'TODOS', 'opcoes': ['MUITOS', 'POUCOS', 'TODOS']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Capela das Almas',
      'frase': 'A [CAPELA] das [ALMAS] revela histórias pintadas em [AZULEJOS], tocando [CORAÇÕES].',
      'palavras': [
        {'correta': 'CAPELA', 'opcoes': ['IGREJA', 'CATEDRAL', 'CAPELA']},
        {'correta': 'ALMAS', 'opcoes': ['FLORES', 'ALMAS', 'CORES']},
        {'correta': 'AZULEJOS', 'opcoes': ['QUADROS', 'AZULEJOS', 'VITRAIS']},
        {'correta': 'CORAÇÕES', 'opcoes': ['MENTES', 'CORAÇÕES', 'ALMAS']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Mercado do Bolhão',
      'frase': 'O [MERCADO] do Bolhão é o [CORAÇÃO] pulsante do [PORTO], onde cores, aromas e [TRADIÇÕES] se encontram.',
      'palavras': [
        {'correta': 'MERCADO', 'opcoes': ['CENTRO', 'EDIFÍCIO', 'MERCADO']},
        {'correta': 'CORAÇÃO', 'opcoes': ['CORAÇÃO', 'PONTO', 'LOCAL']},
        {'correta': 'PORTO', 'opcoes': ['PORTO', 'NORTE', 'MUNDO']},
        {'correta': 'TRADIÇÕES', 'opcoes': ['PESSOAS', 'TRADIÇÕES', 'SABORES']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Estação de São Bento',
      'frase': 'A [ESTAÇÃO] de São Bento é um [MOSAICO] vivo da história do [PORTO], onde cada [AZULEJO] conta uma memória.',
      'palavras': [
        {'correta': 'ESTAÇÃO', 'opcoes': ['ENTRADA', 'PRAÇA', 'ESTAÇÃO']},
        {'correta': 'MOSAICO', 'opcoes': ['QUADRO', 'MOSAICO', 'PAINEL']},
        {'correta': 'PORTO', 'opcoes': ['PAÍS', 'PORTO', 'TEMPO']},
        {'correta': 'AZULEJO', 'opcoes': ['AZULEJO', 'DESENHO', 'MOMENTO']},
      ],
      'isCompleted': false,
    },
    {
      'nome': 'Casa da Música',
      'frase': 'A [CASA] da Música inspira [TODOS] com [HARMONIA] e ritmo, celebrando a [ARTE] no Porto.',
      'palavras': [
        {'correta': 'CASA', 'opcoes': ['SALA', 'OBRA', 'CASA']},
        {'correta': 'TODOS', 'opcoes': ['MUITOS', 'TODOS', 'NÓS']},
        {'correta': 'HARMONIA', 'opcoes': ['ALEGRIA', 'PAIXÃO', 'HARMONIA']},
        {'correta': 'ARTE', 'opcoes': ['ARTE', 'VIDA', 'MÚSICA']},
      ],
      'isCompleted': false,
    },
  ];

  // A LÓGICA DE VERIFICAR A RESPOSTA (SEQUENCIAL)
  void _verificarResposta(String opcao) {
    final enigma = _enigmas[_localSelecionadoIndex!];
    final palavraAtualObj = enigma['palavras'][_palavraAtualIndex];

    if (opcao == palavraAtualObj['correta']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Palavra ${_palavraAtualIndex + 1} Descodificada! ✅"), backgroundColor: Colors.green, duration: const Duration(seconds: 1)));
      
      setState(() => _xpAcumulado += 15);

      // Se ainda houver palavras na frase
      if (_palavraAtualIndex < enigma['palavras'].length - 1) {
        setState(() => _palavraAtualIndex++);
      } else {
        // Se acertou a última palavra
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enigma do Local Concluído! 🎉"), backgroundColor: Colors.green));
        
        setState(() => enigma['isCompleted'] = true);

        bool tudoCompleto = _enigmas.every((e) => e['isCompleted']);
        if (tudoCompleto) {
          Future.delayed(const Duration(seconds: 1), () => _mostrarVitoriaMestre());
        } else {
          Future.delayed(const Duration(seconds: 1), () => setState(() {
            _localSelecionadoIndex = null;
            _palavraAtualIndex = 0; // Volta a zero para o próximo local
          }));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro na tradução. Verifica o teu descodificador Morse! ❌"), backgroundColor: Colors.redAccent, duration: Duration(seconds: 1)));
    }
  }

  void _mostrarVitoriaMestre() {
    int bonusFinal = 450;
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
                  const Icon(Icons.key, color: Colors.amber, size: 100), const SizedBox(height: 20), const Text("MESTRE DESCODIFICADOR", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)), const SizedBox(height: 10), const Text("TODOS OS ENIGMAS RESOLVIDOS", textAlign: TextAlign.center, style: TextStyle(color: Colors.amber, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 40),
                  Container(padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA MISSÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Códigos Traduzidos:", style: TextStyle(color: Colors.white)), Text("${_enigmas.length} / ${_enigmas.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP Base:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bónus Enigma:", style: TextStyle(color: Colors.white)), Text("+$bonusFinal XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold))])])),
                  const SizedBox(height: 50),
                  ElevatedButton(onPressed: () { Navigator.pop(context); setState(() { _localSelecionadoIndex = null; _palavraAtualIndex = 0; }); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListaLocais() {
    int resolvidos = _enigmas.where((e) => e['isCompleted']).length;

    return Container(
      color: const Color(0xFF141414),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ENIGMA DO MESTRE", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(height: 5),
                    Text("$resolvidos / ${_enigmas.length} Locais", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: _enigmas.length,
              itemBuilder: (context, index) {
                final enigma = _enigmas[index];
                bool isDone = enigma['isCompleted'];

                return GestureDetector(
                  onTap: () {
                    if (!isDone) {
                      setState(() {
                        _localSelecionadoIndex = index;
                        _palavraAtualIndex = 0; // Resetar a palavra sempre que abrir um local novo
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: isDone ? Colors.green.withOpacity(0.1) : Colors.white10, borderRadius: BorderRadius.circular(15), border: Border.all(color: isDone ? Colors.green : Colors.white24)),
                    child: Row(
                      children: [
                        Icon(isDone ? Icons.check_circle : Icons.radar, color: isDone ? Colors.green : Colors.amber),
                        const SizedBox(width: 15),
                        Expanded(child: Text(enigma['nome'], style: TextStyle(color: isDone ? Colors.greenAccent : Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                        Icon(Icons.arrow_forward_ios, color: isDone ? Colors.transparent : Colors.white54, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // O TRADUTOR AUTOMÁTICO DE MORSE DA APP
  String _textoParaMorse(String texto) {
    return texto.toUpperCase().split('').map((char) {
      return _dicionarioMorse[char] ?? char;
    }).join(' ');
  }

  // DESENHA A FRASE MOSTRANDO O TEXTO REVELADO A VERDE E O RESTANTE A MORSE AMARELO
  List<TextSpan> _construirFraseProgressiva(String frase) {
    List<TextSpan> spans = [];
    List<String> partes = frase.split('[');
    int indicePalavraOculta = 0;
    
    for (int i = 0; i < partes.length; i++) {
      if (i == 0) {
        spans.add(TextSpan(text: partes[i]));
      } else {
        List<String> subPartes = partes[i].split(']');
        String palavra = subPartes[0];

        if (indicePalavraOculta < _palavraAtualIndex) {
          // Já acertou nesta palavra -> Mostra o texto a verde
          spans.add(TextSpan(text: palavra, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20)));
        } else {
          // Ainda não acertou -> Mostra o Morse a amarelo
          String morse = _textoParaMorse(palavra);
          spans.add(TextSpan(text: morse, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)));
        }
        
        if (subPartes.length > 1) {
          spans.add(TextSpan(text: subPartes[1]));
        }
        indicePalavraOculta++;
      }
    }
    return spans;
  }

  Widget _buildPuzzleLocal() {
    final enigma = _enigmas[_localSelecionadoIndex!];
    final opcoesDaPalavraAtual = enigma['palavras'][_palavraAtualIndex]['opcoes'];

    return Container(
      color: const Color(0xFF141414),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.amber), onPressed: () => setState(() => _localSelecionadoIndex = null)),
                const SizedBox(width: 10),
                Expanded(child: Text(enigma['nome'].toUpperCase(), style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const Icon(Icons.sensors, color: Colors.amber, size: 40),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.black54, border: Border.all(color: Colors.amber.withOpacity(0.3)), borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const Text("MENSAGEM INTERCETADA", style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 2)),
                        const SizedBox(height: 15),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
                            children: _construirFraseProgressiva(enigma['frase']),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  Text("QUAL É A PALAVRA ${_palavraAtualIndex + 1}?", style: const TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  ...opcoesDaPalavraAtual.map<Widget>((opcao) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _verificarResposta(opcao.toString()),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white.withOpacity(0.1)))),
                          child: Text(opcao.toString(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 30),
                  
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white.withOpacity(0.05),
                      backgroundColor: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.amber.withOpacity(0.5))),
                      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      leading: const Icon(Icons.translate, color: Colors.amber),
                      title: const Text("ABRIR DESCODIFICADOR MORSE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: GridView.builder(
                            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
                            itemCount: _dicionarioMorse.length,
                            itemBuilder: (context, index) {
                              String letra = _dicionarioMorse.keys.elementAt(index);
                              String morse = _dicionarioMorse.values.elementAt(index);
                              return Container(
                                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(letra, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)),
                                    Text(morse, style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_localSelecionadoIndex == null) {
      return _buildListaLocais();
    } else {
      return _buildPuzzleLocal();
    }
  }
}