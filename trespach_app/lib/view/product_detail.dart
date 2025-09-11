import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTePsTtyBilWb9sjgUIALUbIDvCYpNTQEzJxA&s',
          ), // imagem
          Text('Nome'), // nome do produto
          Text('Descrição'), // descricao do produto
          TextButton(
            child: Text('Adicionais'),
            onPressed: () => ListView.builder(
              itemBuilder: (context, index) =>
                  ListTile(title: Text('adicionais..')),
              itemCount: 4,
            ),
          ), // Adicionais... },
          TextField(),
          Text('Quantidade'),
          ElevatedButton(
            child: Text('Adicionar ao Carrinho'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
