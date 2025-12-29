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
  const AddressDialog({required this.onSubmit, super.key});

  final void Function(Order order) onSubmit;

  @override
  State<AddressDialog> createState() => _CheckoutDialog();
}

class _CheckoutDialog extends State<AddressDialog> {
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  MaskedTextController cepController = MaskedTextController(mask: '00000-000');
  TextEditingController referenceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  MaskedTextController phoneController = MaskedTextController(
    mask: '(00) 00000-0000',
  );
  final GlobalKey<FormState> checkoutFormState = GlobalKey();
  final CartController cartController = CartController();

  Neighborhood? selectedNeighborhood;
  PaymentMethod? paymentMethod;
  OrderTakeoutType? orderTakeoutType;

  List<DropdownMenuItem<String>> dropdownItems = PaymentMethod.values.map((
    value,
  ) {
    return DropdownMenuItem<String>(value: value.name, child: Text(value.name));
  }).toList();

  List<DropdownMenuItem<OrderTakeoutType>> dropdownOrder = OrderTakeoutType
      .values
      .map((value) {
        return DropdownMenuItem<OrderTakeoutType>(
          value: value,
          child: Text(value.name),
        );
      })
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Dados do Pedido')),
      content: Form(
        key: checkoutFormState,
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do cliente',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obrigatório'
                        : null,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Campo obrigatório'
                        : null,
                  ),

                  const Divider(height: 30),

                  DropdownButtonFormField<PaymentMethod>(
                    initialValue: paymentMethod,
                    hint: const Text('Forma de Pagamento'),
                    items: PaymentMethod.values
                        .map(
                          (v) =>
                              DropdownMenuItem(value: v, child: Text(v.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => paymentMethod = val),
                    validator: (value) =>
                        value == null ? 'Selecione o pagamento' : null,
                  ),

                  if (paymentMethod == PaymentMethod.dinheiro)
                    TextFormField(
                      controller: moneyController,
                      decoration: const InputDecoration(
                        labelText: 'Troco para quanto?',
                        hintText: '0 se não precisar',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe o valor ou 0'
                          : null,
                    ),
                  DropdownButtonFormField<OrderTakeoutType>(
                    initialValue: orderTakeoutType,
                    hint: const Text('Entrega ou Retirada?'),
                    items: OrderTakeoutType.values
                        .map(
                          (v) =>
                              DropdownMenuItem(value: v, child: Text(v.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => orderTakeoutType = val),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),

                  if (orderTakeoutType == OrderTakeoutType.entrega) ...[
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Rua/Endereço',
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Endereço obrigatório'
                          : null,
                    ),
                    TextFormField(
                      controller: numberController,
                      decoration: const InputDecoration(labelText: 'Número'),
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Obrigatório'
                          : null,
                    ),
                    FutureBuilder<List<Neighborhood>>(
                      future: cartController.retrieveNeighborhoods(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField<String>(
                          initialValue: selectedNeighborhood?.neighborhood,
                          hint: const Text('Selecione o Bairro'),
                          items: snapshot.data
                              ?.map(
                                (n) => DropdownMenuItem(
                                  value: n.neighborhood,
                                  child: Text(n.neighborhood),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(
                              () => selectedNeighborhood = snapshot.data!
                                  .firstWhere((n) => n.neighborhood == val),
                            );
                          },
                          validator: (value) =>
                              value == null ? 'Bairro obrigatório' : null,
                        );
                      },
                    ),

                    TextFormField(
                      controller: cepController,
                      decoration: const InputDecoration(labelText: 'CEP'),
                      validator: (value) => (value == null || value.length < 9)
                          ? 'CEP inválido'
                          : null,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (checkoutFormState.currentState!.validate()) {
              final products = await recoverSelectedProducts();
              final total = calculateTotal(products ?? []);

              final Order order = Order(
                address: Address(
                  address: addressController.text,
                  neighborhood:
                      selectedNeighborhood ??
                      Neighborhood(neighborhood: '', deliveryTax: 0),
                  postalCode: cepController.text,
                  deliveryTax: selectedNeighborhood?.deliveryTax,
                  number: numberController.text,
                  reference: referenceController.text,
                ),
                customerName: nameController.text,
                phoneNumber: phoneController.text,
                orderTotal: total,
                orderTakeoutType: orderTakeoutType!,
                products: products ?? [],
                paymentMethod: paymentMethod!,
                isNecessaryExchange: moneyController.text,
                createdAt: DateTime.now().toString(),
              );

              widget.onSubmit(order);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Finalizar Pedido'),
        ),
      ],
    );
  }
}
