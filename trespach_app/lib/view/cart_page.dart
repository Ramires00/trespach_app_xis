import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trespach_app/controller/cart_controller.dart';
import 'package:trespach_app/model/additional.dart';
import 'package:trespach_app/model/address.dart';
import 'package:trespach_app/model/enum/order_takeout_type.dart';
import 'package:trespach_app/model/enum/payment_method.dart';
import 'package:trespach_app/model/order.dart';
import 'package:trespach_app/model/product.dart';
import 'package:trespach_app/view/home_page.dart';
import 'package:trespach_app/view/widgets/checkout_dialog.dart';
import 'package:trespach_app/view/widgets/scaffold_constraint.dart';

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

num calculateTotal(List<Product> products) {
  num total = 0;

  for (final p in products) {
    total +=
        ((p.price * (p.quantity ?? 0)) + calculateAdditionals(p.additionals));
  }

  return total;
}

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
  Order? order;

  final CartController cartController = CartController();

  num total = 0;
  num subtotal = 0;
  bool isLoadingCart = false;
  bool hasProductsInCart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final products = await cartController.retrieveProductsInCart();
      setState(() {
        hasProductsInCart = products.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldConstraint(
      bottomSheet: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (total > 0 && hasProductsInCart) ...[
                      Text('subtotal: $subtotal'),
                      if (order != null && order?.address != null)
                        Text('Valor da tele: ${order?.address!.deliveryTax}'),
                      Text('total do pedido: $total'),
                    ],
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasProductsInCart) ...[
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddressDialog(
                              //
                              onSubmit: (orderFromDialog) {
                                setState(() {
                                  order = Order(
                                    createdAt: orderFromDialog.createdAt,
                                    customerName: orderFromDialog.customerName,
                                    orderTakeoutType:
                                        orderFromDialog.orderTakeoutType,

                                    orderTotal: orderFromDialog.orderTotal,
                                    paymentMethod:
                                        orderFromDialog.paymentMethod,
                                    phoneNumber: orderFromDialog.phoneNumber,
                                    products: orderFromDialog.products,
                                    isNecessaryExchange:
                                        orderFromDialog.isNecessaryExchange,
                                    address: null,
                                  );
                                });
                                setState(() {
                                  subtotal = calculateTotal(
                                    order?.products ?? [],
                                  );
                                  total =
                                      subtotal +
                                      (order?.address?.deliveryTax ?? 0);
                                });
                                this.setState(() {});
                                print(order!.toJson());
                                print(order!.address);
                              },
                            ),
                          );
                        },
                        child: Text('Fazer pedido'),
                      ),
                    ],
                  ],
                ),
                if (order != null)
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            Center(
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Center(
                                  child: Text(
                                    'pedido enviado!',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      cartController.createNewOrder(order?.toJson() ?? {});
                      cartController.clearAll();
                      setState(() {
                        order = null;
                        hasProductsInCart = false;
                        total = 0;
                      });
                    },
                    child: Text('enviar pedido'),
                  ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Trespach Lanches'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            if (hasProductsInCart == false) ...[
              SizedBox(height: 200),
              Text(
                'Ops, não há produtos no carrinho!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (ctx) => HomePage()),
                ),
                child: Text('voltar a tela inicial'),
              ),
            ],

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
                        if (asyncSnapshot.data![index].notes.isNotEmpty)
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
                    trailing: IconButton(
                      color: Colors.red,
                      onPressed: () async {
                        print(asyncSnapshot.data![index].cartId);
                        if (asyncSnapshot.data![index].cartId == null) return;

                        await cartController.deleteProduct(
                          asyncSnapshot.data![index].cartId!,
                        );

                        final retriveProduct = await cartController
                            .retrieveProductsInCart();
                        if (retriveProduct.isEmpty) {
                          setState(() {
                            order = null;
                            hasProductsInCart = false;
                          });
                        }

                        setState(() {});
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),

                  itemCount: asyncSnapshot.data!.length,
                );
              },
            ),

            if (order != null)
              Column(
                children: [
                  Text('nome: ${order!.customerName}'),

                  order!.address != null
                      ? Text(
                          'endereço: ${order!.address!.address}\nnúmero: ${order!.address!.number}\nbairro: ${order!.address!.neighborhood.neighborhood}',
                        )
                      : const SizedBox.shrink(),
                  Text('forma de pagamento: ${order!.paymentMethod.name}'),
                  Text(' ${order!.orderTakeoutType.name} '),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
