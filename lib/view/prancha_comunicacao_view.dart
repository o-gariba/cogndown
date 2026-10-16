import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/prancha_comunicacao_controller.dart';
import '../controller/sessao_controller.dart';

class PranchaComunicacaoView extends StatefulWidget {
  const PranchaComunicacaoView({super.key});

  @override
  State<PranchaComunicacaoView> createState() => _PranchaComunicacaoViewState();
}

class _PranchaComunicacaoViewState extends State<PranchaComunicacaoView> {
  final ctrl = GetIt.I.get<PranchaComunicacaoController>();
  final sessao = GetIt.I.get<SessaoController>();

  void _expressarFrase() {
    final frase = ctrl.expressarFrase(sessao);
    ScaffoldMessenger.of(context).clearSnackBars();
    if (frase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Toque em pelo menos um cartão abaixo para montar sua frase.',
          ),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Frase expressada: "$frase" (+5 estrelas!)'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _repetirFraseRecente(String frase) {
    final expressa = ctrl.repetirFraseHistorico(frase, sessao);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Frase repetida: "$expressa" (+5 estrelas!)'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        final cartoes = ctrl.cartoesFiltrados;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Prancha de Comunicação (CAA)'),
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
                  // Barra Construtora de Frase no Topo
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Construtor de Frase CAA',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Frases expressas: ${sessao.frasesConstruidasCaa}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            constraints: const BoxConstraints(minHeight: 56),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ctrl.fraseEmConstrucao.isEmpty
                                ? const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Toque nos cartões da grade abaixo para construir uma frase...',
                                    ),
                                  )
                                : Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: ctrl.fraseEmConstrucao
                                        .map(
                                          (cartao) => Chip(
                                            avatar: Icon(
                                              cartao.icone,
                                              size: 18,
                                            ),
                                            label: Text(
                                              cartao.texto,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: ctrl.fraseEmConstrucao.isEmpty
                                    ? null
                                    : ctrl.removerUltimoCartao,
                                icon: const Icon(Icons.backspace_outlined),
                                label: const Text('Apagar'),
                              ),
                              OutlinedButton.icon(
                                onPressed: ctrl.fraseEmConstrucao.isEmpty
                                    ? null
                                    : ctrl.limparFrase,
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Limpar'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _expressarFrase,
                                icon: const Icon(Icons.volume_up),
                                label: const Text('Expressar (+5 ⭐)'),
                              ),
                            ],
                          ),
                          // Histórico de Frases Recentes (Repetição com 1 toque)
                          if (ctrl.historicoFrasesRecentes.isNotEmpty) ...[
                            const Divider(height: 18),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Icon(Icons.history, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Recentes: ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  ...ctrl.historicoFrasesRecentes.map(
                                    (f) => Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: ActionChip(
                                        avatar: const Icon(
                                          Icons.volume_up,
                                          size: 14,
                                        ),
                                        label: Text(f),
                                        onPressed: () =>
                                            _repetirFraseRecente(f),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filtros de Categoria de Pictogramas
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: PranchaComunicacaoController.categorias
                          .map(
                            (cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: ctrl.categoriaSelecionada == cat,
                                onSelected: (_) =>
                                    ctrl.selecionarCategoria(cat),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grade de Cartões Pictográficos com GridView.builder (Cumpre RF007)
                  Expanded(
                    child: GridView.builder(
                      itemCount: cartoes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1,
                          ),
                      itemBuilder: (context, index) {
                        final cartao = cartoes[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => ctrl.adicionarCartao(cartao),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    cartao.icone,
                                    size: 38,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cartao.texto,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    cartao.categoria,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
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
