import 'package:flutter/material.dart';

// ==========================================
// JOGO 1: DESTINO PARTILHADO (STORY & SENSES)
// ==========================================
class DestinoPartilhado extends StatefulWidget {
  const DestinoPartilhado({super.key});

  @override
  State<DestinoPartilhado> createState() => _DestinoPartilhadoState();
}

class _DestinoPartilhadoState extends State<DestinoPartilhado> {
  String _faseAtual = 'INTRO'; 
  int _localAtualIndex = 0;
  int _xpAcumulado = 0;
  
  final List<String> _historiaFinal = [];

  final List<Map<String, dynamic>> _locais = [
    {
      'nome': 'Estação de São Bento',
      'icone': Icons.train,
      'opcoes': [
        {'texto': 'Observar os azulejos e tentar descobrir uma história escondida.', 'consequencia': 'Começaram a jornada perdidos no tempo, decifrando os segredos pintados a azul e branco em São Bento.'},
        {'texto': 'Seguir rapidamente para explorar a cidade.', 'consequencia': 'A energia do Porto chamou mais alto e, sem demoras em São Bento, partiram rapidamente à aventura.'},
      ]
    },
    {
      'nome': 'Ponte Luiz I',
      'icone': Icons.architecture,
      'opcoes': [
        {'texto': 'Atravessar o tabuleiro superior e apreciar a vista.', 'consequencia': 'Desafiaram as alturas na Ponte Luiz I, sentindo o vento e maravilhando-se com a vista panorâmica do Douro.'},
        {'texto': 'Descer até à Ribeira.', 'consequencia': 'Deixaram a ponte para trás e desceram pelas ruelas labirínticas até ao coração vibrante da Ribeira.'},
      ]
    },
    {
      'nome': 'Cais da Ribeira',
      'icone': Icons.water,
      'opcoes': [
        {'texto': 'Sentar numa esplanada.', 'consequencia': 'Na Ribeira, decidiram abrandar o ritmo, sentando-se numa esplanada a absorver a alma do rio e das pessoas.'},
        {'texto': 'Fazer um passeio de barco.', 'consequencia': 'Na Ribeira, a água chamou por vocês e embarcaram num passeio suave pelas ondas do Douro.'},
      ]
    },
    {
      'nome': 'Torre dos Clérigos',
      'icone': Icons.account_balance,
      'opcoes': [
        {'texto': 'Subir os degraus até ao topo e apreciar a vista panorâmica.', 'consequencia': 'O fôlego foi testado na subida aos Clérigos, mas a vista 360º sobre os telhados da cidade compensou tudo.'},
        {'texto': 'Ficar no térreo e explorar as ruas históricas envolventes.', 'consequencia': 'Preferiram manter os pés bem assentes na terra, explorando o comércio tradicional e a vida em redor dos Clérigos.'},
      ]
    },
    {
      'nome': 'Jardim da Cordoaria',
      'icone': Icons.park,
      'opcoes': [
        {'texto': 'Fazer uma pausa e ouvir os sons do jardim.', 'consequencia': 'Na Cordoaria, fecharam os olhos debaixo das árvores centenárias, focando-se apenas nos sons serenos da natureza.'},
        {'texto': 'Explorar as esculturas e caminhos escondidos.', 'consequencia': 'Na Cordoaria, deixaram-se guiar pela curiosidade, descobrindo esculturas misteriosas e caminhos de sombra.'},
      ]
    },
    {
      'nome': 'Avenida dos Aliados',
      'icone': Icons.location_city,
      'opcoes': [
        {'texto': 'Sentar e observar o movimento da cidade.', 'consequencia': 'Na grandiosidade dos Aliados, sentaram-se a ver o Porto passar, sentindo o pulsar constante dos seus habitantes.'},
        {'texto': 'Tirar fotografias dos edifícios históricos.', 'consequencia': 'Nos Aliados, procuraram os melhores ângulos, capturando a imponência e o detalhe das fachadas históricas.'},
      ]
    },
    {
      'nome': 'Capela das Almas',
      'icone': Icons.church,
      'opcoes': [
        {'texto': 'Procurar uma cena específica nos azulejos.', 'consequencia': 'Terminaram a aventura na Capela das Almas, inspecionando cada azulejo exterior à procura de pequenos detalhes.'},
        {'texto': 'Entrar na capela e sentir o ambiente tranquilo.', 'consequencia': 'Terminaram a aventura no silêncio da Capela das Almas, encontrando paz e tranquilidade no interior.'},
      ]
    },
  ];

