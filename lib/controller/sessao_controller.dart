import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/modelos_app.dart';

/// Controlador Global de Sessão, Autenticação, Gamificação e Motor de Adaptação Híbrida.
/// Integrado ao Firebase Authentication e Cloud Firestore (coleção `usuarios`).
class SessaoController extends ChangeNotifier {
  static const List<String> niveisDisponiveis = [
    'Básico',
    'Intermediário',
    'Avançado',
  ];

  static const int metaAcertosParaEvoluir = 5;
  static const int metaErrosParaSuporte = 2;

  final List<UsuarioModel> _usuariosCadastrados = [
    UsuarioModel(
      uid: 'demo_uid',
      nome: 'Pedro Garibaldi Santos',
      email: 'pedro.santos@fatec.sp.gov.br',
      telefone: '(16) 99999-0000',
      senha: '123456',
      estrelasTotais: 15,
      frasesConstruidasCaa: 3,
      acertosCognitivos: 4,
      tentativasCognitivasTotais: 5,
      nivelAdaptativoAtual: 'Básico',
      exibirDicasVisuais: true,
      metaDiariaAtividades: 5.0,
      modulosConcluidosIds: {'mod_1'},
    ),
  ];

  UsuarioModel? _usuarioLogado;

  /// Fallback seguro caso alguma tela interna seja aberta diretamente no preview.
  UsuarioModel get _usuarioAtivoOuPadrao =>
      _usuarioLogado ?? _usuariosCadastrados.first;

  List<UsuarioModel> get usuariosCadastrados =>
      List.unmodifiable(_usuariosCadastrados);

  UsuarioModel? get usuarioLogado => _usuarioLogado;

  bool get estaAutenticado => _usuarioLogado != null;

  String get uidUsuarioAtual {
    try {
      final authUid = FirebaseAuth.instance.currentUser?.uid;
      if (authUid != null && authUid.isNotEmpty) {
        return authUid;
      }
    } catch (_) {}
    return _usuarioLogado?.uid ?? '';
  }

  String get nomeUsuarioAtual => _usuarioLogado?.nome ?? 'Convidado';

  String get emailUsuarioAtual => _usuarioLogado?.email ?? '';

  // Getters reativos lendo diretamente do usuário ativo (isolamento por conta)
  int get estrelasTotais => _usuarioAtivoOuPadrao.estrelasTotais;
  int get frasesConstruidasCaa => _usuarioAtivoOuPadrao.frasesConstruidasCaa;
  int get acertosCognitivos => _usuarioAtivoOuPadrao.acertosCognitivos;
  int get tentativasCognitivasTotais =>
      _usuarioAtivoOuPadrao.tentativasCognitivasTotais;
  int get acertosConsecutivos => _usuarioAtivoOuPadrao.acertosConsecutivos;
  int get errosConsecutivos => _usuarioAtivoOuPadrao.errosConsecutivos;
  String get nivelAdaptativoAtual =>
      _usuarioAtivoOuPadrao.nivelAdaptativoAtual;
  bool get exibirDicasVisuais => _usuarioAtivoOuPadrao.exibirDicasVisuais;
  double get metaDiariaAtividades =>
      _usuarioAtivoOuPadrao.metaDiariaAtividades;
  Set<String> get modulosConcluidosIds =>
      _usuarioAtivoOuPadrao.modulosConcluidosIds;
  Set<String> get conquistasResgatadasIds =>
      _usuarioAtivoOuPadrao.conquistasResgatadasIds;

  int get totalAtividadesRealizadas =>
      frasesConstruidasCaa + acertosCognitivos;

  /// Calcula a taxa percentual de precisão cognitiva (0 a 100%).
  int get taxaPrecisaoCognitivaPercentual {
    final tentativas = tentativasCognitivasTotais;
    if (tentativas <= 0) return 0;
    return ((acertosCognitivos / tentativas) * 100).round().clamp(0, 100);
  }

  double get progressoMetaDiaria {
    if (metaDiariaAtividades <= 0) return 1.0;
    final p = totalAtividadesRealizadas / metaDiariaAtividades;
    return p > 1.0 ? 1.0 : p;
  }

