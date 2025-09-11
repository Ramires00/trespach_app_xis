import 'package:flutter/material.dart';
import 'package:trespach_app/controller/home_controller.dart';
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
      appBar: AppBar(title: Text('Trespach Lanches')),
      body: FutureBuilder(
        future: widget.homeController.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Image.network(
                  snapshot.data?[index].image ?? 'ERRO',
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.fastfood),
                ),
                title: Text(snapshot.data?[index].name ?? 'ERRO'),
                subtitle: Text((snapshot.data?[index].price ?? 0).toString()),
                onTap: () => ProductDetail(),
              ),
              itemCount: snapshot.data?.length ?? 0,
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

// Produto (Lanche, bebida, doce (sobremesa))
//   - Nome (String) OK
//   - Descrição (String)
//   - Valor (número)
//   - Adicionais (se houver) (Lista de adicionais)
//   - Observação (String)
