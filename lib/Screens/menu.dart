import 'package:flashcards/ViewModel/cartasViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/modo.dart';

/// Classe principal da tela do Menu (View).
class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _TituloMenu(),
            _OpcoesMenu(),
          ],
        ),
      ),
    );
  }
}

class _TituloMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: Text(
          "FlashCards",
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}

class _OpcoesMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BotaoMenu("Estudo Sequencial", () {
          context.read<CartasViewModel>().iniciaBaralhoSeq();
          Navigator.pushNamed(context, '/estudo', arguments: Modo.sequencial);
        }),
        _BotaoMenu("Estudo Aleatório", () {
          context.read<CartasViewModel>().iniciaBaralhoAle();
          Navigator.pushNamed(context, '/estudo', arguments: Modo.aleatorio);
        }),
        _BotaoMenu("Cards", () => Navigator.pushNamed(context, '/cartas')),
      ],
    );
  }
}

class _BotaoMenu extends StatelessWidget {
  final _textStyle = const TextStyle(
    fontSize: 30,
  );

  final String _texto;
  final Function _handler;

  _BotaoMenu(this._texto, this._handler);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () => _handler(),
        child: Text(
          _texto,
          style: _textStyle,
        ),
      ),
    );
  }
}
