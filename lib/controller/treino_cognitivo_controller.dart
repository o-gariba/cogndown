import 'package:flutter/material.dart';

import '../model/modelos_app.dart';
import 'sessao_controller.dart';

/// Controlador do Treino Cognitivo Adaptativo (RF006.3) com Adaptação Híbrida.
class TreinoCognitivoController extends ChangeNotifier {
  final List<DesafioCognitivoModel> _bancoDesafios = const [
    // Nível Básico (5 questões)
    DesafioCognitivoModel(
      id: 'cog_b1',
      pergunta: 'Qual objeto usamos para beber água quando estamos com sede?',
      dica: 'Pense no recipiente que você segura com a mão na cozinha.',
      iconeEstimulo: Icons.local_drink_outlined,
      opcoes: ['Copo', 'Sapato', 'Travesseiro'],
      indiceCorreto: 0,
      nivel: 'Básico',
    ),
    DesafioCognitivoModel(
      id: 'cog_b2',
      pergunta: 'O que abrimos para não nos molharmos em um dia de chuva?',
      dica: 'Ele fica aberto acima da nossa cabeça quando cai água do céu.',
      iconeEstimulo: Icons.umbrella_outlined,
      opcoes: ['Caderno', 'Guarda-chuva', 'Colher'],
      indiceCorreto: 1,
      nivel: 'Básico',
    ),
    DesafioCognitivoModel(
      id: 'cog_b3',
      pergunta: 'Qual destes animais faz "Au Au" e gosta de brincar?',
      dica: 'É um animal de quatro patas muito amigo das pessoas.',
      iconeEstimulo: Icons.pets_outlined,
      opcoes: ['Peixe', 'Passarinho', 'Cachorro'],
      indiceCorreto: 2,
      nivel: 'Básico',
    ),
    DesafioCognitivoModel(
      id: 'cog_b4',
      pergunta: 'Qual peça de roupa colocamos nos pés antes do tênis?',
      dica: 'Ela é macia e protege os pés dentro do calçado.',
      iconeEstimulo: Icons.accessibility_new_outlined,
      opcoes: ['Meia', 'Chapéu', 'Luva'],
      indiceCorreto: 0,
      nivel: 'Básico',
    ),
    DesafioCognitivoModel(
      id: 'cog_b5',
      pergunta: 'Quando o céu fica escuro e a lua aparece, que momento é esse?',
      dica: 'É o período em que nos preparamos para dormir e descansar.',
      iconeEstimulo: Icons.nights_stay_outlined,
      opcoes: ['Manhã', 'Tarde', 'Noite'],
      indiceCorreto: 2,
      nivel: 'Básico',
    ),

    // Nível Intermediário (5 questões)
    DesafioCognitivoModel(
      id: 'cog_i1',
      pergunta:
          'Quando ganhamos um abraço de quem gostamos, qual sentimento sentimos?',
      dica: 'É o sentimento que faz a gente abrir um sorriso no rosto.',
      iconeEstimulo: Icons.emoji_emotions_outlined,
      opcoes: ['Alegria', 'Fome', 'Sono'],
      indiceCorreto: 0,
      nivel: 'Intermediário',
    ),
    DesafioCognitivoModel(
      id: 'cog_i2',
      pergunta: 'O que devemos fazer com as mãos antes das refeições?',
      dica: 'Serve para deixar as mãos limpinhas antes de tocar na comida.',
      iconeEstimulo: Icons.clean_hands_outlined,
      opcoes: ['Calçar meias', 'Lavar com água e sabão', 'Apagar a luz'],
      indiceCorreto: 1,
      nivel: 'Intermediário',
    ),
    DesafioCognitivoModel(
      id: 'cog_i3',
      pergunta: 'Qual destes itens pertence ao grupo das FRUTAS?',
      dica: 'É um alimento doce e saudável que nasce na árvore.',
      iconeEstimulo: Icons.eco_outlined,
      opcoes: ['Cadeira', 'Maçã', 'Lápis'],
      indiceCorreto: 1,
      nivel: 'Intermediário',
    ),
    DesafioCognitivoModel(
      id: 'cog_i4',
      pergunta: 'Qual destes objetos usamos para escovar os dentes?',
      dica: 'Usamos junto com o creme dental na pia do banheiro.',
      iconeEstimulo: Icons.health_and_safety_outlined,
      opcoes: ['Pente de cabelo', 'Escova de dentes', 'Tesoura'],
      indiceCorreto: 1,
      nivel: 'Intermediário',
    ),
    DesafioCognitivoModel(
      id: 'cog_i5',
      pergunta: 'Se um colega estiver triste e chorando, o que podemos fazer?',
      dica: 'Um gesto de carinho e empatia faz toda a diferença.',
      iconeEstimulo: Icons.volunteer_activism_outlined,
      opcoes: [
        'Oferecer um abraço ou chamar um adulto',
        'Gritar com ele',
        'Sair correndo e rir',
      ],
      indiceCorreto: 0,
      nivel: 'Intermediário',
    ),

    // Nível Avançado (5 questões)
    DesafioCognitivoModel(
      id: 'cog_a1',
      pergunta: 'Quantas partes (sílabas) tem a palavra BO - NE - CA?',
      dica: 'Bata palmas falando devagar: BO (1) - NE (2) - CA (3).',
      iconeEstimulo: Icons.abc_outlined,
      opcoes: ['1 sílaba', '3 sílabas', '5 sílabas'],
      indiceCorreto: 1,
      nivel: 'Avançado',
    ),
    DesafioCognitivoModel(
      id: 'cog_a2',
      pergunta:
          'Se você não conseguir abrir sua mochila sozinho na escola, qual é a melhor atitude?',
      dica:
          'Usar palavras ou a prancha de comunicação para pedir auxílio resolve o problema.',
      iconeEstimulo: Icons.school_outlined,
      opcoes: [
        'Pedir ajuda com calma ao professor ou colega',
        'Jogar a mochila no chão',
        'Ficar escondido na sala',
      ],
      indiceCorreto: 0,
      nivel: 'Avançado',
    ),
    DesafioCognitivoModel(
      id: 'cog_a3',
      pergunta: 'Qual é a ordem correta da nossa rotina pela manhã?',
      dica:
          'Primeiro saímos da cama, cuidamos da higiene e depois tomamos o café.',
      iconeEstimulo: Icons.wb_sunny_outlined,
      opcoes: [
        'Dormir -> Jantar -> Acordar',
        'Acordar -> Escovar os dentes -> Tomar café',
        'Almoçar -> Acordar -> Dormir',
      ],
      indiceCorreto: 1,
      nivel: 'Avançado',
    ),
    DesafioCognitivoModel(
      id: 'cog_a4',
      pergunta: 'Para atravessar a rua com segurança, por onde devemos passar?',
      dica: 'São aquelas faixas brancas pintadas no chão perto do semáforo.',
      iconeEstimulo: Icons.traffic_outlined,
      opcoes: [
        'Na faixa de pedestres com atenção',
        'Correndo entre os carros em movimento',
        'Olhando apenas para o celular',
      ],
      indiceCorreto: 0,
      nivel: 'Avançado',
    ),
    DesafioCognitivoModel(
      id: 'cog_a5',
      pergunta:
          'Se você encontrar um material que caiu do estojo de um colega, o que deve fazer?',
      dica: 'Cuidar dos pertences do grupo ajuda na boa convivência.',
      iconeEstimulo: Icons.handshake_outlined,
      opcoes: [
        'Esconder na sua própria mochila',
        'Devolver com gentileza ao colega ou entregar ao professor',
        'Jogar no cesto de lixo',
      ],
      indiceCorreto: 1,
      nivel: 'Avançado',
    ),
  ];

