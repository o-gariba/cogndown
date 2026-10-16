import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/conquistas_controller.dart';
import '../controller/prancha_comunicacao_controller.dart';
import '../controller/sessao_controller.dart';
import '../controller/treino_cognitivo_controller.dart';
import '../controller/trilha_atividades_controller.dart';
import '../model/modelos_app.dart';

class TrilhaAtividadesView extends StatefulWidget {
  const TrilhaAtividadesView({super.key});

  @override
  State<TrilhaAtividadesView> createState() => _TrilhaAtividadesViewState();
}

class _TrilhaAtividadesViewState extends State<TrilhaAtividadesView> {
  final ctrl = GetIt.I.get<TrilhaAtividadesController>();
  final sessao = GetIt.I.get<SessaoController>();

  void _realizarLogout() {
    ctrl.resetarEstado();
    GetIt.I.get<PranchaComunicacaoController>().resetarEstado();
    GetIt.I.get<TreinoCognitivoController>().resetarEstado();
    GetIt.I.get<ConquistasController>().resetarEstado();
    sessao.logout();
    Navigator.pushReplacementNamed(context, 'login');
  }

  void _abrirModuloDaTrilha(ModuloAtividadeModel modulo) {
    if (modulo.rotaDestino == 'prancha_comunicacao') {
      final pranchaCtrl = GetIt.I.get<PranchaComunicacaoController>();
      if (modulo.id == 'mod_1') {
        pranchaCtrl.selecionarCategoria('Necessidades', notificar: false);
      } else if (modulo.id == 'mod_2') {
        pranchaCtrl.selecionarCategoria('Emoções', notificar: false);
      } else {
        pranchaCtrl.selecionarCategoria('Todas', notificar: false);
      }
    }
    Navigator.pushNamed(context, modulo.rotaDestino);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        final modulosVisiveis = ctrl.obterModulosFiltrados(sessao);

        return Scaffold(
          appBar: AppBar(
            title: Text('Olá, ${sessao.nomeUsuarioAtual}'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Chip(
                  avatar: const Icon(Icons.star, size: 18, color: Colors.amber),
                  label: Text('${sessao.estrelasTotais}'),
                ),
              ),
              IconButton(
                tooltip: 'Perfil do Usuário (RF005)',
                icon: const Icon(Icons.person_outline),
                onPressed: () => Navigator.pushNamed(context, 'perfil'),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      sessao.nomeUsuarioAtual.isNotEmpty
                          ? sessao.nomeUsuarioAtual[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  accountName: Text(sessao.nomeUsuarioAtual),
                  accountEmail: Text(
                    sessao.emailUsuarioAtual.isNotEmpty
                        ? sessao.emailUsuarioAtual
                        : 'Sessão de Demonstração',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.route_outlined),
                  title: const Text('1. Trilha de Atividades'),
                  selected: true,
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.grid_view_outlined),
                  title: const Text('2. Prancha de Comunicação (CAA)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'prancha_comunicacao');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology_outlined),
                  title: const Text('3. Treino Cognitivo Adaptativo'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'treino_cognitivo');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events_outlined),
                  title: const Text('4. Mural de Conquistas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'conquistas');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tune_outlined),
                  title: const Text('5. Painel Adaptativo e SUS'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'painel_adaptativo');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Perfil do Usuário (RF005)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'perfil');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Sobre o Projeto (RF004)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'sobre');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Sair (Logout)'),
                  onTap: _realizarLogout,
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Resumo do Nível Adaptativo e Meta Diária
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Nível Adaptativo: ${sessao.nivelAdaptativoAtual}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  'painel_adaptativo',
                                ),
                                icon: const Icon(Icons.tune, size: 18),
                                label: const Text('Ajustar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Progresso diário: ${sessao.totalAtividadesRealizadas} de ${sessao.metaDiariaAtividades.toInt()} estímulos (${sessao.frasesConstruidasCaa} frases CAA | ${sessao.acertosCognitivos} acertos cognitivos)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: sessao.progressoMetaDiaria,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filtros de Categoria e Nível Adaptativo
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...TrilhaAtividadesController.categoriasFiltro.map(
                          (cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: ctrl.categoriaSelecionada == cat,
                              onSelected: (_) => ctrl.selecionarCategoria(cat),
                            ),
                          ),
                        ),
                        FilterChip(
                          label: Text(
                            'Recomendados (${sessao.nivelAdaptativoAtual})',
                          ),
                          selected: ctrl.filtrarApenasNivelAtual,
                          onSelected: (_) => ctrl.alternarFiltroNivelAtual(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Listagem de Dados com ListView.builder (Cumpre RF007 e RF006.1)
                  Expanded(
                    child: modulosVisiveis.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma atividade encontrada para o filtro selecionado.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: modulosVisiveis.length,
                            itemBuilder: (context, index) {
                              final modulo = modulosVisiveis[index];
                              final concluido = sessao.moduloEstaConcluido(
                                modulo.id,
                              );
                              final recomendado =
                                  modulo.nivelDificuldade ==
                                  sessao.nivelAdaptativoAtual;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    child: Icon(modulo.icone),
                                  ),
                                  title: Text(
                                    modulo.titulo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: concluido
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(modulo.descricao),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          Chip(
                                            label: Text(modulo.categoria),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          Chip(
                                            avatar: recomendado
                                                ? const Icon(
                                                    Icons.auto_awesome,
                                                    size: 16,
                                                  )
                                                : null,
                                            label: Text(
                                              recomendado
                                                  ? 'Nível ${modulo.nivelDificuldade} (Recomendado)'
                                                  : 'Nível ${modulo.nivelDificuldade}',
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Tooltip(
                                    message:
                                        'Marcar módulo como concluído (+5 estrelas)',
                                    child: Checkbox(
                                      value: concluido,
                                      onChanged: (_) {
                                        final marcou = sessao
                                            .alternarConclusaoModulo(modulo.id);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).clearSnackBars();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              marcou
                                                  ? 'Módulo "${modulo.titulo}" concluído! (+5 estrelas)'
                                                  : 'Conclusão do módulo desmarcada.',
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  onTap: () => _abrirModuloDaTrilha(modulo),
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
