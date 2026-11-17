import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador de Recuperação de Senha (RF001) integrado ao Firebase Authentication.
class RecuperarSenhaController extends ChangeNotifier {
  final txtEmail = TextEditingController();
  bool carregando = false;

  SessaoController get _sessao => GetIt.I.get<SessaoController>();

  void limparCampo({bool notificar = true}) {
    txtEmail.clear();
    carregando = false;
    if (notificar) {
      notifyListeners();
    }
  }

  /// Valida o e-mail e dispara o e-mail de redefinição de senha via Firebase Auth (RF001).
  /// Retorna `null` em caso de sucesso, ou a mensagem de erro apropriada.
  Future<String?> validarESolicitarRecuperacao() async {
    final email = txtEmail.text.trim();

    if (email.isEmpty) {
      return 'Por favor, informe o endereço de e-mail cadastrado.';
    }

    if (!validarEmail(email)) {
      return 'O e-mail informado não possui um formato válido.';
    }

    carregando = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      carregando = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      carregando = false;
      notifyListeners();
      switch (e.code) {
        case 'user-not-found':
          return 'Nenhuma conta cadastrada foi encontrada para o e-mail informado.';
        case 'invalid-email':
          return 'O endereço de e-mail informado é inválido.';
        case 'network-request-failed':
          return 'Falha de conexão com a internet. Verifique sua rede.';
        default:
          return 'Não foi possível enviar o e-mail de recuperação (${e.code}).';
      }
    } catch (_) {
      carregando = false;
      notifyListeners();
      if (!_sessao.existeEmail(email)) {
        return 'Nenhuma conta cadastrada foi encontrada para o e-mail informado.';
      }
      return null;
    }
  }
}
