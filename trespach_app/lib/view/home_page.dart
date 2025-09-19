import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trespach_app/controller/home_controller.dart';
import 'package:trespach_app/view/cart_page.dart';
import 'package:trespach_app/view/product_detail.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final HomeController homeController = HomeController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trespach Lanches'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_rounded, color: Colors.black),
            onPressed: () => Navigator.of(
              context,
            ).push(CupertinoPageRoute(builder: (context) => ShoppingCart())),
          ),
        ],
      ),
      body: FutureBuilder(
        future: widget.homeController.getProducts(),
        builder: (_, snapshot) {
          final envelopeDeDados = snapshot;
          final estadoDaConexao = envelopeDeDados.connectionState;
          final possuiDados = envelopeDeDados.hasData;
          final produtos = envelopeDeDados.data;
          if (estadoDaConexao == ConnectionState.done && possuiDados) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final elementoAtualDoForLoop = index;

                return ListTile(
                  leading: Image.network(
                    produtos?.elementAt(elementoAtualDoForLoop).image ?? 'ERRO',
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.fastfood),
                  ),
                  title: Text(
                    produtos?.elementAt(elementoAtualDoForLoop).name ?? 'ERRO',
                  ),
                  subtitle: Text(
                    (produtos?.elementAt(elementoAtualDoForLoop).price ?? 0)
                        .toString(),
                  ),
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

                    if (isProductAddedToCart != null &&
                        isProductAddedToCart &&
                        context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('produto adicionado!')),
                      );
                    }
                  },
                );
              },
              itemCount: produtos == null ? 0 : produtos.length,
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Ocorreu um erro."));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
