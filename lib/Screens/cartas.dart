import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../ViewModel/cartasViewModel.dart';

import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

/// Definir um enum.
enum Opcoes { exportar, novo, importar }

/// Classe principal das castas (View).
class Cartas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Baralho')),
        body: SingleChildScrollView(
          child: Column(
            /*mainAxisAlignment: MainAxisAlignment.center,*/
            children: <Widget>[_Lista(), _Botoes(context)],
          ),
        ));
  }
}

class _Lista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: context.watch<CartasViewModel>().listaCartas.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                    child: Text(
                        '${context.watch<CartasViewModel>().listaCartas[index].frente}\n${context.watch<CartasViewModel>().listaCartas[index].verso}')),
              ),
              key:
                  ValueKey(context.watch<CartasViewModel>().listaCartas[index]),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (DismissDirection direction) {
                context.read<CartasViewModel>().removerCarta(
                    context.read<CartasViewModel>().listaCartas[index]);
                context.read<CartasViewModel>().salvarCartas();
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }
}

class _Botoes extends StatelessWidget {
  var viewModel;

  _Botoes(BuildContext context) {
    viewModel = context.read<CartasViewModel>();
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final path = await context.read<CartasViewModel>().localPath;
    await Share.shareFiles(['$path/listaCartas.txt'],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      context.read<CartasViewModel>().importarCartas(file);
    } else {
      print("entrou no erro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _onShare(context),
                child: _Botao("Export"),
              ),
              ElevatedButton(
                onPressed: () {
                  String frente;
                  String verso;
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text('Add'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Frente'),
                                  TextField(
                                    onChanged: (String key) {
                                      frente = key;
                                    },
                                  ),
                                  Text('Verso'),
                                  TextField(
                                    onChanged: (String key) {
                                      verso = key;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    if (frente != null && verso != null) {
                                      context
                                          .read<CartasViewModel>()
                                          .adicionarCarta(frente, verso);
                                      context
                                          .read<CartasViewModel>()
                                          .salvarCartas();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('ADD'))
                            ],
                          ));
                },
                child: _Botao("+"),
              ),
              ElevatedButton(
                onPressed: () => _pickFile(context),
                child: _Botao("Import"),
              ),
            ]),
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
