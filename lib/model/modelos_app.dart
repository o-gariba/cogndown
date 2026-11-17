import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Utilitário padrão para validação de formato de e-mail (RF001, RF002 e RF003).
bool validarEmail(String email) {
  final texto = email.trim();
  if (texto.isEmpty) return false;
  final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
  return regex.hasMatch(texto);
}

/// Modelo de Usuário para Autenticação, Cadastro (Coleção `usuarios` - RF002),
/// Perfil e Progresso Isolado por Conta.
class UsuarioModel {
  final String uid;
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
    this.uid = '',
    required this.nome,
    required this.email,
    required this.telefone,
    this.senha = '',
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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'estrelasTotais': estrelasTotais,
      'frasesConstruidasCaa': frasesConstruidasCaa,
      'acertosCognitivos': acertosCognitivos,
      'tentativasCognitivasTotais': tentativasCognitivasTotais,
      'acertosConsecutivos': acertosConsecutivos,
      'errosConsecutivos': errosConsecutivos,
      'nivelAdaptativoAtual': nivelAdaptativoAtual,
      'exibirDicasVisuais': exibirDicasVisuais,
      'metaDiariaAtividades': metaDiariaAtividades,
      'modulosConcluidosIds': modulosConcluidosIds.toList(),
      'conquistasResgatadasIds': conquistasResgatadasIds.toList(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map, String docUid) {
    final modulosRaw = map['modulosConcluidosIds'];
    final conquistasRaw = map['conquistasResgatadasIds'];

    return UsuarioModel(
      uid: (map['uid'] as String?) ?? docUid,
      nome: (map['nome'] as String?) ?? 'Usuário',
      email: (map['email'] as String?) ?? '',
      telefone: (map['telefone'] as String?) ?? '',
      estrelasTotais: (map['estrelasTotais'] as num?)?.toInt() ?? 0,
      frasesConstruidasCaa: (map['frasesConstruidasCaa'] as num?)?.toInt() ?? 0,
      acertosCognitivos: (map['acertosCognitivos'] as num?)?.toInt() ?? 0,
      tentativasCognitivasTotais:
          (map['tentativasCognitivasTotais'] as num?)?.toInt() ?? 0,
      acertosConsecutivos: (map['acertosConsecutivos'] as num?)?.toInt() ?? 0,
      errosConsecutivos: (map['errosConsecutivos'] as num?)?.toInt() ?? 0,
      nivelAdaptativoAtual:
          (map['nivelAdaptativoAtual'] as String?) ?? 'Básico',
      exibirDicasVisuais: (map['exibirDicasVisuais'] as bool?) ?? true,
      metaDiariaAtividades:
          (map['metaDiariaAtividades'] as num?)?.toDouble() ?? 5.0,
      modulosConcluidosIds: modulosRaw is Iterable
          ? modulosRaw.map((e) => e.toString()).toSet()
          : <String>{},
      conquistasResgatadasIds: conquistasRaw is Iterable
          ? conquistasRaw.map((e) => e.toString()).toSet()
          : <String>{},
    );
  }
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

/// Modelo de Registro de Avaliação Terapêutica / Escala SUS (Coleção `avaliacoes_sus` - RF003 e RF004).
/// Possui mais de 5 campos e isolamento por usuário via campo `uid`.
class RegistroAvaliacaoModel {
  final String uid;
  final String nomeAvaliado;
  final String dataHora;
  final double notaSatisfacaoSus; // 1.0 a 5.0
  final String observacao;
  final String nivelConfigurado;
  final int criadoEmMs;

  const RegistroAvaliacaoModel({
    this.uid = '',
    required this.nomeAvaliado,
    required this.dataHora,
    required this.notaSatisfacaoSus,
    required this.observacao,
    required this.nivelConfigurado,
    this.criadoEmMs = 0,
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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nomeAvaliado': nomeAvaliado,
      'dataHora': dataHora,
      'notaSatisfacaoSus': notaSatisfacaoSus,
      'escoreSus100': escoreSusEscala100,
      'classificacaoSus': classificacaoSus,
      'observacao': observacao,
      'nivelConfigurado': nivelConfigurado,
      'criadoEmMs': criadoEmMs,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }

  factory RegistroAvaliacaoModel.fromMap(Map<String, dynamic> map) {
    int timestampMs = (map['criadoEmMs'] as num?)?.toInt() ?? 0;
    if (timestampMs == 0 && map['criadoEm'] is Timestamp) {
      timestampMs = (map['criadoEm'] as Timestamp).millisecondsSinceEpoch;
    }
    return RegistroAvaliacaoModel(
      uid: (map['uid'] as String?) ?? '',
      nomeAvaliado: (map['nomeAvaliado'] as String?) ?? 'Usuário',
      dataHora: (map['dataHora'] as String?) ?? '',
      notaSatisfacaoSus: (map['notaSatisfacaoSus'] as num?)?.toDouble() ?? 4.5,
      observacao: (map['observacao'] as String?) ?? '',
      nivelConfigurado: (map['nivelConfigurado'] as String?) ?? 'Básico',
      criadoEmMs: timestampMs,
    );
  }
}

/// Modelo de Registro de Frase Expressa na Prancha CAA (Coleção `frases_caa` - RF003 e RF004).
/// Possui mais de 5 campos e isolamento por usuário via campo `uid`.
class RegistroFraseCaaModel {
  final String uid;
  final String nomeUsuario;
  final String frase;
  final String categoriaFiltro;
  final int quantidadeCartoes;
  final int estrelasGanhas;
  final String dataHora;
  final int criadoEmMs;

  const RegistroFraseCaaModel({
    required this.uid,
    required this.nomeUsuario,
    required this.frase,
    required this.categoriaFiltro,
    required this.quantidadeCartoes,
    required this.estrelasGanhas,
    required this.dataHora,
    this.criadoEmMs = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nomeUsuario': nomeUsuario,
      'frase': frase,
      'categoriaFiltro': categoriaFiltro,
      'quantidadeCartoes': quantidadeCartoes,
      'estrelasGanhas': estrelasGanhas,
      'dataHora': dataHora,
      'criadoEmMs': criadoEmMs,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }

  factory RegistroFraseCaaModel.fromMap(Map<String, dynamic> map) {
    int timestampMs = (map['criadoEmMs'] as num?)?.toInt() ?? 0;
    if (timestampMs == 0 && map['criadoEm'] is Timestamp) {
      timestampMs = (map['criadoEm'] as Timestamp).millisecondsSinceEpoch;
    }
    return RegistroFraseCaaModel(
      uid: (map['uid'] as String?) ?? '',
      nomeUsuario: (map['nomeUsuario'] as String?) ?? 'Usuário',
      frase: (map['frase'] as String?) ?? '',
      categoriaFiltro: (map['categoriaFiltro'] as String?) ?? 'Todas',
      quantidadeCartoes: (map['quantidadeCartoes'] as num?)?.toInt() ?? 1,
      estrelasGanhas: (map['estrelasGanhas'] as num?)?.toInt() ?? 5,
      dataHora: (map['dataHora'] as String?) ?? '',
      criadoEmMs: timestampMs,
    );
  }
}
