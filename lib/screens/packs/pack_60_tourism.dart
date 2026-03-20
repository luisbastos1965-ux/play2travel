import 'package:flutter/material.dart';
import 'dart:async';

// ==========================================
// PACK ESPECIAL: 60' OF TOURISM (5 SENSES)
// ==========================================

class SessentaMinutosTurismo extends StatefulWidget {
  const SessentaMinutosTurismo({super.key});

  @override
  State<SessentaMinutosTurismo> createState() => _SessentaMinutosTurismoState();
}

class _SessentaMinutosTurismoState extends State<SessentaMinutosTurismo> {
  String _faseAtual = 'SETUP'; // SETUP -> DASHBOARD -> DETALHE_SENTIDO -> FIM
  
  int _tempoRestante = 3600; // 60 minutos em segundos
  Timer? _timer;
  
  Map<String, dynamic>? _sentidoAtivo;

  final List<Map<String, dynamic>> _sentidos = [
    {
      'id': 'VISAO',
      'nome': 'VISÃO',
      'icone': Icons.visibility,
      'cor': Colors.blueAccent,
      'locais': 'S. Bento • Clérigos • Ribeira',
      'concluido': false,
      'tarefas': [
        {'desc': 'Encontrar cena histórica específica nos azulejos de São Bento.', 'feita': false},
        {'desc': 'Identificar um detalhe barroco na Torre dos Clérigos.', 'feita': false},
        {'desc': 'Descobrir três cores predominantes nas fachadas da Ribeira.', 'feita': false},
        {'desc': 'Tirar uma fotografia criativa com enquadramento do Douro.', 'feita': false},
      ]
    },
    {
      'id': 'AUDICAO',
      'nome': 'AUDIÇÃO',
      'icone': Icons.hearing,
      'cor': Colors.amber,
      'locais': 'Ribeira • Ponte D. Luís • Sta Catarina',
      'concluido': false,
      'tarefas': [
        {'desc': 'Identificar 3 sons: músico de rua, elétrico, gaivota ou barco rabelo.', 'feita': false},
        {'desc': 'Ouvir o som da cidade e identificar o estilo musical ambiente.', 'feita': false},
        {'desc': 'Perguntar a um comerciante: "Qual é o melhor mês para visitar o Porto?"', 'feita': false},
      ]
    },
    {
      'id': 'OLFATO',
      'nome': 'OLFATO',
      'icone': Icons.air,
      'cor': Colors.greenAccent,
      'locais': 'Bolhão • Cafés • Caves (Gaia)',
      'concluido': false,
      'tarefas': [
        {'desc': 'Identificar dois aromas dominantes no Mercado do Bolhão.', 'feita': false},
        {'desc': 'Associar o cheiro a um produto típico (bacalhau, especiarias, fruta).', 'feita': false},
        {'desc': 'Descrever em 3 palavras o cheiro característico das caves de vinho.', 'feita': false},
      ]
    },
    {
      'id': 'TATO',
      'nome': 'TATO',
      'icone': Icons.touch_app,
      'cor': Colors.deepOrange,
      'locais': 'Fachadas • Calçada • Azulejos',
      'concluido': false,
      'tarefas': [
        {'desc': 'Identificar pelo toque se a fachada é de granito ou outro material.', 'feita': false},
        {'desc': 'Encontrar e sentir um padrão específico na calçada portuguesa.', 'feita': false},
        {'desc': 'Tocar numa parede centenária e estimar a sua idade.', 'feita': false},
      ]
    },
    {
      'id': 'PALADAR',
      'nome': 'PALADAR',
      'icone': Icons.restaurant,
      'cor': Colors.pinkAccent,
      'locais': 'O Sabor do Norte',
      'concluido': false,
      'tarefas': [
        {'desc': 'Responde: Quais são os ingredientes principais do molho da francesinha?', 'feita': false},
        {'desc': 'Missão Premium: Mini degustação de Pastel de Nata ou Vinho do Porto.', 'feita': false},
        {'desc': 'Sente o sabor e guarda a memória: "O Porto entra pelos sentidos... mas fica no sabor."', 'feita': false},
      ]
    },
  ];

