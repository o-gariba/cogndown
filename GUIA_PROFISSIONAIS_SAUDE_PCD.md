# Guia Didático e Clínico-Pedagógico — Aplicativo CognDown

**Público-Alvo:** Profissionais da Atenção à Saúde e Educação Especial de Pessoas com Deficiência (PcDs) — Fonoaudiólogos(as), Terapeutas Ocupacionais, Psicopedagogos(as), Neuropsicólogos(as), Educadores(as) do Atendimento Educacional Especializado (AEE) e Mediadores(as) Familiares.

---

## 1. Fundamentação Clínica e Pedagógica do CognDown

O aplicativo **CognDown** foi concebido a partir do projeto de pesquisa aplicada *"Desenvolvimento e Avaliação de um Software Adaptativo e Gamificado para o Estímulo de Habilidades Cognitivas e de Comunicação em Indivíduos com Síndrome de Down"* (FATEC Ribeirão Preto).

Pessoas com Trissomia do Cromossomo 21 (Síndrome de Down — T21) frequentemente apresentam um **perfil neurocognitivo dissíncrono**, caracterizado por:
1. **Potencialidade no Processamento Visuoespacial:** Maior facilidade na retenção e associação de estímulos visuais concretos, ícones, cores de alto contraste e rotinas previsíveis.
2. **Desafios na Memória de Trabalho Fonológica e Expressão Verbal:** Dificuldades na retenção de instruções puramente auditivas extensas e na articulação fonoarticulatória, o que pode gerar frustração comunicativa quando a compreensão receptiva supera a capacidade expressiva verbal.
3. **Sensibilidade à Sobrecarga Cognitiva:** Interfaces poluídas ou saltos abruptos de dificuldade podem desencadear esquiva comportamental e perda de engajamento na atividade terapêutica.

Para responder diretamente a essas demandas clínicas, o **CognDown** articula três pilares baseados em evidências:
- **Comunicação Aumentativa e Alternativa (CAA):** Uso de pranchas pictográficas categorizadas para construção de frases funcionais (*"Eu quero..."*, *"Eu sinto..."*), reduzindo a barreira expressiva e estimulando a estruturação morfossintática inicial.
- **Treino Cognitivo Visuoespacial e Executivo:** Exercícios estruturados de atenção seletiva, categorização semântica, sequenciamento lógico de rotina diária e memória visuoespacial.
- **Motor de Adaptação Híbrido (Automático + Mediado):** Sistema que monitora os acertos e erros consecutivos em tempo real para ajustar automaticamente o nível de complexidade e o andaime visual (*scaffolding*), permitindo também que o profissional assuma o controle fino a qualquer momento.

---

## 2. Visão Geral das Telas e Recursos Terapêuticos

| Tela do Aplicativo | Papel Clínico / Pedagógico | Quem Utiliza Principalmente |
| :--- | :--- | :--- |
| **Login, Cadastro e Recuperação** | Identificação individualizada. Cada assistido/mediador possui seu próprio perfil, garantindo que o histórico de desempenho não se misture entre diferentes pacientes. | Profissional / Mediador |
| **Trilha de Atividades (Home)** | Roteiro visual previsível dividido por áreas (*Comunicação CAA*, *Memória & Atenção*, *Rotina Diária*). Reduz a ansiedade antecipatória do assistido ao mostrar claramente o progresso diário. | Assistido com mediação |
| **Prancha de Comunicação (CAA)** | Grade de cartões pictográficos com suporte a filtro semântico (*Necessidades*, *Emoções*, *Pessoas*, *Ações*), barra construtora de frase passo a passo e histórico rápido de frases recentes. | Assistido / Fonoaudiólogo(a) |
| **Treino Cognitivo Adaptativo** | Ambiente de estimulação de funções executivas e linguagem receptiva com feedback positivo imediato, dicas visuais (*scaffolding*) e ajuste dinâmico de dificuldade. | Assistido com mediação |
| **Mural de Conquistas** | Sistema de reforço positivo simbólico (gamificação). Converte o engajamento em medalhas visuais e estrelas (`⭐`), evitando punições por erro. | Assistido / Mediador |
| **Painel Adaptativo (Terapeuta)** | Prontuário de calibração e monitoramento quantitativo. Exibe taxa de precisão (%), nível atual, controle de dicas, meta diária e registro estruturado da escala *System Usability Scale* (SUS). | Profissional da Saúde / Educação |

