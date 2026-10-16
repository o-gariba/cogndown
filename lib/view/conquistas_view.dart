import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/conquistas_controller.dart';
import '../controller/sessao_controller.dart';
import '../model/modelos_app.dart';

class ConquistasView extends StatefulWidget {
  const ConquistasView({super.key});

  @override
  State<ConquistasView> createState() => _ConquistasViewState();
}

class _ConquistasViewState extends State<ConquistasView> {
  final ctrl = GetIt.I.get<ConquistasController>();
  final sessao = GetIt.I.get<SessaoController>();

  void _resgatar(ConquistaModel conquista) {
    final resgatou = ctrl.resgatarMedalha(conquista, sessao);
    if (!resgatou) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Parabéns! Medalha "${conquista.titulo}" resgatada (+5 estrelas de bônus ⭐)!',
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        final conquistas = ctrl.obterConquistasFiltradas(sessao);
        final resgatadas = ctrl.totalResgatadas(sessao);
        final totalMedalhas = ctrl.todasConquistas.length;
        final tituloAprendiz = ctrl.obterTituloAprendiz(sessao.estrelasTotais);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mural de Conquistas'),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Painel Superior Gamificado
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                child: Icon(
                                  Icons.emoji_events,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tituloAprendiz,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      'Aluno(a): ${sessao.nomeUsuarioAtual}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Medalhas conquistadas: $resgatadas de $totalMedalhas',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: totalMedalhas > 0
                                ? resgatadas / totalMedalhas
                                : 0,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              Chip(
                                avatar: const Icon(Icons.star, size: 18),
                                label: Text(
                                  '${sessao.estrelasTotais} Estrelas',
                                ),
                              ),
                              Chip(
                                avatar: const Icon(
                                  Icons.record_voice_over,
                                  size: 18,
                                ),
                                label: Text(
                                  '${sessao.frasesConstruidasCaa} Frases CAA',
                                ),
                              ),
                              Chip(
                                avatar: const Icon(Icons.psychology, size: 18),
                                label: Text(
                                  '${sessao.acertosCognitivos} Acertos',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filtros de Medalhas
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ConquistasController.filtros
                          .map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(f),
                                selected: ctrl.filtroSelecionado == f,
                                onSelected: (_) => ctrl.selecionarFiltro(f),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Listagem de Medalhas com ListView.builder (RF006.4 e RF007)
                  Expanded(
                    child: conquistas.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma conquista encontrada neste filtro.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: conquistas.length,
                            itemBuilder: (context, index) {
                              final c = conquistas[index];
                              final jaResgatada = sessao.conquistaEstaResgatada(
                                c.id,
                              );
                              final podeResgatar =
                                  !jaResgatada &&
                                  sessao.estrelasTotais >=
                                      c.estrelasNecessarias;
                              final progresso =
                                  (sessao.estrelasTotais /
                                          c.estrelasNecessarias)
                                      .clamp(0.0, 1.0);

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Icon(c.icone),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  c.titulo,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(c.descricao),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        value: progresso,
                                        minHeight: 6,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Meta: ${c.estrelasNecessarias} ⭐ (Atual: ${sessao.estrelasTotais} ⭐)',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                          if (jaResgatada)
                                            const Chip(
                                              avatar: Icon(
                                                Icons.verified,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              label: Text('Conquistada'),
                                            )
                                          else if (podeResgatar)
                                            ElevatedButton.icon(
                                              onPressed: () => _resgatar(c),
                                              icon: const Icon(
                                                Icons.redeem,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Resgatar (+5 ⭐)',
                                              ),
                                            )
                                          else
                                            Text(
                                              'Faltam ${c.estrelasNecessarias - sessao.estrelasTotais} ⭐',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