  void _fazerEscolha(String consequencia) {
    setState(() {
      _historiaFinal.add(consequencia);
      _xpAcumulado += 50;
    });

    if (_localAtualIndex < _locais.length - 1) {
      setState(() => _localAtualIndex++);
    } else {
      setState(() => _faseAtual = 'FIM');
    }
  }

  Widget _buildIntro() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1E130c), Color(0xFF3a1c0d)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("DESTINO PARTILHADO", style: TextStyle(color: Colors.amber, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
          const Text("Cada escolha molda a vossa viagem. Discutam e decidam em conjunto o que querem fazer em cada local.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)), const SizedBox(height: 40),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.3))), child: const Text("No fim da rota, será gerado o vosso Conto Partilhado, refletindo exatamente as decisões únicas que tomaram juntos.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic))), const SizedBox(height: 50),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'JOGO'), icon: const Icon(Icons.edit, color: Colors.black), label: const Text("ESCREVER A NOSSA HISTÓRIA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
        ],
      ),
    );
  }

  Widget _buildJogo() {
    final local = _locais[_localAtualIndex];

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C1A14), Color(0xFF140A05)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1A0F0A)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CAPÍTULO", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("${_localAtualIndex + 1} de ${_locais.length}", style: const TextStyle(color: Colors.white, fontSize: 18))]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: LinearProgressIndicator(value: (_localAtualIndex) / _locais.length, backgroundColor: Colors.white10, color: Colors.amber)),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(local['icone'], color: Colors.amber, size: 60), const SizedBox(height: 20),
                  Text(local['nome'].toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 40),
                  const Text("O QUE DECIDEM FAZER AQUI?", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 30),
                  _buildBotaoOpcao(local['opcoes'][0]['texto'], local['opcoes'][0]['consequencia'], "A"),
                  const SizedBox(height: 20),
                  _buildBotaoOpcao(local['opcoes'][1]['texto'], local['opcoes'][1]['consequencia'], "B"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoOpcao(String texto, String consequencia, String letra) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _fazerEscolha(consequencia),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.05), padding: const EdgeInsets.all(25), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.amber.withOpacity(0.3)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$letra.", style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(width: 15),
            Expanded(child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4))),
          ],
        ),
      ),
    );
  }

  Widget _buildFim() {
    int bonusFinal = 200;
    int xpTotal = _xpAcumulado + bonusFinal;

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3a1c0d), Color(0xFF1E130c)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Color(0xFF1A0F0A)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("A VOSSA HISTÓRIA", style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("+$xpTotal XP TOTAL", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)))]),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Icon(Icons.auto_stories, color: Colors.amber, size: 60), const SizedBox(height: 20),
                  const Text("O CONTO DO PORTO", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
                  const Text("Escrito pelas vossas escolhas de hoje.", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)), const SizedBox(height: 40),
                  
                  Container(
                    padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))),
                    child: Text(_historiaFinal.join('\n\n'), style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6, fontStyle: FontStyle.italic)),
                  ),
                  
                  const SizedBox(height: 50),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.check, color: Colors.black), label: const Text("CONCLUIR E VOLTAR AO MENU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
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
    if (_faseAtual == 'INTRO') return _buildIntro();
    if (_faseAtual == 'JOGO') return _buildJogo();
    if (_faseAtual == 'FIM') return _buildFim();
    return const SizedBox.shrink();
  }
}

// ==========================================
// JOGO 2: MISSÃO ROMEU E JULIETA (STORY & SENSES)
// ==========================================
class MissaoRomeuJulieta extends StatefulWidget {
  const MissaoRomeuJulieta({super.key});

  @override
  State<MissaoRomeuJulieta> createState() => _MissaoRomeuJulietaState();
}

class _MissaoRomeuJulietaState extends State<MissaoRomeuJulieta> {
  String _faseAtual = 'INSTRUCOES'; // INSTRUCOES -> HUB -> ENVIAR -> RECEBER -> ENCONTRO -> FIM
  int _xpAcumulado = 0;
  int _missaoAtualIndex = 0;

