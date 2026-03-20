import 'package:flutter/material.dart';
import 'dart:async';

// ==========================================
// PACK ESPECIAL: QUIET EDITION (RURAL)
// ==========================================

class QuietEdition extends StatefulWidget {
  const QuietEdition({super.key});

  @override
  State<QuietEdition> createState() => _QuietEditionState();
}

class _QuietEditionState extends State<QuietEdition> with WidgetsBindingObserver {
  String _faseAtual = 'SETUP'; 
  
  DateTime? _horaInicioBackground;
  Duration _tempoTotalLonge = Duration.zero;
  Timer? _timerInterface;
  int _segundosInterface = 0; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerInterface?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_faseAtual != 'TRACKING') return;

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      if (_horaInicioBackground == null) {
        _horaInicioBackground = DateTime.now();
      }
    } 
    else if (state == AppLifecycleState.resumed) {
      if (_horaInicioBackground != null) {
        final tempoFora = DateTime.now().difference(_horaInicioBackground!);
        setState(() {
          _tempoTotalLonge += tempoFora;
          _horaInicioBackground = null; 
        });
      }
    }
  }

  void _iniciarRetiro() {
    setState(() {
      _faseAtual = 'TRACKING';
      _tempoTotalLonge = Duration.zero;
      _segundosInterface = 0;
    });

    _timerInterface = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _segundosInterface++);
    });
  }

  void _terminarRetiro() {
    _timerInterface?.cancel();
    
    if (_horaInicioBackground != null) {
      _tempoTotalLonge += DateTime.now().difference(_horaInicioBackground!);
      _horaInicioBackground = null;
    }

    setState(() => _faseAtual = 'RESULTADO');
  }

  Map<String, dynamic> _calcularResultados() {
    int minutos = _tempoTotalLonge.inMinutes;
    double multiplicador = 1.0;

    if (minutos >= 15) {
      multiplicador = 10.0;
    } else if (minutos >= 5) {
      multiplicador = 5.0;
    } else if (minutos >= 1) {
      multiplicador = 2.0;
    }

    int pontosFinais = (minutos * 50 * multiplicador).round();

    if (minutos == 0 && _tempoTotalLonge.inSeconds > 10) {
      pontosFinais = 10;
    }

    return {
      'minutos': minutos,
      'segundos': _tempoTotalLonge.inSeconds % 60,
      'multiplicador': multiplicador,
      'pontos': pontosFinais
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_faseAtual == 'SETUP') return _buildSetup();
    if (_faseAtual == 'TRACKING') return _buildTracking();
    if (_faseAtual == 'RESULTADO') return _buildResultado();
    return const SizedBox.shrink();
  }

  Widget _buildSetup() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0D1B1A)), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.nature_people, color: Colors.lightGreenAccent, size: 80), 
          const SizedBox(height: 20),
          const Text("QUIET EDITION", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const Text("O DESAFIO DO SILÊNCIO", style: TextStyle(color: Colors.lightGreenAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.lightGreenAccent.withOpacity(0.3))),
            child: const Column(
              children: [
                Row(children: [Icon(Icons.lock, color: Colors.lightGreenAccent), SizedBox(width: 10), Expanded(child: Text("Regra 1: Bloqueia o ecrã.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
                SizedBox(height: 15),
                Row(children: [Icon(Icons.timer_off, color: Colors.lightGreenAccent), SizedBox(width: 10), Expanded(child: Text("Regra 2: Esquece o tempo.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
                SizedBox(height: 15),
                Row(children: [Icon(Icons.rocket_launch, color: Colors.lightGreenAccent), SizedBox(width: 10), Expanded(child: Text("Regra 3: Multiplicadores ativam ao fim de 1, 5 e 15 minutos!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
              ],
            ),
          ),
          
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _iniciarRetiro,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent, padding: const EdgeInsets.symmetric(vertical: 20)),
              child: const Text("INICIAR DESCONEXÃO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTracking() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.2, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, double opacidade, child) {
              return Opacity(
                opacity: 1.0, 
                child: const Icon(Icons.spa, color: Colors.lightGreenAccent, size: 100),
              );
            },
          ),
          const SizedBox(height: 40),
          const Text("A MONITORIZAR...", style: TextStyle(color: Colors.lightGreenAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 3)),
          const SizedBox(height: 20),
          const Text("Bloqueia o ecrã ou guarda o telemóvel no bolso agora.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.5)),
          const SizedBox(height: 60),
          
          OutlinedButton.icon(
            onPressed: _terminarRetiro,
            icon: const Icon(Icons.pan_tool, color: Colors.white54),
            label: const Text("ESTOU DE VOLTA", style: TextStyle(color: Colors.white54)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          )
        ],
      ),
    );
  }

  Widget _buildResultado() {
    final res = _calcularResultados();
    
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: Color(0xFF0D1B1A)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, color: Colors.amber, size: 80), 
          const SizedBox(height: 20),
          const Text("BEM-VINDO DE VOLTA", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          
          Text("${res['minutos']}m ${res['segundos']}s", style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 60, fontWeight: FontWeight.bold)),
          const Text("TEMPO DE DESCONEXÃO", style: TextStyle(color: Colors.white54, letterSpacing: 2)),
          
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.lightGreenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [const Text("MULTIPLICADOR", style: TextStyle(color: Colors.white54, fontSize: 12)), const SizedBox(height: 5), Text("x${res['multiplicador']}", style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold))]),
                Container(width: 2, height: 40, color: Colors.white24),
                Column(children: [const Text("PONTOS", style: TextStyle(color: Colors.white54, fontSize: 12)), const SizedBox(height: 5), Text("+${res['pontos']}", style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 24, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20)),
              child: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}