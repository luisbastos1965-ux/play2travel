import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:local_auth/local_auth.dart'; 
import 'package:flutter/services.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // ✨ IMPORT MÁGICO DA MEMÓRIA
import '../app_settings.dart';
import 'school_dashboard_screen.dart';
import 'home_screen.dart';
import 'tutorial_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSchoolMode = false;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _registoNomeController = TextEditingController();
  final TextEditingController _registoNicknameController = TextEditingController();
  final TextEditingController _registoPasswordController = TextEditingController();
  final TextEditingController _registoEmailController = TextEditingController();
  final TextEditingController _outraCidadeController = TextEditingController();

  final Map<String, String> _contasGlobais = {
    'Juri1': 'turismo', 'Juri2': 'turismo', 'Juri3': 'turismo', 'Juri4': 'turismo', 'Juri5': 'turismo', 'Juri6': 'turismo', 'Juri7': 'turismo', 'Juri8': 'turismo', 'Lourenço_Aluai': 'turismo', 'Nadia_Magalhaes': 'turismo', 'Maria_Americano': 'turismo', 'Paula_Pereira': 'turismo', 'Barbara_Monteiro': 'turismo', 'Admin': 'turismo',
  };

  final List<String> _paisesDoMundo = ["🇦🇫 Afeganistão", "🇿🇦 África do Sul", "🇦🇱 Albânia", "🇩🇪 Alemanha", "🇦🇩 Andorra", "🇦🇴 Angola", "🇦🇷 Argentina", "🇦🇺 Austrália", "🇦🇹 Áustria", "🇧🇪 Bélgica", "🇧🇷 Brasil", "🇨🇻 Cabo Verde", "🇨🇦 Canadá", "🇨🇳 China", "🇨🇴 Colômbia", "🇭🇷 Croácia", "🇩🇰 Dinamarca", "🇪🇬 Egito", "🇦🇪 Emirados Árabes Unidos", "🇪🇸 Espanha", "🇺🇸 Estados Unidos", "🇫🇮 Finlândia", "🇫🇷 França", "🇬🇷 Grécia", "🇮🇳 Índia", "🇮🇪 Irlanda", "🇮🇹 Itália", "🇯🇵 Japão", "🇱🇺 Luxemburgo", "🇲🇦 Marrocos", "🇲🇽 México", "🇲🇿 Moçambique", "🇳🇴 Noruega", "🇳🇱 Países Baixos", "🇵🇱 Polónia", "🇵🇹 Portugal", "🇬🇧 Reino Unido", "🇷🇺 Rússia", "🇸🇹 São Tomé e Príncipe", "🇸🇪 Suécia", "🇨🇭 Suíça", "🇹🇷 Turquia", "🇺🇦 Ucrânia", "🇻🇪 Venezuela"];
  final List<String> _listaEscolas = ["Escola Profissional Profitecla Porto (Sede)", "Colégio de Ermesinde", "Colégio Luso-Francês", "Colégio N. Sra. do Rosário", "Escola Básica 2/3 de Paranhos", "Escola Básica e Secundária Clara de Resende", "Escola Secundária Alexandre Herculano", "Escola Secundária António Nobre", "Escola Secundária Carolina Michaëlis", "Escola Secundária de Rio Tinto", "Escola Secundária Infante D. Henrique", "Instituto Politécnico do Porto (IPP)", "ISCTE - Instituto Universitário", "Universidade Católica Portuguesa", "Universidade de Aveiro", "Universidade de Coimbra", "Universidade de Lisboa", "Universidade do Minho", "Universidade do Porto", "Outra Instituição"];

  // ✨ FUNÇÃO INTELIGENTE QUE DECIDE SE VAI PARA A HOME OU PARA O TUTORIAL ✨
  Future<void> _navegarAposLoginTurista(String username, String cargo) async {
    final prefs = await SharedPreferences.getInstance();
    bool tutorialVisto = prefs.getBool('tutorial_visto') ?? false;

    if (!mounted) return;

    if (tutorialVisto) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(username: username, cargo: cargo)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppTutorialScreen(username: username, cargo: cargo)));
    }
  }

  void _login() async {
    HapticFeedback.selectionClick();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppSettings.instance.t('empty_fields')), backgroundColor: Colors.redAccent));
      return;
    }

    if (_contasGlobais.containsKey(username) && _contasGlobais[username] == password) {
      HapticFeedback.lightImpact();
      if (_isSchoolMode) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SchoolDashboardScreen()));
      } else {
        await _navegarAposLoginTurista(username, "Turista"); // Usa a função inteligente
      }
      return; 
    } 

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
      HapticFeedback.lightImpact();
      if (_isSchoolMode) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SchoolDashboardScreen()));
      } else {
        await _navegarAposLoginTurista(username, "Turista"); // Usa a função inteligente
      }
    } on FirebaseAuthException {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppSettings.instance.t('wrong_credentials')), backgroundColor: Colors.redAccent));
    }
  }

  Future<void> _loginBiometricoAdmin() async {
    HapticFeedback.selectionClick();
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool podeAutenticar = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (podeAutenticar) {
        final bool autenticado = await auth.authenticate(localizedReason: 'Usa a tua impressão digital para entrar como Admin');
        if (autenticado) {
          if (!mounted) return;
          HapticFeedback.lightImpact();
          await _navegarAposLoginTurista("Admin", "Admin"); // Usa a função inteligente
        }
      } else {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Telemóvel sem biometria ativa."), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.redAccent));
    }
  }

  bool _isEnsinoSuperior(String? escola) {
    if (escola == null) return false;
    String nomeMinusculo = escola.toLowerCase();
    return nomeMinusculo.contains("universidade") || nomeMinusculo.contains("instituto") || nomeMinusculo.contains("iscte");
  }

  List<String> _obterCidadesPorPais(String pais) {
    if (pais.contains("Portugal")) return ["Abrantes", "Almada", "Amadora", "Aveiro", "Barcelos", "Beja", "Braga", "Bragança", "Castelo Branco", "Chaves", "Coimbra", "Évora", "Faro", "Figueira da Foz", "Funchal", "Guarda", "Guimarães", "Leiria", "Lisboa", "Maia", "Matosinhos", "Ponta Delgada", "Portalegre", "Portimão", "Porto", "Santarém", "Setúbal", "Viana do Castelo", "Vila Nova de Gaia", "Vila Real", "Viseu", AppSettings.instance.t('other_city')];
    if (pais.contains("Brasil")) return ["São Paulo", "Rio de Janeiro", "Brasília", "Salvador", "Fortaleza", "Curitiba", "Belo Horizonte", AppSettings.instance.t('other_city')];
    if (pais.contains("Espanha")) return ["Madrid", "Barcelona", "Valência", "Sevilha", "Bilbau", "Málaga", AppSettings.instance.t('other_city')];
    if (pais.contains("França")) return ["Paris", "Marselha", "Lyon", "Toulouse", "Nice", "Bordéus", AppSettings.instance.t('other_city')];
    if (pais.contains("Itália")) return ["Roma", "Milão", "Nápoles", "Turim", "Florença", "Veneza", AppSettings.instance.t('other_city')];
    if (pais.contains("Alemanha")) return ["Berlim", "Munique", "Frankfurt", "Hamburgo", "Colónia", AppSettings.instance.t('other_city')];
    if (pais.contains("Reino Unido")) return ["Londres", "Manchester", "Birmingham", "Edimburgo", "Glasgow", "Liverpool", AppSettings.instance.t('other_city')];
    if (pais.contains("Estados Unidos")) return ["Nova Iorque", "Los Angeles", "Chicago", "Miami", "São Francisco", "Washington D.C.", AppSettings.instance.t('other_city')];
    return ["Capital", "Secundária", AppSettings.instance.t('other_city')];
  }

  void _showLanguageDialog(Color textColor, Color bgColor) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Language / Idioma", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ListTile(title: Text('🇬🇧 English', style: TextStyle(color: textColor), textAlign: TextAlign.center), onTap: () { HapticFeedback.selectionClick(); AppSettings.instance.changeLanguage('en'); Navigator.pop(context); }),
              ListTile(title: Text('🇵🇹 Português', style: TextStyle(color: textColor), textAlign: TextAlign.center), onTap: () { HapticFeedback.selectionClick(); AppSettings.instance.changeLanguage('pt'); Navigator.pop(context); }),
              ListTile(title: Text('🇪🇸 Español', style: TextStyle(color: textColor), textAlign: TextAlign.center), onTap: () { HapticFeedback.selectionClick(); AppSettings.instance.changeLanguage('es'); Navigator.pop(context); }),
              ListTile(title: Text('🇫🇷 Français', style: TextStyle(color: textColor), textAlign: TextAlign.center), onTap: () { HapticFeedback.selectionClick(); AppSettings.instance.changeLanguage('fr'); Navigator.pop(context); }),
            ],
          ),
        );
      }
    );
  }

  void _showRecoveryBottomSheet() {
    HapticFeedback.lightImpact();
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(AppSettings.instance.t('recover_title'), style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)), IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context))]),
            const SizedBox(height: 10), Text(AppSettings.instance.t('recover_desc'), style: TextStyle(color: textColor.withOpacity(0.7))), const SizedBox(height: 25),
            TextField(style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('email'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.email, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            const SizedBox(height: 25),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { HapticFeedback.selectionClick(); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text(AppSettings.instance.t('send_code'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))), const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showRegisterBottomSheet() {
    HapticFeedback.lightImpact();
    bool isRegistoEscola = _isSchoolMode;
    String? paisSelecionado, cidadeSelecionada, generoSelecionado, escolaSelecionada, cargoEscolaSelecionado;
    int? idadeSelecionada;

    _registoNomeController.clear(); _registoNicknameController.clear(); 
    _registoPasswordController.clear(); _registoEmailController.clear(); _outraCidadeController.clear();

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color boxColor = isDark ? Colors.white10 : Colors.grey[200]!;

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          bool isSuperior = _isEnsinoSuperior(escolaSelecionada);

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(AppSettings.instance.t('create_account'), style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)), IconButton(icon: Icon(Icons.close, color: textColor.withOpacity(0.5)), onPressed: () => Navigator.pop(context))]),
                  const SizedBox(height: 15),
                  Container(
                    height: 50, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)),
                    child: Stack(children: [
                      AnimatedAlign(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: isRegistoEscola ? Alignment.centerRight : Alignment.centerLeft, child: FractionallySizedBox(widthFactor: 0.5, heightFactor: 1.0, child: Container(decoration: BoxDecoration(color: isRegistoEscola ? Colors.blueAccent : Colors.deepOrange, borderRadius: BorderRadius.circular(15))))),
                      Row(children: [
                        Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { HapticFeedback.selectionClick(); setModalState(() => isRegistoEscola = false); }, child: Center(child: Text(AppSettings.instance.t('tourist'), style: TextStyle(color: isRegistoEscola ? textColor.withOpacity(0.5) : Colors.white, fontWeight: FontWeight.bold))))),
                        Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { HapticFeedback.selectionClick(); setModalState(() => isRegistoEscola = true); }, child: Center(child: Text(AppSettings.instance.t('school'), style: TextStyle(color: !isRegistoEscola ? textColor.withOpacity(0.5) : Colors.white, fontWeight: FontWeight.bold))))),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(controller: _registoNomeController, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('full_name'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.person, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                  const SizedBox(height: 15),
                  TextField(controller: _registoNicknameController, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('username'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.alternate_email, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                  const SizedBox(height: 15),
                  
                  Row(children: [
                    Expanded(child: _buildDynamicPicker(hint: AppSettings.instance.t('country'), icon: Icons.public, value: paisSelecionado, textColor: textColor, boxColor: boxColor, onTap: () async { HapticFeedback.lightImpact(); final pais = await _mostrarSeletorListagem(context, AppSettings.instance.t('country'), _paisesDoMundo, bgColor, textColor); if (pais != null) setModalState(() { paisSelecionado = pais; cidadeSelecionada = null; }); })),
                    const SizedBox(width: 15),
                    Expanded(child: _buildDynamicPicker(hint: AppSettings.instance.t('city'), icon: Icons.location_on, value: cidadeSelecionada, textColor: textColor, boxColor: boxColor, onTap: () async { if (paisSelecionado == null) return; HapticFeedback.lightImpact(); List<String> cidades = _obterCidadesPorPais(paisSelecionado!); final cid = await _mostrarSeletorListagem(context, AppSettings.instance.t('city'), cidades, bgColor, textColor); if (cid != null) setModalState(() => cidadeSelecionada = cid); })),
                  ]),
                  const SizedBox(height: 15),

                  if (cidadeSelecionada == AppSettings.instance.t('other_city')) ...[
                    TextField(controller: _outraCidadeController, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('write_city'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.edit_location, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                    const SizedBox(height: 15),
                  ],
                  
                  Row(children: [
                    Expanded(child: _buildDynamicPicker(hint: AppSettings.instance.t('age'), icon: Icons.calendar_month, value: idadeSelecionada != null ? "$idadeSelecionada ${AppSettings.instance.t('years')}" : null, textColor: textColor, boxColor: boxColor, onTap: () async { HapticFeedback.lightImpact(); final idade = await _mostrarSeletorIdade(context, idadeSelecionada ?? 18, bgColor, textColor); if (idade != null) setModalState(() => idadeSelecionada = idade); })),
                    const SizedBox(width: 15),
                    Expanded(child: _buildDynamicPicker(hint: AppSettings.instance.t('gender'), icon: Icons.groups, value: generoSelecionado, textColor: textColor, boxColor: boxColor, onTap: () async { HapticFeedback.lightImpact(); final genero = await _mostrarSeletorGenero(context, bgColor, textColor); if (genero != null) setModalState(() => generoSelecionado = genero); })),
                  ]),
                  const SizedBox(height: 15),
                  
                  if (isRegistoEscola) ...[
                    _buildDynamicPicker(hint: AppSettings.instance.t('institution'), icon: Icons.school, value: escolaSelecionada, textColor: textColor, boxColor: boxColor, onTap: () async { HapticFeedback.lightImpact(); final escola = await _mostrarSeletorListagem(context, AppSettings.instance.t('institution'), _listaEscolas, bgColor, textColor); if (escola != null) { setModalState(() { escolaSelecionada = escola; if (_isEnsinoSuperior(escola) && cargoEscolaSelecionado == AppSettings.instance.t('guardian')) cargoEscolaSelecionado = null; }); } }),
                    const SizedBox(height: 15),
                    Text(AppSettings.instance.t('what_role'), style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13)),
                    const SizedBox(height: 10),
                    Row(children: [
                      _buildCargoButton(AppSettings.instance.t('student'), Icons.backpack, cargoEscolaSelecionado == AppSettings.instance.t('student'), true, textColor, boxColor, () { HapticFeedback.selectionClick(); setModalState(() => cargoEscolaSelecionado = AppSettings.instance.t('student')); }), const SizedBox(width: 10),
                      _buildCargoButton(AppSettings.instance.t('teacher'), Icons.history_edu, cargoEscolaSelecionado == AppSettings.instance.t('teacher'), true, textColor, boxColor, () { HapticFeedback.selectionClick(); setModalState(() => cargoEscolaSelecionado = AppSettings.instance.t('teacher')); }), const SizedBox(width: 10),
                      _buildCargoButton(AppSettings.instance.t('guardian'), Icons.family_restroom, cargoEscolaSelecionado == AppSettings.instance.t('guardian'), !isSuperior, textColor, boxColor, () { HapticFeedback.selectionClick(); setModalState(() => cargoEscolaSelecionado = AppSettings.instance.t('guardian')); }),
                    ]),
                    const SizedBox(height: 15),
                  ],

                  TextField(controller: _registoEmailController, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('email'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.email, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                  const SizedBox(height: 15),
                  TextField(controller: _registoPasswordController, obscureText: true, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('password'), hintStyle: TextStyle(color: textColor.withOpacity(0.5)), prefixIcon: Icon(Icons.lock, color: textColor.withOpacity(0.5)), filled: true, fillColor: boxColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                  const SizedBox(height: 25),
                  
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.selectionClick();
                        String novoUser = _registoNicknameController.text.trim();
                        String novaPass = _registoPasswordController.text.trim();
                        String novoEmail = _registoEmailController.text.trim();
                        String nomeCompleto = _registoNomeController.text.trim();

                        if (novoUser.isEmpty || novaPass.isEmpty || novoEmail.isEmpty) {
                           HapticFeedback.heavyImpact();
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preenche Email, Username e Password!"), backgroundColor: Colors.redAccent));
                           return;
                        }

                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: novoEmail, password: novaPass);
                          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                            'nome': nomeCompleto, 'username': novoUser, 'email': novoEmail, 'tipo_conta': isRegistoEscola ? 'Escola' : 'Turista', 'pais': paisSelecionado ?? 'Não definido', 'cidade': cidadeSelecionada == AppSettings.instance.t('other_city') ? _outraCidadeController.text.trim() : (cidadeSelecionada ?? 'Não definida'), 'idade': idadeSelecionada ?? 0, 'genero': generoSelecionado ?? 'Não definido', 'pontos': 0, 'escola': isRegistoEscola ? escolaSelecionada : null, 'cargo_escola': isRegistoEscola ? cargoEscolaSelecionado : null, 'data_registo': FieldValue.serverTimestamp(), 
                          });

                          _contasGlobais[novoEmail] = novaPass; 
                          HapticFeedback.lightImpact();
                          Navigator.pop(context); 
                          
                          if (isRegistoEscola) { 
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SchoolDashboardScreen())); 
                          } else { 
                            await _navegarAposLoginTurista(novoUser, "Turista"); // Usa a função inteligente
                          }
                        } on FirebaseAuthException catch (e) {
                          HapticFeedback.heavyImpact();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: ${e.message}"), backgroundColor: Colors.redAccent));
                        } catch (e) {
                          HapticFeedback.heavyImpact();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao guardar dados: $e"), backgroundColor: Colors.redAccent));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: isRegistoEscola ? Colors.blueAccent : Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      child: Text(AppSettings.instance.t('create_and_login'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicPicker({required String hint, required IconData icon, required String? value, required Color textColor, required Color boxColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)),
        child: Row(children: [Icon(icon, color: textColor.withOpacity(0.5), size: 22), const SizedBox(width: 12), Expanded(child: Text(value ?? hint, style: TextStyle(color: value == null ? textColor.withOpacity(0.5) : textColor, fontSize: 16), overflow: TextOverflow.ellipsis))]),
      ),
    );
  }

  Widget _buildCargoButton(String titulo, IconData icon, bool isSelected, bool isEnabled, Color textColor, Color boxColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? Colors.blueAccent : boxColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent)),
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.3,
            child: Column(children: [Icon(icon, color: isSelected ? Colors.white : textColor.withOpacity(0.5), size: 22), const SizedBox(height: 5), Text(titulo, style: TextStyle(color: isSelected ? Colors.white : textColor.withOpacity(0.5), fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)]),
          ),
        ),
      ),
    );
  }

  Future<String?> _mostrarSeletorListagem(BuildContext context, String titulo, List<String> opcoes, Color bgColor, Color textColor) {
    return showModalBottomSheet<String>(
      context: context, isScrollControlled: true, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(titulo, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 15), Flexible(child: ListView.builder(shrinkWrap: true, itemCount: opcoes.length, itemBuilder: (context, index) { return ListTile(title: Text(opcoes[index], style: TextStyle(color: textColor.withOpacity(0.8)), textAlign: TextAlign.center), onTap: () { HapticFeedback.selectionClick(); Navigator.pop(context, opcoes[index]); }); })), const SizedBox(height: 10)])),
      ),
    );
  }

  Future<int?> _mostrarSeletorIdade(BuildContext context, int idadeAtual, Color bgColor, Color textColor) {
    int idadeTemp = idadeAtual;
    return showModalBottomSheet<int>(
      context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setPickerState) => Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.calendar_month, color: Colors.deepOrange), const SizedBox(width: 10), Text(AppSettings.instance.t('age'), style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold))]), const SizedBox(height: 30), Text("$idadeTemp", style: const TextStyle(color: Colors.deepOrange, fontSize: 60, fontWeight: FontWeight.bold)), Slider(value: idadeTemp.toDouble(), min: 10, max: 100, activeColor: Colors.deepOrange, inactiveColor: textColor.withOpacity(0.1), onChanged: (val) { HapticFeedback.selectionClick(); setPickerState(() => idadeTemp = val.toInt()); }), const SizedBox(height: 20), ElevatedButton(onPressed: () { HapticFeedback.selectionClick(); Navigator.pop(context, idadeTemp); }, style: ElevatedButton.styleFrom(backgroundColor: textColor.withOpacity(0.1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), minimumSize: const Size(double.infinity, 50)), child: Text("OK", style: TextStyle(color: textColor)))])),
      ),
    );
  }

  Future<String?> _mostrarSeletorGenero(BuildContext context, Color bgColor, Color textColor) {
    return showModalBottomSheet<String>(
      context: context, backgroundColor: bgColor, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(padding: const EdgeInsets.all(25), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(AppSettings.instance.t('gender'), style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildBotaoGenero(context, Icons.male, "M", Colors.blue, textColor), _buildBotaoGenero(context, Icons.female, "F", Colors.pink, textColor)]), const SizedBox(height: 15), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildBotaoGenero(context, Icons.privacy_tip, "Secret", Colors.orange, textColor), _buildBotaoGenero(context, Icons.add_circle_outline, "Other", Colors.grey, textColor)])])),
    );
  }

  Widget _buildBotaoGenero(BuildContext context, IconData icon, String titulo, Color cor, Color textColor) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); Navigator.pop(context, titulo); },
      child: Container(width: 140, padding: const EdgeInsets.symmetric(vertical: 20), decoration: BoxDecoration(color: textColor.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: cor.withOpacity(0.5))), child: Column(children: [Icon(icon, color: cor, size: 40), const SizedBox(height: 10), Text(titulo, style: TextStyle(color: textColor.withOpacity(0.8)))])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, child) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;
        Color textColor = isDark ? Colors.white : Colors.black87;
        Color textMuted = isDark ? Colors.white54 : Colors.black54;
        Color boxColor = isDark ? Colors.white10 : Colors.grey[300]!;

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Image.asset('assets/logo.png', height: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.travel_explore, color: Colors.deepOrange, size: 80)),
                        const SizedBox(height: 15),
                        Text("Play2Travel", style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const SizedBox(height: 5),
                        Text(AppSettings.instance.t('login_subtitle'), style: TextStyle(color: textMuted, fontSize: 16)),
                        const SizedBox(height: 35),

                        Container(
                          height: 50, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            children: [
                              AnimatedAlign(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut, alignment: _isSchoolMode ? Alignment.centerRight : Alignment.centerLeft, child: FractionallySizedBox(widthFactor: 0.5, heightFactor: 1.0, child: Container(decoration: BoxDecoration(color: _isSchoolMode ? Colors.blueAccent : Colors.deepOrange, borderRadius: BorderRadius.circular(15))))),
                              Row(children: [
                                Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { HapticFeedback.selectionClick(); setState(() => _isSchoolMode = false); }, child: Center(child: Text(AppSettings.instance.t('tourist'), style: TextStyle(color: _isSchoolMode ? textMuted : Colors.white, fontWeight: FontWeight.bold))))),
                                Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { HapticFeedback.selectionClick(); setState(() => _isSchoolMode = true); }, child: Center(child: Text(AppSettings.instance.t('school'), style: TextStyle(color: !_isSchoolMode ? textMuted : Colors.white, fontWeight: FontWeight.bold))))),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        TextField(controller: _usernameController, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('username'), hintStyle: TextStyle(color: textMuted), prefixIcon: Icon(Icons.person, color: textMuted), filled: true, fillColor: boxColor, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide.none))),
                        const SizedBox(height: 15),
                        TextField(controller: _passwordController, obscureText: true, style: TextStyle(color: textColor), decoration: InputDecoration(hintText: AppSettings.instance.t('password'), hintStyle: TextStyle(color: textMuted), prefixIcon: Icon(Icons.lock, color: textMuted), filled: true, fillColor: boxColor, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide.none))),
                        
                        Align(alignment: Alignment.centerRight, child: TextButton(
                          onPressed: _showRecoveryBottomSheet, 
                          child: Text(AppSettings.instance.t('forgot_password'), style: TextStyle(color: _isSchoolMode ? Colors.blueAccent : Colors.deepOrange, fontSize: 13))
                        )),
                        const SizedBox(height: 10),

                        SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _login, style: ElevatedButton.styleFrom(backgroundColor: _isSchoolMode ? Colors.blueAccent : Colors.deepOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text(AppSettings.instance.t('enter'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)))),
                        const SizedBox(height: 25),

                        if (!_isSchoolMode) ...[
                          Row(children: [Expanded(child: Divider(color: textMuted, thickness: 1)), Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(AppSettings.instance.t('or_login_with'), style: TextStyle(color: textMuted, fontSize: 13))), Expanded(child: Divider(color: textMuted, thickness: 1))]),
                          const SizedBox(height: 20),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildSocialButton(Icons.mail, textColor, boxColor, 28), const SizedBox(width: 20), _buildSocialButton(Icons.facebook, Colors.blue[800]!, boxColor, 28), const SizedBox(width: 20), _buildSocialButton(Icons.phone_android, Colors.green, boxColor, 28)]),
                          const SizedBox(height: 25),
                        ],

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppSettings.instance.t('no_account'), style: TextStyle(color: textMuted)),
                            GestureDetector(
                              onTap: _showRegisterBottomSheet, 
                              child: Text(AppSettings.instance.t('register_here'), style: TextStyle(color: _isSchoolMode ? Colors.blueAccent : Colors.deepOrange, fontWeight: FontWeight.bold))
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: _loginBiometricoAdmin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey[200], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.fingerprint, color: Colors.blueAccent, size: 24),
                                SizedBox(width: 10),
                                Text("Acesso Admin (Biometria)", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 15, right: 20,
                  child: Container(
                    decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black12, borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.language), color: textColor, tooltip: 'Language', onPressed: () => _showLanguageDialog(textColor, Theme.of(context).scaffoldBackgroundColor)),
                        Container(width: 1, height: 20, color: textMuted),
                        IconButton(icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode), color: textColor, tooltip: 'Theme', onPressed: () { HapticFeedback.lightImpact(); AppSettings.instance.toggleTheme(); }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildSocialButton(IconData icon, Color iconColor, Color boxColor, double iconSize) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A ligar ao serviço..."))); },
      child: Container(height: 55, width: 55, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(15)), child: Center(child: Icon(icon, color: iconColor, size: iconSize))),
    );
  }
}