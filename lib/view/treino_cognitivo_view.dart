import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/sessao_controller.dart';
import '../controller/treino_cognitivo_controller.dart';

class TreinoCognitivoView extends StatefulWidget {
  const TreinoCognitivoView({super.key});

  @override
  State<TreinoCognitivoView> createState() => _TreinoCognitivoViewState();
}

class _TreinoCognitivoViewState extends State<TreinoCognitivoView> {
  final ctrl = GetIt.I.get<TreinoCognitivoController>();
  final sessao = GetIt.I.get<SessaoController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        final listaNivel = ctrl.desafiosDoNivel(sessao);
        final desafio = ctrl.desafioAtual(sessao);
        final numeroQuestao = (ctrl.indiceAtualNoNivel % listaNivel.length) + 1;
        final mostrarDica =
            sessao.exibirDicasVisuais || ctrl.exibirDicaPorErro;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Treino Cognitivo Adaptativo'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  avatar: const Icon(Icons.star, size: 18, color: Colors.amber),
                  label: Text('${sessao.estrelasTotais}'),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra de Status do Motor Adaptativo
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.auto_graph, size: 18),
                            label: Text(
                              'Nível: ${sessao.nivelAdaptativoAtual}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Sequência p/ evoluir: ${sessao.acertosConsecutivos}/2',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Desafio $numeroQuestao de ${listaNivel.length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Banner de Notificação do Algoritmo Adaptativo (quando sobe/desce nível)
                  if (ctrl.notificacaoAdaptativa != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Theme.of(
                                context,
                              ).colorScheme.onTertiaryContainer,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ctrl.notificacaoAdaptativa!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Card Principal do Estímulo Cognitivo
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Icon(
                              desafio.iconeEstimulo,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            desafio.pergunta,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Card de Dica Cognitiva (Exibido se dicas automáticas estiverem ativas ou após erro)
                  if (mostrarDica) ...[
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: ListTile(
                        leading: const Icon(Icons.lightbulb_outline),
                        title: const Text(
                          'Dica Cognitiva de Apoio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(desafio.dica),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Alternativas de Resposta
                  ...List.generate(desafio.opcoes.length, (index) {
                    final textoOpcao = desafio.opcoes[index];
                    final selecionada = ctrl.opcaoSelecionada == index;
                    final ehCorreta = index == desafio.indiceCorreto;

                    IconData iconeBotao = Icons.circle_outlined;
                    if (selecionada) {
                      iconeBotao = ehCorreta
                          ? Icons.check_circle
                          : Icons.cancel_outlined;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        height: 54,
                        child: selecionada && ehCorreta
                            ? ElevatedButton.icon(
                                onPressed: () =>
                                    ctrl.responderOpcao(index, sessao),
                                icon: Icon(iconeBotao),
                                label: Text(
                                  textoOpcao,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            : OutlinedButton.icon(
                                onPressed: () =>
                                    ctrl.responderOpcao(index, sessao),
                                icon: Icon(iconeBotao),
                                label: Text(
                                  textoOpcao,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    );
                  }),

                  // Mensagem de Feedback Imediato e Botão Próximo Desafio
                  if (ctrl.mensagemFeedbackResposta != null) ...[
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Icon(
                              ctrl.acertouQuestaoAtual
                                  ? Icons.celebration
                                  : Icons.info_outline,
                              color: ctrl.acertouQuestaoAtual
                                  ? Colors.green
                                  : Colors.orange.shade800,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ctrl.mensagemFeedbackResposta!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => ctrl.proximoDesafio(sessao),
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        ctrl.acertouQuestaoAtual
                            ? 'Próximo Desafio'
                            : 'Pular / Trocar Desafio',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
