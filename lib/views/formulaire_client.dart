import 'package:crud_app/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/client_provider.dart';

class Formulaire extends StatefulWidget {
  const Formulaire({super.key});

  @override
  State<Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends State<Formulaire> {
  final _formulario = GlobalKey<FormState>();
  final Map<String, String> _dadosFormulario = {};

  void _carregaDadosFormulario(Client cliente) {
    _dadosFormulario['id'] = cliente.id.toString();
    _dadosFormulario['nome'] = cliente.nome;
    _dadosFormulario['sobrenome'] = cliente.sobrenome;
    _dadosFormulario['email'] = cliente.email;
    _dadosFormulario['idade'] = cliente.idade.toString();
    _dadosFormulario['avatarURL'] = cliente.avatarUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? cliente = ModalRoute.of(context)!.settings.arguments;
    if (cliente != null) {
      _carregaDadosFormulario(cliente as Client);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ModalRoute.of(context)!.settings.arguments != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de clientes'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_formulario.currentState!.validate()) {
                _formulario.currentState!.save();
                if (isEditing) {
                  Provider.of<ClientProvider>(context, listen: false).putCliente(
                    Client(
                      id: _dadosFormulario['id'] ?? '',
                      nome: _dadosFormulario['nome'] ?? '',
                      sobrenome: _dadosFormulario['sobrenome'] ?? '',
                      email: _dadosFormulario['email'] ?? '',
                      idade: int.parse(_dadosFormulario['idade'] ?? '0'),
                      avatarUrl: _dadosFormulario['avatarURL'] ?? '',
                    ),
                  );
                } else {
                  Provider.of<ClientProvider>(context, listen: false).addCliente(
                    Client(
                      id: '',
                      nome: _dadosFormulario['nome'] ?? '',
                      sobrenome: _dadosFormulario['sobrenome'] ?? '',
                      email: _dadosFormulario['email'] ?? '',
                      idade: int.parse(_dadosFormulario['idade'] ?? '0'),
                      avatarUrl: _dadosFormulario['avatarURL'] ?? '',
                    ),
                  );
                }
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formulario,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _dadosFormulario['nome'],
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Nome Inválido';
                  }
                  if (valor.trim().length < 3 || valor.trim().length > 25) {
                    return "Nome deve ter entre 3 e 25 caracteres";
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['nome'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['sobrenome'],
                decoration: const InputDecoration(labelText: 'Sobrenome'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Sobrenome Inválido';
                  }
                  if (valor.trim().length < 3 || valor.trim().length > 25) {
                    return "Sobrenome deve ter entre 3 e 25 caracteres";
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['sobrenome'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['email'],
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valor)) {
                    return 'Email Inválido';
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['email'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['idade'],
                decoration: const InputDecoration(labelText: 'Idade'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty || int.tryParse(valor) == null || int.parse(valor) <= 0 || int.parse(valor) >= 120) {
                    return 'Idade deve ser um número positivo menor que 120';
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['idade'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['avatarURL'],
                decoration: const InputDecoration(labelText: 'URL do Avatar'),
                validator: (valor) {
                  if (valor != null && valor.isNotEmpty && !Uri.parse(valor).isAbsolute) {
                    return 'URL Inválida';
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['avatarURL'] = valor!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