  final List<Map<String, dynamic>> _missoes = [
    {'emissor': 'GAIA', 'recetor': 'PORTO', 'alvo': 'Funicular dos Guindais'},
    {'emissor': 'PORTO', 'recetor': 'GAIA', 'alvo': 'Mosteiro da Serra do Pilar'},
    {'emissor': 'GAIA', 'recetor': 'PORTO', 'alvo': 'Muralha Fernandina'},
    {'emissor': 'PORTO', 'recetor': 'GAIA', 'alvo': 'Teleférico de Gaia'},
    {'emissor': 'GAIA', 'recetor': 'PORTO', 'alvo': 'Igreja de São Francisco'},
    {'emissor': 'PORTO', 'recetor': 'GAIA', 'alvo': 'Mural Half Rabbit'},
  ];

  final List<String> _todasPistas = [
    'Monumento', 'Restaurante/Café', 'Estátua', 'Transporte', 'Edifício Grande', 
    'Pequeno Detalhe', 'Colorido', 'Tons Escuros', 'Perto da Água', 'Numa Colina/Alto', 
    'Arte Urbana', 'Religioso', 'Feito de Pedra', 'Tem Metal', 'Natureza/Jardim', 
    'Forma Redonda', 'Forma Quadrada', 'Moderno', 'Antigo', 'Amarelo', 'Branco'
  ];

  List<String> _pistasSelecionadas = [];
  bool _pistasEnviadas = false;