---

## 3. Roteiro Prático de Sessão Terapêutica (Passo a Passo)

Abaixo, apresentamos um protocolo sugerido de **30 a 45 minutos** para utilização do **CognDown** em consultório, clínica multiprofissional, sala de recursos multifuncionais (AEE) ou orientação domiciliar:

### Passo 1 — Identificação e Acolhimento (2 a 3 minutos)
1. Acesse a tela de **Login** utilizando a conta individual do assistido (ou cadastre um novo perfil em **"Criar conta de Mediador / Educando"** para isolar os indicadores daquele paciente).
   - *Conta de demonstração pré-configurada para teste rápido:*
     - **E-mail:** `pedro.santos@fatec.sp.gov.br` | **Senha:** `123456`
2. Caso deseje personalizar o nome exibido nos relatórios e cabeçalhos para o nome da criança/jovem atendido, acesse o ícone **Meu Perfil** na barra superior ou menu lateral e salve a alteração.

### Passo 2 — Calibração Pré-Sessão pelo Profissional (3 a 5 minutos)
Antes de entregar o dispositivo ao assistido, acesse o **Painel Adaptativo** (ícone `tune` na barra superior ou pelo menu lateral):
1. **Escolha o Nível Inicial de Complexidade:**
   - **Básico:** Indicado para início de vínculo terapêutico, crianças pequenas ou assistidos com necessidade de conceitos concretos diretos (cores primárias, pareamento simples e emoções básicas).
   - **Intermediário:** Indicado para treino de categorização funcional (ex.: separar alimentos de objetos, identificar utensílios e associar contexto climático ao vestuário).
   - **Avançado:** Indicado para jovens/adultos ou assistidos em fase de consolidação de funções executivas (sequenciamento temporal de higiene, exclusão de intruso semântico e inferência funcional).
2. **Configure o Andaime Visual (*Scaffolding*):**
   - Mantenha a chave **"Exibir Dicas Visuais (Scaffolding) no Treino"** ativada caso o assistido ainda dependa de pistas contextuais ou mediação verbal constante.
   - Desative a chave quando desejar avaliar a **autonomia de resposta** sem dicas suplementares.
3. **Ajuste a Meta Diária de Módulos (3 a 6 módulos):**
   - Adapte a meta ao tempo de atenção sustentada do assistido naquele dia, garantindo que ele consiga atingir 100% da barra de progresso antes da fadiga cognitiva.

### Passo 3 — Estimulação Expressiva na Prancha de Comunicação CAA (10 a 15 minutos)
1. A partir da **Trilha de Atividades**, toque em um módulo de *Comunicação CAA* (ex.: *"Expressando Necessidades Básicas"* ou *"Reconhecimento de Emoções e Estados"*) ou acesse diretamente o botão **"Prancha CAA"**.
   - *Observação clínica:* Ao clicar em *"Expressando Necessidades Básicas"* ou *"Reconhecimento de Emoções"* na Trilha, o aplicativo já abre a Prancha CAA filtrada na respectiva categoria semântica para reduzir distratores visuais.
2. **Construção Guiada de Frases:**
   - Estimule o assistido a tocar sequencialmente nos pictogramas para estruturar frases funcionais na barra superior (ex.: `[Eu quero]` + `[Beber Água]` + `[Obrigado]`, ou `[Eu sinto]` + `[Alegria]`).
   - Utilize o botão **"Remover Último"** para trabalhar autocorreção sem apagar toda a frase construída.
3. **Vocalização e Reforço Comunicativo:**
   - Ao tocar em **"Expressar Frase"**, o aplicativo exibe um destaque visual com a sentença completa, contabiliza a produção comunicativa no prontuário da sessão (`+2 ⭐`) e armazena a frase na barra de **"Últimas frases expressas"**.
   - Caso o assistido queira repetir uma solicitação recente, basta tocar sobre a frase salva no histórico superior para recarregá-la na barra construtora.

