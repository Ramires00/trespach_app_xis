import 'package:flutter/material.dart';
import 'package:trespach_app/external_services/localstorage/localstorage_collections.dart';
import 'package:trespach_app/model/additional.dart';
import 'package:trespach_app/model/product.dart';
import 'package:trespach_app/external_services/localstorage/localstorage.dart';
import 'package:trespach_app/view/cart_page.dart';
import 'package:trespach_app/view/home_page.dart';
import 'package:trespach_app/view/widgets/scaffold_constraint.dart';

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
      return Text('sem produtos');
    }

    return ScaffoldConstraint(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                width: 250,
                child: Image.network(
                  widget.produtoSelecionado?.image ?? '',
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.fastfood),
                ),
              ), // imagem
              Text(
                widget.produtoSelecionado!.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.produtoSelecionado!.description),
              TextButton(
                child: Text('Adicionais'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
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
                                    trailing: NumberStepper(
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
                                        setState(() {
                                          additionalsSelected.removeWhere(
                                            (a) =>
                                                a.name ==
                                                widget
                                                    .produtoSelecionado!
                                                    .additionals![index]
                                                    .name,
                                          );
                                        });
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

                                        if (!isAdditionalExistent &&
                                            quantity >= 1) {
                                          setState(() {
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
                                          });
                                        } else {
                                          setState(() {
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
                                          });
                                        }
                                        this.setState(() {});
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
                                  itemCount: widget
                                      .produtoSelecionado!
                                      .additionals!
                                      .length,
                                ),
                                TextButton(
                                  onPressed: additionalsSelected.isEmpty
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                        },
                                  child: Text('Adicionar'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ), // Adicionais... },
              SizedBox(
                width: 200,
                child: TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    hintText: 'Observação: Tirar milho e ervilha.',
                  ),
                ),
              ),
              NumberStepper(
                onRemoved: () {
                  setState(() {
                    quantity = 0;
                  });
                },
                onChanged: (quantitySelected) {
                  setState(() {
                    quantity = quantitySelected;
                  });
                },
              ),

              additionalsSelected.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Text('Adicionais selecionados: '),
                        ...additionalsSelected.map<Widget>(
                          (ad) => Row(
                            spacing: 20,
                            children: [
                              Text('${ad.name} quant: ${ad.quantity}'),
                              IconButton(
                                onPressed: () => setState(
                                  () => additionalsSelected.removeWhere(
                                    (a) => a.name == ad.name,
                                  ),
                                ),
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              ElevatedButton(
                onPressed: quantity <= 0
                    ? null
                    : () async {
                        await LocalStorage.storeJson(
                          localStorageCollection:
                              LocalStorageCollections.cartProducts,
                          data: Product(
                            id: widget.produtoSelecionado!.id,
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
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('O que deseja fazer?'),
                              content: SizedBox(width: 300, height: 30),
                              actions: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      child: Text('selecionarR mais produtos'),
                                      onPressed: () => Navigator.of(context)
                                          .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                            (routeSettings) =>
                                                routeSettings.isFirst,
                                          ),
                                    ),
                                    ElevatedButton(
                                      child: Text('ir para o carrinho'),
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShoppingCart(),
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                child: Text('Adicionar ao Carrinho'),
                // caso o xis seja selecionado, passar o valor para o cart_page.
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberStepper extends StatefulWidget {
  const NumberStepper({
    required this.onChanged,
    this.onRemoved,
    this.quantityLimit,
    this.initialQuantity = 0,
    super.key,
  });

  final void Function(int quantitySelected) onChanged;
  final void Function()? onRemoved;
  final int? quantityLimit;
  final int initialQuantity;

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
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
              widget.onRemoved?.call();
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
