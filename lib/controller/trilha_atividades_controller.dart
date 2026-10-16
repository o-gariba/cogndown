import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador da Trilha de Módulos e Atividades (RF006.1 e RF007 - ListView).
class TrilhaAtividadesController extends ChangeNotifier {
  static const List<String> categoriasFiltro = [
    'Todos',
    'Comunicação',
    'Cognitivo',
  ];

  final List<ModuloAtividadeModel> _modulos = const [
    ModuloAtividadeModel(
      id: 'mod_1',
      titulo: 'Prancha de Necessidades Básicas',
      descricao:
          'Construa frases rápidas sobre sede, fome e rotina usando cartões visuais (CAA).',
      categoria: 'Comunicação',
      nivelDificuldade: 'Básico',
      rotaDestino: 'prancha_comunicacao',
      icone: Icons.record_voice_over_outlined,
    ),
    ModuloAtividadeModel(
      id: 'mod_2',
      titulo: 'Expressão de Emoções e Sentimentos',
      descricao:
          'Comunique como está se sentindo e peça ajuda ou interação social.',
      categoria: 'Comunicação',
      nivelDificuldade: 'Intermediário',
      rotaDestino: 'prancha_comunicacao',
      icone: Icons.emoji_emotions_outlined,
    ),
    ModuloAtividadeModel(
      id: 'mod_3',
      titulo: 'Associação Visual do Cotidiano',
      descricao:
          'Estimule a atenção e memória associando objetos e situações do dia a dia.',
      categoria: 'Cognitivo',
      nivelDificuldade: 'Básico',
      rotaDestino: 'treino_cognitivo',
      icone: Icons.psychology_outlined,
    ),
    ModuloAtividadeModel(
      id: 'mod_4',
      titulo: 'Reconhecimento de Rotinas e Categorias',
      descricao:
          'Exercite funções executivas identificando hábitos saudáveis e grupos semânticos.',
      categoria: 'Cognitivo',
      nivelDificuldade: 'Intermediário',
      rotaDestino: 'treino_cognitivo',
      icone: Icons.extension_outlined,
    ),
    ModuloAtividadeModel(
      id: 'mod_5',
      titulo: 'Autonomia, Sílabas e Situações Sociais',
      descricao:
          'Desafios adaptativos avançados de consciência silábica e tomada de decisão.',
      categoria: 'Cognitivo',
      nivelDificuldade: 'Avançado',
      rotaDestino: 'treino_cognitivo',
      icone: Icons.groups_outlined,
    ),
    ModuloAtividadeModel(
      id: 'mod_6',
      titulo: 'Mural de Medalhas e Conquistas',
      descricao:
          'Acompanhe suas estrelas acumuladas e resgate recompensas motivacionais.',
      categoria: 'Comunicação',
      nivelDificuldade: 'Básico',
      rotaDestino: 'conquistas',
      icone: Icons.emoji_events_outlined,
    ),
  ];

  String categoriaSelecionada = 'Todos';
  bool filtrarApenasNivelAtual = false;

  List<ModuloAtividadeModel> get todosModulos => _modulos;

  /// Retorna os módulos filtrados pela categoria e, se ativo, pelo nível adaptativo atual.
  List<ModuloAtividadeModel> obterModulosFiltrados(SessaoController sessao) {
    return _modulos.where((m) {
      final bateCategoria =
          categoriaSelecionada == 'Todos' ||
          m.categoria == categoriaSelecionada;
      final bateNivel =
          !filtrarApenasNivelAtual ||
          m.nivelDificuldade == sessao.nivelAdaptativoAtual;
      return bateCategoria && bateNivel;
    }).toList();
  }

  void selecionarCategoria(String categoria) {
    categoriaSelecionada = categoria;
    notifyListeners();
  }

  void alternarFiltroNivelAtual() {
    filtrarApenasNivelAtual = !filtrarApenasNivelAtual;
    notifyListeners();
  }

  void resetarEstado({bool notificar = false}) {
    categoriaSelecionada = 'Todos';
    filtrarApenasNivelAtual = false;
    if (notificar) {
      notifyListeners();
    }
  }
}
