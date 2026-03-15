import 'package:flutter/material.dart';

class SocialTab extends StatefulWidget {
  const SocialTab({super.key});

  @override
  State<SocialTab> createState() => _SocialTabState();
}

class _SocialTabState extends State<SocialTab> {
  // Lista fictícia de amigos (Nível 0 para todos!)
  final List<Map<String, dynamic>> _amigos = [
    {"nome": "Nádia Magalhães", "user": "@nadiam", "img": "1"},
    {"nome": "Lourenço Aluai", "user": "@lourenco", "img": "2"},
    {"nome": "Maria Americano", "user": "@maria", "img": "5"},
    {"nome": "Paula Pereira", "user": "@paula", "img": "4"},
    {"nome": "Bárbara Monteiro", "user": "@barbara", "img": "9"},
  ];

  // ==========================================
  // MENU FLUTUANTE DE MENSAGENS (CHAT)
  // ==========================================
  void _abrirChat(Map<String, dynamic> amigo) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Levanta com o teclado!
            left: 20, right: 20, top: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho do Chat
              Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${amigo["img"]}')),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(amigo["nome"], style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Online agora", style: TextStyle(color: Colors.green[400], fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 30),
              
              // Histórico Vazio Fictício
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Text("Inicia uma conversa com ${amigo["nome"]}!", style: TextStyle(color: textColor.withOpacity(0.5))),
              ),

              // Caixa de Escrever Mensagem
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Escreve uma mensagem...",
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        filled: true,
                        fillColor: boxColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mensagem enviada!"), backgroundColor: Colors.green));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

  // ==========================================
  // MENU FLUTUANTE PARA CONVIDAR PARA JOGAR
  // ==========================================
  void _abrirConviteJogo(Map<String, dynamic> amigo) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Desafiar ${amigo["nome"]}", style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Escolhe o Pack de Turismo para jogarem em equipa ou competirem!", style: TextStyle(color: textColor.withOpacity(0.7))),
              const SizedBox(height: 25),

              // Opções de Packs
              _buildPackConvite("Pack Porto Histórico", Icons.church, boxColor, textColor),
              const SizedBox(height: 10),
              _buildPackConvite("Ribeira e Caves", Icons.wine_bar, boxColor, textColor),
              const SizedBox(height: 10),
              _buildPackConvite("Mistérios da Baixa", Icons.search, boxColor, textColor),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

  Widget _buildPackConvite(String titulo, IconData icon, Color boxColor, Color textColor) {
    return ListTile(
      tileColor: boxColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(titulo, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Convite para $titulo enviado!"), backgroundColor: Colors.green));
        },
        child: const Text("Convidar", style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  // ==========================================
  // UI PRINCIPAL DO ECRÃ SOCIAL
  // ==========================================
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: Colors.transparent, // Usa o fundo geral da App
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Social", style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // BARRA DE PESQUISA (Adicionar Amigos)
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Procurar novos amigos...",
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.5)),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.person_add, color: Colors.white, size: 20),
                ),
                filled: true,
                fillColor: boxColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // LISTA DE AMIGOS
            Expanded(
              child: ListView.separated(
                itemCount: _amigos.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final amigo = _amigos[index];
                  
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        // FOTO DE PERFIL (Pravatar)
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${amigo["img"]}'),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: boxColor, width: 2))),
                            )
                          ],
                        ),
                        const SizedBox(width: 15),
                        
                        // INFO DO JOGADOR
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(amigo["nome"], style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(amigo["user"], style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 13)),
                                  const SizedBox(width: 10),
                                  // TODOS A NÍVEL 0!
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                                    child: const Text("Nível 0", style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        
                        // BOTÕES DE AÇÃO (Chat e Jogar)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              color: Colors.blueAccent,
                              onPressed: () => _abrirChat(amigo), // Abre o menu flutuante de chat
                            ),
                            IconButton(
                              icon: const Icon(Icons.sports_esports),
                              color: Colors.deepOrange,
                              onPressed: () => _abrirConviteJogo(amigo), // Abre o menu flutuante de jogo
                            ),
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
      ),
    );
  }
}