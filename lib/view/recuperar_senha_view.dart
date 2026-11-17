import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/recuperar_senha_controller.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final ctrl = GetIt.I.get<RecuperarSenhaController>();

  @override
  void initState() {
    super.initState();
    ctrl.limparCampo(notificar: false);
  }

  Future<void> _solicitarRecuperacao() async {
    final emailInformado = ctrl.txtEmail.text.trim();
    final erro = await ctrl.validarESolicitarRecuperacao();
    if (!mounted) return;

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

    ctrl.limparCampo();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Instruções de redefinição de senha enviadas para $emailInformado.',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Recuperar Senha'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Esqueceu sua senha?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Informe o endereço de e-mail associado à sua conta cadastrada para receber as instruções de redefinição.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Campo para informação do e-mail cadastrado (RF001)
                  TextField(
                    controller: ctrl.txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail cadastrado',
                      hintText: 'pedro.santos@fatec.sp.gov.br',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão para solicitar a recuperação da senha (RF001)
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed:
                          ctrl.carregando ? null : _solicitarRecuperacao,
                      icon: ctrl.carregando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_outlined),
                      label: Text(
                        ctrl.carregando
                            ? 'Enviando e-mail...'
                            : 'Solicitar recuperação de senha',
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
