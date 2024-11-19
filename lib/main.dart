import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_app/providers/client_provider.dart';
import 'package:crud_app/views/clients_list.dart';
import 'package:crud_app/views/formulaire.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.grey),
          useMaterial3: true,
        ),
        routes: {
          Routes.INICIAL: (_) => const ClientsList(),
          Routes.FORMULARIO: (_) => Formulaire(), // Certifique-se que o construtor pode ser `const`
        },
      ),
    );
  }
}
