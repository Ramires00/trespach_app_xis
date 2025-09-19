import 'package:flutter/material.dart';
import 'package:trespach_app/controller/cart_controller.dart';
import 'package:trespach_app/model/additional.dart';
import 'package:trespach_app/model/product.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({super.key});

  final CartController cartController = CartController();

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

Future<List<Product>?> recoverSelectedProducts() async {
  try {
    final recoverData = await CartController().retrieveProductsInCart();
    return recoverData;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

class _ShoppingCartState extends State<ShoppingCart> {
  num calculateAdditionals(List<Additional>? additionals) {
    num total = 0;

    if (additionals == null || additionals.isEmpty) {
      return total;
    }

    for (final a in additionals) {
      total += (a.price * a.quantity!);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: recoverSelectedProducts(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(asyncSnapshot.data![index].name),
                        Text(
                          'Observação: ${asyncSnapshot.data![index].notes.length == 0 ? '-' : asyncSnapshot.data![index].notes}',
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'Quantidade: ${asyncSnapshot.data![index].quantity}',
                        ),
                        Text(
                          ' valor:${(asyncSnapshot.data![index].price * asyncSnapshot.data![index].quantity!.toDouble()) + calculateAdditionals(asyncSnapshot.data![index].additionals)},00',
                        ),
                      ],
                    ),
                  ),

                  itemCount: asyncSnapshot
                      .data!
                      .length, // quantidade adicionada ao carrinho
                );
              },
            ),
            //deletar
            // se for tele, adicionar o valor cobrado a mais.
            //valor total com ou sem tele entrega.
            //tempo de espera até o lanche ficar pronto.
          ],
        ),
      ),
    );
  }
}