  void _iniciarTimer() {
    setState(() {
      _faseAtual = 'DASHBOARD';
      _tempoRestante = 3600;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() => _tempoRestante--);
      } else {
        _timer?.cancel();
        setState(() => _faseAtual = 'FIM_TEMPO');
      }
    });
  }

  void _verificarVitoria() {
    bool todosConcluidos = _sentidos.every((s) => s['concluido'] == true);
    if (todosConcluidos) {
      _timer?.cancel();
      setState(() => _faseAtual = 'VITORIA');
    }
  }

  String _formatarTempo(int segundos) {
    int m = segundos ~/ 60;
    int s = segundos % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP') return _buildSetup();
    if (_faseAtual == 'DASHBOARD') return _buildDashboard();
    if (_faseAtual == 'DETALHE_SENTIDO') return _buildDetalheSentido();
    if (_faseAtual == 'VITORIA') return _buildFim(true);
    if (_faseAtual == 'FIM_TEMPO') return _buildFim(false);
    return const SizedBox.shrink();
  }

  // ==========================================
  // ECRÃ 1: SETUP
  // ==========================================
  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0A0A0A)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.av_timer, color: Colors.amber, size: 80), const SizedBox(height: 20),
          const Text("60' OF TOURISM", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const Text("THE 5 SENSES CHALLENGE", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 40),
          const Text("Tens exatamente 1 hora para absorver a essência da cidade através da Visão, Audição, Olfato, Tato e Paladar.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _iniciarTimer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20)),
              child: const Text("INICIAR OS 60 MINUTOS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // ECRÃ 2: DASHBOARD (Menu dos Sentidos)
  // ==========================================
  Widget _buildDashboard() {
    return Container(
      color: const Color(0xFF101010),
      child: Column(
        children: [
          _appBarCronometro(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _sentidos.length,
              itemBuilder: (context, index) {
                final sentido = _sentidos[index];
                bool concluido = sentido['concluido'];
                List tarefas = sentido['tarefas'];
                int feitas = tarefas.where((t) => t['feita'] == true).length;
                double progresso = feitas / tarefas.length;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _sentidoAtivo = sentido;
                      _faseAtual = 'DETALHE_SENTIDO';
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: concluido ? sentido['cor'].withOpacity(0.1) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: concluido ? sentido['cor'] : Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: sentido['cor'].withOpacity(0.2), shape: BoxShape.circle), child: Icon(sentido['icone'], color: sentido['cor'], size: 30)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sentido['nome'], style: TextStyle(color: concluido ? sentido['cor'] : Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 5),
                              Text(sentido['locais'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(value: progresso, backgroundColor: Colors.white10, color: sentido['cor']),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(concluido ? Icons.check_circle : Icons.arrow_forward_ios, color: concluido ? sentido['cor'] : Colors.white24, size: concluido ? 30 : 16)
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

  // ==========================================
  // ECRÃ 3: DETALHE DO SENTIDO
  // ==========================================
  Widget _buildDetalheSentido() {
    Color corAtiva = _sentidoAtivo!['cor'];
    List tarefas = _sentidoAtivo!['tarefas'];

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          _appBarCronometro(voltarPara: 'DASHBOARD'),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: corAtiva.withOpacity(0.1), border: Border(bottom: BorderSide(color: corAtiva.withOpacity(0.3)))),
            child: Column(
              children: [
                Icon(_sentidoAtivo!['icone'], color: corAtiva, size: 60), const SizedBox(height: 10),
                Text(_sentidoAtivo!['nome'], style: TextStyle(color: corAtiva, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 5),
                Text(_sentidoAtivo!['locais'], style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                var tarefa = tarefas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                  child: CheckboxListTile(
                    value: tarefa['feita'],
                    activeColor: corAtiva,
                    checkColor: Colors.black,
                    title: Text(tarefa['desc'], style: TextStyle(color: tarefa['feita'] ? Colors.white54 : Colors.white, decoration: tarefa['feita'] ? TextDecoration.lineThrough : null, fontSize: 14)),
                    onChanged: (bool? val) {
                      setState(() {
                        tarefa['feita'] = val;
                        // Verifica se concluiu todas as tarefas deste sentido
                        bool todasFeitas = tarefas.every((t) => t['feita'] == true);
                        _sentidoAtivo!['concluido'] = todasFeitas;
                      });
                      _verificarVitoria();
                    },
                  ),
                );
              },
            ),
          ),
          if (_sentidoAtivo!['concluido'])
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _faseAtual = 'DASHBOARD'),
                  style: ElevatedButton.styleFrom(backgroundColor: corAtiva, padding: const EdgeInsets.symmetric(vertical: 20)),
                  child: const Text("SENTIDO CONCLUÍDO! VOLTAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            )
        ],
      ),
    );
  }

  // ==========================================
  // ECRÃ 4: FIM (VITORIA OU DERROTA)
  // ==========================================
  Widget _buildFim(bool vitoria) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(vitoria ? Icons.emoji_events : Icons.timer_off, color: vitoria ? Colors.amber : Colors.redAccent, size: 100),
          const SizedBox(height: 20),
          Text(vitoria ? "MISSÃO CUMPRIDA!" : "TEMPO ESGOTADO!", style: TextStyle(color: vitoria ? Colors.amber : Colors.redAccent, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(vitoria ? "Conseguiram absorver toda a essência do Porto dentro do tempo limite. Os vossos sentidos estão agora sincronizados com a cidade." : "O tempo voa quando exploramos. Ficaram alguns sentidos por apurar, mas a experiência foi memorável!", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
          const SizedBox(height: 40),
          Text("Tempo Final: ${_formatarTempo(3600 - _tempoRestante)}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)), child: const Text("VOLTAR AOS PACKS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }

  // ==========================================
  // COMPONENTE: APPBAR COM CRONÓMETRO
  // ==========================================
  Widget _appBarCronometro({String? voltarPara}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 50, 20, 15), decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (voltarPara != null)
            IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => setState(() => _faseAtual = voltarPara))
          else
            const SizedBox(width: 48), // Espaçador para alinhar
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: _tempoRestante < 300 ? Colors.red.withOpacity(0.2) : Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: _tempoRestante < 300 ? Colors.red : Colors.amber)),
            child: Row(
              children: [
                Icon(Icons.timer, color: _tempoRestante < 300 ? Colors.redAccent : Colors.amber, size: 20),
                const SizedBox(width: 10),
                Text(_formatarTempo(_tempoRestante), style: TextStyle(color: _tempoRestante < 300 ? Colors.redAccent : Colors.amber, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
          ),
          const SizedBox(width: 48), // Espaçador para alinhar
        ],
      ),
    );
  }
}