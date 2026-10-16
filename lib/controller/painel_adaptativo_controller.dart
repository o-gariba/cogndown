import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador do Painel Adaptativo e Relatório de Desempenho / Escala SUS (RF006.5).
class PainelAdaptativoController extends ChangeNotifier {
  double notaSusAtual = 4.5;
  final txtObservacaoClinica = TextEditingController();

  final List<RegistroAvaliacaoModel> _historicoAvaliacoes = [
    const RegistroAvaliacaoModel(
      nomeAvaliado: 'Pedro Garibaldi Santos',
      dataHora: 'Pré-teste Inicial',
      notaSatisfacaoSus: 4.5,
      observacao:
          'Excelente engajamento visual com os cartões da Prancha CAA e boa resposta às dicas cognitivas.',
      nivelConfigurado: 'Básico',
    ),
  ];

  List<RegistroAvaliacaoModel> get historicoAvaliacoes =>
      List.unmodifiable(_historicoAvaliacoes);

  /// Escore SUS convertido na escala de 0 a 100 pontos.
  int get escoreSusAtualEscala100 =>
      ((notaSusAtual - 1.0) * 25.0).round().clamp(0, 100);

  void atualizarNotaSus(double novaNota) {
    notaSusAtual = novaNota;
    notifyListeners();
  }

  /// Valida e salva um novo registro de avaliação clínica/usabilidade (SUS) em memória.
  String? registrarAvaliacao(SessaoController sessao) {
    final texto = txtObservacaoClinica.text.trim();
    if (texto.isEmpty) {
      return 'Informe uma observação pedagógica ou clínica antes de salvar o registro.';
    }

    final agora = DateTime.now();
    final horarioFormatado =
        '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year} '
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';

    _historicoAvaliacoes.insert(
      0,
      RegistroAvaliacaoModel(
        nomeAvaliado: sessao.nomeUsuarioAtual,
        dataHora: horarioFormatado,
        notaSatisfacaoSus: notaSusAtual,
        observacao: texto,
        nivelConfigurado: sessao.nivelAdaptativoAtual,
      ),
    );

    txtObservacaoClinica.clear();
    notifyListeners();
    return null;
  }
}