### Passo 4 — Estimulação de Funções Executivas no Treino Cognitivo (10 a 15 minutos)
1. Retorne à **Trilha de Atividades** e selecione um módulo de *Memória & Atenção* ou *Rotina Diária*, ou toque em **"Treino Cognitivo"**.
2. **Mediação da Resposta:**
   - Leia o enunciado junto ao assistido (ou incentive a leitura compartilhada) e observe o tempo de varredura visual entre as 4 alternativas com suporte de ícone.
   - Caso as **Dicas Visuais** estejam ativas, utilize o quadro amarelo de *"Dica Pedagógica"* como pista semântica antes da escolha.
3. **Como Funciona a Adaptação Dinâmica Automática durante o Treino:**
   - **Promoção de Nível (+3 acertos consecutivos):** Quando o assistido acerta **3 desafios seguidos**, o Motor de Adaptação Híbrido identifica consolidação da habilidade e avança automaticamente o nível (`Básico → Intermediário → Avançado`), emitindo um aviso ao mediador.
   - **Suporte e Redução de Frustração (2 erros consecutivos):** Quando ocorrem **2 erros seguidos**, o sistema **ativa automaticamente as Dicas Visuais (*scaffolding*)** e, se necessário, reduz a complexidade em um nível (`Avançado → Intermediário → Básico`), preservando a autoestima e a motivação do assistido.

### Passo 5 — Fechamento com Reforço Positivo e Registro Clínico (5 minutos)
1. **Celebração no Mural de Conquistas:**
   - Ao final das atividades, abra a tela **Conquistas** junto com o assistido.
   - Mostre as medalhas desbloqueadas automaticamente (ex.: *"Primeira Frase CAA"*, *"Explorador Visual"*, *"Foco em Evolução"*) e convide o próprio assistido a tocar em **"Resgatar Bônus (+5 ⭐)"**. Esse ritual de encerramento consolida o vínculo positivo com a sessão.
2. **Análise de Indicadores e Registro no Painel Adaptativo:**
   - De volta ao **Painel Adaptativo**, verifique os **Indicadores Quantitativos da Sessão**:
     - **Acertos Cognitivos** e **Taxa de Precisão (%)**: Úteis para documentar a evolução longitudinal em relatórios fonoaudiológicos, psicopedagógicos ou de terapia ocupacional.
     - **Frases CAA Expressas** e **Módulos Concluídos**: Indicadores de engajamento comunicativo e cumprimento da rotina planejada.
   - Preencha o formulário de **Avaliação Empírica (Escala SUS — 1 a 5)** e descreva a observação qualitativa do atendimento (ex.: *"Paciente manteve atenção sustentada por 20 min; utilizou a prancha de emoções de forma funcional após dica verbal mínima"*).
   - O sistema calcula automaticamente o **Escore SUS convertido na escala padronizada de 0 a 100 pontos** e classifica a sessão (*Excelente*, *Bom/Aceitável* ou *Atenção Clínica*), listando o registro no histórico cronológico inferior com o nome do assistido avaliado.

---

## 4. Perguntas Frequentes da Equipe Multiprofissional (FAQ Clínico)

### 1. "Posso atender vários pacientes no mesmo tablet/celular sem misturar os dados?"
**Sim.** O CognDown possui isolamento completo de dados por conta de usuário. Você pode cadastrar uma conta para cada assistido na tela de **Cadastro de Usuário** (ex.: `paciente1@clinica.com.br`, `paciente2@clinica.com.br`) ou atualizar o nome do assistido em **Meu Perfil**. As estrelas, frases CAA, taxa de precisão cognitiva, medalhas e nível adaptativo ficam vinculados individualmente a cada perfil.

### 2. "O sistema subiu para o nível Avançado automaticamente, mas percebi que o paciente cansou. Posso voltar para o Básico?"
**Sim, a qualquer momento.** Por ser um **Motor de Adaptação Híbrido**, a palavra final é sempre do profissional mediador. Basta abrir o **Painel Adaptativo**, tocar no seletor manual de nível (**Básico**, **Intermediário** ou **Avançado**) e o **Treino Cognitivo** se sincronizará imediatamente com a sua decisão clínica.

### 3. "Como o aplicativo lida com o erro do assistido?"
Seguindo diretrizes de aprendizagem sem erro (*errorless learning*) e gamificação inclusiva, o aplicativo **nunca retira estrelas ou medalhas** quando o assistido seleciona uma alternativa incorreta. O feedback de erro é gentil, convida a uma nova tentativa sem punição e aciona o suporte de dicas visuais caso a dificuldade persista.
