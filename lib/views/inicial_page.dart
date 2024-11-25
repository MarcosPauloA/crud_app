import 'package:flutter/material.dart';
import 'package:crud_app/routes/routes.dart';

class InicialPage extends StatelessWidget {
  const InicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.CLIENTES),
              child: const Text('Clientes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.PRODUTOS),
              child: const Text('Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
