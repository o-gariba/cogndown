import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador de Cadastro de Usuário (RF002) com gerenciamento de estado via ChangeNotifier.
class CadastroUsuarioController extends ChangeNotifier {
  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();
  final txtTelefone = TextEditingController();
  final txtSenha = TextEditingController();
  final txtConfirmarSenha = TextEditingController();

  bool senhaOculta = true;
  bool confirmarSenhaOculta = true;

  SessaoController get _sessao => GetIt.I.get<SessaoController>();

  void alternarVisibilidadeSenha() {
    senhaOculta = !senhaOculta;
    notifyListeners();
  }

  void alternarVisibilidadeConfirmarSenha() {
    confirmarSenhaOculta = !confirmarSenhaOculta;
    notifyListeners();
  }

  void limparCampos({bool notificar = true}) {
    txtNome.clear();
    txtEmail.clear();
    txtTelefone.clear();
    txtSenha.clear();
    txtConfirmarSenha.clear();
    senhaOculta = true;
    confirmarSenhaOculta = true;
    if (notificar) {
      notifyListeners();
    }
  }

  /// Realiza todas as validações exigidas no RF002 e registra o novo usuário.
  /// Retorna `null` em caso de sucesso, ou a mensagem de erro apropriada.
  String? validarECadastrar() {
    final nome = txtNome.text.trim();
    final email = txtEmail.text.trim();
    final telefone = txtTelefone.text.trim();
    final senha = txtSenha.text;
    final confirmarSenha = txtConfirmarSenha.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      return 'Preencha todos os campos obrigatórios para realizar o cadastro.';
    }

    if (!validarEmail(email)) {
      return 'O e-mail informado não possui um formato válido.';
    }

    if (senha != confirmarSenha) {
      return 'Os campos de senha e confirmação de senha devem ser iguais.';
    }

    if (_sessao.existeEmail(email)) {
      return 'Este endereço de e-mail já está cadastrado no sistema.';
    }

    final novoUsuario = UsuarioModel(
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
    );

    _sessao.cadastrarNovoUsuario(novoUsuario);
    limparCampos();
    return null;
  }
}
