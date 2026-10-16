import 'package:flutter/material.dart';

/// Controlador da tela Sobre (RF004) com gerenciamento de estado via ChangeNotifier.
class SobreController extends ChangeNotifier {
  final String nomeAplicativo = 'CognDown';
  final String tituloEstudo =
      'Desenvolvimento e Avaliação de um Software Adaptativo e Gamificado para o Estímulo de Habilidades Cognitivas e de Comunicação em Indivíduos com Síndrome de Down';

  final String objetivoGeral =
      'Projetar, desenvolver e avaliar um protótipo de software adaptativo e gamificado, com foco na melhoria de habilidades de comunicação (CAA) e no estímulo de funções cognitivas em indivíduos com Síndrome de Down.';

  final List<String> integrantesEquipe = const [
    'Pedro Garibaldi Santos (pedro.santos@fatec.sp.gov.br)',
  ];

  final String disciplina = 'Programação para Dispositivos Móveis';
  final String instituicao =
      'Faculdade de Tecnologia de Ribeirão Preto (FATEC)';
  final String professor = 'Prof. Dr. Rodrigo de Oliveira Plotze';
  final String versao = '1.0.0 (Parte 1 - 2026)';

  final List<String> pilaresMetodologicos = const [
    'Design Centrado no Usuário (DCU) voltado a indivíduos com Síndrome de Down, pais e terapeutas.',
    'Comunicação Alternativa e Aumentativa (CAA) por pranchas pictográficas.',
    'Algoritmos de aprendizagem adaptativa combinados com mecânicas de gamificação.',
    'Avaliação quantitativa baseada na Escala de Usabilidade do Sistema (SUS) e logs de desempenho.',
  ];

  bool exibirDetalhesMetodologia = true;

  void alternarDetalhesMetodologia() {
    exibirDetalhesMetodologia = !exibirDetalhesMetodologia;
    notifyListeners();
  }
}