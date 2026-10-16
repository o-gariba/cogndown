import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'controller/cadastro_usuario_controller.dart';
import 'controller/conquistas_controller.dart';
import 'controller/login_controller.dart';
import 'controller/painel_adaptativo_controller.dart';
import 'controller/perfil_controller.dart';
import 'controller/prancha_comunicacao_controller.dart';
import 'controller/recuperar_senha_controller.dart';
import 'controller/sessao_controller.dart';
import 'controller/sobre_controller.dart';
import 'controller/trilha_atividades_controller.dart';
import 'controller/treino_cognitivo_controller.dart';
import 'view/cadastro_usuario_view.dart';
import 'view/conquistas_view.dart';
import 'view/login_view.dart';
import 'view/painel_adaptativo_view.dart';
import 'view/perfil_view.dart';
import 'view/prancha_comunicacao_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/sobre_view.dart';
import 'view/trilha_atividades_view.dart';
import 'view/treino_cognitivo_view.dart';

final g = GetIt.instance;

void registrarDependencias() {
  if (!g.isRegistered<SessaoController>()) {
    g.registerSingleton<SessaoController>(SessaoController());
  }
  if (!g.isRegistered<LoginController>()) {
    g.registerSingleton<LoginController>(LoginController());
  }
  if (!g.isRegistered<CadastroUsuarioController>()) {
    g.registerSingleton<CadastroUsuarioController>(CadastroUsuarioController());
  }
  if (!g.isRegistered<RecuperarSenhaController>()) {
    g.registerSingleton<RecuperarSenhaController>(RecuperarSenhaController());
  }
  if (!g.isRegistered<PerfilController>()) {
    g.registerSingleton<PerfilController>(PerfilController());
  }
  if (!g.isRegistered<SobreController>()) {
    g.registerSingleton<SobreController>(SobreController());
  }
  if (!g.isRegistered<TrilhaAtividadesController>()) {
    g.registerSingleton<TrilhaAtividadesController>(
      TrilhaAtividadesController(),
    );
  }
  if (!g.isRegistered<PranchaComunicacaoController>()) {
    g.registerSingleton<PranchaComunicacaoController>(
      PranchaComunicacaoController(),
    );
  }
  if (!g.isRegistered<TreinoCognitivoController>()) {
    g.registerSingleton<TreinoCognitivoController>(TreinoCognitivoController());
  }
  if (!g.isRegistered<ConquistasController>()) {
    g.registerSingleton<ConquistasController>(ConquistasController());
  }
  if (!g.isRegistered<PainelAdaptativoController>()) {
    g.registerSingleton<PainelAdaptativoController>(
      PainelAdaptativoController(),
    );
  }
}

void main() {
  registrarDependencias();
  runApp(DevicePreview(builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'CognDown - Estímulo Cognitivo e CAA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      //
      // ROTAS NOMEADAS (RF001 a RF007)
      //
      initialRoute: 'login',
      routes: {
        // Bloco Geral Obrigatório (RF001 a RF005)
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'perfil': (context) => const PerfilView(),
        'sobre': (context) => const SobreView(),

        // Bloco Específico do Tema (RF006 e RF007)
        'trilha_atividades': (context) => const TrilhaAtividadesView(),
        'prancha_comunicacao': (context) => const PranchaComunicacaoView(),
        'treino_cognitivo': (context) => const TreinoCognitivoView(),
        'conquistas': (context) => const ConquistasView(),
        'painel_adaptativo': (context) => const PainelAdaptativoView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      },
    );
  }
}

