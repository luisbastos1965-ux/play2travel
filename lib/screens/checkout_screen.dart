import 'package:flutter/material.dart';
import 'home_screen.dart'; // Para aceder à lista de packs desbloqueados

class CheckoutScreen extends StatefulWidget {
  final String nomePack;
  final String preco;

  const CheckoutScreen({super.key, required this.nomePack, required this.preco});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _metodoSelecionado = 'MBWay';
  bool _aProcessar = false;

  void _processarPagamento() async {
    setState(() => _aProcessar = true);
    
    // Simula o tempo de ligação ao banco (3 segundos)
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    setState(() => _aProcessar = false);
    
    // Adiciona o pack à lista de desbloqueados na sessão
    HomeScreen.packsDesbloqueadosNestaSessao.add(widget.nomePack);

    // Mostra o sucesso e volta ao ecrã anterior
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Pagamento Aprovado!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("O ${widget.nomePack} foi adicionado ao teu Passaporte.", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o dialog
                Navigator.pop(context, true); // Volta para a tab jogar com sucesso
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: const Text("COMEÇAR AVENTURA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[100]!;
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Checkout Seguro", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: _aProcessar 
        ? _buildEcraProcessamento(textColor)
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo da Compra
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepOrange.withOpacity(0.3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("A desbloquear:", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)),
                          const SizedBox(height: 5),
                          Text(widget.nomePack, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(widget.preco, style: const TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                Text("MÉTODO DE PAGAMENTO", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 15),
                
                _buildMetodoPagamento('MBWay', Icons.phone_android, cardColor, textColor),
                _buildMetodoPagamento('Cartão de Crédito', Icons.credit_card, cardColor, textColor),
                _buildMetodoPagamento('Apple / Google Pay', Icons.account_balance_wallet, cardColor, textColor),
                
                const SizedBox(height: 20),
                
                // Formulário dinâmico consoante a escolha
                if (_metodoSelecionado == 'MBWay')
                  TextField(keyboardType: TextInputType.phone, style: TextStyle(color: textColor), decoration: InputDecoration(labelText: "Número de Telemóvel", labelStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: const Icon(Icons.phone), filled: true, fillColor: cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                
                if (_metodoSelecionado == 'Cartão de Crédito')
                  Column(
                    children: [
                      TextField(keyboardType: TextInputType.number, style: TextStyle(color: textColor), decoration: InputDecoration(labelText: "Número do Cartão", labelStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: const Icon(Icons.credit_card), filled: true, fillColor: cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: TextField(style: TextStyle(color: textColor), decoration: InputDecoration(labelText: "Validade", labelStyle: TextStyle(color: textColor.withOpacity(0.5)), filled: true, fillColor: cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)))),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(style: TextStyle(color: textColor), decoration: InputDecoration(labelText: "CVV", labelStyle: TextStyle(color: textColor.withOpacity(0.5)), filled: true, fillColor: cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)))),
                        ],
                      )
                    ],
                  ),

                const SizedBox(height: 40),
                
                ElevatedButton(
                  onPressed: _processarPagamento,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, color: Colors.white, size: 18),
                      const SizedBox(width: 10),
                      Text("PAGAR ${widget.preco}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(child: Text("Pagamento encriptado e seguro (SSL 256-bit)", style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 10))),
              ],
            ),
          ),
    );
  }

  Widget _buildMetodoPagamento(String titulo, IconData icon, Color cardColor, Color textColor) {
    bool isSelected = _metodoSelecionado == titulo;
    return GestureDetector(
      onTap: () => setState(() => _metodoSelecionado = titulo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.withOpacity(0.1) : cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.deepOrange : Colors.transparent, width: 2)
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.deepOrange : textColor.withOpacity(0.5)),
            const SizedBox(width: 15),
            Expanded(child: Text(titulo, style: TextStyle(color: textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.deepOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildEcraProcessamento(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.deepOrange, strokeWidth: 6),
          const SizedBox(height: 30),
          Text("A contactar o teu banco...", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Por favor, não feches a aplicação.", style: TextStyle(color: textColor.withOpacity(0.6))),
        ],
      ),
    );
  }
}