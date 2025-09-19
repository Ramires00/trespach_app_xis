import 'package:flutter/material.dart';
import 'package:trespach_app/external_services/localstorage/localstorage_collections.dart';
import 'package:trespach_app/model/additional.dart';
import 'package:trespach_app/model/product.dart';
import 'package:trespach_app/external_services/localstorage/localstorage.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.produtoSelecionado});

  final Product? produtoSelecionado;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 0;
  List<Additional> additionalsSelected = [];
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.produtoSelecionado == null) {
      return Text('Produto não');
    }

    return Scaffold(
      body: Card(
        child: Column(
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTePsTtyBilWb9sjgUIALUbIDvCYpNTQEzJxA&s',
            ), // imagem
            Text(widget.produtoSelecionado!.name),
            Text(widget.produtoSelecionado!.description),
            TextButton(
              child: Text('Adicionais'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      height: 400,
                      width: 300,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                widget
                                    .produtoSelecionado!
                                    .additionals![index]
                                    .name,
                              ),
                              trailing: QuantityAdditionals(
                                quantityLimit: widget
                                    .produtoSelecionado!
                                    .additionals![index]
                                    .quantityLimit,
                                initialQuantity:
                                    additionalsSelected
                                        .elementAtOrNull(index)
                                        ?.quantity ??
                                    0,
                                onRemoved: () {
                                  additionalsSelected.removeWhere(
                                    (a) =>
                                        a.name ==
                                        widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .name,
                                  );
                                },
                                onChanged: (additionalQuantity) {
                                  final isAdditionalExistent =
                                      additionalsSelected.any(
                                        (a) =>
                                            a.name ==
                                            widget
                                                .produtoSelecionado!
                                                .additionals![index]
                                                .name,
                                      );

                                  if (!isAdditionalExistent && quantity >= 1) {
                                    additionalsSelected.add(
                                      Additional(
                                        name: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .name,
                                        price: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .price,
                                        quantityLimit: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .quantityLimit,
                                        quantity: additionalQuantity,
                                      ),
                                    );
                                  } else {
                                    additionalsSelected.removeWhere(
                                      (a) =>
                                          a.name ==
                                          widget
                                              .produtoSelecionado!
                                              .additionals![index]
                                              .name,
                                    );
                                    additionalsSelected.add(
                                      Additional(
                                        name: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .name,
                                        price: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .price,
                                        quantityLimit: widget
                                            .produtoSelecionado!
                                            .additionals![index]
                                            .quantityLimit,
                                        quantity: additionalQuantity,
                                      ),
                                    );
                                  }
                                },
                              ),
                              subtitle: Text(
                                widget
                                    .produtoSelecionado!
                                    .additionals![index]
                                    .price
                                    .toString(),
                              ),
                            ),
                            itemCount:
                                widget.produtoSelecionado!.additionals!.length,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Adicionar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ), // Adicionais... },
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: 'Observação: Ex Tirar milho e ervilha.',
              ),
            ),
            QuantityAdditionals(
              onRemoved: () {},
              onChanged: (quantitySelected) {
                setState(() {
                  quantity = quantitySelected;
                });
              },
            ),
            ElevatedButton(
              child: Text('Adicionar ao Carrinho'),
              // se não for adicionado nenhum produto desabilitar o botão!
              onPressed: () async {
                await LocalStorage.storeJson(
                  localStorageCollection: LocalStorageCollections.cartProducts,
                  data: Product(
                    name: widget.produtoSelecionado!.name,
                    description: widget.produtoSelecionado!.description,
                    additionals: additionalsSelected,
                    quantity: quantity,
                    price: widget.produtoSelecionado!.price,
                    notes: notesController.value.text,
                  ).toJson(),
                );
                additionalsSelected.clear();

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              // caso o xis seja selecionado, passar o valor para o cart_page.
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityAdditionals extends StatefulWidget {
  const QuantityAdditionals({
    required this.onChanged,
    required this.onRemoved,
    this.quantityLimit,
    this.initialQuantity = 0,
    super.key,
  });

  final void Function(int quantitySelected) onChanged;
  final void Function() onRemoved;
  final int? quantityLimit;
  final int initialQuantity;

  @override
  State<QuantityAdditionals> createState() => _QuantityAdditionalsState();
}

class _QuantityAdditionalsState extends State<QuantityAdditionals> {
  int quantity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        quantity = widget.initialQuantity;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (quantity <= 0) {
              return;
            }

            setState(() {
              quantity--;
            });

            if (quantity <= 0) {
              widget.onRemoved();
            } else {
              widget.onChanged(quantity);
            }
          },
        ),
        Text('Quantidade: ${quantity}'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (widget.quantityLimit != null &&
                quantity >= widget.quantityLimit!) {
              return;
            }

            setState(() {
              quantity++;
            });

            widget.onChanged(quantity);
          },
        ),
      ],
    );
  }
}
