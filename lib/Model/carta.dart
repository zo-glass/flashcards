/// Classe principal da carta individual.
class Carta {
  /// Texto da face frente.
  String frente;
  /// Texto da face verso.
  String verso;
  /// Status atual da jogada.
  Status status = Status.nada;
  /// Status da posição atual da carta.
  bool faceCima = false;

  /// Construtor da classe Carta
  Carta(this.frente, this.verso);

  /// Construtor a partir de um Json
  Carta.fromJson(Map<String, dynamic> json)
      : frente = json['frente'].toString(),
        verso = json['verso'].toString();

  /// Codifica a carta no formato Json
  Map<String, dynamic> toJson() => {
        'frente': frente,
        'verso': verso,
      };
}

/// Definir um enum
enum Status { nada, acertou, errou }
