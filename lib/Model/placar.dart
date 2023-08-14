/// Classe do placar.
class Placar {
  /// Número de acertos do usuário.
  int acertos = 0;

  /// Número de erros do usuário.
  int erros = 0;

  /// Número total de jogadas.
  int total = 0;

  /// Porcentagem de acertos do usuário.
  double p_acertos = 0;

  /// Porcentagem de erros do usuário.
  double p_erros = 0;

  /// Porcentagem total de jogadas.
  double p_total = 0;

  /// Incrementa as variáveis de acerto.
  void acertou() {
    acertos += 1;
    _adicionaTotal();
  }

  /// Incrementa as variáveis de erro.
  void errou() {
    erros += 1;
    _adicionaTotal();
  }

  // Incrementa a variável de total.
  void _adicionaTotal() {
    total += 1;
    _calculaP();
  }

  /// Reseta todas as variáveis do jogo.
  void resetar() {
    acertos = 0;
    erros = 0;
    total = 0;
    p_acertos = 0;
    p_erros = 0;
    p_total = 0;
  }

  /// Calcula a porcentagem.
  void _calculaP() {
    p_acertos = acertos / total;
    p_erros = erros / total;
    p_total = total / total;
  }
}
