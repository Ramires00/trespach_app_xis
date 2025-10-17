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
            Column(
              children: [
                if (total > 0) ...[
                  Text('subtotal: $subtotal'),
                  if (order != null &&
                      order!.address != null &&
                      order?.address!.deliveryTax != null)
                    Text('Valor da tele: ${order?.address!.deliveryTax}'),
                  Text('total do pedido: $total'),
                ],
              ],
            ),

            //editar
            Row(
              children: [
                if (hasProductsInCart) ...[
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => AddressDialog(
                            takeoutType: OrderTakeoutType.retirada,

                            onSubmit: (orderFromDialog) {
                              setState(() {
                                order = Order(
                                  createdAt: orderFromDialog.createdAt,
                                  customerName: orderFromDialog.customerName,
                                  orderTakeoutType: OrderTakeoutType.retirada,
                                  orderTotal: orderFromDialog.orderTotal,
                                  paymentMethod: orderFromDialog.paymentMethod,
                                  phoneNumber: orderFromDialog.phoneNumber,
                                  products: orderFromDialog.products,
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
                        ),
                      );
                      /*total do pedido: 25*/
                    },
                    child: Text('retirada'),
                  ),

                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => AddressDialog(
                            takeoutType: OrderTakeoutType.entrega,
                            onSubmit: (orderFromDialog) {
                              setState(() {
                                order = orderFromDialog;
                                if (context.mounted) {
                                  setState(() {
                                    subtotal = calculateTotal(
                                      order?.products ?? [],
                                    );
                                    total =
                                        subtotal +
                                        (order?.address?.deliveryTax ?? 0);
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('entrega'),
                  ),
                ],
                SizedBox(width: 20, height: 20),
              ],
            ),
            if (order != null)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actions: [Center(child: Text('pedido enviado!'))],
                    ),
                  );
                  cartController.createNewOrder(order?.toJson() ?? {});
                },
                child: Text('enviar pedido'),
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
                        await cartController.deleteProduct(
                          asyncSnapshot.data![index].id,
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
                          'endereço: ${order!.address!.address}\n + ${order!.address!.number}\n + ${order!.address!.neighborhood}',
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

class AddressDialog extends StatefulWidget {
  const AddressDialog({
    required this.onSubmit,
    required this.takeoutType,
    super.key,
  });

  final void Function(Order order) onSubmit;
  final OrderTakeoutType takeoutType;

  @override
  State<AddressDialog> createState() => _CheckoutDialog();
}

class _CheckoutDialog extends State<AddressDialog> {
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  MaskedTextController cepController = MaskedTextController(mask: '00000-000');
  TextEditingController referenceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  MaskedTextController phoneController = MaskedTextController(
    mask: '(00) 00000-0000',
  );
  final GlobalKey<FormState> checkoutFormState = GlobalKey();
  final tele = OrderTakeoutType.entrega;
  final CartController cartController = CartController();

  Neighborhood? selectedNeighborhood;
  PaymentMethod? paymentMethod;

  List<DropdownMenuItem<String>> dropdownItems = PaymentMethod.values.map((
    value,
  ) {
    return DropdownMenuItem<String>(value: value.name, child: Text(value.name));
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: checkoutFormState,
      child: AlertDialog(
        title: Center(child: Text('Preencha os dados para enviar o pedido')),
        actions: [
          if (widget.takeoutType == OrderTakeoutType.entrega) ...[
            Text('Endereço para tele-entrega'),
            TextFormField(
              decoration: InputDecoration(hint: Text('endereço')),
              controller: addressController,

              validator: (currentText) {
                if (currentText == null || currentText.isEmpty) {
                  return 'digite um endereço válido!';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hint: Text('número')),
              controller: numberController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            FutureBuilder(
              future: cartController.retrieveNeighborhoods(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Carregando bairros...");
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return DropdownButtonFormField<String>(
                    hint: Text('selecione um bairro'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'selecione um bairro!';
                      }

                      return null;
                    },
                    initialValue: selectedNeighborhood?.neighborhood,
                    items: snapshot.data
                        ?.map(
                          (n) => DropdownMenuItem(
                            value: n.neighborhood,
                            child: Text(n.neighborhood),
                          ),
                        )
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        selectedNeighborhood = snapshot.data!.firstWhere(
                          (n) => n.neighborhood == selected,
                        );
                      });
                    },
                  );
                }

                return Text("Erro ao carregar bairros.");
              },
            ),
            TextFormField(
              decoration: InputDecoration(hint: Text('CEP')),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: cepController,
              validator: (currentText) {
                if (currentText == null ||
                    currentText.isEmpty ||
                    currentText.length < 9) {
                  return 'digite um CEP válido!';
                }

                return null;
              },
            ),
            Text('taxa de entrega'),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(hint: Text('ponto de referência')),
              controller: referenceController,
              validator: (currentText) {
                if (currentText == null || currentText.isEmpty) {
                  return 'digite um ponto de referência válido!';
                }
                return null;
              },
            ),
          ],
          TextFormField(
            decoration: InputDecoration(hintText: 'Nome do cliente'),
            controller: nameController,
            validator: (currentText) {
              if (currentText == null || currentText.isEmpty) {
                return 'Nome do cliente precisa ser um nome válido';
              }

              return null;
            },
          ),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(hintText: 'Número para contato'),
            validator: (currentText) {
              if (currentText == null || currentText.isEmpty) {
                return 'Número de telefone inválido';
              }
            },
          ),
          DropdownButtonFormField<String>(
            hint: Text('Forma de Pagamento'),
            items: dropdownItems,
            initialValue: paymentMethod?.name,
            onChanged: (value) {
              setState(() {
                paymentMethod = PaymentMethod.values.firstWhere(
                  (p) => p.name == value,
                );
              });
            },
          ),
          TextButton(
            onPressed: () async {
              final isFormValid = checkoutFormState.currentState?.validate();
              final products = await recoverSelectedProducts();
              final total = calculateTotal(products ?? []);

              if (isFormValid != null && isFormValid) {
                final Order order = Order(
                  address: Address(
                    address: addressController.value.text,
                    neighborhood:
                        selectedNeighborhood ??
                        Neighborhood(neighborhood: '', deliveryTax: 0),
                    postalCode: cepController.value.text,
                    deliveryTax: selectedNeighborhood?.deliveryTax,
                    number: numberController.value.text,
                    reference: referenceController.value.text,
                  ),

                  customerName: nameController.value.text,
                  phoneNumber: phoneController.value.text,
                  orderTotal: total,
                  orderTakeoutType: tele,
                  products: products ?? [],
                  paymentMethod: paymentMethod ?? PaymentMethod.credito,
                  createdAt: DateTime.now().toString(),
                );

                widget.onSubmit(order);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