  /// Define diretamente o usuário logado a partir do Firebase Auth / Firestore.
  void definirUsuarioLogado(UsuarioModel usuario) {
    _usuarioLogado = usuario;
    final idx = _usuariosCadastrados.indexWhere(
      (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
    );
    if (idx >= 0) {
      _usuariosCadastrados[idx] = usuario;
    } else {
      _usuariosCadastrados.add(usuario);
    }
    notifyListeners();
  }

  /// Carrega o documento do usuário na coleção `usuarios` do Cloud Firestore,
  /// ou cria um registro inicial se ainda não existir (RF001 e RF002).
  Future<void> carregarUsuarioDoFirestore(
    User user, {
    String? nomePadrao,
    String? telefonePadrao,
  }) async {
    final docRef =
        FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
    final docSnap = await docRef.get();

    if (docSnap.exists && docSnap.data() != null) {
      final usuario = UsuarioModel.fromMap(docSnap.data()!, user.uid);
      definirUsuarioLogado(usuario);
    } else {
      final email = user.email ?? '';
      final ehContaDemo =
          email.toLowerCase() == 'pedro.santos@fatec.sp.gov.br';
      final novoUsuario = UsuarioModel(
        uid: user.uid,
        nome: nomePadrao ??
            user.displayName ??
            (ehContaDemo ? 'Pedro Garibaldi Santos' : email.split('@').first),
        email: email,
        telefone: telefonePadrao ?? (ehContaDemo ? '(16) 99999-0000' : ''),
        estrelasTotais: ehContaDemo ? 15 : 0,
        frasesConstruidasCaa: ehContaDemo ? 3 : 0,
        acertosCognitivos: ehContaDemo ? 4 : 0,
        tentativasCognitivasTotais: ehContaDemo ? 5 : 0,
        modulosConcluidosIds: ehContaDemo ? {'mod_1'} : <String>{},
      );
      await docRef.set(novoUsuario.toMap());
      definirUsuarioLogado(novoUsuario);
    }
  }

  /// Sincroniza em background os dados e progresso do usuário logado na coleção `usuarios`.
  Future<void> sincronizarUsuarioNoFirestore() async {
    final u = _usuarioLogado;
    if (u == null || u.uid.isEmpty || u.uid == 'demo_uid') return;
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(u.uid)
          .set(u.toMap(), SetOptions(merge: true));
    } catch (_) {}
  }

  /// Verifica se um e-mail já está associado a alguma conta cadastrada em memória.
  bool existeEmail(String email) {
    final emailNormalizado = email.trim().toLowerCase();
    return _usuariosCadastrados.any(
      (u) => u.email.trim().toLowerCase() == emailNormalizado,
    );
  }

