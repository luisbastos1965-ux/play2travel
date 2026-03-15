import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';

// ==========================================
// JOGO 1: RADAR DE CURIOSIDADES
// ==========================================
class RadarCuriosidades extends StatefulWidget {
  const RadarCuriosidades({super.key});

  @override
  State<RadarCuriosidades> createState() => _RadarCuriosidadesState();
}

class _RadarCuriosidadesState extends State<RadarCuriosidades> {
  final List<Map<String, dynamic>> _locais = [
    {'nome': 'Estação de S. Bento', 'coords': const LatLng(41.1456, -8.6115), 'lenda': 'Os mais de 20 mil azulejos de Jorge Colaço, colocados em 1916, contam os momentos mais épicos da História de Portugal.', 'xp': 50, 'isScanned': false},
    {'nome': 'Palácio da Bolsa', 'coords': const LatLng(41.1414, -8.6158), 'lenda': 'O deslumbrante Salão Árabe demorou 18 anos a ser construído e a sua decoração pesa quase 20 quilos em ouro de 18 quilates.', 'xp': 50, 'isScanned': false},
    {'nome': 'Teatro Sá da Bandeira', 'coords': const LatLng(41.1472, -8.6083), 'lenda': 'É o teatro mais antigo do Porto (1846). Foi aqui que se exibiram os primeiros filmes em Portugal e foi o primeiro teatro a ter luz elétrica!', 'xp': 50, 'isScanned': false},
    {'nome': 'Torre dos Clérigos', 'coords': const LatLng(41.1458, -8.6139), 'lenda': 'Tem 75 metros de altura e 225 degraus. Construída por Nicolau Nasoni no séc. XVIII, servia de farol para os navios que entravam no Douro.', 'xp': 50, 'isScanned': false},
    {'nome': 'Palácio de Cristal', 'coords': const LatLng(41.1481, -8.6258), 'lenda': 'O pavilhão original de 1865 era todo em vidro e ferro, inspirado no Crystal Palace de Londres. Foi demolido em 1951, dando lugar à cúpula atual.', 'xp': 50, 'isScanned': false},
  ];

  int _locaisLidos = 0;
  int _xpAcumulado = 0;
  bool _jogoConcluido = false;
  
  // Variável para a caixa flutuante do mapa
  Map<String, dynamic>? _localSelecionado;

