import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trespach_app/firebase_options.dart';
import 'package:trespach_app/view/home_page.dart';
import 'package:trespach_app/view/widgets/error_boundary_widget.dart';

Future<void> init() async {
  try {
    final firebaseProject = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase inicializado com sucesso. ${firebaseProject.name}");
  } catch (err) {
    debugPrint("Ocorreu um erro ao inicializar o Firebase: $err");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        ErrorWidget.builder = (details) {
          return ErrorBoundaryWidget(details: details);
        };

        return child!;
      },
    ),
  );
}

class AppColors {
  static const Color primary = Color(0xFF0D47A1); // azul
  static const Color secondary = Color(0xFFFFC107); // amarelo
  static const Color accent = Color(0xFF4CAF50); // verde
  static const Color background = Color(0xFFF5F5F5); // cinza claro
}
