import 'package:crud_app/components/client_widget.dart';
import 'package:crud_app/providers/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/routes/routes.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({super.key});
  @override
  Widget build(BuildContext context) {
    final ClientProvider clientes = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Lista de clientes'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.FORMULARIO);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: clientes.contador,
          itemBuilder: (ctx, i) =>
              ClientWidget(cliente: clientes.peloIndice(i))),
    );
  }
}