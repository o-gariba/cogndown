import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/sobre_controller.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  final ctrl = GetIt.I.get<SobreController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sobre o Projeto'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Cabeçalho do Aplicativo
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.psychology_alt,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ctrl.nomeAplicativo,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Versão: ${ctrl.versao}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ctrl.tituloEstudo,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Objetivo do Aplicativo (Obrigatório RF004)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Objetivo do Aplicativo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(ctrl.objetivoGeral),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Equipe de Desenvolvimento (Obrigatório RF004)
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Equipe de Desenvolvimento',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ...ctrl.integrantesEquipe.map(
                        (integrante) => ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(integrante),
                          subtitle: const Text('Autor e Desenvolvedor'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Informações Institucionais Adicionais (RF004)
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: const Text('Instituição de Ensino'),
                        subtitle: Text(ctrl.instituicao),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: const Text('Disciplina'),
                        subtitle: Text(ctrl.disciplina),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.co_present_outlined),
                        title: const Text('Professor Responsável'),
                        subtitle: Text(ctrl.professor),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Versão do Aplicativo'),
                        subtitle: Text(ctrl.versao),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pilares Metodológicos do Anteprojeto (Interativo com ChangeNotifier)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pilares do Anteprojeto',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: ctrl.alternarDetalhesMetodologia,
                              icon: Icon(
                                ctrl.exibirDetalhesMetodologia
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                              label: Text(
                                ctrl.exibirDetalhesMetodologia
                                    ? 'Ocultar'
                                    : 'Mostrar',
                              ),
                            ),
                          ],
                        ),
                        if (ctrl.exibirDetalhesMetodologia)
                          ...ctrl.pilaresMetodologicos.map(
                            (pilar) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(pilar)),
                                ],
                              ),
                            ),
                          ),
                      ],
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
