import 'package:flutter/material.dart';
import 'package:trespach_app/controller/cart_controller.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({super.key});

  final CartController cartController = CartController();

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

recuperarProdutosSelecionados() async {
  try {
    await CartController().retrieveProductsInCart();
  } catch (e) {
    print(e.toString());
  }
  return CartController().retrieveProductsInCart().toString();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    if (recuperarProdutosSelecionados() == null) {
      CircularProgressIndicator;
      Center(child: Text('nenhum produto selecionado'));
    }
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                ListTile(title: Text(widget.produtoNoCarrinho!.name)),
            itemCount: widget
                .produtoNoCarrinho!
                .quantity, // quantidade adicionada ao carrinho
          ),
          Text('Retirada ou tele'),
          // se for tele, adicionar o valor cobrado a mais.
          Text('Valor total: 2020'),
          //valor total com ou sem tele entrega.
          //tempo de espera até o lanche ficar pronto.
        ],
      ),
    );
  }
}
