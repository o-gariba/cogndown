import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/cadastro_usuario_controller.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final ctrl = GetIt.I.get<CadastroUsuarioController>();

  @override
  void initState() {
    super.initState();
    ctrl.limparCampos(notificar: false);
  }

  void _confirmarCadastro() {
    final erro = ctrl.validarECadastrar();
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
      const SnackBar(
        content: Text('Cadastro realizado com sucesso! Bem-vindo(a)!'),
        backgroundColor: Colors.green,
      ),
    );

    // Após validação e cadastro, permite acesso imediato ao aplicativo (RF002)
    Navigator.pushNamedAndRemoveUntil(
      context,
      'trilha_atividades',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cadastro de Usuário'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Crie sua conta para acessar os módulos cognitivos e de comunicação.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),

                  // 1. Nome do usuário (RF002)
                  TextField(
                    controller: ctrl.txtNome,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome do usuário',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. E-mail (RF002)
                  TextField(
                    controller: ctrl.txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'usuario@dominio.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Número de telefone (RF002)
                  TextField(
                    controller: ctrl.txtTelefone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Número de telefone',
                      hintText: '(16) 99999-0000',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Senha (RF002)
                  TextField(
                    controller: ctrl.txtSenha,
                    obscureText: ctrl.senhaOculta,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          ctrl.senhaOculta
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: ctrl.alternarVisibilidadeSenha,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Confirmação de senha (RF002)
                  TextField(
                    controller: ctrl.txtConfirmarSenha,
                    obscureText: ctrl.confirmarSenhaOculta,
                    decoration: InputDecoration(
                      labelText: 'Confirmação de senha',
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          ctrl.confirmarSenhaOculta
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: ctrl.alternarVisibilidadeConfirmarSenha,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão para confirmação do cadastro (RF002)
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _confirmarCadastro,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Criar conta'),
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
