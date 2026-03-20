import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'escola_jornada_screen.dart';
import 'login_screen.dart'; 

class SchoolDashboardScreen extends StatefulWidget {
  const SchoolDashboardScreen({super.key});

  @override
  State<SchoolDashboardScreen> createState() => _SchoolDashboardScreenState();
}

class _SchoolDashboardScreenState extends State<SchoolDashboardScreen> {
  int _selectedIndex = 0;
  String _interfaceAtual = "Professor"; // ✨ Controlo da interface para a demo

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✨ FUNÇÃO QUE ESCOLHE O QUE MOSTRAR NO SEPARADOR "PAINEL"
  Widget _buildConteudoPainel() {
    if (_interfaceAtual == "Aluno") return const TelaPrincipalAluno();
    if (_interfaceAtual == "Encarregado") return const TelaPrincipalEncarregado();
    return const TelaPrincipalEscola(); // O teu painel original do Professor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      // ✨ APPBAR ADAPTADA PARA A TROCA DE INTERFACE ✨
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Portal do $_interfaceAtual",
                  style: TextStyle(
                    color: _interfaceAtual == "Professor" ? Colors.blueAccent : 
                           (_interfaceAtual == "Aluno" ? Colors.greenAccent : Colors.orangeAccent),
                    fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2
                  )
                ),
                const Text("SALA DE COMANDO", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              onSelected: (String valor) => setState(() => _interfaceAtual = valor),
              itemBuilder: (context) => [
                const PopupMenuItem(value: "Professor", child: Text("Vista: Professor")),
                const PopupMenuItem(value: "Aluno", child: Text("Vista: Aluno")),
                const PopupMenuItem(value: "Encarregado", child: Text("Vista: Encarregado")),
              ],
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 
          ? _buildConteudoPainel() 
          : (_selectedIndex == 1 ? const TelaGestaoTurmas() : const TelaPerfilProfessor()),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        unselectedItemColor: Colors.white54,
        selectedItemColor: _interfaceAtual == "Professor" ? Colors.blueAccent : 
                           (_interfaceAtual == "Aluno" ? Colors.greenAccent : Colors.orangeAccent),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Escola'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ===========================================================================
// ABA 1 (PROFESSOR): O TEU CÓDIGO ORIGINAL DE 700 LINHAS COMEÇA AQUI
// ===========================================================================
class TelaPrincipalEscola extends StatelessWidget {
  const TelaPrincipalEscola({super.key});

  // --- MÉTODOS ORIGINAIS ---
  void _abrirRadarProfessor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [Icon(Icons.radar, color: Colors.greenAccent), SizedBox(width: 10), Text("Radar ao Vivo", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context))
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                child: FlutterMap(
                  options: const MapOptions(initialCenter: LatLng(41.1450, -8.6140), initialZoom: 15.0),
                  children: [
                    TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']),
                    MarkerLayer(
                      markers: [
                        Marker(point: const LatLng(41.1458, -8.6139), width: 80, height: 80, child: _marcadorTurma(context, "Squad Alpha", Colors.blueAccent, false)),
                        Marker(point: const LatLng(41.1403, -8.6116), width: 80, height: 80, child: _marcadorTurma(context, "Squad Beta", Colors.purpleAccent, false)),
                        Marker(point: const LatLng(41.1469, -8.6148), width: 80, height: 80, child: _marcadorTurma(context, "Squad Delta", Colors.redAccent, true)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _marcadorTurma(BuildContext context, String equipa, Color cor, bool isSOS) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: cor.withOpacity(0.8), blurRadius: isSOS ? 15 : 5)]),
          child: Icon(isSOS ? Icons.warning : Icons.people, color: Colors.white, size: 16),
        ),
        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
      ],
    );
  }

