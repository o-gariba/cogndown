import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:cogndown/controller/conquistas_controller.dart';
import 'package:cogndown/controller/login_controller.dart';
import 'package:cogndown/controller/painel_adaptativo_controller.dart';
import 'package:cogndown/controller/prancha_comunicacao_controller.dart';
import 'package:cogndown/controller/sessao_controller.dart';
import 'package:cogndown/controller/treino_cognitivo_controller.dart';
import 'package:cogndown/main.dart';
import 'package:cogndown/model/modelos_app.dart';
import 'package:cogndown/view/login_view.dart';
import 'package:cogndown/view/trilha_atividades_view.dart';

void main() {
  setUp(() {
    // Garante injeção de dependências antes de cada execução
    registrarDependencias();
    final sessao = GetIt.instance<SessaoController>();
    sessao.autenticar('pedro.santos@fatec.sp.gov.br', '123456');
    GetIt.instance<LoginController>().limparCampos();
  });

  group('Grupo 1: Modelos e Funções Auxiliares de Validação', () {
    test('Validador de e-mail (validarEmail) aceita válidos e rejeita inválidos', () {
      expect(validarEmail('pedro.santos@fatec.sp.gov.br'), isTrue);
      expect(validarEmail('usuario@dominio.com'), isTrue);
      expect(validarEmail('fono@clinica.org.br'), isTrue);

      expect(validarEmail(''), isFalse);
      expect(validarEmail('   '), isFalse);
      expect(validarEmail('sem_arroba.com'), isFalse);
      expect(validarEmail('@sem_usuario.com'), isFalse);
      expect(validarEmail('sem_dominio@'), isFalse);
      expect(validarEmail('usuario@dominio'), isFalse);
    });

    test('RegistroAvaliacaoModel converte escala SUS (1.0-5.0) em escore 0-100 e classifica clinicamente', () {
      const avaliacaoExcelente = RegistroAvaliacaoModel(
        nomeAvaliado: 'Lucas',
        dataHora: '16/10/2026 14:00',
        notaSatisfacaoSus: 5.0,
        observacao: 'Atenção e engajamento excelentes.',
        nivelConfigurado: 'Intermediário',
      );
      expect(avaliacaoExcelente.escoreSusEscala100, equals(100));
      expect(avaliacaoExcelente.classificacaoSus, equals('Excelente'));

      const avaliacaoBoa = RegistroAvaliacaoModel(
        nomeAvaliado: 'Beatriz',
        dataHora: '16/10/2026 15:00',
        notaSatisfacaoSus: 4.0,
        observacao: 'Boa resposta aos pictogramas.',
        nivelConfigurado: 'Básico',
      );
      expect(avaliacaoBoa.escoreSusEscala100, equals(75));
      expect(avaliacaoBoa.classificacaoSus, equals('Bom'));

      const avaliacaoAceitavel = RegistroAvaliacaoModel(
        nomeAvaliado: 'Joana',
        dataHora: '16/10/2026 15:30',
        notaSatisfacaoSus: 3.0,
        observacao: 'Compreendeu a rotina com mediação.',
        nivelConfigurado: 'Básico',
      );
      expect(avaliacaoAceitavel.escoreSusEscala100, equals(50));
      expect(avaliacaoAceitavel.classificacaoSus, equals('Aceitável'));

      const avaliacaoAtencao = RegistroAvaliacaoModel(
        nomeAvaliado: 'Gabriel',
        dataHora: '16/10/2026 16:00',
        notaSatisfacaoSus: 2.0,
        observacao: 'Necessitou de mediação verbal e visual constante.',
        nivelConfigurado: 'Básico',
      );
      expect(avaliacaoAtencao.escoreSusEscala100, equals(25));
      expect(avaliacaoAtencao.classificacaoSus, equals('Atenção Clínica'));
    });

    test('UsuarioModel preserva atributos e isolamento de dados', () {
      final user = UsuarioModel(
        nome: 'Aluno Teste',
        email: 'aluno@teste.com',
        telefone: '16999990000',
        senha: 'senha123',
        estrelasTotais: 20,
        frasesConstruidasCaa: 5,
        acertosCognitivos: 6,
        tentativasCognitivasTotais: 8,
        nivelAdaptativoAtual: 'Intermediário',
      );

      expect(user.nome, equals('Aluno Teste'));
      expect(user.email, equals('aluno@teste.com'));
      expect(user.estrelasTotais, equals(20));
      expect(user.frasesConstruidasCaa, equals(5));
      expect(user.acertosCognitivos, equals(6));
      expect(user.tentativasCognitivasTotais, equals(8));
      expect(user.nivelAdaptativoAtual, equals('Intermediário'));
    });
  });

  group('Grupo 2: SessaoController e Motor de Adaptação Híbrida', () {
    test('Autenticação com credenciais corretas e bloqueio com senha incorreta (RF001)', () {
      final sessao = GetIt.instance<SessaoController>();

      // Sucesso
      final loginOk = sessao.autenticar('pedro.santos@fatec.sp.gov.br', '123456');
      expect(loginOk, isTrue);
      expect(sessao.usuarioLogado, isNotNull);
      expect(sessao.nomeUsuarioAtual, equals('Pedro Garibaldi Santos'));

      // Falha com senha errada
      final loginInvalido = sessao.autenticar('pedro.santos@fatec.sp.gov.br', 'senha_errada');
      expect(loginInvalido, isFalse);

      // Falha com e-mail inexistente
      final loginInexistente = sessao.autenticar('inexistente@fatec.sp.gov.br', '123456');
      expect(loginInexistente, isFalse);
    });

    test('Cadastro de novo usuário isola progresso e credenciais (RF002)', () {
      final sessao = GetIt.instance<SessaoController>();
      final emailNovo = 'novo.aluno_${DateTime.now().millisecondsSinceEpoch}@teste.com';

      final novo = UsuarioModel(
        nome: 'Maria Fernanda',
        email: emailNovo,
        telefone: '16988887777',
        senha: 'senhaForte123',
      );

      final cadastrou = sessao.cadastrarNovoUsuario(novo);
      expect(cadastrou, isTrue);
      expect(sessao.usuarioLogado?.email, equals(emailNovo));
      expect(sessao.nomeUsuarioAtual, equals('Maria Fernanda'));

      // Progresso isolado (deve iniciar com valores limpos)
      expect(sessao.estrelasTotais, equals(0));
      expect(sessao.frasesConstruidasCaa, equals(0));
      expect(sessao.acertosCognitivos, equals(0));
      expect(sessao.tentativasCognitivasTotais, equals(0));
      expect(sessao.nivelAdaptativoAtual, equals('Básico'));
      expect(sessao.exibirDicasVisuais, isTrue);
    });

    test('Atualização reativa de perfil altera identificação globalmente (RF005)', () {
      final sessao = GetIt.instance<SessaoController>();
      sessao.autenticar('pedro.santos@fatec.sp.gov.br', '123456');

      sessao.atualizarNomeUsuario('Pedro Garibaldi (Terapeuta)');
      expect(sessao.nomeUsuarioAtual, equals('Pedro Garibaldi (Terapeuta)'));

      // Reverte nome para manter padrão nos demais testes
      sessao.atualizarNomeUsuario('Pedro Garibaldi Santos');
      expect(sessao.nomeUsuarioAtual, equals('Pedro Garibaldi Santos'));
    });

    test('Motor Adaptativo: 2 acertos promovem nível; 2 erros ativam dicas e reduzem complexidade', () {
      final sessao = GetIt.instance<SessaoController>();
      sessao.alterarNivelAdaptativo('Básico');
      expect(sessao.nivelAdaptativoAtual, equals('Básico'));

      // 1º acerto
      sessao.processarResultadoCognitivo(acertou: true);
      expect(sessao.nivelAdaptativoAtual, equals('Básico'));

      // 2º acerto consecutivo -> Motor promove para Intermediário
      final msgPromocao = sessao.processarResultadoCognitivo(acertou: true);
      expect(sessao.nivelAdaptativoAtual, equals('Intermediário'));
      expect(msgPromocao, contains('avançou para o nível Intermediário'));

      // Mais 2 acertos em Intermediário -> Promove para Avançado
      sessao.processarResultadoCognitivo(acertou: true);
      sessao.processarResultadoCognitivo(acertou: true);
      expect(sessao.nivelAdaptativoAtual, equals('Avançado'));

      // Desativa dicas para testar reativação automática
      sessao.alternarDicasVisuais(false);
      expect(sessao.exibirDicasVisuais, isFalse);

      // 1º erro
      sessao.processarResultadoCognitivo(acertou: false);
      expect(sessao.nivelAdaptativoAtual, equals('Avançado'));

      // 2º erro consecutivo -> Reativa dicas e reduz para Intermediário
      final msgReducao = sessao.processarResultadoCognitivo(acertou: false);
      expect(sessao.exibirDicasVisuais, isTrue);
      expect(sessao.nivelAdaptativoAtual, equals('Intermediário'));
      expect(msgReducao, contains('Suporte Adaptativo ativado'));

      // Taxa de precisão calculada
      expect(sessao.taxaPrecisaoCognitivaPercentual, greaterThan(0));
    });
  });

  group('Grupo 3: Controladores Específicos do Domínio (RF006)', () {
    test('PranchaComunicacaoController: montagem, histórico e premiação de frases CAA', () {
      final sessao = GetIt.instance<SessaoController>();
      final pranchaCtrl = GetIt.instance<PranchaComunicacaoController>();

      pranchaCtrl.limparFrase();
      expect(pranchaCtrl.fraseEmConstrucao, isEmpty);

      // Filtro de categoria
      pranchaCtrl.selecionarCategoria('Necessidades');
      expect(pranchaCtrl.cartoesFiltrados.every((c) => c.categoria == 'Necessidades'), isTrue);

      // Adição de cartões
      final c1 = pranchaCtrl.cartoesFiltrados.first;
      final c2 = pranchaCtrl.cartoesFiltrados.last;
      pranchaCtrl.adicionarCartao(c1);
      pranchaCtrl.adicionarCartao(c2);
      expect(pranchaCtrl.fraseEmConstrucao.length, equals(2));

      // Remoção do último cartão
      pranchaCtrl.removerUltimoCartao();
      expect(pranchaCtrl.fraseEmConstrucao.length, equals(1));

      // Expressão da frase e premiação com estrelas (+5 ⭐)
      final estrelasAntes = sessao.estrelasTotais;
      final fraseExpressa = pranchaCtrl.expressarFrase(sessao);
      expect(fraseExpressa, isNotNull);
      expect(pranchaCtrl.fraseEmConstrucao, isEmpty);
      expect(pranchaCtrl.historicoFrasesRecentes.first, equals(fraseExpressa));
      expect(sessao.estrelasTotais, equals(estrelasAntes + 5));
    });

    test('TreinoCognitivoController: resposta correta e resposta incorreta com dica', () {
      final sessao = GetIt.instance<SessaoController>();
      final treinoCtrl = GetIt.instance<TreinoCognitivoController>();

      sessao.alterarNivelAdaptativo('Básico');
      final desafio = treinoCtrl.desafioAtual(sessao);
      expect(desafio.nivel, equals('Básico'));

      // Resposta correta
      treinoCtrl.responderOpcao(desafio.indiceCorreto, sessao);
      expect(treinoCtrl.acertouQuestaoAtual, isTrue);
      expect(treinoCtrl.opcaoSelecionada, equals(desafio.indiceCorreto));

      // Avança para o próximo
      treinoCtrl.proximoDesafio(sessao);
      expect(treinoCtrl.acertouQuestaoAtual, isFalse);
      expect(treinoCtrl.opcaoSelecionada, isNull);

      // Resposta incorreta
      final desafio2 = treinoCtrl.desafioAtual(sessao);
      final indiceIncorreto = (desafio2.indiceCorreto + 1) % desafio2.opcoes.length;
      treinoCtrl.responderOpcao(indiceIncorreto, sessao);
      expect(treinoCtrl.acertouQuestaoAtual, isFalse);
      expect(treinoCtrl.exibirDicaPorErro, isTrue);
    });

    test('ConquistasController: listagem de 6 medalhas e resgate de bônus +5 estrelas', () {
      final sessao = GetIt.instance<SessaoController>();
      final conquistasCtrl = GetIt.instance<ConquistasController>();

      expect(conquistasCtrl.todasConquistas.length, equals(6));

      // Resgate da conquista 'conq_1' (10 estrelas necessárias)
      sessao.adicionarEstrelas(20);
      final conq1 = conquistasCtrl.todasConquistas.firstWhere((c) => c.id == 'conq_1');

      if (!sessao.conquistaEstaResgatada(conq1.id)) {
        final estrelasAntes = sessao.estrelasTotais;
        final resgatou = conquistasCtrl.resgatarMedalha(conq1, sessao);
        expect(resgatou, isTrue);
        expect(sessao.conquistaEstaResgatada(conq1.id), isTrue);
        expect(sessao.estrelasTotais, equals(estrelasAntes + 5));
      }
    });

    test('PainelAdaptativoController: registro de avaliação clínica na escala SUS', () {
      final sessao = GetIt.instance<SessaoController>();
      final painelCtrl = GetIt.instance<PainelAdaptativoController>();

      final totalAntes = painelCtrl.historicoAvaliacoes.length;
      painelCtrl.atualizarNotaSus(4.5);
      painelCtrl.txtObservacaoClinica.text = 'Sessão com boa evolução no reconhecimento visual.';

      final resultado = painelCtrl.registrarAvaliacao(sessao);
      expect(resultado, isNull); // Sem erros
      expect(painelCtrl.historicoAvaliacoes.length, equals(totalAntes + 1));
      expect(painelCtrl.historicoAvaliacoes.first.notaSatisfacaoSus, equals(4.5));
      expect(painelCtrl.historicoAvaliacoes.first.nomeAvaliado, equals(sessao.nomeUsuarioAtual));
    });
  });

  group('Grupo 4: Testes de Widgets e Integração de Interface (RF001 e RF007)', () {
    testWidgets('LoginView renderiza campos, valida preenchimento e navega autenticado para Trilha', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: 'login',
          routes: {
            'login': (context) => const LoginView(),
            'trilha_atividades': (context) => const TrilhaAtividadesView(),
          },
        ),
      );

      // Verifica logotipo CognDown e campos do RF001
      expect(find.text('CognDown'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget);

      // Atalho "Preencher conta de demonstração"
      final btnDemo = find.text('Preencher conta de demonstração');
      expect(btnDemo, findsOneWidget);
      await tester.tap(btnDemo);
      await tester.pump();

      // Clica em "Entrar" para navegar para a Trilha de Atividades
      final btnEntrar = find.text('Entrar');
      await tester.tap(btnEntrar);
      await tester.pumpAndSettle();

      // Comprova navegação e renderização da Trilha (RF007 - ListView de módulos)
      expect(find.textContaining('Pedro Garibaldi Santos'), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);
      expect(find.text('Prancha de Necessidades Básicas'), findsOneWidget);

      // Rola a ListView para comprovar rolagem dinâmica e renderização sob demanda (RF007)
      await tester.drag(find.byType(ListView).first, const Offset(0, -350));
      await tester.pumpAndSettle();
      expect(find.text('Associação Visual do Cotidiano'), findsOneWidget);
    });
  });
}
