import 'carta.dart';

/// Classe principal do baralho.
class ListaCartas {
  /// Baralho, array contendo cartas.
  List<Carta> cartas;

  /// Construtor da Classe ListaCartas.
  ListaCartas() {
    cartas = [];
    //temporario
    cartas = [];
  }

  /// Adiciona cartas ao baralho a partir de um arquivo Json.
  ListaCartas.fromJson(Map<String, dynamic> json) {
    cartas = [];
    for (var i = 0; i < json['cartas'].length; i++) {
      cartas.add(Carta.fromJson(json['cartas'][i]));
    }
  }

  /// Codifica a lista de cartas em Json
  Map<String, dynamic> toJson() => {
        'cartas': cartas.map((e) => e.toJson()).toList(),
      };

  /// Volta ao estado inicial
  void resetCartas() {
    cartas.forEach((element) {
      element.status = Status.nada;
      element.faceCima = false;
    });
  }

  /// Vira uma carta, alterando o seu status.
  void virarCarta(int indexCarta) {
    cartas[indexCarta].faceCima = !cartas[indexCarta].faceCima;
  }

  /// Adiciona uma carta ao baralho.
  void adicionarCarta(Carta carta) {
    cartas.add(carta);
  }

  /// Remove uma carta do baralho.
  void remover(int indexCarta) {
    cartas.removeAt(indexCarta);
  }

  /// Muda o status da carta index
  void mudarStatus(int indexCarta, Status status) {
    cartas[indexCarta].status = status;
  }

  /// Retorna uma lista com as cartas misturadas
  List<Carta> cartasMisturadas() {
    var cartasAle = cartas.toList();
    cartasAle.shuffle();
    return cartasAle.toList(); //para passar por valor
  }
}
