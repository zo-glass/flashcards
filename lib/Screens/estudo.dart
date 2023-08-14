import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/modo.dart';
import '../Model/carta.dart';
import '../ViewModel/cartasViewModel.dart';

import 'package:flip_card/flip_card.dart';

/// Definir um enum
enum EstadoJogo { analisando, conclusao, terminado }

/// Status atual da posição carta para animação.
GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

/// Classe principal da tela de estudo (View).
class Estudo extends StatefulWidget {
  @override
  _EstudoState createState() => _EstudoState();
}

class _EstudoState extends State<Estudo> {
  EstadoJogo _estadoJogo = EstadoJogo.analisando;

  void mudarEstado(EstadoJogo estado) {
    setState(() {
      _estadoJogo = estado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as Modo;
    return Scaffold(
      appBar: AppBar(
        title: (arg == Modo.sequencial)
            ? Text("Estudo Sequencial")
            : Text("Estudo Aleatório"),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _UIPlacar(),
            _UICarta(context.watch<CartasViewModel>().cartaAtual),
            _Botoes(context, _estadoJogo, mudarEstado)
          ],
        ),
      ),
    );
  }
}

class _UIPlacar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: Text(
          '''
Acertos: ${context.watch<CartasViewModel>().placar.acertos} 
Erros: ${context.watch<CartasViewModel>().placar.erros}
Total: ${context.watch<CartasViewModel>().placar.total}
          ''',
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

class _UICarta extends StatelessWidget {
  final Carta carta;

  _UICarta(this.carta);

  @override
  Widget build(BuildContext context) {
    return carta != null
        ? Container(
            width: 300,
            height: 300,
            child: Card(
              elevation: 0.0,
              margin: EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
              color: Color(0x00000000),
              child: FlipCard(
                key: cardKey,
                flipOnTouch: false,
                direction: FlipDirection.HORIZONTAL,
                speed: 1000,
                front: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff00bcd4),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(carta.frente,
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff00bcd4),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(carta.verso,
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Text(
            "Aguardando cartas",
            style: TextStyle(fontSize: 27),
          );
  }
}

class _Botoes extends StatelessWidget {
  EstadoJogo _estadoJogo;
  Function _mudarEstado;

  Map<EstadoJogo, List<Widget>> arrayDeBotoes;

  _Botoes(BuildContext context, EstadoJogo estadoJogo, Function mudarEstado) {
    this._estadoJogo = estadoJogo;
    this._mudarEstado = mudarEstado;

    var viewModel = context.read<CartasViewModel>();

    arrayDeBotoes = {
      EstadoJogo.analisando: [
        ElevatedButton(
          onPressed: () {
            cardKey.currentState.toggleCard();
            viewModel.virarCarta();
            _mudarEstado(EstadoJogo.conclusao);
          },
          child: _Botao("Virar Carta"),
        ),
      ],
      EstadoJogo.conclusao: [
        ElevatedButton(
          onPressed: () {
            viewModel.resultadoAcerto(true);
            _mudarEstado(EstadoJogo.terminado);
          },
          child: _Botao("Acertei"),
        ),
        ElevatedButton(
          onPressed: () {
            viewModel.resultadoAcerto(false);
            _mudarEstado(EstadoJogo.terminado);
          },
          child: _Botao("Errei"),
        ),
      ],
      EstadoJogo.terminado: [
        ElevatedButton(
          onPressed: () {
            if (viewModel.isUltimaCarta) {
              Navigator.pushNamed(context, '/score');
            } else {
              cardKey.currentState.toggleCard();
              viewModel.proxCarta();
              _mudarEstado(EstadoJogo.analisando);
            }
          },
          child: _Botao("Proxima carta"),
        ),
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: arrayDeBotoes[_estadoJogo]),
      ),
    );
  }
}

class _Botao extends StatelessWidget {
  final String text;

  _Botao(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
