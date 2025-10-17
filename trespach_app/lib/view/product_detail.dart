import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 280,
              width: 800,
              child: Image.network(
                widget.produtoSelecionado?.image ?? '',
                fit: BoxFit.cover,
                scale: 1,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.fastfood, size: 100),
                alignment: Alignment(1, 0.3),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    widget.produtoSelecionado!.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              CurrencyTextInputFormatter.currency(
                    locale: 'pt_BR',
                    symbol: 'R\$',
                  )
                  .formatString(
                    widget.produtoSelecionado!.price.toStringAsFixed(2),
                  )
                  .toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 300,
              child: Text(
                widget.produtoSelecionado!.description,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    widget.produtoSelecionado!.additionals![index].name,
                  ),
                  trailing: NumberStepper(
                    quantityLimit: widget
                        .produtoSelecionado!
                        .additionals![index]
                        .quantityLimit,
                    initialQuantity:
                        additionalsSelected.elementAtOrNull(index)?.quantity ??
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
                      final isAdditionalExistent = additionalsSelected.any(
                        (a) =>
                            a.name ==
                            widget.produtoSelecionado!.additionals![index].name,
                      );

                      if (!isAdditionalExistent && quantity >= 1) {
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
                    CurrencyTextInputFormatter.currency(
                      locale: 'pt_BR',
                      symbol: 'R\$',
                    ).formatString(
                      widget.produtoSelecionado!.additionals![index].price
                          .toStringAsFixed(2),
                    ),
                  ),
                ),
                itemCount: widget.produtoSelecionado!.additionals!.length,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 770,
              child: TextField(
                maxLines: 5,
                controller: notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'Observação: Tirar milho e ervilha.',
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              description:
                                  widget.produtoSelecionado!.description,
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
                                content: SizedBox(
                                  width: 300,
                                  child: Text(
                                    'Produto adicionado ao carrinho!',
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        child: Text('Selecionar mais produtos'),
                                        onPressed: () => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                              (routeSettings) =>
                                                  routeSettings.isFirst,
                                            ),
                                      ),
                                      ElevatedButton(
                                        child: Text('Ir para o carrinho'),
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
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
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
        Text('${quantity}'),
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
