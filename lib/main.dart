import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print("Firebase já estava inicializado.");
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  try {
    String? token = await messaging.getToken();
    print("ID DO DISPOSITIVO (FCM TOKEN): $token");
    await messaging.subscribeToTopic('jogadores_porto');
  } catch (e) {
    print("Erro ao obter token: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Play2Travel',
          debugShowCheckedModeBanner: false,
          themeMode: AppSettings.instance.themeMode, 
          
          theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            primaryColor: Colors.deepOrange,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              secondary: Colors.blueAccent,
            ),
            useMaterial3: true,
            // ✨ TRANSICÕES SUAVES PARA TEMA CLARO ✨
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            scaffoldBackgroundColor: const Color(0xFF0A0A0A),
            primaryColor: Colors.deepOrange,
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepOrange,
              secondary: Colors.blueAccent,
            ),
            useMaterial3: true,
            // ✨ TRANSICÕES SUAVES PARA TEMA ESCURO ✨
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          
          home: const SplashScreen(),
        );
      },
    );
  }
}