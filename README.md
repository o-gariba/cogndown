# CognDown — Software Adaptativo e Gamificado (Parte 1)

Protótipo desenvolvido para a disciplina de **Programação para Dispositivos Móveis** (FATEC Ribeirão Preto — Prof. Dr. Rodrigo de Oliveira Plotze), baseado no anteprojeto:
> *"Desenvolvimento e Avaliação de um Software Adaptativo e Gamificado para o Estímulo de Habilidades Cognitivas e de Comunicação em Indivíduos com Síndrome de Down"* — **Pedro Garibaldi Santos**.

---

## 📌 Status do Desenvolvimento (100% Concluído — Parte 1)

- [x] **Etapa 1 (Concluída):** Fundação, Modelos de Dados (`modelos_app.dart`), Controlador Global de Sessão (`sessao_controller.dart`), Injeção de Dependência (`GetIt`) e Mapa das 10 Rotas Nomeadas (`main.dart`).
- [x] **Etapa 2 (Concluída):** Fluxo de Autenticação Completo (`RF001` Login, `RF002` Cadastro de Usuário, `RF003` Recuperar Senha — **20% da nota**).
- [x] **Etapa 3 (Concluída):** Telas Institucionais e Perfil (`RF004` Sobre, `RF005` Perfil do Usuário com nome reativo global — **20% da nota**).
- [x] **Etapa 4 (Concluída):** Saneamento de *Code Smells* (Sub-etapa 4.0) + Módulos Específicos 1, 2 e 3 (`RF006.1` Trilha com `ListView`, `RF006.2` Prancha CAA com `GridView`, `RF006.3` Treino Cognitivo com Adaptação Híbrida + `RF007` — **40% da nota**).
- [x] **Etapa 5 (Concluída):** Gamificação e Painel Adaptativo — Módulos 4 e 5 (`RF006.4` Mural de Conquistas e `RF006.5` Painel Adaptativo e Avaliação SUS — **20% da nota**).
- [x] **Refatoração Pós-Etapa 5 e Guia Clínico (Concluída):** Sincronização reativa de nível/usuário no Treino Cognitivo, isolamento completo de estado no logout, navegação contextual Trilha → Prancha CAA, cálculo de Taxa de Precisão Cognitiva (%) e Escore SUS (0–100), e elaboração do **[Guia para Profissionais da Saúde e Educação Especial (`GUIA_PROFISSIONAIS_SAUDE_PCD.md`)](GUIA_PROFISSIONAIS_SAUDE_PCD.md)**.
- [x] **Etapa 6 (Concluída):** Suíte de Testes Automatizados com 12 testes aprovados (`test/app_projeto_test.dart`), Verificação Estática com 0 erros (`flutter analyze`) e Checklist Definitivo de 100% da Rubrica Oficial.

---

## 🩺 Documentos Didáticos e Estratégicos na Raiz do Projeto

1. **[Guia para Profissionais da Saúde e Educação Especial (`GUIA_PROFISSIONAIS_SAUDE_PCD.md`)](GUIA_PROFISSIONAIS_SAUDE_PCD.md):**
   - Fundamentação clínica e neurocognitiva (T21);
   - Roteiro prático passo a passo de sessão terapêutica (30 a 45 min);
   - Como utilizar o Motor Adaptativo e a escala SUS em consultórios/escolas.
2. **[Roteiro de Evolução Estratégica: Saúde PcD & Tecnologia (`ROTEIRO_EVOLUCAO_SAUDE_E_TECNOLOGIA.md`)](ROTEIRO_EVOLUCAO_SAUDE_E_TECNOLOGIA.md):**
   - **Eixo Saúde PcD:** Validação clínica com comitê de ética (CEP/CONEP), escalas padronizadas QUEST 2.0 e PEDI, parcerias com APAEs e rede AEE municipal, e tele-reabilitação fonoaudiológica com fotos reais;
   - **Eixo Amadurecimento Técnico:** Identidade nativa Android (Keystore, AAB, ícones adaptativos), persistência SQLite offline-first (Parte 2), síntese vocal nativa (TTS `flutter_tts`), backend multi-tenant em nuvem com conformidade integral à LGPD, IA adaptativa com Bayesian Knowledge Tracing e esteira CI/CD via GitHub Actions e Fastlane.

---

## 🗺️ Mapa Completo de Telas e Requisitos (`lib/main.dart`)

