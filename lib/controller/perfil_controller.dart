import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'sessao_controller.dart';

/// Controlador de Perfil do Usuário (RF005) com gerenciamento de estado via ChangeNotifier.
class PerfilController extends ChangeNotifier {
  static const int tamanhoMinimoNome = 3;

  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();

  SessaoController get _sessao => GetIt.I.get<SessaoController>();

  bool get estaAutenticado => _sessao.estaAutenticado;

  /// Carrega os dados atuais do usuário autenticado nos campos do formulário.
  void carregarDadosUsuario({bool notificar = false}) {
    final usuario = _sessao.usuarioLogado;
    if (usuario != null) {
      txtNome.text = usuario.nome;
      txtEmail.text = usuario.email;
    } else {
      txtNome.clear();
      txtEmail.clear();
    }
    if (notificar) {
      notifyListeners();
    }
  }

  /// Restaura o nome para o valor atualmente salvo na sessão (opção Cancelar).
  void restaurarEdicao() {
    carregarDadosUsuario(notificar: true);
  }

  /// Valida e atualiza o nome do usuário autenticado conforme RF005.
  /// Retorna `null` em caso de sucesso, ou a mensagem de erro apropriada.
  String? validarESalvarPerfil() {
    if (!_sessao.estaAutenticado) {
      return 'Acesso negado. Faça login para atualizar o perfil.';
    }

    final novoNome = txtNome.text.trim();

    if (novoNome.isEmpty) {
      return 'Por favor, preencha o campo Nome do usuário.';
    }

    if (novoNome.length < tamanhoMinimoNome) {
      return 'O nome deve possuir no mínimo $tamanhoMinimoNome caracteres.';
    }

    _sessao.atualizarNomeUsuario(novoNome);
    txtNome.text = _sessao.nomeUsuarioAtual;
    notifyListeners();
    return null;
  }
}