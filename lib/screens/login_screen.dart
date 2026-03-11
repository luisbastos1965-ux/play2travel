import 'package:flutter/material.dart';
import 'home_screen.dart'; // O ecrã dos turistas
import 'school_dashboard_screen.dart'; // O novo ecrã das escolas
import 'register_screen.dart'; // O novo ecrã de registo

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isEscolaMode = false; // Controla se estamos no modo Turista ou Escola

  void _fazerLogin() {
    String user = _usernameController.text.trim();
    
    // Lógica simples para a DEMO da PAP
    if (user.isNotEmpty) {
      if (_isEscolaMode) {
        // Se for escola, vai para o Dashboard Escolar
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => SchoolDashboardScreen(username: user),
        ));
      } else {
        // Se for turista, vai para a Home Screen normal
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen(username: user, cargo: 'Turista'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insere um utilizador!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definimos as cores dinâmicas baseadas no modo selecionado
    Color corPrincipal = _isEscolaMode ? Colors.blueAccent : Colors.deepOrange;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO Animado com a cor
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: corPrincipal.withOpacity(0.5), blurRadius: 30, spreadRadius: 2)],
                  ),
                  child: Icon(Icons.travel_explore, size: 80, color: corPrincipal),
                ),
                const SizedBox(height: 10),
                const Text(
                  "PLAY2TRAVEL",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // O GRANDE DESTAQUE: TOGGLE TURISTA / ESCOLA
                // ==========================================
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isEscolaMode = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: !_isEscolaMode ? Colors.deepOrange : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text("TURISTA", style: TextStyle(color: !_isEscolaMode ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isEscolaMode = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: _isEscolaMode ? Colors.blueAccent : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text("ESCOLA", style: TextStyle(color: _isEscolaMode ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // CAMPOS DE TEXTO
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _isEscolaMode ? "Nº Mecanográfico (Ex: Juri1, Lourenço)" : "Nome de Utilizador",
                    hintStyle: const TextStyle(color: Colors.white30),
                    prefixIcon: Icon(_isEscolaMode ? Icons.school : Icons.person, color: corPrincipal),
                    filled: true, fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: corPrincipal, width: 2)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Palavra-passe",
                    hintStyle: const TextStyle(color: Colors.white30),
                    prefixIcon: Icon(Icons.lock, color: corPrincipal),
                    filled: true, fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: corPrincipal, width: 2)),
                  ),
                ),
                const SizedBox(height: 30),

                // BOTÃO ENTRAR
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrincipal,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("ENTRAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                  ),
                ),
                const SizedBox(height: 20),

                // ==========================================
                // REDES SOCIAIS (ESCONDIDAS NO MODO ESCOLA)
                // ==========================================
                if (!_isEscolaMode) ...[
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OU INICIA COM", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Botões Redes Sociais: Google, Facebook, Apple
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton("G", Colors.redAccent), // Google
                      const SizedBox(width: 20),
                      _socialButton("f", Colors.blue), // Facebook
                      const SizedBox(width: 20),
                      _socialButton("", Colors.white, isApple: true), // Apple
                    ],
                  ),
                ],

                const SizedBox(height: 40),

                // BOTÃO CRIAR CONTA
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Ainda não tens conta? ", style: const TextStyle(color: Colors.white54),
                      children: [TextSpan(text: "Regista-te aqui", style: TextStyle(color: corPrincipal, fontWeight: FontWeight.bold))],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Design dos botões sociais redondos
  Widget _socialButton(String label, Color color, {bool isApple = false}) {
    return Container(
      width: 55, height: 55,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white10), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color, 
          fontSize: isApple ? 30 : 28, 
          fontWeight: FontWeight.bold,
          fontFamily: isApple ? null : 'serif' // Para dar um ar mais parecido aos logos originais
        ),
      ),
    );
  }
}