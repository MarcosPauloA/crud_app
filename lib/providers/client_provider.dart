import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/client.dart';

class ClientProvider with ChangeNotifier {
  // NÃO ESQUEÇA DE COLOCAR O IP LOCAL
  final String _baseUrl = 'http://192.168.2.174:3000/clientes';
  final Map<String, Client> _itens = {};
  Future<void>? _fetchClientesFuture;

  List<Client> get todos {
    return [..._itens.values];
  }

  int get contador {
    return _itens.length;
  }

  Client peloIndice(int i) {
    return _itens.values.elementAt(i);
  }

  Future<void>? get fetchClientesFuture {
    if (_fetchClientesFuture == null) {
      _fetchClientesFuture = fetchClientes();
    }
    return _fetchClientesFuture;
  }

  Future<void> fetchClientes() async {
    try {
      print('Fetching clients... ${DateTime.now()}');
      final response = await http.get(Uri.parse(_baseUrl));
      print('Response status: ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      print('Received data: $data');
      _itens.clear();
      for (var item in data) {
        _itens.putIfAbsent(
          item['id'].toString(),
              () => Client(
            id: item['id'].toString(),
            nome: item['nome'],
            sobrenome: item['sobrenome'],
            email: item['email'],
            idade: item['idade'],
            avatarUrl: item['foto'],
          ),
        );
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching clients: $error');
    }
  }

  Future<void> addCliente(Client cliente) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': cliente.nome,
          'sobrenome': cliente.sobrenome,
          'email': cliente.email,
          'idade': cliente.idade,
          'foto': cliente.avatarUrl,
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final id = json.decode(response.body)['id'].toString();
        _itens.putIfAbsent(
          id,
              () => Client(
            id: id,
            nome: cliente.nome,
            sobrenome: cliente.sobrenome,
            email: cliente.email,
            idade: cliente.idade,
            avatarUrl: cliente.avatarUrl,
          ),
        );
        notifyListeners();
      } else {
        print('Failed to add client. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding client: $error');
    }
  }



  Future<void> putCliente(Client cliente) async {
    if (cliente.id.trim().isNotEmpty && _itens.containsKey(cliente.id)) {
      await http.put(
        Uri.parse('$_baseUrl/${cliente.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': cliente.nome,
          'sobrenome': cliente.sobrenome,
          'email': cliente.email,
          'idade': cliente.idade,
          'foto': cliente.avatarUrl,
        }),
      );
      _itens.update(cliente.id, (_) => cliente);
      notifyListeners();
    }
  }

  Future<void> removeCliente(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
    _itens.remove(id);
    notifyListeners();
  }
}
