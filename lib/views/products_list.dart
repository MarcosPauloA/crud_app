import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/product_provider.dart';
import 'package:crud_app/components/product_widget.dart';
import 'package:crud_app/routes/routes.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider produtos = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Lista de Produtos'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.FORMULARIO_PRODUTOS);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: produtos.fetchProdutosFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return ListView.builder(
              itemCount: produtos.contador,
              itemBuilder: (ctx, i) => ProductWidget(produto: produtos.peloIndice(i)),
            );
          }
        },
      ),
    );
  }
}
