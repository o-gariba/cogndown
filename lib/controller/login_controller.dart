import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador de Login (RF001) com gerenciamento de estado via ChangeNotifier.
class LoginController extends ChangeNotifier {
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();

  bool senhaOculta = true;

  SessaoController get _sessao => GetIt.I.get<SessaoController>();

  /// Alterna a exibição/ocultação dos caracteres da senha.
  void alternarVisibilidadeSenha() {
    senhaOculta = !senhaOculta;
    notifyListeners();
  }

  /// Preenche rapidamente as credenciais da conta padrão para agilizar testes.
  void preencherContaDemonstracao() {
    txtEmail.text = 'pedro.santos@fatec.sp.gov.br';
    txtSenha.text = '123456';
    notifyListeners();
  }

  /// Limpa os campos do formulário de login.
  void limparCampos() {
    txtEmail.clear();
    txtSenha.clear();
    senhaOculta = true;
    notifyListeners();
  }

  /// Valida os campos conforme RF001 e tenta autenticar o usuário.
  /// Retorna `null` em caso de sucesso, ou a mensagem de erro apropriada.
  String? validarELogar() {
    final email = txtEmail.text.trim();
    final senha = txtSenha.text;

    if (email.isEmpty || senha.isEmpty) {
      return 'Por favor, preencha os campos de e-mail e senha.';
    }

    if (!validarEmail(email)) {
      return 'O e-mail informado não possui um formato válido.';
    }

    final autenticado = _sessao.autenticar(email, senha);
    if (!autenticado) {
      return 'Credenciais inválidas. Verifique seu e-mail e senha.';
    }

    txtSenha.clear();
    senhaOculta = true;
    notifyListeners();
    return null;
  }
}