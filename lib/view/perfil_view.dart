import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/perfil_controller.dart';
import '../controller/sessao_controller.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final ctrl = GetIt.I.get<PerfilController>();
  final sessao = GetIt.I.get<SessaoController>();

  @override
  void initState() {
    super.initState();
    // Regra de Negócio RF005: Somente usuários autenticados podem acessar o Perfil
    if (!sessao.estaAutenticado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Faça login para acessar a tela de Perfil do Usuário.',
            ),
            backgroundColor: Colors.red.shade700,
          ),
        );
        Navigator.pushReplacementNamed(context, 'login');
      });
    } else {
      ctrl.carregarDadosUsuario();
    }
  }

  void _salvarAlteracoes() {
    final erro = ctrl.validarESalvarPerfil();
    if (erro != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil atualizado com sucesso! Novo nome: ${sessao.nomeUsuarioAtual}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelarEdicoes() {
    ctrl.restaurarEdicao();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alterações descartadas.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ctrl, sessao]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil do Usuário'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Resumo da identificação atual ativa no aplicativo (RF005)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          sessao.nomeUsuarioAtual.isNotEmpty
                              ? sessao.nomeUsuarioAtual[0].toUpperCase()
                              : 'U',
                        ),
                      ),
                      title: Text(
                        sessao.nomeUsuarioAtual,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(sessao.emailUsuarioAtual),
                      trailing: Chip(
                        avatar: const Icon(Icons.star, size: 18),
                        label: Text('${sessao.estrelasTotais}'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campo Nome do Usuário - Editável pelo usuário autenticado (RF005)
                  TextField(
                    controller: ctrl.txtNome,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome do usuário',
                      helperText:
                          'Editável (mínimo de ${PerfilController.tamanhoMinimoNome} caracteres)',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo E-mail - Somente visualização, não permitindo alteração (RF005)
                  TextField(
                    controller: ctrl.txtEmail,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'E-mail utilizado no login',
                      helperText:
                          'Apenas visualização (não pode ser alterado)',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botão para salvar as alterações realizadas (RF005)
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _salvarAlteracoes,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Salvar alterações'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botão para cancelar edições (RF005)
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _cancelarEdicoes,
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar edições'),
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