  int indiceAtualNoNivel = 0;
  int? opcaoSelecionada;
  bool acertouQuestaoAtual = false;
  bool exibirDicaPorErro = false;
  String? mensagemFeedbackResposta;
  String? notificacaoAdaptativa;

  String? _ultimoNivelSincronizado;
  String? _ultimoEmailSincronizado;

  /// Sincroniza automaticamente o estado transiente caso o nível ou o usuário tenha mudado externamente.
  void _garantirSincroniaComSessao(SessaoController sessao) {
    final nivelAtual = sessao.nivelAdaptativoAtual;
    final emailAtual = sessao.emailUsuarioAtual;

    if (_ultimoNivelSincronizado != null &&
        (_ultimoNivelSincronizado != nivelAtual ||
            _ultimoEmailSincronizado != emailAtual)) {
      indiceAtualNoNivel = 0;
      opcaoSelecionada = null;
      acertouQuestaoAtual = false;
      exibirDicaPorErro = false;
      mensagemFeedbackResposta = null;
      notificacaoAdaptativa = null;
    }

    _ultimoNivelSincronizado = nivelAtual;
    _ultimoEmailSincronizado = emailAtual;
  }

  /// Reseta o estado transiente do treino cognitivo (ex: ao realizar logout).
  void resetarEstado({bool notificar = false}) {
    indiceAtualNoNivel = 0;
    opcaoSelecionada = null;
    acertouQuestaoAtual = false;
    exibirDicaPorErro = false;
    mensagemFeedbackResposta = null;
    notificacaoAdaptativa = null;
    _ultimoNivelSincronizado = null;
    _ultimoEmailSincronizado = null;
    if (notificar) {
      notifyListeners();
    }
  }

