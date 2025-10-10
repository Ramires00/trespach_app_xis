import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ErrorBoundaryWidget extends StatelessWidget {
  const ErrorBoundaryWidget({required this.details, super.key});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                Text(
                  "Sentimos muito, ocorreu um erro na aplicação. Por favor, contate o suporte ou recarregue a página.",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      launchUrlString('https://wa.link/vume4e');
                    },
                    label: Text(
                      "Entrar em contato no WhatsApp",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(details.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
