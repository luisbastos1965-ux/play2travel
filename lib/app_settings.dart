import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings instance = AppSettings._internal();
  AppSettings._internal();

  String currentLanguage = 'en';
  ThemeMode themeMode = ThemeMode.dark;

  void changeLanguage(String langCode) {
    currentLanguage = langCode;
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  String t(String key) {
    return _dicionario[currentLanguage]?[key] ?? _dicionario['en']?[key] ?? key;
  }

  final Map<String, Map<String, String>> _dicionario = {
    'en': {
      'login_subtitle': 'Explore the world by playing', 'tourist': 'Tourist', 'school': 'School',
      'username': 'Username', 'password': 'Password', 'forgot_password': 'Forgot your password?',
      'enter': 'LOGIN', 'or_login_with': 'Or login with', 'no_account': 'Don\'t have an account? ',
      'register_here': 'Register here', 'empty_fields': 'Please fill in all fields!',
      'wrong_credentials': 'Username or Password incorrect!', 'recover_title': 'Recover Password',
      'recover_desc': 'Enter your associated email. We will send you a recovery code.', 'email': 'E-mail',
      'send_code': 'SEND CODE', 'create_account': 'Create New Account', 'full_name': 'Full Name',
      'country': 'Country', 'city': 'City', 'other_city': 'Other City', 'write_city': 'Write the city name',
      'age': 'Age', 'years': 'years', 'gender': 'Gender', 'institution': 'Select Institution / Univ.',
      'what_role': 'What is your role?', 'student': 'Student', 'teacher': 'Teacher', 'guardian': 'Guardian',
      'create_and_login': 'CREATE ACCOUNT AND LOGIN',
      // --- NOVOS: SOCIAL ---
      'your_friends': 'YOUR FRIENDS', 'travel_squads': 'YOUR SQUADS',
      'search_friends': 'Search new friends...', 'search_groups': 'Search squads...',
      'friends_tab': 'Friends', 'groups_tab': 'Squads',
      'pending_requests': 'Pending Requests', 'accept': 'Accept', 'reject': 'Decline',
      'level': 'Level', 'members': 'members',
      'start_chat': 'Start a conversation with', 'type_message': 'Type a message...',
      'challenge': 'Challenge', 'choose_pack': 'Choose a Tourism Pack to play together or compete!',
      'invite': 'Invite',
    },
    'pt': {
      'login_subtitle': 'Explora o mundo a jogar', 'tourist': 'Turista', 'school': 'Escola',
      'username': 'Username', 'password': 'Password', 'forgot_password': 'Esqueceste-te da password?',
      'enter': 'ENTRAR', 'or_login_with': 'Ou entrar com', 'no_account': 'Ainda não tens conta? ',
      'register_here': 'Regista-te aqui', 'empty_fields': 'Por favor, preenche todos os campos!',
      'wrong_credentials': 'Username ou Password incorretos!', 'recover_title': 'Recuperar Password',
      'recover_desc': 'Insere o teu e-mail associado à conta. Vamos enviar-te um código de recuperação.', 'email': 'E-mail',
      'send_code': 'ENVIAR CÓDIGO', 'create_account': 'Criar Nova Conta', 'full_name': 'Nome Completo',
      'country': 'País', 'city': 'Cidade', 'other_city': 'Outra Cidade', 'write_city': 'Escreve o nome da cidade',
      'age': 'Idade', 'years': 'anos', 'gender': 'Género', 'institution': 'Selecionar Instituição / Univ.',
      'what_role': 'Qual é o teu papel na instituição?', 'student': 'Aluno', 'teacher': 'Professor', 'guardian': 'Enc. Edu.',
      'create_and_login': 'CRIAR CONTA E ENTRAR',
      // --- NOVOS: SOCIAL ---
      'your_friends': 'OS TEUS AMIGOS', 'travel_squads': 'OS TEUS GRUPOS',
      'search_friends': 'Procurar novos amigos...', 'search_groups': 'Procurar grupos...',
      'friends_tab': 'Amigos', 'groups_tab': 'Grupos',
      'pending_requests': 'Pedidos Pendentes', 'accept': 'Aceitar', 'reject': 'Recusar',
      'level': 'Nível', 'members': 'membros',
      'start_chat': 'Inicia uma conversa com', 'type_message': 'Escreve uma mensagem...',
      'challenge': 'Desafiar', 'choose_pack': 'Escolhe o Pack de Turismo para jogarem em equipa ou competirem!',
      'invite': 'Convidar',
    },
    'es': {
      'login_subtitle': 'Explora el mundo jugando', 'tourist': 'Turista', 'school': 'Escuela',
      'username': 'Usuario', 'password': 'Password', 'forgot_password': '¿Olvidaste tu contraseña?',
      'enter': 'ENTRAR', 'or_login_with': 'O entrar con', 'no_account': '¿No tienes cuenta? ',
      'register_here': 'Regístrate aquí', 'empty_fields': '¡Por favor, completa todos los campos!',
      'wrong_credentials': '¡Usuario o contraseña incorrectos!', 'recover_title': 'Recuperar Contraseña',
      'recover_desc': 'Introduce el correo asociado. Te enviaremos un código de recuperación.', 'email': 'Correo electrónico',
      'send_code': 'ENVIAR CÓDIGO', 'create_account': 'Crear Nueva Cuenta', 'full_name': 'Nombre Completo',
      'country': 'País', 'city': 'Ciudad', 'other_city': 'Otra Ciudad', 'write_city': 'Escribe el nombre de la ciudad',
      'age': 'Edad', 'years': 'años', 'gender': 'Género', 'institution': 'Seleccionar Institución',
      'what_role': '¿Cuál es tu rol?', 'student': 'Alumno', 'teacher': 'Profesor', 'guardian': 'Tutor legal',
      'create_and_login': 'CREAR CUENTA Y ENTRAR',
      // --- NOVOS: SOCIAL ---
      'your_friends': 'TUS AMIGOS', 'travel_squads': 'TUS GRUPOS',
      'search_friends': 'Buscar nuevos amigos...', 'search_groups': 'Buscar grupos...',
      'friends_tab': 'Amigos', 'groups_tab': 'Grupos',
      'pending_requests': 'Solicitudes Pendientes', 'accept': 'Aceptar', 'reject': 'Rechazar',
      'level': 'Nivel', 'members': 'miembros',
      'start_chat': 'Inicia una conversación con', 'type_message': 'Escribe un mensaje...',
      'challenge': 'Desafiar', 'choose_pack': '¡Elige el Pack de Turismo para jugar en equipo o competir!',
      'invite': 'Invitar',
    },
    'fr': {
      'login_subtitle': 'Explore le monde en jouant', 'tourist': 'Touriste', 'school': 'École',
      'username': 'Nom d\'utilisateur', 'password': 'Mot de passe', 'forgot_password': 'Mot de passe oublié ?',
      'enter': 'CONNEXION', 'or_login_with': 'Ou connectez-vous avec', 'no_account': 'Vous n\'avez pas de compte ? ',
      'register_here': 'S\'inscrire ici', 'empty_fields': 'Veuillez remplir tous les champs !',
      'wrong_credentials': 'Nom d\'utilisateur ou mot de passe incorrect !', 'recover_title': 'Récupérer le mot de passe',
      'recover_desc': 'Entrez votre e-mail associé. Nous vous enverrons un code de récupération.', 'email': 'E-mail',
      'send_code': 'ENVOYER LE CODE', 'create_account': 'Créer un nouveau compte', 'full_name': 'Nom Complet',
      'country': 'Pays', 'city': 'Ville', 'other_city': 'Autre Ville', 'write_city': 'Écris le nom de la ville',
      'age': 'Âge', 'years': 'ans', 'gender': 'Genre', 'institution': 'Sélectionner l\'Institution',
      'what_role': 'Quel est votre rôle ?', 'student': 'Élève', 'teacher': 'Professeur', 'guardian': 'Tuteur',
      'create_and_login': 'CRÉER UN COMPTE ET SE CONNECTER',
      // --- NOVOS: SOCIAL ---
      'your_friends': 'TES AMIS', 'travel_squads': 'TES GROUPES',
      'search_friends': 'Chercher de nouveaux amis...', 'search_groups': 'Chercher des groupes...',
      'friends_tab': 'Amis', 'groups_tab': 'Groupes',
      'pending_requests': 'Demandes en attente', 'accept': 'Accepter', 'reject': 'Refuser',
      'level': 'Niveau', 'members': 'membres',
      'start_chat': 'Commencez une conversation avec', 'type_message': 'Écrivez un message...',
      'challenge': 'Défier', 'choose_pack': 'Choisissez le Pack de Tourisme pour jouer en équipe ou concourir !',
      'invite': 'Inviter',
    }
  };
}