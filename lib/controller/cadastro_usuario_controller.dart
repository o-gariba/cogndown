import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador de Cadastro de Usuário (RF002) integrado ao Firebase Authentication
/// e à coleção `usuarios` do Cloud Firestore.
class CadastroUsuarioController extends ChangeNotifier {
  final txtNome = TextEditingController();
  final txtEmail = TextEditingController();
  final txtTelefone = TextEditingController();
  final txtSenha = TextEditingController();
  final txtConfirmarSenha = TextEditingController();

  bool senhaOculta = true;
  bool confirmarSenhaOculta = true;
  bool carregando = false;

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
    carregando = false;
    if (notificar) {
      notifyListeners();
    }
  }

  /// Realiza todas as validações exigidas no RF002, registra no Firebase Auth
  /// e armazena os campos adicionais na coleção `usuarios` do Cloud Firestore.
  /// Retorna `null` em caso de sucesso, ou a mensagem de erro apropriada.
  Future<String?> validarECadastrar() async {
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

    if (senha.length < 6) {
      return 'A senha deve possuir no mínimo 6 caracteres para ser segura.';
    }

    if (senha != confirmarSenha) {
      return 'Os campos de senha e confirmação de senha devem ser iguais.';
    }

    carregando = true;
    notifyListeners();

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final uid = cred.user?.uid ?? '';
      await cred.user?.updateDisplayName(nome);

      final novoUsuario = UsuarioModel(
        uid: uid,
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
      );

      // RF002: Armazena as informações adicionais na coleção `usuarios` do Firestore
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .set(novoUsuario.toMap());
      }

      _sessao.definirUsuarioLogado(novoUsuario);
      limparCampos();
      return null;
    } on FirebaseAuthException catch (e) {
      carregando = false;
      notifyListeners();
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este endereço de e-mail já está cadastrado no sistema.';
        case 'weak-password':
          return 'A senha informada é muito fraca (mínimo de 6 caracteres).';
        case 'invalid-email':
          return 'O endereço de e-mail informado não é válido.';
        case 'network-request-failed':
          return 'Falha de conexão com a internet. Verifique sua rede.';
        default:
          return 'Erro ao registrar usuário no Firebase (${e.code}).';
      }
    } catch (_) {
      carregando = false;
      if (_sessao.existeEmail(email)) {
        notifyListeners();
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
}
