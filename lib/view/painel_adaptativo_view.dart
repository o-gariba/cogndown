import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/painel_adaptativo_controller.dart';
import '../controller/sessao_controller.dart';

class PainelAdaptativoView extends StatefulWidget {
  const PainelAdaptativoView({super.key});

  @override
  State<PainelAdaptativoView> createState() => _PainelAdaptativoViewState();
}

class _PainelAdaptativoViewState extends State<PainelAdaptativoView> {
  final ctrl = GetIt.I.get<PainelAdaptativoController>();
  final sessao = GetIt.I.get<SessaoController>();

  void _salvarAvaliacaoClinica() {
    final erro = ctrl.registrarAvaliacao(sessao);
    ScaffoldMessenger.of(context).clearSnackBars();
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Registro de avaliação de usabilidade/desempenho salvo com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Painel Adaptativo e Desempenho'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Seção 1: Relatório Quantitativo de Desempenho
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Indicadores Quantitativos — ${sessao.nomeUsuarioAtual}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
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
                                '${sessao.acertosCognitivos}/${sessao.tentativasCognitivasTotais} Acertos (${sessao.taxaPrecisaoCognitivaPercentual}%)',
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                              ),
                              label: Text(
                                '${sessao.modulosConcluidosIds.length} Módulos Concluídos',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Seção 2: Calibragem Manual do Motor Adaptativo (Terapeuta / Pais)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Calibragem do Motor Adaptativo (Pais / Terapeuta)',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Defina manualmente o nível de complexidade cognitiva ou deixe que o algoritmo ajuste durante os treinos:',
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: SessaoController.niveisDisponiveis
                              .map(
                                (nivel) => ChoiceChip(
                                  label: Text('Nível $nivel'),
                                  selected:
                                      sessao.nivelAdaptativoAtual == nivel,
                                  onSelected: (_) {
                                    sessao.alterarNivelAdaptativo(nivel);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Nível adaptativo calibrado para: $nivel',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(height: 24),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Exibir Dicas Cognitivas Visuais Automaticamente',
                          ),
                          subtitle: const Text(
                            'Mostra orientações de apoio em todas as questões do Treino Cognitivo.',
                          ),
                          value: sessao.exibirDicasVisuais,
                          onChanged: sessao.alternarDicasVisuais,
                        ),
                        const Divider(height: 24),
                        Text(
                          'Meta Diária de Estímulos: ${sessao.metaDiariaAtividades.toInt()} atividades',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Slider(
                          value: sessao.metaDiariaAtividades,
                          min: 1,
                          max: 15,
                          divisions: 14,
                          label: '${sessao.metaDiariaAtividades.toInt()}',
                          onChanged: sessao.alterarMetaDiaria,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Seção 3: Avaliação de Usabilidade e Engajamento (Escala SUS do Anteprojeto)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.assignment_turned_in_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Avaliação de Usabilidade e Engajamento (SUS)',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nota Likert: ${ctrl.notaSusAtual.toStringAsFixed(1)} / 5.0  •  Índice SUS: ${ctrl.escoreSusAtualEscala100}/100 pts',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Slider(
                          value: ctrl.notaSusAtual,
                          min: 1.0,
                          max: 5.0,
                          divisions: 8,
                          label:
                              '${ctrl.notaSusAtual.toStringAsFixed(1)} (${ctrl.escoreSusAtualEscala100} pts)',
                          onChanged: ctrl.atualizarNotaSus,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: ctrl.txtObservacaoClinica,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Observação Clínica / Pedagógica',
                            hintText:
                                'Ex: Demonstrou autonomia na escolha dos cartões de alimentação...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _salvarAvaliacaoClinica,
                            icon: const Icon(Icons.add_task),
                            label: const Text('Salvar Registro de Avaliação'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Histórico de Registros Clínicos / SUS
                Text(
                  'Histórico de Avaliações Registradas (${ctrl.historicoAvaliacoes.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...ctrl.historicoAvaliacoes.map(
                  (reg) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '${reg.escoreSusEscala100}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(reg.observacao),
                      subtitle: Text(
                        'Assistido(a): ${reg.nomeAvaliado} • ${reg.dataHora}\n'
                        'Nível: ${reg.nivelConfigurado} • SUS: ${reg.escoreSusEscala100}/100 (${reg.classificacaoSus})',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
