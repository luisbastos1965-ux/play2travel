import 'package:flutter/material.dart';
import 'dart:async'; // Necessário para o temporizador de 3 segundos
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variáveis para controlar a animação (começa invisível e pequeno)
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();

    // 1. Inicia a animação milissegundos depois de abrir a app
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // Fica totalmente visível
        _scale = 1.0;   // Fica no tamanho normal
      });
    });

    // 2. Temporizador de 3 segundos para ir para o Login
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        // Esta animação faz um Fade suave para o Login em vez de "empurrar" o ecrã
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // O teu fundo escuro elegante
      body: Center(
        // Animação de aparecer e crescer
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          opacity: _opacity,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutBack,
            scale: _scale,
            child: Image.asset(
              'assets/logo.png', 
              height: 160, // Coloquei um bocadinho maior para ter mais impacto na abertura
              // Fallback caso a imagem falhe no teste
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.travel_explore,
                color: Colors.deepOrange,
                size: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}