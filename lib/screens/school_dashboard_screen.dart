import 'package:flutter/material.dart';

class SchoolDashboardScreen extends StatefulWidget {
  final String username;
  
  const SchoolDashboardScreen({super.key, required this.username});

  @override
  State<SchoolDashboardScreen> createState() => _SchoolDashboardScreenState();
}

class _SchoolDashboardScreenState extends State<SchoolDashboardScreen> {
  int _indiceAtual = 0; // Começa na aba das Turmas

  // ==========================================
  // DADOS REAIS DAS TURMAS DO TIAGO!
  // ==========================================
  String _turmaSelecionada = 'Turma T1';
  final List<String> _turmas = ['Turma T1', 'Turma T2', 'Turma T3'];

  // Gerei níveis e progressos fictícios para dar realismo à demo!
  final Map<String, List<Map<String, dynamic>>> _alunosPorTurma = {
    'Turma T1': [
      {'nome': 'Ambrozinda da Conceição Soares Lourenço', 'idade': 17, 'nivel': 4, 'progresso': 25},
      {'nome': 'Ariana Paixão Pinto', 'idade': 15, 'nivel': 2, 'progresso': 15},
      {'nome': 'Camila Valentina Ribas Lemus', 'idade': 16, 'nivel': 5, 'progresso': 35},
      {'nome': 'Carla Sofia Barbosa Lopes', 'idade': 16, 'nivel': 3, 'progresso': 20},
      {'nome': 'Diana Cardoso Sousa', 'idade': 15, 'nivel': 6, 'progresso': 45},
      {'nome': 'Diana Carolina Gonçalves da Silva Sá', 'idade': 15, 'nivel': 7, 'progresso': 50},
      {'nome': 'Fábio Martim Santos Ferreira de Almeida', 'idade': 15, 'nivel': 4, 'progresso': 30},
      {'nome': 'Francisca Silva Rocha', 'idade': 17, 'nivel': 8, 'progresso': 60},
      {'nome': 'Gabriel Araújo Gonçalves', 'idade': 15, 'nivel': 5, 'progresso': 40},
      {'nome': 'Hanna Nicole Moreno da Silva', 'idade': 16, 'nivel': 3, 'progresso': 25},
      {'nome': 'Helena Rocha Manuel Gonzaga', 'idade': 15, 'nivel': 9, 'progresso': 70},
      {'nome': 'Henrique dos Santos Leonardo', 'idade': 16, 'nivel': 2, 'progresso': 10},
      {'nome': 'Iara Moreira Martins', 'idade': 16, 'nivel': 6, 'progresso': 45},
      {'nome': 'Lara Gabriely Leal Paixão', 'idade': 15, 'nivel': 7, 'progresso': 55},
      {'nome': 'Letícia da Silva Rodrigues', 'idade': 15, 'nivel': 4, 'progresso': 35},
      {'nome': 'Mafalda Inês Teixeira Santos', 'idade': 16, 'nivel': 5, 'progresso': 40},
      {'nome': 'Mafalda Penetro Duarte', 'idade': 15, 'nivel': 3, 'progresso': 20},
      {'nome': 'Mara Raquel Ferreira da Silva Moreira', 'idade': 15, 'nivel': 6, 'progresso': 48},
      {'nome': 'Maria Beatriz Marques', 'idade': 16, 'nivel': 8, 'progresso': 65},
      {'nome': 'Maria Eduarda Siqueira dos Santos', 'idade': 16, 'nivel': 5, 'progresso': 38},
      {'nome': 'Mariana Gomes Custódio', 'idade': 15, 'nivel': 4, 'progresso': 30},
      {'nome': 'Miguel Pinto Borges de Almeida', 'idade': 15, 'nivel': 7, 'progresso': 52},
      {'nome': 'Nathan Perretti dos Santos', 'idade': 16, 'nivel': 9, 'progresso': 75},
      {'nome': 'Raquel Marques Barros', 'idade': 15, 'nivel': 6, 'progresso': 44},
      {'nome': 'Rodrigo Azevedo Lopes', 'idade': 16, 'nivel': 5, 'progresso': 36},
    ],
    'Turma T2': [
      {'nome': 'Ana Carolina Corrêa Sousa Costa', 'idade': 16, 'nivel': 7, 'progresso': 55},
      {'nome': 'Anyeli Freyre Martínez', 'idade': 17, 'nivel': 5, 'progresso': 40},
      {'nome': 'Aryna Cholak', 'idade': 17, 'nivel': 8, 'progresso': 60},
      {'nome': 'Beatriz Camilo Magalhães', 'idade': 16, 'nivel': 4, 'progresso': 30},
      {'nome': 'Beatriz Maria Aurélio da Silva', 'idade': 16, 'nivel': 6, 'progresso': 45},
      {'nome': 'Catarina Anjos Marinho', 'idade': 17, 'nivel': 9, 'progresso': 70},
      {'nome': 'Clara Nogueira Fernandes', 'idade': 16, 'nivel': 5, 'progresso': 35},
      {'nome': 'Daniela Francisca Fernandes de Andrade', 'idade': 17, 'nivel': 3, 'progresso': 25},
      {'nome': 'Dinis Mateus Loureiro da Silva', 'idade': 17, 'nivel': 8, 'progresso': 65},
      {'nome': 'Érica Sofia Ventura Ferreira', 'idade': 17, 'nivel': 4, 'progresso': 32},
      {'nome': 'Francisca Oliveira Soares', 'idade': 17, 'nivel': 7, 'progresso': 50},
      {'nome': 'Francisca Vieira Inácio', 'idade': 16, 'nivel': 6, 'progresso': 48},
      {'nome': 'Iara Filipa Martins Mendes', 'idade': 17, 'nivel': 5, 'progresso': 38},
      {'nome': 'Jéssika Proiavko', 'idade': 17, 'nivel': 9, 'progresso': 75},
      {'nome': 'Joana Filipa Sotto-Mayor Teixeira Sobrinho', 'idade': 16, 'nivel': 4, 'progresso': 28},
      {'nome': 'Kevin da Silva Teixeira Tavares', 'idade': 18, 'nivel': 6, 'progresso': 46},
      {'nome': 'Lara Filipa Botelho Guedes', 'idade': 19, 'nivel': 10, 'progresso': 80},
      {'nome': 'Luana Ferreira Sá', 'idade': 17, 'nivel': 5, 'progresso': 40},
      {'nome': 'Luana Filipa Silva Gonçalves', 'idade': 18, 'nivel': 7, 'progresso': 52},
      {'nome': 'Mara Catarina Cardoso Anjos', 'idade': 17, 'nivel': 6, 'progresso': 44},
      {'nome': 'Mariana Sofia Cruz Sousa Neves', 'idade': 16, 'nivel': 4, 'progresso': 34},
      {'nome': 'Mónica Germano da Cruz Costa', 'idade': 17, 'nivel': 8, 'progresso': 62},
      {'nome': 'Nuno Joaquim Abreu de Barros', 'idade': 17, 'nivel': 5, 'progresso': 36},
      {'nome': 'Rafaela Costa Gomes', 'idade': 16, 'nivel': 7, 'progresso': 58},
      {'nome': 'Rodrigo da Costa Marinho', 'idade': 17, 'nivel': 6, 'progresso': 42},
      {'nome': 'Soraia Daniela da Costa Jesus', 'idade': 18, 'nivel': 9, 'progresso': 72},
    ],
    'Turma T3': [
      {'nome': 'André Oliveira da Silva', 'idade': 19, 'nivel': 6, 'progresso': 45},
      {'nome': 'Beatriz Filipa Novais Resende', 'idade': 19, 'nivel': 8, 'progresso': 60},
      {'nome': 'Daniela Sofia Correia Vieira', 'idade': 17, 'nivel': 5, 'progresso': 35},
      {'nome': 'Elisa Felicia Pinto Pemba', 'idade': 20, 'nivel': 7, 'progresso': 50},
      {'nome': 'Ema Oliveira Freitas', 'idade': 17, 'nivel': 4, 'progresso': 30},
      {'nome': 'Gabriela Duarte de Sousa Ribeiro', 'idade': 18, 'nivel': 6, 'progresso': 40},
      {'nome': 'Hermes dos Santos Neto', 'idade': 17, 'nivel': 5, 'progresso': 38},
      {'nome': 'Isabella França Soares', 'idade': 20, 'nivel': 9, 'progresso': 65},
      {'nome': 'Leticia Melo da Silva', 'idade': 17, 'nivel': 7, 'progresso': 55},
      // OS TEUS COLEGAS EM DESTAQUE (Com stats mais altos!)
      {'nome': 'Lourenço Ferreira Aluai', 'idade': 18, 'nivel': 14, 'progresso': 92},
      {'nome': 'Luana de Castro Santos', 'idade': 18, 'nivel': 6, 'progresso': 48},
      {'nome': 'Luísa Filipa Magalhães Lopes', 'idade': 17, 'nivel': 5, 'progresso': 36},
      {'nome': 'Maira Janina do Rosário Fortes', 'idade': 18, 'nivel': 8, 'progresso': 62},
      {'nome': 'Mara Sousa Aruil de Figueiredo', 'idade': 18, 'nivel': 7, 'progresso': 54},
      {'nome': 'Maria Beatriz Pereira Americano', 'idade': 18, 'nivel': 13, 'progresso': 88},
      {'nome': 'Marinela Ramos Nassende Estrela', 'idade': 17, 'nivel': 5, 'progresso': 32},
      {'nome': 'Matilde Ribeiro Taborda', 'idade': 17, 'nivel': 6, 'progresso': 42},
      {'nome': 'Nádia Simões Magalhães', 'idade': 18, 'nivel': 15, 'progresso': 96},
      {'nome': 'Paula Alexandra Rodrigues Pereira', 'idade': 17, 'nivel': 14, 'progresso': 85},
      {'nome': 'Pedro Miguel Marques Ferreira', 'idade': 17, 'nivel': 7, 'progresso': 58},
      {'nome': 'Rodrigo José da Silva Neves', 'idade': 17, 'nivel': 8, 'progresso': 66},
      {'nome': 'Sofia Dias Pinheiro', 'idade': 17, 'nivel': 6, 'progresso': 46},
    ],
  };