  /// Realiza a autenticação local (fallback de testes) e define a sessão ativa.
  bool autenticar(String email, String senha) {
    final emailNormalizado = email.trim().toLowerCase();
    for (final usuario in _usuariosCadastrados) {
      if (usuario.email.trim().toLowerCase() == emailNormalizado &&
          usuario.senha == senha) {
        _usuarioLogado = usuario;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  /// Cadastra um novo usuário em memória e define como sessão ativa.
  bool cadastrarNovoUsuario(UsuarioModel novoUsuario) {
    _usuariosCadastrados.removeWhere(
      (u) => u.email.trim().toLowerCase() == novoUsuario.email.trim().toLowerCase(),
    );
    _usuariosCadastrados.add(novoUsuario);
    _usuarioLogado = novoUsuario;
    notifyListeners();
    return true;
  }

  /// Atualiza o nome do usuário autenticado, refletindo em todas as telas e no Firestore (RF005).
  void atualizarNomeUsuario(String novoNome) {
    if (_usuarioLogado == null) return;
    _usuarioLogado!.nome = novoNome.trim();
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Encerra a sessão do usuário atual no Firebase Auth e em memória.
  void logout() {
    _usuarioLogado = null;
    notifyListeners();
    try {
      FirebaseAuth.instance.signOut();
    } catch (_) {}
  }

  /// Adiciona estrelas à pontuação gamificada do usuário ativo.
  void adicionarEstrelas(int quantidade) {
    final u = _usuarioAtivoOuPadrao;
    u.estrelasTotais = (u.estrelasTotais + quantidade).clamp(0, 99999);
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Verifica se um módulo da trilha foi concluído pelo usuário ativo.
  bool moduloEstaConcluido(String moduloId) {
    return _usuarioAtivoOuPadrao.modulosConcluidosIds.contains(moduloId);
  }

  /// Marca ou desmarca um módulo da trilha como concluído (+5 / -5 estrelas).
  bool alternarConclusaoModulo(String moduloId, {int estrelas = 5}) {
    final u = _usuarioAtivoOuPadrao;
    final jaConcluido = u.modulosConcluidosIds.contains(moduloId);
    if (jaConcluido) {
      u.modulosConcluidosIds.remove(moduloId);
      u.estrelasTotais = (u.estrelasTotais - estrelas).clamp(0, 99999);
      notifyListeners();
      sincronizarUsuarioNoFirestore();
      return false;
    } else {
      u.modulosConcluidosIds.add(moduloId);
      u.estrelasTotais += estrelas;
      notifyListeners();
      sincronizarUsuarioNoFirestore();
      return true;
    }
  }

  /// Verifica se uma conquista gamificada já foi resgatada pelo usuário ativo.
  bool conquistaEstaResgatada(String conquistaId) {
    return _usuarioAtivoOuPadrao.conquistasResgatadasIds.contains(conquistaId);
  }

  /// Resgata uma conquista caso o usuário possua as estrelas necessárias.
  bool resgatarConquista(
    ConquistaModel conquista, {
    int estrelasBonus = 5,
  }) {
    final u = _usuarioAtivoOuPadrao;
    if (u.conquistasResgatadasIds.contains(conquista.id)) {
      return false;
    }
    if (u.estrelasTotais < conquista.estrelasNecessarias) {
      return false;
    }
    u.conquistasResgatadasIds.add(conquista.id);
    u.estrelasTotais += estrelasBonus;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
    return true;
  }

  /// Registra a expressão de uma frase na Prancha CAA (RF006.2).
  void registrarFraseCaa({int estrelasBonus = 5}) {
    final u = _usuarioAtivoOuPadrao;
    u.frasesConstruidasCaa += 1;
    u.estrelasTotais += estrelasBonus;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Registra um acerto simples no Treino Cognitivo.
  void registrarAcertoCognitivo({int estrelasBonus = 10}) {
    final u = _usuarioAtivoOuPadrao;
    u.acertosCognitivos += 1;
    u.tentativasCognitivasTotais += 1;
    u.estrelasTotais += estrelasBonus;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Motor de Adaptação Híbrida Automática (RF006.3):
  /// - 5 acertos seguidos promovem o nível ('Básico' -> 'Intermediário' -> 'Avançado').
  /// - 2 erros seguidos ativam dicas visuais contínuas e reduzem um nível para evitar frustração.
  String? processarResultadoCognitivo({
    required bool acertou,
    int estrelasPorAcerto = 10,
  }) {
    final u = _usuarioAtivoOuPadrao;
    u.tentativasCognitivasTotais += 1;
    String? mensagemAdaptativa;

    if (acertou) {
      u.acertosCognitivos += 1;
      u.estrelasTotais += estrelasPorAcerto;
      u.acertosConsecutivos += 1;
      u.errosConsecutivos = 0;

      if (u.acertosConsecutivos >= metaAcertosParaEvoluir) {
        final idxAtual = niveisDisponiveis.indexOf(u.nivelAdaptativoAtual);
        if (idxAtual >= 0 && idxAtual < niveisDisponiveis.length - 1) {
          final proximoNivel = niveisDisponiveis[idxAtual + 1];
          u.nivelAdaptativoAtual = proximoNivel;
          u.acertosConsecutivos = 0;
          mensagemAdaptativa =
              'Evolução Adaptativa! Você acertou $metaAcertosParaEvoluir vezes seguidas e avançou para o nível $proximoNivel!';
        } else {
          u.acertosConsecutivos = 0;
          mensagemAdaptativa =
              'Excelente desempenho! Você manteve o domínio no nível máximo (${u.nivelAdaptativoAtual})!';
        }
      }
    } else {
      u.errosConsecutivos += 1;
      u.acertosConsecutivos = 0;

      if (u.errosConsecutivos >= metaErrosParaSuporte) {
        u.exibirDicasVisuais = true;
        final idxAtual = niveisDisponiveis.indexOf(u.nivelAdaptativoAtual);
        if (idxAtual > 0) {
          final nivelAnterior = niveisDisponiveis[idxAtual - 1];
          u.nivelAdaptativoAtual = nivelAnterior;
          u.errosConsecutivos = 0;
          mensagemAdaptativa =
              'Suporte Adaptativo ativado: ajustamos o nível para $nivelAnterior e ativamos as dicas visuais para apoiar seu aprendizado.';
        } else {
          u.errosConsecutivos = 0;
          mensagemAdaptativa =
              'Suporte Adaptativo: as dicas visuais automáticas foram ativadas para auxiliar na resolução.';
        }
      }
    }

    notifyListeners();
    sincronizarUsuarioNoFirestore();
    return mensagemAdaptativa;
  }

  /// Atualiza manualmente o nível de dificuldade do motor adaptativo (RF006.5).
  void alterarNivelAdaptativo(String novoNivel) {
    if (!niveisDisponiveis.contains(novoNivel)) return;
    final u = _usuarioAtivoOuPadrao;
    u.nivelAdaptativoAtual = novoNivel;
    u.acertosConsecutivos = 0;
    u.errosConsecutivos = 0;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Ativa ou desativa manualmente o suporte automático de dicas visuais (RF006.5).
  void alternarDicasVisuais(bool ativo) {
    _usuarioAtivoOuPadrao.exibirDicasVisuais = ativo;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }

  /// Atualiza a meta diária de estímulos cognitivos/comunicacionais (RF006.5).
  void alterarMetaDiaria(double novaMeta) {
    _usuarioAtivoOuPadrao.metaDiariaAtividades = novaMeta;
    notifyListeners();
    sincronizarUsuarioNoFirestore();
  }
}
