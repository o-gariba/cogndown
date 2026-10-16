import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ctrl = GetIt.I.get<LoginController>();

  void _realizarLogin() {
    final erro = ctrl.validarELogar();
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
        content: Text('Autenticação realizada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacementNamed(context, 'trilha_atividades');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logotipo da aplicação (RF001)
                    Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology_alt,
                          size: 72,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CognDown',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Estímulo Cognitivo e Comunicação Adaptativa',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Campo de E-mail (RF001)
                    TextField(
                      controller: ctrl.txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'exemplo@fatec.sp.gov.br',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo de Senha (RF001)
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

                    // Link Esqueceu a senha? (RF001 / RF003)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'recuperar_senha');
                        },
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botão Entrar (RF001)
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _realizarLogin,
                        icon: const Icon(Icons.login),
                        label: const Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Atalho de usabilidade para preenchimento rápido em testes
                    OutlinedButton.icon(
                      onPressed: ctrl.preencherContaDemonstracao,
                      icon: const Icon(Icons.bolt),
                      label: const Text('Preencher conta de demonstração'),
                    ),
                    const SizedBox(height: 24),

                    // Link para Cadastro de Usuário (RF001 / RF002)
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastro_usuario');
                      },
                      child: const Text('Ainda não tem conta? Cadastre-se.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
