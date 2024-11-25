import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/client_provider.dart';
import 'package:crud_app/components/client_widget.dart';
import 'package:crud_app/routes/routes.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientProvider clientes = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Lista de clientes'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.FORMULARIO_CLIENTES);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: clientes.fetchClientesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Ocorreu um erro!'));
          } else {
            return ListView.builder(
              itemCount: clientes.contador,
              itemBuilder: (ctx, i) => ClientWidget(cliente: clientes.peloIndice(i)),
            );
          }
        },
      ),
    );
  }
}
