import 'package:flutter/material.dart';
import 'package:trespach_app/view/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trespach Lanches')),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTePsTtyBilWb9sjgUIALUbIDvCYpNTQEzJxA&s',
          ),
          title: Text('Nome do Produto'),
          subtitle: Text('Valor do produto'),
          onTap: () => ProductDetail(),
        ),
        itemCount: 5,
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
