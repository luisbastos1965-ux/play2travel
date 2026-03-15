import 'package:flutter/material.dart';
import 'escola_jornada_screen.dart';
import 'login_screen.dart'; // Importante para o Terminar Sessão funcionar!

class SchoolDashboardScreen extends StatefulWidget {
  const SchoolDashboardScreen({super.key});

  @override
  State<SchoolDashboardScreen> createState() => _SchoolDashboardScreenState();
}

class _SchoolDashboardScreenState extends State<SchoolDashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _paginas = <Widget>[
    const TelaPrincipalEscola(),
    const TelaGestaoTurmas(),
    const TelaPerfilProfessor(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _paginas.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Turmas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ==========================================
// ABA 1: INÍCIO (DASHBOARD)
// ==========================================
class TelaPrincipalEscola extends StatelessWidget {
  const TelaPrincipalEscola({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Portal da Escola", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    Text("O que vamos planear?", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                CircleAvatar(backgroundColor: Colors.blueAccent.withOpacity(0.2), child: const Icon(Icons.notifications, color: Colors.blueAccent)),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EscolaJornadaScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]), borderRadius: BorderRadius.circular(15)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Icon(Icons.add_location_alt, color: Colors.white, size: 30), SizedBox(height: 15), Text("Atribuir\nRoteiro", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A abrir satélite de monitorização..."), backgroundColor: Colors.orange)),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Icon(Icons.radar, color: Colors.orangeAccent, size: 30), SizedBox(height: 15), Text("Monitorizar\nTurmas", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            const Text("Atividade em Curso", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: const Color(0xFF121212), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.withOpacity(0.3))),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.directions_walk, color: Colors.green)),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Turma T1", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Muralhas Fernandinas", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 5),
                        Text("Progresso: 60% concluído", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ABA 2: GESTÃO DE TURMAS
// ==========================================
class TelaGestaoTurmas extends StatelessWidget {
  const TelaGestaoTurmas({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> turmas = [
      {'nome': 'Turma T1', 'alunos': 24, 'nivel': 'Avançado', 'cor': Colors.blueAccent},
      {'nome': 'Turma T2', 'alunos': 28, 'nivel': 'Intermédio', 'cor': Colors.orangeAccent},
      {'nome': 'Turma T3', 'alunos': 22, 'nivel': 'Iniciante', 'cor': Colors.greenAccent},
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Gestão de Turmas", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...turmas.map((turma) => Container(
              margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: turma['cor'].withOpacity(0.2), radius: 25, child: Icon(Icons.groups, color: turma['cor'])),
                  const SizedBox(width: 15),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(turma['nome'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("${turma['alunos']} Alunos • Nível ${turma['nivel']}", style: const TextStyle(color: Colors.white54, fontSize: 13))])),
                  const Icon(Icons.more_vert, color: Colors.white54),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ABA 3: PERFIL DO PROFESSOR
// ==========================================
class TelaPerfilProfessor extends StatelessWidget {
  const TelaPerfilProfessor({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 50, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 15),
            const Text("Prof. Silva", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Escola Secundária do Porto", style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 30),
            
            _buildProfileOption(Icons.school, "As Minhas Disciplinas"),
            _buildProfileOption(Icons.history, "Histórico de Jornadas"),
            _buildProfileOption(Icons.settings, "Definições de Conta"),
            _buildProfileOption(Icons.help_outline, "Ajuda e Suporte"),
            
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Terminar Sessão", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)),
      child: ListTile(leading: Icon(icon, color: Colors.blueAccent), title: Text(title, style: const TextStyle(color: Colors.white)), trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16), onTap: () {}),
    );
  }
}