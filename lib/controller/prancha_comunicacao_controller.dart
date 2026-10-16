import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador da Prancha de Comunicação Alternativa - CAA (RF006.2 e RF007 - GridView).
class PranchaComunicacaoController extends ChangeNotifier {
  static const List<String> categorias = [
    'Todas',
    'Necessidades',
    'Emoções',
    'Ações',
    'Social',
  ];

  final List<CartaoComunicacaoModel> _catalogoCartoes = const [
    CartaoComunicacaoModel(
      id: 'caa_1',
      texto: 'Eu quero',
      categoria: 'Necessidades',
      icone: Icons.record_voice_over,
    ),
    CartaoComunicacaoModel(
      id: 'caa_2',
      texto: 'Beber água',
      categoria: 'Necessidades',
      icone: Icons.local_drink_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_3',
      texto: 'Comer',
      categoria: 'Necessidades',
      icone: Icons.restaurant_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_4',
      texto: 'Ir ao banheiro',
      categoria: 'Necessidades',
      icone: Icons.wc_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_5',
      texto: 'Estou feliz',
      categoria: 'Emoções',
      icone: Icons.sentiment_very_satisfied,
    ),
    CartaoComunicacaoModel(
      id: 'caa_6',
      texto: 'Estou cansado',
      categoria: 'Emoções',
      icone: Icons.bedtime_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_7',
      texto: 'Tenho dúvida',
      categoria: 'Emoções',
      icone: Icons.help_outline,
    ),
    CartaoComunicacaoModel(
      id: 'caa_8',
      texto: 'Vamos brincar',
      categoria: 'Ações',
      icone: Icons.toys_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_9',
      texto: 'Preciso de ajuda',
      categoria: 'Ações',
      icone: Icons.front_hand_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_10',
      texto: 'Mais devagar',
      categoria: 'Ações',
      icone: Icons.speed_outlined,
    ),
    CartaoComunicacaoModel(
      id: 'caa_11',
      texto: 'Obrigado',
      categoria: 'Social',
      icone: Icons.favorite_border,
    ),
    CartaoComunicacaoModel(
      id: 'caa_12',
      texto: 'Gostei muito',
      categoria: 'Social',
      icone: Icons.thumb_up_outlined,
    ),
  ];

  String categoriaSelecionada = 'Todas';
  final List<CartaoComunicacaoModel> fraseEmConstrucao = [];
  final List<String> historicoFrasesRecentes = [];

  List<CartaoComunicacaoModel> get cartoesFiltrados {
    if (categoriaSelecionada == 'Todas') {
      return _catalogoCartoes;
    }
    return _catalogoCartoes
        .where((c) => c.categoria == categoriaSelecionada)
        .toList();
  }

  String get textoFraseAtual =>
      fraseEmConstrucao.map((c) => c.texto).join(' ');

  void selecionarCategoria(String novaCategoria, {bool notificar = true}) {
    if (!categorias.contains(novaCategoria)) return;
    categoriaSelecionada = novaCategoria;
    if (notificar) {
      notifyListeners();
    }
  }

  void adicionarCartao(CartaoComunicacaoModel cartao) {
    fraseEmConstrucao.add(cartao);
    notifyListeners();
  }

  void removerUltimoCartao() {
    if (fraseEmConstrucao.isEmpty) return;
    fraseEmConstrucao.removeLast();
    notifyListeners();
  }

  void limparFrase() {
    if (fraseEmConstrucao.isEmpty) return;
    fraseEmConstrucao.clear();
    notifyListeners();
  }

  void resetarEstado({bool notificar = false}) {
    categoriaSelecionada = 'Todas';
    fraseEmConstrucao.clear();
    historicoFrasesRecentes.clear();
    if (notificar) {
      notifyListeners();
    }
  }

  /// Expressa a frase montada na prancha, registra na sessão (+5 estrelas) e salva no histórico.
  String? expressarFrase(SessaoController sessao) {
    if (fraseEmConstrucao.isEmpty) {
      return null;
    }
    final fraseFinal = textoFraseAtual;
    historicoFrasesRecentes.remove(fraseFinal);
    historicoFrasesRecentes.insert(0, fraseFinal);
    if (historicoFrasesRecentes.length > 5) {
      historicoFrasesRecentes.removeLast();
    }
    sessao.registrarFraseCaa(estrelasBonus: 5);
    fraseEmConstrucao.clear();
    notifyListeners();
    return fraseFinal;
  }

  /// Permite repetir rapidamente uma frase do histórico recente com 1 toque.
  String repetirFraseHistorico(String frase, SessaoController sessao) {
    sessao.registrarFraseCaa(estrelasBonus: 5);
    notifyListeners();
    return frase;
  }
}
