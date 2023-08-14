import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import '../Model/listaCartas.dart';
import '../Model/placar.dart';
import '../Model/carta.dart';

/// Classe principal da ViewModel.
class CartasViewModel extends ChangeNotifier {
  var _baralho = ListaCartas();
  var _placar = Placar();
  List<Carta> _baralhoTemp;
  Carta _cartaAtual;

  /// Pega a localização padrão de documentos da apliação.
  Future<String> get localPath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return directory;
  }

  /// Pega o arquivo padrão de pessistência.
  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/listaCartas.txt');
  }

  /// Carrega as cartas lidas ao array.
  Future<void> carregarCartas() async {
    try {
      final file = await localFile;

      // Read the file
      final contents = await file.readAsString();

      _baralho = ListaCartas.fromJson(jsonDecode(contents));
      print(_baralho.cartas);
    } catch (e) {
      _baralho = ListaCartas();
    }
    notifyListeners();
  }

  /// Le cartas de um arquivo Json
  Future<void> importarCartas(File file) async {
    try {
      final contents = await file.readAsString();
      final listaImp = ListaCartas.fromJson(jsonDecode(contents));

      listaImp.cartas.forEach((element) {
        _baralho.adicionarCarta(element);
      });
      salvarCartas();
    } catch (e) {
      print("Erro");
    }
    notifyListeners();
  }

  /// Persistência
  void salvarCartas() async {
    final file = await localFile;
    // Write the file
    file.writeAsString(jsonEncode(_baralho.toJson()));
  }

  //gets para a View nao alterar o ViewModel
  /// Carta atual.
  get cartaAtual => _cartaAtual;
  /// Placar.
  get placar => _placar;
  /// Baralho.
  get listaCartas => _baralho.cartas;

  get _indexCartaBaralhoTemp => _baralhoTemp.indexOf(_cartaAtual);

  get _indexCartaAtual => _baralho.cartas
      .indexWhere((element) => element.frente == _cartaAtual.frente);

  /// Retorna se é a última carta.
  get isUltimaCarta {
    return (_indexCartaBaralhoTemp + 1) == _baralhoTemp.length;
  }

  /// Carrega o baralho de modo sequencial.
  void iniciaBaralhoSeq() async {
    await _resetarJogo();
    _baralhoTemp = _baralho.cartas;
    if (_baralho.cartas.length > 0) {
      _cartaAtual = _baralhoTemp[0];
    }
    notifyListeners();
  }

  /// Carrega o baralho de modo aleatório.
  void iniciaBaralhoAle() async {
    await _resetarJogo();
    _baralhoTemp = _baralho.cartasMisturadas();
    if (_baralho.cartas.length > 0) {
      _cartaAtual = _baralhoTemp[0];
    }
    notifyListeners();
  }

  /// Passa para a próxima carta.
  void proxCarta() {
    if (_baralho.cartas.length == 0) return;
    int proxIndex;
    if (_cartaAtual == null) {
      _cartaAtual = _baralhoTemp[0];
    } else {
      proxIndex = _indexCartaBaralhoTemp + 1;
      if (proxIndex < _baralhoTemp.length) {
        _cartaAtual = _baralhoTemp[proxIndex];
      }
    }
    notifyListeners();
  }

  /// Vira a carta atual.
  void virarCarta() {
    if (_indexCartaAtual == -1) return;
    _baralho.virarCarta(_indexCartaAtual);
    notifyListeners();
  }

  /// Adiciona uma carta na lista de cartas.
  void adicionarCarta(String frente, String verso) {
    var novaCarta = Carta(frente, verso);
    _baralho.adicionarCarta(novaCarta);
    salvarCartas();
    notifyListeners();
  }

  /// Deleta uma carta da lista de cartas.
  void removerCarta(Carta carta) {
    var indexCarta = _baralho.cartas.indexOf(carta);
    _baralho.remover(indexCarta);
    salvarCartas();
    if (_baralho.cartas.length == 0) {
      _cartaAtual = null;
    }
    notifyListeners();
  }

  /// Resultado da jogada atual do usuário.
  void resultadoAcerto(bool acertou) {
    if (_indexCartaAtual == -1) return;
    if (acertou) {
      _placar.acertou();
      _baralho.mudarStatus(_indexCartaAtual, Status.acertou);
    } else {
      _placar.errou();
      _baralho.mudarStatus(_indexCartaAtual, Status.errou);
    }
    notifyListeners();
  }

  /// Reseta o jogo, voltando ao estado inicial.
  Future<void> _resetarJogo() async {
    await carregarCartas();
    _placar.resetar();
    _baralho.resetCartas();
  }
}
