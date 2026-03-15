import 'package:flutter/material.dart';

class EscolaJornadaScreen extends StatefulWidget {
  const EscolaJornadaScreen({super.key});

  @override
  State<EscolaJornadaScreen> createState() => _EscolaJornadaScreenState();
}

class _EscolaJornadaScreenState extends State<EscolaJornadaScreen> {
  bool _isPeriodoLetivo = true;
  String _tipoTurismoSelecionado = 'Histórico';
  Map<String, dynamic>? _jornadaSelecionada;
  String? _turmaSelecionada;
  DateTime? _dataSelecionada;
  final List<String> _professoresSelecionados = [];

  final List<String> _tiposTurismo = ['Histórico', 'Literário', 'Científico', 'Aventura'];
  final List<String> _turmas = ['T1', 'T2', 'T3'];
  final List<Map<String, String>> _professores = [
    {'nome': 'Prof. Silva', 'disciplina': 'História'},
    {'nome': 'Prof.ª Costa', 'disciplina': 'Português'},
    {'nome': 'Prof. Martins', 'disciplina': 'Biologia'},
  ];

  final List<Map<String, dynamic>> _todasJornadas = [
    {'nome': 'Muralhas Fernandinas e o Berço', 'tipo': 'Histórico', 'letivo': true, 'duracao': '2h 30m', 'distancia': '3.2 km', 'aprendizagem': 'Defesa Militar, Século XIV.'},
    {'nome': 'O Porto nos Descobrimentos', 'tipo': 'Histórico', 'letivo': true, 'duracao': '3h', 'distancia': '4.5 km', 'aprendizagem': 'Infante D. Henrique, Ribeira.'},
    {'nome': 'Passos de Camilo e Eça', 'tipo': 'Literário', 'letivo': true, 'duracao': '2h', 'distancia': '2.8 km', 'aprendizagem': 'Romantismo, Realismo.'},
    {'nome': 'Mistérios Botânicos', 'tipo': 'Científico', 'letivo': true, 'duracao': '3h', 'distancia': '5.0 km', 'aprendizagem': 'Biodiversidade.'},
    {'nome': 'Lendas e Fantasmas', 'tipo': 'Histórico', 'letivo': false, 'duracao': '2h', 'distancia': '2.5 km', 'aprendizagem': 'Mitos Urbanos, Team Building.'},
    {'nome': 'Caça ao Tesouro', 'tipo': 'Aventura', 'letivo': false, 'duracao': '3h', 'distancia': '6.0 km', 'aprendizagem': 'Trabalho de Equipa.'},
  ];

  List<Map<String, dynamic>> get _jornadasDisponiveis => _todasJornadas.where((j) => j['letivo'] == _isPeriodoLetivo && j['tipo'] == _tipoTurismoSelecionado).toList();

  // Menu de Calendário Deslizante (Não Crasha)
  void _escolherData() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selecionar Data", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildOpcaoData("Amanhã", DateTime.now().add(const Duration(days: 1))),
            _buildOpcaoData("Próxima Semana", DateTime.now().add(const Duration(days: 7))),
            _buildOpcaoData("Daqui a 15 dias", DateTime.now().add(const Duration(days: 15))),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcaoData(String titulo, DateTime data) {
    return ListTile(
      leading: const Icon(Icons.calendar_month, color: Colors.blueAccent),
      title: Text(titulo, style: const TextStyle(color: Colors.white)),
      subtitle: Text("${data.day}/${data.month}/${data.year}", style: const TextStyle(color: Colors.white54)),
      onTap: () {
        setState(() => _dataSelecionada = data);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(backgroundColor: const Color(0xFF121212), elevation: 0, title: const Text("Planear Jornada", style: TextStyle(color: Colors.white)), iconTheme: const IconThemeData(color: Colors.blueAccent)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Contexto da Saída", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(child: GestureDetector(onTap: () => setState(() {_isPeriodoLetivo = true; _jornadaSelecionada = null;}), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _isPeriodoLetivo ? Colors.blueAccent : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: const Center(child: Text("Período Letivo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))),
                  Expanded(child: GestureDetector(onTap: () => setState(() {_isPeriodoLetivo = false; _jornadaSelecionada = null;}), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: !_isPeriodoLetivo ? Colors.orangeAccent : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: const Center(child: Text("Não Letivo (Férias)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Wrap(spacing: 10, runSpacing: 10, children: _tiposTurismo.map((t) => ChoiceChip(label: Text(t), selected: _tipoTurismoSelecionado == t, onSelected: (v) { if(v) setState(() { _tipoTurismoSelecionado = t; _jornadaSelecionada = null; }); }, selectedColor: Colors.blueAccent.withOpacity(0.2), backgroundColor: Colors.white10, labelStyle: TextStyle(color: _tipoTurismoSelecionado == t ? Colors.blueAccent : Colors.white70), side: BorderSide(color: _tipoTurismoSelecionado == t ? Colors.blueAccent : Colors.transparent))).toList()),
            const SizedBox(height: 30),
            
            const Text("2. Selecionar Jornada (Porto)", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ..._jornadasDisponiveis.map((j) => GestureDetector(
              onTap: () => setState(() => _jornadaSelecionada = j),
              child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _jornadaSelecionada == j ? Colors.blueAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05), border: Border.all(color: _jornadaSelecionada == j ? Colors.blueAccent : Colors.white10), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(j['nome'], style: TextStyle(color: Colors.white, fontWeight: _jornadaSelecionada == j ? FontWeight.bold : FontWeight.normal)), if(_jornadaSelecionada == j) Padding(padding: const EdgeInsets.only(top: 8), child: Text("Objetivo: ${j['aprendizagem']}", style: const TextStyle(color: Colors.white70, fontSize: 13)))])),
            )),
            const SizedBox(height: 30),

            const Text("3. Logística e Turma", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _escolherData,
              child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_dataSelecionada == null ? "Selecionar Data da Saída" : "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}", style: TextStyle(color: _dataSelecionada == null ? Colors.white54 : Colors.white)), const Icon(Icons.calendar_today, color: Colors.white54)])),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(decoration: InputDecoration(labelText: 'Selecionar Turma', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), dropdownColor: Colors.grey[900], style: const TextStyle(color: Colors.white), initialValue: _turmaSelecionada, items: _turmas.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _turmaSelecionada = v)),
            const SizedBox(height: 15),
            Wrap(spacing: 10, runSpacing: 10, children: _professores.map((p) => FilterChip(label: Text(p['nome']!), selected: _professoresSelecionados.contains(p['nome']), onSelected: (v) { setState(() { v ? _professoresSelecionados.add(p['nome']!) : _professoresSelecionados.remove(p['nome']); }); }, selectedColor: Colors.green.withOpacity(0.3), backgroundColor: Colors.white10, checkmarkColor: Colors.green, labelStyle: TextStyle(color: _professoresSelecionados.contains(p['nome']) ? Colors.green : Colors.white70), side: BorderSide(color: _professoresSelecionados.contains(p['nome']) ? Colors.green : Colors.transparent))).toList()),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: _jornadaSelecionada != null && _turmaSelecionada != null && _professoresSelecionados.isNotEmpty ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jornada criada com sucesso!"), backgroundColor: Colors.green)) : null,
                style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey[900], backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("GERAR CÓDIGO DA MISSÃO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}