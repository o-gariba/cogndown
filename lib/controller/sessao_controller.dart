import 'package:flutter/material.dart';
import '../model/modelos_app.dart';

/// Controlador Global de Sessão, Autenticação, Gamificação e Motor de Adaptação Híbrida.
/// Registrado como Singleton no GetIt para compartilhar estado entre todas as telas.
class SessaoController extends ChangeNotifier {
  static const List<String> niveisDisponiveis = [
    'Básico',
    'Intermediário',
    'Avançado',
  ];

  final List<UsuarioModel> _usuariosCadastrados = [
    UsuarioModel(
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

  /// Verifica se um e-mail já está associado a alguma conta cadastrada (RF002 e RF003).
  bool existeEmail(String email) {
    final emailNormalizado = email.trim().toLowerCase();
    return _usuariosCadastrados.any(
      (u) => u.email.trim().toLowerCase() == emailNormalizado,
    );
  }

  /// Realiza a autenticação do usuário e define a sessão ativa (RF001).
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

  /// Cadastra um novo usuário em memória com progresso próprio zerado e inicia sua sessão (RF002).
  bool cadastrarNovoUsuario(UsuarioModel novoUsuario) {
    if (existeEmail(novoUsuario.email)) {
      return false;
    }
    _usuariosCadastrados.add(novoUsuario);
    _usuarioLogado = novoUsuario;
    notifyListeners();
    return true;
  }

  /// Atualiza o nome do usuário autenticado, refletindo em todas as telas (RF005).
  void atualizarNomeUsuario(String novoNome) {
    if (_usuarioLogado == null) return;
    _usuarioLogado!.nome = novoNome.trim();
    notifyListeners();
  }

  /// Encerra a sessão do usuário atual.
  void logout() {
    _usuarioLogado = null;
    notifyListeners();
  }

  /// Adiciona estrelas à pontuação gamificada do usuário ativo.
  void adicionarEstrelas(int quantidade) {
    final u = _usuarioAtivoOuPadrao;
    u.estrelasTotais = (u.estrelasTotais + quantidade).clamp(0, 99999);
    notifyListeners();
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
      return false;
    } else {
      u.modulosConcluidosIds.add(moduloId);
      u.estrelasTotais += estrelas;
      notifyListeners();
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
    return true;
  }

  /// Registra a expressão de uma frase na Prancha CAA (RF006.2).
  void registrarFraseCaa({int estrelasBonus = 5}) {
    final u = _usuarioAtivoOuPadrao;
    u.frasesConstruidasCaa += 1;
    u.estrelasTotais += estrelasBonus;
    notifyListeners();
  }

  /// Registra um acerto simples no Treino Cognitivo.
  void registrarAcertoCognitivo({int estrelasBonus = 10}) {
    final u = _usuarioAtivoOuPadrao;
    u.acertosCognitivos += 1;
    u.tentativasCognitivasTotais += 1;
    u.estrelasTotais += estrelasBonus;
    notifyListeners();
  }

  /// Motor de Adaptação Híbrida Automática (RF006.3):
  /// - 2 acertos seguidos promovem o nível ('Básico' -> 'Intermediário' -> 'Avançado').
  /// - 2 erros seguidos ativam dicas visuais contínuas e reduzem um nível para evitar frustração.
  /// Retorna uma mensagem explicativa quando o algoritmo realiza um ajuste adaptativo.
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

      if (u.acertosConsecutivos >= 2) {
        final idxAtual = niveisDisponiveis.indexOf(u.nivelAdaptativoAtual);
        if (idxAtual >= 0 && idxAtual < niveisDisponiveis.length - 1) {
          final proximoNivel = niveisDisponiveis[idxAtual + 1];
          u.nivelAdaptativoAtual = proximoNivel;
          u.acertosConsecutivos = 0;
          mensagemAdaptativa =
              'Evolução Adaptativa! Você acertou 2 vezes seguidas e avançou para o nível $proximoNivel!';
        } else {
          u.acertosConsecutivos = 0;
          mensagemAdaptativa =
              'Excelente desempenho! Você manteve o domínio no nível máximo (${u.nivelAdaptativoAtual})!';
        }
      }
    } else {
      u.errosConsecutivos += 1;
      u.acertosConsecutivos = 0;

      if (u.errosConsecutivos >= 2) {
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
  }

  /// Ativa ou desativa manualmente o suporte automático de dicas visuais (RF006.5).
  void alternarDicasVisuais(bool ativo) {
    _usuarioAtivoOuPadrao.exibirDicasVisuais = ativo;
    notifyListeners();
  }

  /// Atualiza a meta diária de estímulos cognitivos/comunicacionais (RF006.5).
  void alterarMetaDiaria(double novaMeta) {
    _usuarioAtivoOuPadrao.metaDiariaAtividades = novaMeta;
    notifyListeners();
  }
}
