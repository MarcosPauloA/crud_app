import 'package:crud_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/product_provider.dart';

class ProductWidget extends StatelessWidget {
  final Product produto;
  const ProductWidget({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.inventory), // Ícone representando o produto
      title: Text(produto.nome),
      subtitle: Text(produto.descricao),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.FORMULARIO_PRODUTOS,
                  arguments: produto,
                );
              },
              icon: const Icon(Icons.edit),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text('Tem certeza?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                ).then((confirmado) {
                  if (confirmado) {
                    Provider.of<ProductProvider>(context, listen: false).removeProduto(produto.id);
                  }
                });
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
