import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador do Mural de Conquistas e Recompensas Gamificadas (RF006.4 e RF007 - ListView).
class ConquistasController extends ChangeNotifier {
  static const List<String> filtros = [
    'Todas',
    'Disponíveis',
    'Conquistadas',
  ];

  final List<ConquistaModel> _catalogoConquistas = const [
    ConquistaModel(
      id: 'conq_1',
      titulo: 'Primeiros Passos',
      descricao: 'Alcançou 10 estrelas explorando os módulos do CognDown.',
      estrelasNecessarias: 10,
      icone: Icons.flag_outlined,
    ),
    ConquistaModel(
      id: 'conq_2',
      titulo: 'Voz Ativa (CAA)',
      descricao:
          'Acumulou 20 estrelas expressando necessidades e emoções na Prancha CAA.',
      estrelasNecessarias: 20,
      icone: Icons.record_voice_over_outlined,
    ),
    ConquistaModel(
      id: 'conq_3',
      titulo: 'Mente Curiosa',
      descricao:
          'Alcançou 30 estrelas praticando os desafios de estímulo cognitivo.',
      estrelasNecessarias: 30,
      icone: Icons.lightbulb_outline,
    ),
    ConquistaModel(
      id: 'conq_4',
      titulo: 'Comunicador Autônomo',
      descricao:
          'Atingiu 45 estrelas combinando construção de frases e associação visual.',
      estrelasNecessarias: 45,
      icone: Icons.forum_outlined,
    ),
    ConquistaModel(
      id: 'conq_5',
      titulo: 'Mestre da Adaptação',
      descricao:
          'Chegou a 60 estrelas evoluindo pelos níveis do motor adaptativo.',
      estrelasNecessarias: 60,
      icone: Icons.trending_up,
    ),
    ConquistaModel(
      id: 'conq_6',
      titulo: 'Campeão da Inclusão',
      descricao:
          'Atingiu a marca histórica de 80 estrelas de engajamento cognitivo e comunicacional!',
      estrelasNecessarias: 80,
      icone: Icons.workspace_premium_outlined,
    ),
  ];

  String filtroSelecionado = 'Todas';

  List<ConquistaModel> get todasConquistas => _catalogoConquistas;

  void selecionarFiltro(String novoFiltro) {
    filtroSelecionado = novoFiltro;
    notifyListeners();
  }

  /// Determina o título gamificado do aprendiz com base nas estrelas acumuladas.
  String obterTituloAprendiz(int estrelas) {
    if (estrelas >= 60) return 'Mestre da Adaptação';
    if (estrelas >= 35) return 'Comunicador Brilhante';
    if (estrelas >= 15) return 'Explorador Cognitivo';
    return 'Aprendiz Iniciante';
  }

  /// Retorna a lista de conquistas filtrada conforme a seleção do usuário.
  List<ConquistaModel> obterConquistasFiltradas(SessaoController sessao) {
    return _catalogoConquistas.where((c) {
      final resgatada = sessao.conquistaEstaResgatada(c.id);
      final disponivel =
          !resgatada && sessao.estrelasTotais >= c.estrelasNecessarias;

      if (filtroSelecionado == 'Conquistadas') return resgatada;
      if (filtroSelecionado == 'Disponíveis') return disponivel;
      return true;
    }).toList();
  }

  int totalResgatadas(SessaoController sessao) {
    return _catalogoConquistas
        .where((c) => sessao.conquistaEstaResgatada(c.id))
        .length;
  }

  /// Tenta resgatar uma medalha e concede +5 estrelas de bônus motivacional.
  bool resgatarMedalha(ConquistaModel conquista, SessaoController sessao) {
    final sucesso = sessao.resgatarConquista(conquista, estrelasBonus: 5);
    if (sucesso) {
      notifyListeners();
    }
    return sucesso;
  }

  void resetarEstado({bool notificar = false}) {
    filtroSelecionado = 'Todas';
    if (notificar) {
      notifyListeners();
    }
  }
}
