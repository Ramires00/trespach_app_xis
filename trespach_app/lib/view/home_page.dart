import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: Image.network(
            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
          ),
          title: Text('Xis saas - ${2.00}'),
          subtitle: Text('descricao'),
        ),
        itemCount: 2,
      ),
    );
  }
}


// Produto (Lanche, bebida, doce (sobremesa))
//   - Nome (String) OK
//   - Descrição (String)
//   - Valor (número)
//   - Adicionais (se houver) (Lista de adicionais)
//   - Observação (String)
//   - Quantidade (número)
//   - Foto (String - link http da foto) OK