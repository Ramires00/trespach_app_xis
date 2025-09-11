import 'package:flutter/material.dart';
import 'package:trespach_app/model/product.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.produtoSelecionado});

  final Product? produtoSelecionado;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    if (widget.produtoSelecionado == null) {
      return Text('Produto não');
    }

    return Card(
      child: Column(
        children: [
          Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTePsTtyBilWb9sjgUIALUbIDvCYpNTQEzJxA&s',
          ), // imagem
          Text(widget.produtoSelecionado!.name), // nome do produto
          Text(widget.produtoSelecionado!.description), // descricao do produto
          TextButton(
            child: Text('Adicionais'),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SizedBox(
                  height: 400,
                  width: 300,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            ListTile(title: Text('adicionais..')),
                        itemCount: 4,
                      ),
                    ],
                  ),
                ),
              ),
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