  void _enviarPistas() {
    if (_pistasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Seleciona pelo menos 1 pista para enviares!"), backgroundColor: Colors.amber));
      return;
    }
    setState(() {
      _pistasEnviadas = true;
      _faseAtual = 'HUB';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pistas enviadas ao teu parceiro! 📡"), backgroundColor: Colors.green));
  }

  void _validarLocal(String tipoValidacao) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tipoValidacao == 'FOTO' ? "A abrir câmara... 📸" : "A verificar GPS... 📍"), duration: const Duration(seconds: 1)));
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _xpAcumulado += 50;
        _pistasEnviadas = false;
        _pistasSelecionadas.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Local encontrado e validado! ✅"), backgroundColor: Colors.green));

      if (_missaoAtualIndex < _missoes.length - 1) {
        setState(() => _missaoAtualIndex++);
        setState(() => _faseAtual = 'HUB');
      } else {
        setState(() => _faseAtual = 'ENCONTRO');
      }
    });
  }

  Widget _buildEcraInstrucoes() {
    return Container(
      width: double.infinity, height: double.infinity, padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4B1D52), Color(0xFF1A0A1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.compare_arrows, color: Colors.pinkAccent, size: 80), const SizedBox(height: 20),
            const Text("OPERAÇÃO MARGENS OPOSTAS", textAlign: TextAlign.center, style: TextStyle(color: Colors.pinkAccent, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
            const Text("Uma missão de orientação à distância. Um jogador deve ir para a margem do Porto e o outro para a margem de Gaia.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
            const Text("Através da app, quem estiver numa margem vai receber o nome de um alvo e deverá selecionar as características visuais do local. \n\nO parceiro na margem oposta vai receber essas características no ecrã e tem de procurar o local e validá-lo com foto ou GPS!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)), const SizedBox(height: 40),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'HUB'), icon: const Icon(Icons.play_arrow, color: Colors.white), label: const Text("COMEÇAR MISSÃO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
          ],
        ),
      ),
    );
  }

  Widget _buildEcraHub() {
    final missao = _missoes[_missaoAtualIndex];
    String emissor = missao['emissor'];
    String recetor = missao['recetor'];

    return Container(
      width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CONTROLO DE MISSÃO", style: TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("Missão ${_missaoAtualIndex + 1} de ${_missoes.length}", style: const TextStyle(color: Colors.white, fontSize: 18))]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text("QUEM ESTÁ A SEGURAR O TELEMÓVEL?", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1))), const SizedBox(height: 30),
                  
                  GestureDetector(
                    onTap: () {
                      if (_pistasEnviadas) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Já enviaste as tuas pistas! Passa a vez ao teu parceiro."), backgroundColor: Colors.amber));
                      } else {
                        setState(() => _faseAtual = 'ENVIAR_PISTAS');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: _pistasEnviadas ? Colors.grey.withOpacity(0.1) : Colors.cyanAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: _pistasEnviadas ? Colors.grey : Colors.cyanAccent.withOpacity(0.5), width: 2)),
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: _pistasEnviadas ? Colors.grey : Colors.cyanAccent, size: 40), const SizedBox(width: 15),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("ESTOU EM $emissor", style: TextStyle(color: _pistasEnviadas ? Colors.grey : Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text(_pistasEnviadas ? "A aguardar parceiro..." : "É a tua vez de Enviar Pistas", style: const TextStyle(color: Colors.white54, fontSize: 13))])),
                          if (!_pistasEnviadas) const Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 16)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      if (!_pistasEnviadas) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ainda não recebeste pistas! O teu parceiro tem de as enviar primeiro."), backgroundColor: Colors.amber));
                      } else {
                        setState(() => _faseAtual = 'RECEBER_PISTAS');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: !_pistasEnviadas ? Colors.grey.withOpacity(0.1) : Colors.pinkAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: !_pistasEnviadas ? Colors.grey : Colors.pinkAccent.withOpacity(0.5), width: 2)),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: !_pistasEnviadas ? Colors.grey : Colors.pinkAccent, size: 40), const SizedBox(width: 15),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("ESTOU NO $recetor", style: TextStyle(color: !_pistasEnviadas ? Colors.grey : Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text(!_pistasEnviadas ? "Aguardando transmissão..." : "Pistas Recebidas! Abrir", style: const TextStyle(color: Colors.white54, fontSize: 13))])),
                          if (_pistasEnviadas) const Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: 16)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcraEnviar() {
    final missao = _missoes[_missaoAtualIndex];

    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)))),
            child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent), onPressed: () => setState(() => _faseAtual = 'HUB')), const Text("MODO EMISSOR", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("O ALVO A DESCREVER É:", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 10),
                  Text(missao['alvo'].toUpperCase(), style: const TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 30),
                  const Text("Seleciona as etiquetas que melhor descrevem este local para ajudar o teu parceiro a encontrá-lo:", style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4)), const SizedBox(height: 20),
                  
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: _todasPistas.map((pista) {
                      bool isSelected = _pistasSelecionadas.contains(pista);
                      return FilterChip(
                        label: Text(pista, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                        selected: isSelected,
                        selectedColor: Colors.cyanAccent,
                        backgroundColor: Colors.white10,
                        checkmarkColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isSelected ? Colors.cyanAccent : Colors.transparent)),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) _pistasSelecionadas.add(pista);
                            else _pistasSelecionadas.remove(pista);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 50),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _enviarPistas, icon: const Icon(Icons.send, color: Colors.black), label: const Text("ENVIAR ESTAS PISTAS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEcraReceber() {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), border: Border(bottom: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)))),
            child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.pinkAccent), onPressed: () => setState(() => _faseAtual = 'HUB')), const Text("MODO EXPLORADOR", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1))])
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DADOS INTERCETADOS:", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
                  const Text("O teu parceiro diz que o local que deves procurar na tua margem tem estas características:", style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4)), const SizedBox(height: 20),
                  
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pinkAccent.withOpacity(0.5))),
                    child: Wrap(
                      spacing: 10, runSpacing: 10,
                      children: _pistasSelecionadas.map((pista) {
                        return Chip(
                          label: Text(pista, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  const Text("Sabe onde fica? Dirige-te até lá e valida a localização!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)), const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('FOTO'), icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18), label: const Text("FOTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))), const SizedBox(width: 15),
                      Expanded(child: ElevatedButton.icon(onPressed: () => _validarLocal('GPS'), icon: const Icon(Icons.gps_fixed, color: Colors.white, size: 18), label: const Text("GPS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEcraEncontro() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4B1D52), Color(0xFF1A0A1D)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tour, color: Colors.pinkAccent, size: 80), const SizedBox(height: 20),
          const Text("OPERAÇÃO CONCLUÍDA!", style: TextStyle(color: Colors.pinkAccent, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
          const Text("Todos os locais foram encontrados com sucesso. É hora de se voltarem a reunir.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)), const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pinkAccent)),
            child: const Column(
              children: [
                Text("PONTO DE ENCONTRO:", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 10),
                Text("Ponte Luiz I", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 5),
                Text("(A meio do Tabuleiro Inferior)", style: TextStyle(color: Colors.pinkAccent, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text("Quando se encontrarem, validem com uma selfie juntos!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)), const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A validar Selfie Conjunta... 📸"), duration: Duration(seconds: 2)));
            Future.delayed(const Duration(seconds: 2), () {
              setState(() => _xpAcumulado += 200);
              setState(() => _faseAtual = 'FIM');
            });
          }, icon: const Icon(Icons.camera_alt, color: Colors.white), label: const Text("TIRAR SELFIE DE REENCONTRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  Widget _buildFim() {
    int xpTotal = _xpAcumulado;

    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF300018), Color(0xFF100008)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified, color: Colors.greenAccent, size: 80), const SizedBox(height: 20),
          const Text("REENCONTRO EFETUADO", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)), const SizedBox(height: 40),
          
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.greenAccent.withOpacity(0.5))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP GANHO DA DUPLA:", style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)), Text("+$xpTotal XP", style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 50),
          
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.home, color: Colors.white), label: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'INSTRUCOES') return _buildEcraInstrucoes();
    if (_faseAtual == 'HUB') return _buildEcraHub();
    if (_faseAtual == 'ENVIAR_PISTAS') return _buildEcraEnviar();
    if (_faseAtual == 'RECEBER_PISTAS') return _buildEcraReceber();
    if (_faseAtual == 'ENCONTRO') return _buildEcraEncontro();
    if (_faseAtual == 'FIM') return _buildFim();
    return const SizedBox.shrink();
  }
}

// ==========================================
// JOGO 3: PRISMA DA SAUDADE (STORY & SENSES)
// ==========================================
class PrismaDaSaudade extends StatefulWidget {
  const PrismaDaSaudade({super.key});

  @override
  State<PrismaDaSaudade> createState() => _PrismaDaSaudadeState();
}

class _PrismaDaSaudadeState extends State<PrismaDaSaudade> {
  String _faseAtual = 'INTRO'; // INTRO -> LISTA -> CAPTURA -> FIM
  int? _localSelecionadoIndex;
  String? _filtroAtivo; // 'VERMELHO' ou 'AZUL'
  int _xpAcumulado = 0;

  final TextEditingController _ctrlEmocao = TextEditingController();

  final List<Map<String, dynamic>> _locais = [
    {'nome': 'Torre dos Clérigos', 'memoriaVermelha': null, 'memoriaAzul': null},
    {'nome': 'Ribeira do Porto', 'memoriaVermelha': null, 'memoriaAzul': null},
    {'nome': 'Ponte Luiz I', 'memoriaVermelha': null, 'memoriaAzul': null},
    {'nome': 'Estação de São Bento', 'memoriaVermelha': null, 'memoriaAzul': null},
    {'nome': 'Jardins do Palácio de Cristal', 'memoriaVermelha': null, 'memoriaAzul': null},
  ];

  void _abrirCaptura(int index, String filtro) {
    setState(() {
      _localSelecionadoIndex = index;
      _filtroAtivo = filtro;
      _faseAtual = 'CAPTURA';
      _ctrlEmocao.clear();
    });
  }

  void _guardarEmocao() {
    if (_ctrlEmocao.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Escreve o que estás a sentir primeiro!"), backgroundColor: Colors.amber));
      return;
    }

    setState(() {
      if (_filtroAtivo == 'VERMELHO') {
        _locais[_localSelecionadoIndex!]['memoriaVermelha'] = _ctrlEmocao.text;
      } else {
        _locais[_localSelecionadoIndex!]['memoriaAzul'] = _ctrlEmocao.text;
      }
      _xpAcumulado += 50;
      _faseAtual = 'LISTA';
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sentimento e foto guardados no Prisma! 📸"), backgroundColor: Colors.green));

    // Verifica se completaram os dois filtros em todos os locais
    bool tudoCompleto = _locais.every((local) => local['memoriaVermelha'] != null && local['memoriaAzul'] != null);
    if (tudoCompleto) {
      Future.delayed(const Duration(seconds: 1), () => setState(() => _faseAtual = 'FIM'));
    }
  }

  Widget _buildIntro() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF0F1B29)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.lens, color: Colors.redAccent, size: 50), SizedBox(width: 10), Icon(Icons.lens, color: Colors.blueAccent, size: 50)]), const SizedBox(height: 20),
          const Text("PRISMA DA SAUDADE", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
          const Text("A cidade tem múltiplas caras. Peguem nos vossos filtros físicos coloridos.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
          const Text("Olhem para os monumentos do Porto através do FILTRO VERMELHO (que traz o calor, a paixão e a energia) e depois através do FILTRO AZUL (que traz a melancolia, o frio e a calma).\n\nO ecrã da aplicação vai adaptar-se à vossa lente. Registem as duas perspetivas em cada local!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)), const SizedBox(height: 40),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => setState(() => _faseAtual = 'LISTA'), icon: const Icon(Icons.camera, color: Colors.white), label: const Text("ABRIR O PRISMA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  Widget _buildLista() {
    return Container(
      width: double.infinity, decoration: const BoxDecoration(color: Color(0xFF121212)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1E1E1E)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("DIÁRIO DE EMOÇÕES", style: TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("O Prisma", style: TextStyle(color: Colors.white, fontSize: 18))]),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _locais.length,
              itemBuilder: (context, index) {
                final local = _locais[index];
                bool temVermelho = local['memoriaVermelha'] != null;
                bool temAzul = local['memoriaAzul'] != null;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [const Icon(Icons.location_on, color: Colors.white54, size: 18), const SizedBox(width: 10), Expanded(child: Text(local['nome'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))]),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => temVermelho ? null : _abrirCaptura(index, 'VERMELHO'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: temVermelho ? Colors.redAccent.withOpacity(0.2) : Colors.transparent, border: Border.all(color: Colors.redAccent, width: 2), borderRadius: BorderRadius.circular(10)),
                                child: Column(children: [Icon(temVermelho ? Icons.check : Icons.local_fire_department, color: Colors.redAccent), const SizedBox(height: 5), Text(temVermelho ? "Guardado" : "CALOR", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12))]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => temAzul ? null : _abrirCaptura(index, 'AZUL'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: temAzul ? Colors.blueAccent.withOpacity(0.2) : Colors.transparent, border: Border.all(color: Colors.blueAccent, width: 2), borderRadius: BorderRadius.circular(10)),
                                child: Column(children: [Icon(temAzul ? Icons.check : Icons.ac_unit, color: Colors.blueAccent), const SizedBox(height: 5), Text(temAzul ? "Guardado" : "FRIO", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12))]),
                              ),
                            ),
                          )
                        ],
                      )
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

  Widget _buildCaptura() {
    bool isVermelho = _filtroAtivo == 'VERMELHO';
    Color corFiltro = isVermelho ? Colors.red : Colors.blue;
    String tituloFiltro = isVermelho ? "LENTE DO CALOR" : "LENTE DA MELANCOLIA";
    String subtitulo = isVermelho ? "Coloca o filtro vermelho no olho/câmara. Que paixão, energia ou ruído sentes aqui?" : "Coloca o filtro azul no olho/câmara. Que calma, frio ou nostalgia sentes aqui?";

    return Container(
      width: double.infinity, height: double.infinity,
      // O Ecrã ganha uma opacidade gigante vermelha ou azul para imitar o filtro!
      decoration: BoxDecoration(color: corFiltro.withOpacity(0.9)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => setState(() => _faseAtual = 'LISTA')),
                  const Spacer(),
                  Text(tituloFiltro, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)),
                  const Spacer(),
                  const SizedBox(width: 30), // Para balancear o botão de fechar
                ],
              ),
              const SizedBox(height: 40),
              
              Icon(isVermelho ? Icons.local_fire_department : Icons.ac_unit, color: Colors.white, size: 100),
              const SizedBox(height: 20),
              Text(_locais[_localSelecionadoIndex!]['nome'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(subtitulo, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
              const SizedBox(height: 40),

              TextField(
                controller: _ctrlEmocao, maxLines: 4,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(hintText: "A cidade parece...", hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), filled: true, fillColor: Colors.white.withOpacity(0.8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardarEmocao,
                  icon: Icon(Icons.camera, color: corFiltro),
                  label: Text("TIRAR FOTO E GUARDAR SENTIMENTO", style: TextStyle(color: corFiltro, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFim() {
    int bonusFinal = 400;
    int xpTotal = _xpAcumulado + bonusFinal;

    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2C0B1A), Color(0xFF0F1B29)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 80), const SizedBox(height: 20),
          const Text("PRISMA COMPLETO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 20),
          const Text("Conseguiram observar a verdadeira dualidade da cidade do Porto.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
            child: Column(
              children: [
                const Text("XP DA OBSERVAÇÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Emoções:", style: TextStyle(color: Colors.white)), Text("${_locais.length * 2}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bónus Visão:", style: TextStyle(color: Colors.white)), Text("+$bonusFinal XP", style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold))])
              ],
            ),
          ),
          const SizedBox(height: 50),
          
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.home, color: Colors.white), label: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'INTRO') return _buildIntro();
    if (_faseAtual == 'LISTA') return _buildLista();
    if (_faseAtual == 'CAPTURA') return _buildCaptura();
    if (_faseAtual == 'FIM') return _buildFim();
    return const SizedBox.shrink();
  }
}