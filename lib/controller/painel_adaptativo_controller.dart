import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador do Painel Adaptativo e Relatório de Desempenho / Escala SUS.
/// Cumpre RF003 (Inserção no Firestore separada por usuário com >= 5 campos)
/// e RF004 (Recuperação em tempo real via StreamBuilder + ListView na 1ª coleção `avaliacoes_sus`).
class PainelAdaptativoController extends ChangeNotifier {
  double notaSusAtual = 4.5;
  bool salvando = false;
  final txtObservacaoClinica = TextEditingController();

  final List<RegistroAvaliacaoModel> _historicoAvaliacoes = [
    const RegistroAvaliacaoModel(
      uid: 'demo_uid',
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

  /// Stream em tempo real da coleção `avaliacoes_sus` filtrada pelo `uid` do usuário logado (RF004).
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAvaliacoesUsuario(
    String uid,
  ) {
    return FirebaseFirestore.instance
        .collection('avaliacoes_sus')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  /// Valida e insere um novo registro de avaliação clínica/usabilidade (SUS)
  /// na coleção `avaliacoes_sus` do Cloud Firestore, separado por usuário (RF003).
  Future<String?> registrarAvaliacao(SessaoController sessao) async {
    final texto = txtObservacaoClinica.text.trim();
    if (texto.isEmpty) {
      return 'Informe uma observação pedagógica ou clínica antes de salvar o registro.';
    }

    final agora = DateTime.now();
    final horarioFormatado =
        '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year} '
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';

    final uid = sessao.uidUsuarioAtual;
    final novoRegistro = RegistroAvaliacaoModel(
      uid: uid,
      nomeAvaliado: sessao.nomeUsuarioAtual,
      dataHora: horarioFormatado,
      notaSatisfacaoSus: notaSusAtual,
      observacao: texto,
      nivelConfigurado: sessao.nivelAdaptativoAtual,
      criadoEmMs: agora.millisecondsSinceEpoch,
    );

    salvando = true;
    notifyListeners();

    try {
      if (uid.isNotEmpty && uid != 'demo_uid') {
        await FirebaseFirestore.instance
            .collection('avaliacoes_sus')
            .add(novoRegistro.toMap());
      }
      _historicoAvaliacoes.insert(0, novoRegistro);
      txtObservacaoClinica.clear();
      salvando = false;
      notifyListeners();
      return null;
    } catch (e) {
      salvando = false;
      notifyListeners();
      return 'Falha ao inserir os dados no Firebase Firestore: $e';
    }
  }
}