| Rota Nomeada | View (`lib/view/`) | Controller (`lib/controller/`) | Requisito Atendido | Peso | Status |
| :--- | :--- | :--- | :--- | :---: | :---: |
| `'login'` *(inicial)* | `login_view.dart` | `login_controller.dart` | **RF001** (Login + Validações) | **20%** *(bloco)* | ✅ |
| `'cadastro_usuario'` | `cadastro_usuario_view.dart` | `cadastro_usuario_controller.dart` | **RF002** (Cadastro + 5 campos) | *(bloco)* | ✅ |
| `'recuperar_senha'` | `recuperar_senha_view.dart` | `recuperar_senha_controller.dart` | **RF003** (Esqueceu a Senha) | *(bloco)* | ✅ |
| `'sobre'` | `sobre_view.dart` | `sobre_controller.dart` | **RF004** (Sobre o Projeto) | **10%** | ✅ |
| `'perfil'` | `perfil_view.dart` | `perfil_controller.dart` | **RF005** (Perfil Reativo) | **10%** | ✅ |
| `'trilha_atividades'` | `trilha_atividades_view.dart` | `trilha_atividades_controller.dart` | **RF006 (1/5)** + **RF007 (`ListView`)** | **50% + 10%** | ✅ |
| `'prancha_comunicacao'` | `prancha_comunicacao_view.dart` | `prancha_comunicacao_controller.dart` | **RF006 (2/5)** + **RF007 (`GridView`)** | *(bloco)* | ✅ |
| `'treino_cognitivo'` | `treino_cognitivo_view.dart` | `treino_cognitivo_controller.dart` | **RF006 (3/5)** (Adaptação Híbrida) | *(bloco)* | ✅ |
| `'conquistas'` | `conquistas_view.dart` | `conquistas_controller.dart` | **RF006 (4/5)** + **RF007 (`ListView`)** | *(bloco)* | ✅ |
| `'painel_adaptativo'` | `painel_adaptativo_view.dart` | `painel_adaptativo_controller.dart` | **RF006 (5/5)** (Calibragem + SUS) | *(bloco)* | ✅ |

---

## 🔑 Credenciais Padrão para Demonstração Rápida

Na tela de Login (`LoginView`), você pode clicar no botão **"Preencher conta de demonstração"** ou informar manualmente:
* **E-mail:** `pedro.santos@fatec.sp.gov.br`
* **Senha:** `123456`

---

## ✅ Checklist da Rubrica de Avaliação (Roteiro Rápido de Verificação)

- [x] **RF001 (Login):** Campo de e-mail, senha, logotipo (`CognDown`), botão `"Entrar"`, links para Cadastro e Esqueceu a Senha, validação de campos vazios e formato de e-mail.
- [x] **RF002 (Cadastro):** Campos Nome, E-mail, Telefone, Senha e Confirmação de Senha; validação de preenchimento, formato de e-mail e igualdade de senhas; entrada direta no app após cadastro.
- [x] **RF003 (Esqueceu a Senha):** Validação de e-mail preenchido, formato válido e vínculo com conta cadastrada (`sessao.existeEmail`).
- [x] **RF004 (Sobre):** Objetivo do aplicativo, Equipe (`Pedro Garibaldi Santos`), Disciplina (`Programação para Dispositivos Móveis`), Instituição (`FATEC Ribeirão Preto`), Professor (`Prof. Dr. Rodrigo de Oliveira Plotze`) e Versão (`1.0.0`).
- [x] **RF005 (Perfil do Usuário):** E-mail somente visualização (`readOnly: true`, `enabled: false`), Nome editável (mínimo 3 caracteres) e atualização reativa global do nome em todas as telas (`AppBar`, `Drawer`, `ConquistasView`, `PainelAdaptativoView`).
- [x] **RF006 (5 Funcionalidades Específicas do Tema):** 5 funcionalidades em 5 arquivos Dart separados dentro de `lib/view/`.
- [x] **RF007 (Listagem de Dados):** `ListView.builder` implementado em `trilha_atividades_view.dart` e `conquistas_view.dart`, e `GridView.builder` implementado em `prancha_comunicacao_view.dart`.
- [x] **Gerenciamento de Estado:** Uso de `ChangeNotifier` + `GetIt` + `ListenableBuilder` em todas as telas.

---

## 🚀 Como Executar e Testar o Projeto

```bash
# Executar a suíte de testes automatizados (12 testes cobrindo os 4 grupos)
flutter test test/app_projeto_test.dart

# Verificar análise estática de código (0 issues)
flutter analyze

# Executar no Chrome (Web) ou Linux Desktop
flutter run -d chrome
# ou
flutter run -d linux
```