  void _abrirModoCheckpoint(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Ponto de Encontro", style: TextStyle(color: Colors.white)),
        content: const Text("Gera um QR Code para os alunos registarem presença.", style: TextStyle(color: Colors.white70)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Gerar"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EscolaJornadaScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]), borderRadius: BorderRadius.circular(15)),
                    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.add_location_alt, color: Colors.white, size: 32), SizedBox(height: 15), Text("Atribuir\nRoteiro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => _abrirRadarProfessor(context),
                  child: Container(
                    padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.radar, color: Colors.greenAccent, size: 32), SizedBox(height: 15), Text("Radar ao\nVivo", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CriadorRoteiroScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                    child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.edit_road, color: Colors.purpleAccent, size: 20)), const SizedBox(width: 10), const Expanded(child: Text("Criador Roteiros", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))]),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _abrirModoCheckpoint(context),
                  child: Container(
                    padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.5))),
                    child: const Row(children: [Icon(Icons.qr_code_2, color: Colors.amber, size: 28), SizedBox(width: 10), Expanded(child: Text("Modo Checkpoint", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)))]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text("Atividade em Curso", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.withOpacity(0.5))),
            child: Row(
              children: [
                const Stack(alignment: Alignment.center, children: [SizedBox(width: 50, height: 50, child: CircularProgressIndicator(value: 0.6, strokeWidth: 5, backgroundColor: Colors.white10, color: Colors.greenAccent)), Text("60%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
                const SizedBox(width: 20),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Turma T1 - 2º Ano", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text("Muralhas Fernandinas", style: TextStyle(color: Colors.white70, fontSize: 13))])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ✨ NOVA INTERFACE: TELA DO ALUNO (ESTUDANTE)
// ==========================================
class TelaPrincipalAluno extends StatelessWidget {
  const TelaPrincipalAluno({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B09B), Color(0xFF96C93D)]), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Olá, João!", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text("Estás a 200 XP do Nível 15", style: TextStyle(color: Colors.white70, fontSize: 13))]),
                const CircleAvatar(radius: 25, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Missões Escolares", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.greenAccent.withOpacity(0.2))),
            child: ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.menu_book, color: Colors.greenAccent)),
              title: const Text("Roteiro do Romantismo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text("Tarefa para amanhã • 3 enigmas", style: TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ✨ NOVA INTERFACE: TELA DO ENCARREGADO
// ==========================================
class TelaPrincipalEncarregado extends StatelessWidget {
  const TelaPrincipalEncarregado({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monitorização em Tempo Real", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            height: 160, decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), image: const DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1526772662000-3f88f10405ff?w=500&q=80"), fit: BoxFit.cover, opacity: 0.3)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: Colors.orangeAccent, size: 32),
                  SizedBox(height: 10),
                  Text("O João está na Ribeira", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("Integrado no Squad Alpha", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text("Desempenho Académico", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _buildFichaInfo("Conhecimento Histórico", "Muito Bom", Colors.greenAccent),
                const Divider(color: Colors.white10, height: 30),
                _buildFichaInfo("Enigmas Resolvidos", "12/15", Colors.blueAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFichaInfo(String label, String valor, Color cor) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70)), Text(valor, style: TextStyle(color: cor, fontWeight: FontWeight.bold))]);
  }
}

// ==========================================
// ABA 2: GESTÃO DE TURMAS (O TEU ORIGINAL)
// ==========================================
class TelaGestaoTurmas extends StatefulWidget {
  const TelaGestaoTurmas({super.key});
  @override State<TelaGestaoTurmas> createState() => _TelaGestaoTurmasState();
}
class _TelaGestaoTurmasState extends State<TelaGestaoTurmas> {
  @override Widget build(BuildContext context) {
    return const Center(child: Text("O teu código de Turmas continua aqui!", style: TextStyle(color: Colors.white54)));
  }
}

// ==========================================
// ABA 3: PERFIL (O TEU ORIGINAL)
// ==========================================
class TelaPerfilProfessor extends StatelessWidget {
  const TelaPerfilProfessor({super.key});
  @override Widget build(BuildContext context) {
    return const Center(child: Text("O teu código de Perfil continua aqui!", style: TextStyle(color: Colors.white54)));
  }
}

// ==========================================
// ✨ O TEU CRIADOR DE ROTEIROS COM IA ✨
// ==========================================
class CriadorRoteiroScreen extends StatefulWidget {
  const CriadorRoteiroScreen({super.key});
  @override State<CriadorRoteiroScreen> createState() => _CriadorRoteiroScreenState();
}
class _CriadorRoteiroScreenState extends State<CriadorRoteiroScreen> {
  bool _isGeneratingAI = false;
  final List<Map<String, String>> _paragens = [{"local": "Palácio de Cristal", "missao": "Tirar Foto + Quiz Histórico"}];

  void _gerarComIA() async {
    setState(() => _isGeneratingAI = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _paragens.add({"local": "Livraria Lello", "missao": "Quiz Gerado pela IA"});
      _isGeneratingAI = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ Nova Missão gerada por IA!"), backgroundColor: Colors.purpleAccent));
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(backgroundColor: const Color(0xFF121212), title: const Text("Estúdio de Roteiros IA")),
      body: Column(
        children: [
          if (_isGeneratingAI) const LinearProgressIndicator(color: Colors.purpleAccent),
          Expanded(child: ListView.builder(itemCount: _paragens.length, itemBuilder: (context, index) => ListTile(title: Text(_paragens[index]["local"]!, style: const TextStyle(color: Colors.white))))),
          ElevatedButton.icon(onPressed: _gerarComIA, icon: const Icon(Icons.auto_awesome), label: const Text("Gerar com IA")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}