import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:trespach_app/controller/home_controller.dart';
import 'package:trespach_app/view/cart_page.dart';
import 'package:trespach_app/view/product_detail.dart';
import 'package:trespach_app/view/widgets/scaffold_constraint.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final HomeController homeController = HomeController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldConstraint(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: //Image.asset(''),
        Text(
          'Trespach Lanches',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_rounded, color: Colors.black),
            onPressed: () => Navigator.of(
              context,
            ).push(CupertinoPageRoute(builder: (context) => ShoppingCart())),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 16.0),
        child: FutureBuilder(
          future: widget.homeController.getProducts(),
          builder: (_, snapshot) {
            final envelopeDeDados = snapshot;
            final estadoDaConexao = envelopeDeDados.connectionState;
            final possuiDados = envelopeDeDados.hasData;
            final produtos = envelopeDeDados.data;
            if (estadoDaConexao == ConnectionState.done && possuiDados) {
              return MasonryGridView.builder(
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.sizeOf(context).width < 1000
                      ? 3
                      : 4,
                ),
                itemBuilder: (_, index) {
                  final elementoAtualDoForLoop = index;

                  return InkWell(
                    onTap: () async {
                      final isProductAddedToCart = await Navigator.of(context)
                          .push<bool>(
                            CupertinoPageRoute(
                              builder: (context) => ProductDetail(
                                produtoSelecionado: produtos?.elementAt(
                                  elementoAtualDoForLoop,
                                ),
                              ),
                            ),
                          );
                      if (context.mounted &&
                          isProductAddedToCart != null &&
                          isProductAddedToCart) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('produto adicionado!'),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ShoppingCart(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text("Ir para o carrinho"),
                                      Icon(Icons.shopping_cart),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                produtos
                                        ?.elementAt(elementoAtualDoForLoop)
                                        .image ??
                                    'ERRO',
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.fastfood),
                              ),
                            ),
                            Text(
                              produtos
                                      ?.elementAt(elementoAtualDoForLoop)
                                      .name ??
                                  'ERRO',
                            ),
                            Text(
                              (CurrencyTextInputFormatter.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).formatString(
                                    produtos
                                            ?.elementAt(elementoAtualDoForLoop)
                                            .price
                                            .toStringAsFixed(2) ??
                                        "",
                                  ))
                                  .toString(),
                            ),
                            Text(
                              produtos
                                      ?.elementAt(elementoAtualDoForLoop)
                                      .description ??
                                  "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: produtos == null ? 0 : produtos.length,
              );
            }

            // if (snapshot.hasError) {
            //   return Center(child: Text("Ocorreu um erro."));
            // }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
