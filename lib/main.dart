import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/client_provider.dart';
import 'package:crud_app/providers/product_provider.dart';
import 'package:crud_app/views/inicial_page.dart';
import 'package:crud_app/views/clients_list.dart';
import 'package:crud_app/views/products_list.dart';
import 'package:crud_app/views/formulaire_client.dart';
import 'package:crud_app/views/formulaire_product.dart';
import 'package:crud_app/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ClientProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter CRUD App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.grey),
          useMaterial3: true,
        ),
        initialRoute: Routes.INICIAL,
        routes: {
          Routes.INICIAL: (_) => const InicialPage(),
          Routes.CLIENTES: (_) => const ClientsList(),
          Routes.PRODUTOS: (_) => const ProductsList(),
          Routes.FORMULARIO_CLIENTES: (_) => const Formulaire(),
          Routes.FORMULARIO_PRODUTOS: (_) => const FormulaireProduct(),
        },
      ),
    );
  }
}
