import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trespach_app/controller/cart_controller.dart';
import 'package:trespach_app/model/address.dart';
import 'package:trespach_app/model/enum/order_takeout_type.dart';
import 'package:trespach_app/model/enum/payment_method.dart';
import 'package:trespach_app/model/order.dart';
import 'package:trespach_app/view/cart_page.dart';

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
  OrderTakeoutType? orderTakeoutType;

  List<DropdownMenuItem<String>> dropdownItems = PaymentMethod.values.map((
    value,
  ) {
    return DropdownMenuItem<String>(value: value.name, child: Text(value.name));
  }).toList();

  List<DropdownMenuItem<String>> dropdownOrder = OrderTakeoutType.values.map((
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
          DropdownButtonFormField<String>(
            hint: Text('Pedido para Retirada ou Entrega'),
            items: dropdownOrder,

            initialValue: orderTakeoutType?.name,
            onChanged: (value) {
              setState(() {
                orderTakeoutType = OrderTakeoutType.values.firstWhere(
                  (p) => p.name == value,
                );
              });
            },
          ),

          if (widget.takeoutType == OrderTakeoutType.entrega) ...[
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

          Center(
            child: SizedBox(
              width: 160,
              child: TextButton(
                onPressed: () async {
                  final isFormValid = checkoutFormState.currentState
                      ?.validate();
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
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text('Salvar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
