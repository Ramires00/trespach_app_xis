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
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
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