  void _abrirScannerRadar() {
    bool isScanned = false; 
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.black,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MobileScanner(onDetect: (capture) { if (!isScanned) { isScanned = true; Navigator.pop(context); _processarQRCodeLido(); } }),
              Container(width: 250, height: 250, decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange, width: 3), borderRadius: BorderRadius.circular(30)), child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.white54, size: 80))),
              Positioned(top: 20, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)), child: const Text("PROCURANDO SINAL...", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, letterSpacing: 2)))),
              Positioned(bottom: 40, child: ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white), label: const Text("Cancelar", style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent)))
            ],
          ),
        );
      },
    );
  }

  void _processarQRCodeLido() {
    int indexDesbloquear = _locais.indexWhere((local) => local['isScanned'] == false);
    if (indexDesbloquear != -1) {
      setState(() { 
        _locais[indexDesbloquear]['isScanned'] = true; 
        _locaisLidos++; 
        _xpAcumulado += _locais[indexDesbloquear]['xp'] as int; 
        _localSelecionado = null; // Limpa a caixa flutuante se estiver aberta
      });
      _mostrarLendaDoLocal(_locais[indexDesbloquear]);
      if (_locaisLidos == _locais.length) Future.delayed(const Duration(seconds: 2), () => _mostrarTelaDeVitoria());
    }
  }

  void _mostrarLendaDoLocal(Map<String, dynamic> local) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.deepOrange, width: 2)),
        title: Column(children: [const Icon(Icons.my_location, color: Colors.greenAccent, size: 50), const SizedBox(height: 10), const Text("ALVO ENCONTRADO!", style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 5), Text(local['nome'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))]),
        content: Text(local['lenda'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.check, color: Colors.white), label: Text("+${local['xp']} XP RECOLHIDO", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))],
      ),
    );
  }

  void _mostrarTelaDeVitoria() {
    setState(() => _jogoConcluido = true);
    int bonusConclusao = 250;
    int xpTotalFinal = _xpAcumulado + bonusConclusao;
    showGeneralDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.9), barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 100), const SizedBox(height: 20), const Text("MISSÃO CONCLUÍDA!", style: TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3)), const SizedBox(height: 10), const Text("Radar de Curiosidades", style: TextStyle(color: Colors.white, fontSize: 20)), const SizedBox(height: 40),
                  Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA MISSÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Locais Descobertos:", style: TextStyle(color: Colors.white)), Text("$_locaisLidos / ${_locais.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP de Exploração:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bónus de Conclusão:", style: TextStyle(color: Colors.white)), Text("+$bonusConclusao XP", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotalFinal XP", style: const TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold))])])),
                  const SizedBox(height: 50),
                  ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(initialCenter: LatLng(41.1450, -8.6140), initialZoom: 15.0), 
          children: [
            TileLayer(urlTemplate: isDark ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png' : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']), 
            MarkerLayer(
              markers: _locais.map((local) { 
                bool scanned = local['isScanned']; 
                return Marker(
                  point: local['coords'], 
                  width: 60, height: 60, 
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _localSelecionado = local),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5), 
                          decoration: BoxDecoration(color: scanned ? Colors.greenAccent : Colors.deepOrange, shape: BoxShape.circle, boxShadow: [BoxShadow(color: scanned ? Colors.greenAccent : Colors.deepOrange, blurRadius: 10)]), 
                          child: Icon(scanned ? Icons.check : Icons.location_on, color: Colors.black, size: 20)
                        )
                      ]
                    ),
                  )
                ); 
              }).toList()
            )
          ]
        ),

        // ✨ NOVA CAIXA FLUTUANTE DE INFORMAÇÃO ✨
        if (_localSelecionado != null)
          Positioned(
            top: 20, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E).withOpacity(0.95) : Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 1),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.place, color: Colors.deepOrange),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_localSelecionado!['nome'], style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          _localSelecionado!['isScanned'] ? "Local já explorado. Missão concluída." : "Dirige-te aqui para encontrar o QR Code.",
                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions, color: Colors.blueAccent, size: 30),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A abrir rota para ${_localSelecionado!['nome']} no Google Maps..."), backgroundColor: Colors.blueAccent));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => setState(() => _localSelecionado = null),
                  ),
                ],
              ),
            ),
          ),

        Positioned(
          bottom: 20, left: 20, right: 20, 
          child: Container(
            padding: const EdgeInsets.all(20), 
            decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E).withOpacity(0.95) : Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.deepOrange.withOpacity(0.5), width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))]), 
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                const Text("RADAR DE CURIOSIDADES", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, letterSpacing: 1.5)), 
                const SizedBox(height: 15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Alvos Detetados", style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12)), Text("$_locaisLidos / ${_locais.length}", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.bold))]), 
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("XP Atual", style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12)), Text("+$_xpAcumulado", style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold))])
                  ]
                ), 
                const SizedBox(height: 15), 
                ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: _locais.isNotEmpty ? _locaisLidos / _locais.length : 0, minHeight: 8, backgroundColor: isDark ? Colors.white10 : Colors.grey[300], color: Colors.deepOrange)), 
                const SizedBox(height: 20), 
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton.icon(
                    onPressed: _jogoConcluido ? null : _abrirScannerRadar, 
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white), 
                    label: Text(_jogoConcluido ? "RADAR DESATIVADO" : "ATIVAR LENTE DO RADAR", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)), 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, disabledBackgroundColor: Colors.grey[800], padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
                  )
                )
              ]
            )
          )
        ),
      ],
    );
  }
}