  /// Retorna a lista de desafios correspondente ao nível adaptativo atual do usuário.
  List<DesafioCognitivoModel> desafiosDoNivel(SessaoController sessao) {
    _garantirSincroniaComSessao(sessao);
    final filtrados = _bancoDesafios
        .where((d) => d.nivel == sessao.nivelAdaptativoAtual)
        .toList();
    return filtrados.isNotEmpty ? filtrados : _bancoDesafios;
  }

  /// Obtém o desafio em exibição no momento.
  DesafioCognitivoModel desafioAtual(SessaoController sessao) {
    final lista = desafiosDoNivel(sessao);
    final idxSeguro = indiceAtualNoNivel % lista.length;
    return lista[idxSeguro];
  }

  /// Processa a alternativa escolhida pelo usuário e aciona o Motor de Adaptação Híbrida.
  void responderOpcao(int indiceEscolhido, SessaoController sessao) {
    _garantirSincroniaComSessao(sessao);
    if (acertouQuestaoAtual) return;

    final desafio = desafioAtual(sessao);
    opcaoSelecionada = indiceEscolhido;
    final nivelAntes = sessao.nivelAdaptativoAtual;

    if (indiceEscolhido == desafio.indiceCorreto) {
      acertouQuestaoAtual = true;
      exibirDicaPorErro = false;
      mensagemFeedbackResposta =
          'Muito bem! Resposta correta! (+10 estrelas ⭐)';
      notificacaoAdaptativa = sessao.processarResultadoCognitivo(
        acertou: true,
        estrelasPorAcerto: 10,
      );
      if (sessao.nivelAdaptativoAtual != nivelAntes) {
        indiceAtualNoNivel = 0;
        opcaoSelecionada = null;
        acertouQuestaoAtual = false;
        exibirDicaPorErro = false;
        mensagemFeedbackResposta = null;
        _ultimoNivelSincronizado = sessao.nivelAdaptativoAtual;
      }
    } else {
      acertouQuestaoAtual = false;
      exibirDicaPorErro = true;
      mensagemFeedbackResposta =
          'Quase lá! Veja a dica de apoio abaixo e tente novamente.';
      notificacaoAdaptativa = sessao.processarResultadoCognitivo(
        acertou: false,
      );
      if (sessao.nivelAdaptativoAtual != nivelAntes) {
        indiceAtualNoNivel = 0;
        opcaoSelecionada = null;
        acertouQuestaoAtual = false;
        exibirDicaPorErro = false;
        mensagemFeedbackResposta = null;
        _ultimoNivelSincronizado = sessao.nivelAdaptativoAtual;
      }
    }

    notifyListeners();
  }

  /// Avança para o próximo desafio do nível adaptativo atual.
  void proximoDesafio(SessaoController sessao) {
    final lista = desafiosDoNivel(sessao);
    indiceAtualNoNivel = (indiceAtualNoNivel + 1) % lista.length;
    opcaoSelecionada = null;
    acertouQuestaoAtual = false;
    exibirDicaPorErro = false;
    mensagemFeedbackResposta = null;
    notificacaoAdaptativa = null;
    notifyListeners();
  }
}
