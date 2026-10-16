import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador de Recuperação de Senha (RF003) com gerenciamento de estado via ChangeNotifier.
class RecuperarSenhaController extends ChangeNotifier {
  final txtEmail = TextEditingController();

  SessaoController get _sessao => GetIt.I.get<SessaoController>();

  void limparCampo({bool notificar = true}) {
    txtEmail.clear();
    if (notificar) {
      notifyListeners();
    }
  }

  /// Valida o e-mail conforme RF003 (preenchimento, formato válido e conta existente).
  /// Retorna `null` se válido e associado a uma conta cadastrada, ou a mensagem de erro.
  String? validarESolicitarRecuperacao() {
    final email = txtEmail.text.trim();

    if (email.isEmpty) {
      return 'Por favor, informe o endereço de e-mail cadastrado.';
    }

    if (!validarEmail(email)) {
      return 'O e-mail informado não possui um formato válido.';
    }

    if (!_sessao.existeEmail(email)) {
      return 'Nenhuma conta cadastrada foi encontrada para o e-mail informado.';
    }

    return null;
  }
}