// ==========================================
// JOGO 2: BINGO DO PATRIMÓNIO
// ==========================================
class BingoPatrimonio extends StatefulWidget {
  const BingoPatrimonio({super.key});

  @override
  State<BingoPatrimonio> createState() => _BingoPatrimonioState();
}

class _BingoPatrimonioState extends State<BingoPatrimonio> {
  late Timer _timer;
  
  // ✨ CRONÓMETRO PROGRESSIVO (COMEÇA NO 0) ✨
  int _tempoJogado = 0; 
  
  int _itemSelecionadoIndex = -1; 
  int _quadradosConcluidos = 1; 
  int _xpAcumulado = 0;
  bool _primeiraLinhaFeita = false;

  final List<List<int>> _linhasDeBingo = [
    [0, 1, 2, 3, 4], [5, 6, 7, 8, 9], [10, 11, 12, 13, 14], [15, 16, 17, 18, 19], [20, 21, 22, 23, 24],
    [0, 5, 10, 15, 20], [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], [3, 8, 13, 18, 23], [4, 9, 14, 19, 24],
    [0, 6, 12, 18, 24], [4, 8, 12, 16, 20]
  ];

  final List<Map<String, dynamic>> _bingoGrid = [
    {'id': 'A1', 'nome': 'Metro do Porto', 'isCompleted': false, 'shortDesc': 'Rede de transporte icónica.', 'longDesc': 'O Metro do Porto foi inaugurado em 2002. A sua rede abrange 6 concelhos e é conhecida pelo design moderno das estações desenhadas por Souto de Moura.', 'coords': null},
    {'id': 'B1', 'nome': 'Sé do Porto', 'isCompleted': false, 'shortDesc': 'Coração histórico.', 'longDesc': 'A Catedral da Sé do Porto é o edifício religioso mais importante da cidade, com raízes no século XII e estilo românico.', 'coords': const LatLng(41.1428, -8.6111)},
    {'id': 'C1', 'nome': 'HardRock Café', 'isCompleted': false, 'shortDesc': 'Cultura Pop.', 'longDesc': 'Instalado num edifício do século XIX, junta a energia da música com a arquitetura clássica portuense.', 'coords': const LatLng(41.1466, -8.6114)},
    {'id': 'D1', 'nome': 'Praça dos Leões', 'isCompleted': false, 'shortDesc': 'Ponto de encontro universitário.', 'longDesc': 'Oficialmente Praça de Gomes Teixeira, é rodeada por edifícios históricos como a Reitoria da Universidade do Porto e a Igreja do Carmo.', 'coords': const LatLng(41.1470, -8.6148)},
    {'id': 'E1', 'nome': 'Teatro Nac. S. João', 'isCompleted': false, 'shortDesc': 'Centro cultural.', 'longDesc': 'Inaugurado em 1920, este magnífico teatro foi projetado por Marques da Silva, após o incêndio do teatro original.', 'coords': const LatLng(41.1444, -8.6074)},
    {'id': 'A2', 'nome': 'Ponte D. Luís I', 'isCompleted': false, 'shortDesc': 'O grande marco de ferro.', 'longDesc': 'Projetada por Théophile Seyrig, discípulo de Gustave Eiffel, liga o Porto a Gaia desde 1886.', 'coords': const LatLng(41.1401, -8.6094)},
    {'id': 'B2', 'nome': 'FC Porto', 'isCompleted': false, 'shortDesc': 'Símbolo desportivo.', 'longDesc': 'Procura um símbolo do Futebol Clube do Porto, instituição bicampeã europeia e orgulho da cidade.', 'coords': null},
    {'id': 'C2', 'nome': 'Teleférico de Gaia', 'isCompleted': false, 'shortDesc': 'A melhor vista sobre o Douro.', 'longDesc': 'Liga o tabuleiro superior da Ponte D. Luís I ao Cais de Gaia, oferecendo uma vista panorâmica incrível.', 'coords': const LatLng(41.1378, -8.6096)},
    {'id': 'D2', 'nome': 'McDonalds Imperial', 'isCompleted': false, 'shortDesc': 'O restaurante mais belo.', 'longDesc': 'Considerado um dos McDonald\'s mais bonitos do mundo, mantém a fachada e o interior Arte Déco do antigo Café Imperial (1936).', 'coords': const LatLng(41.1463, -8.6112)},
    {'id': 'E2', 'nome': 'Comboio', 'isCompleted': false, 'shortDesc': 'Fotografa um comboio.', 'longDesc': 'Estações como São Bento ou Campanhã são fulcrais. Fotografa um comboio urbano, regional ou alfa pendular!', 'coords': null},
    {'id': 'A3', 'nome': 'Lata de Sardinha', 'isCompleted': false, 'shortDesc': 'Sabor a mar.', 'longDesc': 'A indústria conserveira portuguesa é famosa mundialmente. Procura uma lata de sardinhas decorativa.', 'coords': null},
    {'id': 'B3', 'nome': 'Lenço de Viana', 'isCompleted': false, 'shortDesc': 'Tradição do Minho.', 'longDesc': 'Embora típicos de Viana do Castelo, estes lenços coloridos dos namorados são um símbolo nacional presente em várias lojas tradicionais do Porto.', 'coords': null},
    {'id': 'TOB', 'nome': 'Play2Travel (TOB)', 'isCompleted': true, 'shortDesc': 'Tourism On Board', 'longDesc': 'A Play2Travel é uma startup inovadora que junta o turismo tradicional ao poder da gamificação. A nossa missão é fazer de cada viagem um jogo inesquecível! Começa a tua jornada aqui.', 'coords': null},
    {'id': 'D3', 'nome': 'Caves do Vinho do Porto', 'isCompleted': false, 'shortDesc': 'Onde o néctar envelhece.', 'longDesc': 'Apanha o barco ou cruza a ponte até Gaia para fotografar a entrada das lendárias caves onde o Vinho do Porto repousa.', 'coords': const LatLng(41.1368, -8.6146)},
    {'id': 'E3', 'nome': 'Coração de Filigrana', 'isCompleted': false, 'shortDesc': 'A arte do ouro.', 'longDesc': 'A filigrana é uma técnica ancestral de ourivesaria. O Coração de Viana é a sua peça mais icónica.', 'coords': null},
    {'id': 'A4', 'nome': 'Livraria Lello', 'isCompleted': false, 'shortDesc': 'Magia literária.', 'longDesc': 'Conhecida por ter inspirado o universo de Harry Potter, a sua escadaria carmim é uma das mais belas do mundo.', 'coords': const LatLng(41.1469, -8.6148)},
    {'id': 'B4', 'nome': 'Azulejo', 'isCompleted': false, 'shortDesc': 'Arte na parede.', 'longDesc': 'Fotografa um padrão de azulejos na rua. Eles contam histórias, regulam a temperatura e dão cor às ruas do Porto.', 'coords': null},
    {'id': 'C4', 'nome': 'Torre dos Clérigos', 'isCompleted': false, 'shortDesc': 'O ponto mais alto.', 'longDesc': 'Com 75 metros de altura e desenhada por Nicolau Nasoni, é a grande referência no skyline do Porto.', 'coords': const LatLng(41.1458, -8.6139)},
    {'id': 'D4', 'nome': 'Francesinha', 'isCompleted': false, 'shortDesc': 'Iguaria divina.', 'longDesc': 'Criada na década de 50 por um emigrante regressado de França. Um prato épico cheio de carnes, queijo derretido e um molho secreto.', 'coords': null},
    {'id': 'E4', 'nome': 'Barco Rabelo', 'isCompleted': false, 'shortDesc': 'Os transportadores do vinho.', 'longDesc': 'Estas embarcações típicas do rio Douro eram usadas para transportar os barris de Vinho do Porto do Alto Douro até Gaia.', 'coords': const LatLng(41.1404, -8.6128)},
    {'id': 'A5', 'nome': 'Café Majestic', 'isCompleted': false, 'shortDesc': 'Glamour da Belle Époque.', 'longDesc': 'Fundado em 1921, era o ponto de encontro da elite cultural do Porto. A sua fachada e interior são absolutamente deslumbrantes.', 'coords': const LatLng(41.1472, -8.6065)},
    {'id': 'B5', 'nome': 'Pastel de Nata', 'isCompleted': false, 'shortDesc': 'O doce português.', 'longDesc': 'Embora originário de Belém, é adorado em todo o país. Encontra um e, de preferência, come-o a seguir!', 'coords': null},
    {'id': 'C5', 'nome': 'Mercado do Bolhão', 'isCompleted': false, 'shortDesc': 'A alma da cidade.', 'longDesc': 'Recentemente restaurado, é o local perfeito para sentir a verdadeira essência portuense, entre flores, pão e peixe.', 'coords': const LatLng(41.1487, -8.6074)},
    {'id': 'D5', 'nome': 'Super Bock', 'isCompleted': false, 'shortDesc': 'A cerveja do Norte.', 'longDesc': 'Lançada em 1927, é a marca de cerveja mais icónica da região e companheira inseparável da Francesinha.', 'coords': null},
    {'id': 'E5', 'nome': 'Vinho do Porto', 'isCompleted': false, 'shortDesc': 'O Ouro Líquido.', 'longDesc': 'Fotografa um cálice de Vinho do Porto, seja ele Tawny, Ruby, Branco ou Rosé.', 'coords': null},
  ];

