import 'package:flutter/material.dart';

/// Utilitário padrão para validação de formato de e-mail (RF001, RF002 e RF003).
bool validarEmail(String email) {
  final texto = email.trim();
  if (texto.isEmpty) return false;
  final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
  return regex.hasMatch(texto);
}

/// Modelo de Usuário para Autenticação, Cadastro, Perfil e Progresso Isolado por Conta.
class UsuarioModel {
  String nome;
  final String email;
  final String telefone;
  final String senha;

  // Estado de Gamificação e Desempenho isolado por usuário
  int estrelasTotais;
  int frasesConstruidasCaa;
  int acertosCognitivos;
  int tentativasCognitivasTotais;
  int acertosConsecutivos;
  int errosConsecutivos;

  // Parâmetros do Motor Adaptativo isolados por usuário
  String nivelAdaptativoAtual; // 'Básico', 'Intermediário', 'Avançado'
  bool exibirDicasVisuais;
  double metaDiariaAtividades;

  // Conjuntos de IDs de progresso individual
  final Set<String> modulosConcluidosIds;
  final Set<String> conquistasResgatadasIds;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    this.estrelasTotais = 0,
    this.frasesConstruidasCaa = 0,
    this.acertosCognitivos = 0,
    this.tentativasCognitivasTotais = 0,
    this.acertosConsecutivos = 0,
    this.errosConsecutivos = 0,
    this.nivelAdaptativoAtual = 'Básico',
    this.exibirDicasVisuais = true,
    this.metaDiariaAtividades = 5.0,
    Set<String>? modulosConcluidosIds,
    Set<String>? conquistasResgatadasIds,
  }) : modulosConcluidosIds = modulosConcluidosIds ?? <String>{},
       conquistasResgatadasIds = conquistasResgatadasIds ?? <String>{};
}

/// Modelo de Módulo/Atividade para a Trilha Principal (RF006.1 e RF007 - ListView).
class ModuloAtividadeModel {
  final String id;
  final String titulo;
  final String descricao;
  final String categoria; // 'Comunicação' ou 'Cognitivo'
  final String nivelDificuldade; // 'Básico', 'Intermediário' ou 'Avançado'
  final String rotaDestino;
  final IconData icone;

  const ModuloAtividadeModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.nivelDificuldade,
    required this.rotaDestino,
    required this.icone,
  });
}

/// Modelo de Cartão Pictográfico para a Prancha CAA (RF006.2 e RF007 - GridView).
class CartaoComunicacaoModel {
  final String id;
  final String texto;
  final String categoria; // 'Necessidades', 'Emoções', 'Ações', 'Social'
  final IconData icone;

  const CartaoComunicacaoModel({
    required this.id,
    required this.texto,
    required this.categoria,
    required this.icone,
  });
}

/// Modelo de Desafio para o Treino Cognitivo Adaptativo (RF006.3).
class DesafioCognitivoModel {
  final String id;
  final String pergunta;
  final String dica;
  final IconData iconeEstimulo;
  final List<String> opcoes;
  final int indiceCorreto;
  final String nivel; // 'Básico', 'Intermediário' ou 'Avançado'

  const DesafioCognitivoModel({
    required this.id,
    required this.pergunta,
    required this.dica,
    required this.iconeEstimulo,
    required this.opcoes,
    required this.indiceCorreto,
    required this.nivel,
  });
}

/// Modelo de Medalha/Conquista para o Mural Gamificado (RF006.4).
class ConquistaModel {
  final String id;
  final String titulo;
  final String descricao;
  final int estrelasNecessarias;
  final IconData icone;

  const ConquistaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.estrelasNecessarias,
    required this.icone,
  });
}

/// Modelo de Registro de Avaliação Terapêutica / Escala SUS (RF006.5).
class RegistroAvaliacaoModel {
  final String nomeAvaliado;
  final String dataHora;
  final double notaSatisfacaoSus; // 1.0 a 5.0
  final String observacao;
  final String nivelConfigurado;

  const RegistroAvaliacaoModel({
    required this.nomeAvaliado,
    required this.dataHora,
    required this.notaSatisfacaoSus,
    required this.observacao,
    required this.nivelConfigurado,
  });

  /// Converte a nota Likert (1.0 a 5.0) para o índice padronizado SUS (0 a 100 pontos).
  int get escoreSusEscala100 =>
      ((notaSatisfacaoSus - 1.0) * 25.0).round().clamp(0, 100);

  /// Classificação qualitativa do Escore SUS conforme literatura de usabilidade.
  String get classificacaoSus {
    final score = escoreSusEscala100;
    if (score >= 80) return 'Excelente';
    if (score >= 68) return 'Bom';
    if (score >= 50) return 'Aceitável';
    return 'Atenção Clínica';
  }
}
