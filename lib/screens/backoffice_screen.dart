import 'package:flutter/material.dart';

class BackofficeScreen extends StatelessWidget {
  const BackofficeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text("Sala de Comando", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_active, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Visão Geral", style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard("Turistas Ativos", "1,240", Icons.people, Colors.blueAccent, cardColor, textColor),
                _buildStatCard("Escolas Registadas", "45", Icons.school, Colors.green, cardColor, textColor),
                _buildStatCard("Packs Concluídos", "8,902", Icons.map, Colors.purpleAccent, cardColor, textColor),
                _buildStatCard("Alertas / SOS", "0", Icons.warning, Colors.redAccent, cardColor, textColor),
              ],
            ),
            const SizedBox(height: 30),
            Text("Atividade Recente", style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: isDark ? Colors.white10 : Colors.transparent)),
              child: Column(
                children: [
                  _buildActivityRow("Turma T1 - Profitecla", "Iniciou Pack Heritage Hunt", "Há 2 min", Icons.play_circle, Colors.green, textColor),
                  Divider(color: isDark ? Colors.white10 : Colors.grey[200], height: 1),
                  _buildActivityRow("Novo Registo", "João Silva (Turista)", "Há 15 min", Icons.person_add, Colors.blueAccent, textColor),
                  Divider(color: isDark ? Colors.white10 : Colors.grey[200], height: 1),
                  _buildActivityRow("Júri 3", "Publicou foto de Ouro no Mural", "Há 1 hora", Icons.workspace_premium, Colors.amber, textColor),
                  Divider(color: isDark ? Colors.white10 : Colors.grey[200], height: 1),
                  _buildActivityRow("Manutenção", "Servidor atualizado", "Ontem", Icons.build, Colors.grey, textColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.3), width: 2), boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String title, String subtitle, String time, IconData icon, Color color, Color textColor) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
      trailing: Text(time, style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 11)),
    );
  }
}