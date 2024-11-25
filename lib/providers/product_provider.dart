import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final Map<String, Product> _itens = {};
  Future<void>? _fetchProdutosFuture;

  List<Product> get todos {
    return [..._itens.values];
  }

  int get contador {
    return _itens.length;
  }

  Product peloIndice(int i) {
    return _itens.values.elementAt(i);
  }

  // NÃO ESQUEÇA DE COLOCAR O IP LOCAL
  final String urlBase = 'http://192.168.2.174:3000';

  Future<void>? get fetchProdutosFuture {
    if (_fetchProdutosFuture == null) {
      _fetchProdutosFuture = fetchProdutos();
    }
    return _fetchProdutosFuture;
  }

  Future<void> fetchProdutos() async {
    try {
      print('Fetching products from $urlBase/produtos');
      final response = await http.get(Uri.parse('$urlBase/produtos'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Decoded data: $data');
        _itens.clear();
        for (var item in data) {
          _itens.putIfAbsent(
            item['id'].toString(),
                () => Product(
              id: item['id'].toString(),
              nome: item['nome'],
              descricao: item['descricao'],
              preco: double.parse(item['preco'].toString()),
              dataAtualizado: DateTime.parse(item['dataAtualizado']),
            ),
          );
        }
        print('Products loaded: $_itens');
        notifyListeners();
      } else {
        print('Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> addProduto(Product produto) async {
    final response = await http.post(
      Uri.parse('$urlBase/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': produto.nome,
        'descricao': produto.descricao,
        'preco': produto.preco,
        'data_atualizado': produto.dataAtualizado.toIso8601String(),
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final id = json.decode(response.body)['id'].toString();
      _itens.putIfAbsent(
        id,
            () => Product(
          id: id,
          nome: produto.nome,
          descricao: produto.descricao,
          preco: produto.preco,
          dataAtualizado: produto.dataAtualizado,
        ),
      );
      notifyListeners();
    } else {
      print('Failed to add product. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeProduto(String id) async {
    await http.delete(Uri.parse('$urlBase/produtos/$id'));
    _itens.remove(id);
    notifyListeners();
  }

  Future<void> updateProduto(Product produto) async {
    if (produto.id.trim().isNotEmpty && _itens.containsKey(produto.id)) {
      await http.put(
        Uri.parse('$urlBase/produtos/${produto.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': produto.nome,
          'descricao': produto.descricao,
          'preco': produto.preco,
          'data_atualizado': produto.dataAtualizado.toIso8601String(),
        }),
      );
      _itens.update(produto.id, (_) => produto);
      notifyListeners();
    }
  }
}