  @override
  void initState() { 
    super.initState(); 
    _iniciarCronometro(); 
    _itemSelecionadoIndex = 0; 
  }

  void _iniciarCronometro() { 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      setState(() => _tempoJogado++); 
    }); 
  }

  @override
  void dispose() { 
    _timer.cancel(); 
    super.dispose(); 
  }

  String _formatarTempo(int segundosTotal) {
    int minutos = segundosTotal ~/ 60; int segundos = segundosTotal % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  void _validarQuadrado(String tipoValidacao) {
    String msgProgresso = tipoValidacao == 'FOTO' ? "A abrir a câmara... 📸" : "A verificar sinal de GPS... 📍";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msgProgresso), duration: const Duration(seconds: 1)));
    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _bingoGrid[_itemSelecionadoIndex]['isCompleted'] = true; _quadradosConcluidos++; _xpAcumulado += 10; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tipoValidacao == 'FOTO' ? "Sucesso! Foto enviada para a Galeria Privada no teu Perfil! ✅ (+10 XP)" : "Localização Confirmada! Ponto validado com sucesso! ✅ (+10 XP)"), backgroundColor: Colors.green));
      if (!_primeiraLinhaFeita) _verificarPrimeiraLinha();
      if (_quadradosConcluidos == 25) { _timer.cancel(); Future.delayed(const Duration(seconds: 1), () => _mostrarTelaDeVitoriaBingo()); }
    });
  }

  void _verificarPrimeiraLinha() {
    for (var linha in _linhasDeBingo) {
      bool linhaCompleta = true;
      for (var index in linha) { if (!_bingoGrid[index]['isCompleted']) { linhaCompleta = false; break; } }
      if (linhaCompleta) {
        setState(() { _primeiraLinhaFeita = true; _xpAcumulado += 100; });
        showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: const Color(0xFF1E1E1E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.amber, width: 2)), title: const Column(children: [Icon(Icons.check_circle_outline, color: Colors.amber, size: 50), SizedBox(height: 10), Text("LINHA CONCLUÍDA!", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2))]), content: const Text("Fizeste a tua primeira linha no Bingo do Património! Continua para o prémio final.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)), actionsAlignment: MainAxisAlignment.center, actions: [ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), child: const Text("+100 XP RECOLHIDO", style: TextStyle(fontWeight: FontWeight.bold)))]));
        break; 
      }
    }
  }

  void _mostrarTelaDeVitoriaBingo() {
    int xpFinal = _xpAcumulado + 500;
    showGeneralDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.9), barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.grid_on, color: Colors.blueAccent, size: 100), const SizedBox(height: 20), const Text("BINGO COMPLETO!", style: TextStyle(color: Colors.blueAccent, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3)), const SizedBox(height: 40), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueAccent.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA MISSÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP Base Acumulado:", style: TextStyle(color: Colors.white)), Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Bónus Cartão Cheio:", style: TextStyle(color: Colors.white)), Text("+500 XP", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpFinal XP", style: const TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold))])])), const SizedBox(height: 50), ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))]))),
        );
      },
    );
  }

  void _lerMaisHistorico(Map<String, dynamic> item) { showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1E1E1E), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (context) => Padding(padding: const EdgeInsets.all(25), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['nome'], style: const TextStyle(color: Colors.deepOrange, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 15), Text(item['longDesc'], style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)), const SizedBox(height: 30), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.white10), child: const Text("Fechar", style: TextStyle(color: Colors.white))))]))); }

  @override
  Widget build(BuildContext context) {
    final itemSelecionado = _itemSelecionadoIndex != -1 ? _bingoGrid[_itemSelecionadoIndex] : null;
    return Container(
      color: const Color(0xFF0F1218), 
      child: Column(
        children: [
          Container(margin: const EdgeInsets.fromLTRB(20, 10, 20, 10), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.deepOrange.withOpacity(0.5))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Icon(Icons.timer, color: Colors.deepOrange), const SizedBox(width: 10), Text(_formatarTempo(_tempoJogado), style: const TextStyle(color: Colors.deepOrange, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, fontFamily: 'monospace'))]), Text("$_xpAcumulado XP", style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold))])),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: AspectRatio(aspectRatio: 1, child: GridView.builder(physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 2, mainAxisSpacing: 2), itemCount: 25, itemBuilder: (context, index) { 
            final item = _bingoGrid[index]; 
            bool isSelected = _itemSelecionadoIndex == index; 
            bool isTOB = item['id'] == 'TOB'; 
            
            return GestureDetector(
              onTap: () => setState(() => _itemSelecionadoIndex = index), 
              child: Container(
                decoration: BoxDecoration(color: isSelected && !item['isCompleted'] ? Colors.deepOrange : (item['isCompleted'] && !isTOB ? Colors.deepOrange.withOpacity(0.3) : const Color(0xFF1A1D24)), border: Border.all(color: isSelected ? Colors.white : (isTOB ? Colors.deepOrange : Colors.white10), width: isSelected ? 2 : 1)), 
                child: Center(
                  child: isTOB 
                    ? Padding(padding: const EdgeInsets.all(4.0), child: Image.asset('assets/logo.png', errorBuilder: (context, error, stackTrace) => const Icon(Icons.travel_explore, color: Colors.deepOrange)))
                    : (item['isCompleted'] && !isSelected ? const Icon(Icons.check, color: Colors.deepOrange, size: 20) : Text(item['id'], style: TextStyle(color: isSelected ? Colors.black : Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)))
                )
              )
            ); 
          }))),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Color(0xFF14171E), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: itemSelecionado == null 
                ? const Center(child: Text("Seleciona um quadrado.", style: TextStyle(color: Colors.white54)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (itemSelecionado['coords'] != null) ...[Container(height: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)), child: ClipRRect(borderRadius: BorderRadius.circular(15), child: FlutterMap(options: MapOptions(initialCenter: itemSelecionado['coords'], initialZoom: 16.0, interactionOptions: const InteractionOptions(flags: InteractiveFlag.none)), children: [TileLayer(urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c', 'd']), MarkerLayer(markers: [Marker(point: itemSelecionado['coords'], width: 40, height: 40, child: const Icon(Icons.location_on, color: Colors.blueAccent, size: 40))])]))), const SizedBox(height: 15)],
                        Row(children: [const Icon(Icons.location_on, color: Colors.deepOrange, size: 16), const SizedBox(width: 5), Text("LOCAL A ENCONTRAR", style: TextStyle(color: Colors.deepOrange.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))]), const SizedBox(height: 5), Text(itemSelecionado['nome'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const Divider(color: Colors.white10, height: 20), Text(itemSelecionado['shortDesc'], style: const TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(height: 10), GestureDetector(onTap: () => _lerMaisHistorico(itemSelecionado), child: const Text("Ler mais >", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13))), const SizedBox(height: 25),
                        if (!itemSelecionado['isCompleted'])
                          Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => _validarQuadrado('FOTO'), icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18), label: const Text("FOTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))), const SizedBox(width: 15), Expanded(child: ElevatedButton.icon(onPressed: () => _validarQuadrado('GPS'), icon: const Icon(Icons.gps_fixed, color: Colors.white, size: 18), label: const Text("GPS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))])
                        else
                          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.check, color: Colors.white), label: const Text("LOCAL VALIDADO ✅", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.green.withOpacity(0.3), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))
                      ],
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// JOGO 3: CÂMARA DE ÉPOCA 
// ==========================================
class CamaraDeEpoca extends StatefulWidget {
  const CamaraDeEpoca({super.key});

  @override
  State<CamaraDeEpoca> createState() => _CamaraDeEpocaState();
}

class _CamaraDeEpocaState extends State<CamaraDeEpoca> {
  int _xpAcumulado = 0;
  int _fotosValidadas = 0;

  final List<Map<String, dynamic>> _locaisEpoca = [
    {'nome': 'Ponte Pênsil', 'img': 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=600&q=80', 'isCompleted': false},
    {'nome': 'Ribeira', 'img': 'https://images.unsplash.com/photo-1585255318859-f5c15f4cffe9?w=600&q=80', 'isCompleted': false},
    {'nome': 'Praça dos Leões', 'img': 'https://images.unsplash.com/photo-1596711585261-2a1e1cc714a5?w=600&q=80', 'isCompleted': false},
    {'nome': 'Avenida dos Aliados', 'img': 'https://images.unsplash.com/photo-1596645367129-2ec828ed1635?w=600&q=80', 'isCompleted': false},
    {'nome': 'Estação de S. Bento', 'img': 'https://images.unsplash.com/photo-1620311497232-613d9865f3bc?w=600&q=80', 'isCompleted': false},
    {'nome': 'Estação de Campanhã', 'img': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=600&q=80', 'isCompleted': false},
    {'nome': 'Praça Almeida Garrett', 'img': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=600&q=80', 'isCompleted': false},
    {'nome': 'Câmara M. do Porto', 'img': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=600&q=80', 'isCompleted': false},
    {'nome': 'Praça do Infante', 'img': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=600&q=80', 'isCompleted': false},
    {'nome': 'Torre dos Clérigos', 'img': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=600&q=80', 'isCompleted': false},
    {'nome': 'Alfândega do Porto', 'img': 'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?w=600&q=80', 'isCompleted': false},
    {'nome': 'Sé do Porto', 'img': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=600&q=80', 'isCompleted': false},
  ];

  void _abrirModoAlinhamento(int index) {
    final local = _locaisEpoca[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0.3, child: Image.network(local['img'], fit: BoxFit.cover, height: double.infinity, width: double.infinity)),
              Container(width: 300, height: 450, decoration: BoxDecoration(border: Border.all(color: Colors.amber.withOpacity(0.8), width: 3), borderRadius: BorderRadius.circular(10)), child: ColorFiltered(colorFilter: const ColorFilter.matrix([0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0,0,0,0.5,0]), child: Image.network(local['img'], fit: BoxFit.cover))),
              const Positioned(top: 80, child: Text("ALINHE A FOTO COM A REALIDADE", style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2))),
              Positioned(top: 110, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)), child: Text(local['nome'], style: const TextStyle(color: Colors.white)))),
              Positioned(bottom: 50, child: GestureDetector(onTap: () { Navigator.pop(context); _validarFotografia(index); }, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), color: Colors.white24), child: Center(child: Container(width: 60, height: 60, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))))),
              Positioned(top: 40, left: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)))
            ],
          ),
        ),
      ),
    );
  }

  void _validarFotografia(int index) {
    setState(() { _locaisEpoca[index]['isCompleted'] = true; _fotosValidadas++; _xpAcumulado += 20; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("📸 Foto de ${_locaisEpoca[index]['nome']} guardada na Galeria Privada! (+20 XP)"), backgroundColor: Colors.green, duration: const Duration(seconds: 3)));
    if (_fotosValidadas == _locaisEpoca.length) Future.delayed(const Duration(seconds: 1), () => _mostrarTelaVitoriaFotos());
  }

  void _mostrarTelaVitoriaFotos() {
    int xpTotal = _xpAcumulado + 500;
    showGeneralDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.9), barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(backgroundColor: Colors.transparent, body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.camera_roll, color: Colors.tealAccent, size: 100), const SizedBox(height: 20), const Text("ÁLBUM COMPLETO!", style: TextStyle(color: Colors.tealAccent, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3)), const SizedBox(height: 40), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.tealAccent.withOpacity(0.5))), child: Column(children: [const Text("RESUMO DA MISSÃO", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP Fotografias:", style: TextStyle(color: Colors.white)), Text("+$_xpAcumulado XP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 10), const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Bónus Álbum Cheio:", style: TextStyle(color: Colors.white)), Text("+500 XP", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))]), const Divider(color: Colors.white24, height: 30), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("XP TOTAL GANHO:", style: TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold)), Text("$xpTotal XP", style: const TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold))])])), const SizedBox(height: 50), ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("VOLTAR AO MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))]))));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(20, 30, 20, 20), decoration: BoxDecoration(color: Colors.black87, border: Border(bottom: BorderSide(color: Colors.tealAccent.withOpacity(0.3), width: 2))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("ÁLBUM DE ÉPOCA", style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 5), Text("$_fotosValidadas / ${_locaisEpoca.length} FOTOS", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))]), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text("XP TOTAL", style: TextStyle(color: Colors.white54, fontSize: 12)), Text("+$_xpAcumulado", style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold))])])),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8),
              itemCount: _locaisEpoca.length,
              itemBuilder: (context, index) {
                final local = _locaisEpoca[index]; bool done = local['isCompleted'];
                return GestureDetector(
                  onTap: () => done ? null : _abrirModoAlinhamento(index),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: done ? Colors.tealAccent : Colors.white24, width: done ? 2 : 1), boxShadow: done ? [BoxShadow(color: Colors.tealAccent.withOpacity(0.2), blurRadius: 10)] : []),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(15), child: done ? Image.network(local['img'], fit: BoxFit.cover) : ColorFiltered(colorFilter: const ColorFilter.matrix([0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0,0,0,1,0]), child: Image.network(local['img'], fit: BoxFit.cover))),
                        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.9), Colors.transparent]))),
                        if (!done) const Center(child: Icon(Icons.lock_outline, color: Colors.white54, size: 40)),
                        if (done) const Positioned(top: 10, right: 10, child: Icon(Icons.check_circle, color: Colors.tealAccent, size: 24)),
                        Positioned(bottom: 15, left: 10, right: 10, child: Text(local['nome'], textAlign: TextAlign.center, style: TextStyle(color: done ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)))
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}