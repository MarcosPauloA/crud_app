import 'package:crud_app/models/client.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/routes/routes.dart';
import 'package:crud_app/providers/client_provider.dart';
import 'package:provider/provider.dart';

class ClientWidget extends StatelessWidget {
  final Client cliente;
  const ClientWidget({super.key, required this.cliente});
  @override
  Widget build(BuildContext context) {
    final avatar = cliente.avatarUrl.isEmpty ? const CircleAvatar(child: Icon(Icons.person)) :
    CircleAvatar(backgroundImage: NetworkImage(cliente.avatarUrl));
    return ListTile(
      leading: avatar, title: Text("${cliente.nome} ${cliente.sobrenome}"), subtitle: Text(cliente.email),
      trailing: SizedBox(width: 100, child: Row(children: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.FORMULARIO, arguments: cliente);
            },
            icon: const Icon(Icons.edit),
            color: Colors.orange),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Excluir Cliente'),
                  content: const Text('Tem certeza?'),
                  actions: <Widget>[
                    FloatingActionButton(
                      onPressed: () => Navigator.of(context).pop(false), child: const Text('Não'),
                    ),
                    FloatingActionButton(
                      onPressed: () => Navigator.of(context).pop(true), child: const Text('Sim'),
                    )],),
              ).then((confirmado) => {
                if (confirmado) {
                  Provider.of<ClientProvider>(context, listen: false)
                      .remove(cliente.id)
                }
              });
            },
            icon: const Icon(Icons.delete),
            color: Colors.red),
      ],),),
    );
  }}