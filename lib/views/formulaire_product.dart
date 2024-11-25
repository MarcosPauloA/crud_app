import 'package:crud_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/product_provider.dart';

class FormulaireProduct extends StatefulWidget {
  const FormulaireProduct({super.key});

  @override
  State<FormulaireProduct> createState() => _FormulaireProductState();
}

class _FormulaireProductState extends State<FormulaireProduct> {
  final _formulario = GlobalKey<FormState>();
  final Map<String, String> _dadosFormulario = {};

  void _carregaDadosFormulario(Product product) {
    _dadosFormulario['id'] = product.id.toString();
    _dadosFormulario['nome'] = product.nome;
    _dadosFormulario['descricao'] = product.descricao;
    _dadosFormulario['preco'] = product.preco.toString();
    _dadosFormulario['dataAtualizado'] = product.dataAtualizado.toIso8601String();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? produto = ModalRoute.of(context)!.settings.arguments;
    if (produto != null) {
      _carregaDadosFormulario(produto as Product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ModalRoute.of(context)!.settings.arguments != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de produtos'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_formulario.currentState!.validate()) {
                _formulario.currentState!.save();
                final DateTime dataAtualizado = DateTime.tryParse(_dadosFormulario['dataAtualizado'] ?? '') ?? DateTime.now();
                if (isEditing) {
                  Provider.of<ProductProvider>(context, listen: false).updateProduto(
                    Product(
                      id: _dadosFormulario['id'] ?? '',
                      nome: _dadosFormulario['nome'] ?? '',
                      descricao: _dadosFormulario['descricao'] ?? '',
                      preco: double.parse(_dadosFormulario['preco'] ?? '0'),
                      dataAtualizado: dataAtualizado,
                    ),
                  );
                } else {
                  Provider.of<ProductProvider>(context, listen: false).addProduto(
                    Product(
                      id: '',
                      nome: _dadosFormulario['nome'] ?? '',
                      descricao: _dadosFormulario['descricao'] ?? '',
                      preco: double.parse(_dadosFormulario['preco'] ?? '0'),
                      dataAtualizado: dataAtualizado,
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
                  if (valor.trim().length < 3 || valor.trim().length > 50) {
                    return "Nome deve ter entre 3 e 50 caracteres";
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['nome'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['descricao'],
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Descrição Inválida';
                  }
                  if (valor.trim().length < 5 || valor.trim().length > 100) {
                    return "Descrição deve ter entre 5 e 100 caracteres";
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['descricao'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['preco'],
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty || double.tryParse(valor) == null || double.parse(valor) <= 0) {
                    return 'Preço deve ser um número positivo';
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['preco'] = valor!,
              ),
              TextFormField(
                initialValue: _dadosFormulario['dataAtualizado'],
                decoration: const InputDecoration(labelText: 'Data de Atualização'),
                validator: (valor) {
                  if (valor != null && valor.isNotEmpty && !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(valor)) {
                    return 'Data Inválida (use o formato AAAA-MM-DD)';
                  }
                  return null;
                },
                onSaved: (valor) => _dadosFormulario['dataAtualizado'] = valor!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