  // ==========================================
  // ABA 1: GESTÃO DE TURMAS
  // ==========================================
  Widget _menuTurmas() {
    List<Map<String, dynamic>> alunos = _alunosPorTurma[_turmaSelecionada] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Estatística Geral Animada (Muda consoante a turma)
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.indigo]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_graph, color: Colors.white, size: 50),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gestão da $_turmaSelecionada", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Alunos Ativos: ${alunos.length}", style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filtro de Turmas
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _turmas.map((turma) {
              bool isSelected = _turmaSelecionada == turma;
              return GestureDetector(
                onTap: () => setState(() => _turmaSelecionada = turma),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.transparent,
                    border: Border.all(color: isSelected ? Colors.blueAccent : Colors.white24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    turma,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Cabeçalho da Lista
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("LISTA DE ALUNOS (${alunos.length})", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),

        // Lista de Alunos Dinâmica
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final aluno = alunos[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.2), 
                      child: Text(aluno['nome'][0], style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nome com Ellipsis para não quebrar com nomes gigantes
                          Text(aluno['nome'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text("${aluno['idade']} anos  •  Nível ${aluno['nivel']}  •  ", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(
                                    value: aluno['progresso'] / 100,
                                    backgroundColor: Colors.white10,
                                    color: Colors.blueAccent,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("${aluno['progresso']}%", style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          )
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
    );
  }

  // ==========================================
  // ABA 2: JOGAR / INICIAR JORNADA (Professores)
  // ==========================================
  Widget _menuPlay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.travel_explore, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text("MODO JORNADA", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 15),
            const Text(
              "Neste espaço o professor pode iniciar um percurso em modo de acompanhamento, ou atribuir packs específicos às suas turmas.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.add_location_alt, color: Colors.white),
              label: const Text("ATRIBUIR ROTEIRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ABA 3: PERFIL DO PROFESSOR / JÚRI
  // ==========================================
  Widget _menuPerfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            child: Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Text(widget.username, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          const Text("Professor / Membro do Júri", style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          
          const SizedBox(height: 40),
          
          _buildPerfilInfoRow(Icons.school, "Instituição", "Escola Secundária (Turismo)"),
          const Divider(color: Colors.white10, height: 30),
          _buildPerfilInfoRow(Icons.book, "Disciplina Orientada", "Área de Integração / Turismo"),
          const Divider(color: Colors.white10, height: 30),
          _buildPerfilInfoRow(Icons.email, "Email Institucional", "${widget.username.toLowerCase().replaceAll(' ', '')}@escola.pt"),
          
          const SizedBox(height: 50),
          TextButton.icon(
            onPressed: () => Navigator.pop(context), 
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent), 
            label: const Text("Terminar Sessão", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }

  Widget _buildPerfilInfoRow(IconData icon, String titulo, String valor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white70),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(valor, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BUILD PRINCIPAL E BARRA DE NAVEGAÇÃO
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      _menuTurmas(),
      _menuPlay(),
      _menuPerfil(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Text("Portal Escolar - ${widget.username}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: paginas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, 
        onTap: (i) => setState(() => _indiceAtual = i),
        type: BottomNavigationBarType.fixed, 
        backgroundColor: const Color(0xFF121212), 
        selectedItemColor: Colors.blueAccent, 
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Turmas"),
          
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                boxShadow: _indiceAtual == 1 
                    ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)]
                    : [],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_circle_fill, size: 42),
            ), 
            label: "Jornada"
          ),
          
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}