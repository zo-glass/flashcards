import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:flashcards/ViewModel/cartasViewModel.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Classe principal da tela de score (View).
class Score extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Score"),
      ),
      body: Center(
          /*child: _TxtScore(),*/
          child: ListView(
        children: <Widget>[
          new CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 10.0,
            animation: true,
            animationDuration: 2000,
            percent: context.watch<CartasViewModel>().placar.p_erros,
            header: new Text("Erros",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            center: new Text(
                (context.watch<CartasViewModel>().placar.erros).toString(),
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            footer: new Text(
                "${(context.watch<CartasViewModel>().placar.p_erros * 100).toStringAsFixed(2)}%",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.red,
          ),
          new CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 10.0,
            animation: true,
            animationDuration: 2000,
            percent: context.watch<CartasViewModel>().placar.p_acertos,
            header: new Text("Acertos",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            center: new Text(
                context.watch<CartasViewModel>().placar.acertos.toString(),
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            footer: new Text(
                "${(context.watch<CartasViewModel>().placar.p_acertos * 100).toStringAsFixed(2)}%",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.green,
          ),
          new CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 10.0,
            animation: true,
            animationDuration: 2000,
            percent: context.watch<CartasViewModel>().placar.p_total,
            header: new Text("Total",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            center: new Text(
                context.watch<CartasViewModel>().placar.total.toString(),
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            footer: new Text(
                "${(context.watch<CartasViewModel>().placar.p_total * 100).toStringAsFixed(2)}%",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.blue,
            //backgroundColor: Colors.yellow,
          )
        ],
      )),
    );
  }
}
