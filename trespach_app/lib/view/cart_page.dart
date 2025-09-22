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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          Text(
                            'Retirar Pedido no endereço ... total do pedido ...., forma de pagamento? ',
                          ),
                        ],
                      ),
                    );
                    /*total do pedido: 25*/
                  },
                  child: Text('retirada'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CostumerAddress(),
                    );
                  },
                  child: Text('tele'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CostumerAddress extends StatefulWidget {
  const CostumerAddress({super.key});

  @override
  State<CostumerAddress> createState() => _CostumerAddressState();
}

class _CostumerAddressState extends State<CostumerAddress> {
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController neighboorhoodController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Text('Endereço para tele-entrega'),
        TextField(
          decoration: InputDecoration(hint: Text('endereço')),
          controller: addressController,
        ),
        TextField(
          decoration: InputDecoration(hint: Text('número')),
          controller: numberController,
        ),
        TextField(
          decoration: InputDecoration(hint: Text('bairro')),
          controller: neighboorhoodController,
        ),
        TextField(
          decoration: InputDecoration(hint: Text('CEP')),
          controller: cepController,
        ),
        Text('taxa de entrega'),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(hint: Text('ponto de referência')),
          controller: referenceController,
        ),
        TextButton(onPressed: () => CheckoutPage, child: Text('Checkout')),
      ],
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('CheckoutPage')));
  }
}

// final String address;
//   final String? number;
//   final String neighborhood;
//   final String postalCode;
//   final num? deliveryTax;
//   final String? reference;2
