import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ViewModel/cartasViewModel.dart';
import './Screens/menu.dart';
import './Screens/estudo.dart';
import './Screens/score.dart';
import './Screens/cartas.dart';

/// Função principal.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartasViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

/// Classe Principal
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Menu(),
        '/estudo': (context) => Estudo(),
        '/score': (context) => Score(),
        '/cartas': (context) => Cartas(),
      },
    );
  }
}
