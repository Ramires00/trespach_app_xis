import 'package:flutter/material.dart';
import 'package:trespach_app/model/product.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.produtoSelecionado});

  final Product? produtoSelecionado;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 0;

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
          Text(widget.produtoSelecionado!.name),
          Text(widget.produtoSelecionado!.description),
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
                            ListTile(title: Text('1212')),
                        itemCount:
                            widget.produtoSelecionado!.additionals!.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ), // Adicionais... },
          TextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    quantity--;
                  });
                },
              ),
              Text('Quantidade: ${quantity}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            child: Text('Adicionar ao Carrinho'),
            onPressed: () => Navigator.pop(context),
            // caso o xis seja selecionado, passar o valor para o cart_page.
          ),
        ],
      ),
    );
  }
}
