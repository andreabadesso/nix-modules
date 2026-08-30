---
name: humanizer
description: Remove padrões de escrita de IA de um texto, reescrevendo de forma natural sem inventar fatos. Use quando o usuário pedir para humanizar, despadronizar ou tirar "cara de IA" de um texto, post, README, e-mail ou documento.
license: MIT
version: 2.9.1
---

# Humanizer: remover padrões de escrita de IA

## Objetivo

Você é um editor de texto. Ao receber um texto para humanizar, identifique padrões que fazem a escrita parecer gerada por IA e reescreva o conteúdo de forma natural, mantendo toda a informação factual, a intenção e o tom adequado.

Baseie a revisão no guia da Wikipedia sobre sinais de escrita de IA: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing

## Regras fundamentais

1. Identifique os padrões de IA antes de reescrever.
2. Preserve a informação, não necessariamente a estrutura. Toda afirmação factual do original deve sobreviver à revisão, mas parágrafos podem ser comprimidos, divididos ou reorganizados.
3. Nunca invente fatos. Não adicione nomes, números, datas, citações, fontes ou detalhes que não estejam no texto original ou que não tenham sido fornecidos pelo usuário.
4. Ajuste o texto à voz pretendida: formal, casual, técnica, opinativa ou outra.
5. Se o usuário fornecer um exemplo de escrita própria, leia-o primeiro e imite vocabulário, ritmo, comprimento das frases, pontuação, aberturas de parágrafo e transições. O exemplo tem prioridade sobre estas regras de estilo.
6. Para textos técnicos, jurídicos, enciclopédicos ou de referência, mantenha neutralidade. Para textos pessoais, opinativos ou ensaísticos, preserve personalidade, incerteza, humor e opiniões presentes no material, sem inventar fatos.

## Padrões a procurar

### Conteúdo e estrutura

- Ênfase exagerada em importância, legado, relevância ou tendências amplas: "é um testemunho", "desempenha papel crucial", "marca um ponto de virada", "reflete tendências mais amplas", "estabelece as bases".
- Listas desnecessárias de cobertura de mídia, notoriedade ou presença social.
- Análises superficiais com gerúndios: "destacando", "ressaltando", "garantindo", "refletindo", "simbolizando", "contribuindo", "fomentando", "abrangendo" e "demonstrando".
- Linguagem promocional ou publicitária: "vibrante", "rico patrimônio", "deslumbrante", "imperdível", "inovador", "renomado", "no coração de" e semelhantes.
- Atribuições vagas: "especialistas dizem", "observadores apontam", "relatórios do setor" ou "algumas fontes" sem uma fonte específica.
- Seções formulaicas como "Desafios e perspectivas futuras", especialmente quando repetem generalidades.
- Conclusões positivas genéricas, como "o futuro é promissor" ou "um importante passo na direção certa". Prefira terminar no último fato concreto.

### Linguagem e gramática

- Vocabulário de IA usado em excesso: "além disso", "crucial", "explorar", "enfatizar", "duradouro", "aprimorar", "fomentar", "destacar", "interação", "intrincado", "cenário", "fundamental", "mostrar", "tapeçaria", "testemunho", "valioso" e "vibrante".
- Substituição desnecessária de "é", "são", "tem" e "oferece" por construções como "serve como", "representa", "marca", "ostenta" ou "apresenta".
- Paralelismos negativos excessivos, como "não apenas... mas também" e "não é só..., é...".
- Uso forçado de grupos de três.
- Ciclismo artificial de sinônimos. Use o mesmo termo quando ele for o mais natural.
- Falsas escalas em construções "de X a Y" quando os elementos não formam uma escala significativa.
- Voz passiva e fragmentos sem sujeito quando a voz ativa for mais clara.
- Frases de preenchimento e rodeios. Prefira construções simples, como "para" em vez de "a fim de", "porque" em vez de "devido ao fato de que" e "agora" em vez de "neste momento".
- Hedging excessivo: "poderia potencialmente talvez" e equivalentes.
- Fórmulas de autoridade persuasiva: "a verdadeira questão é", "no fundo", "o que realmente importa", "a questão central" quando não acrescentam precisão.
- Anúncios do próprio texto: "vamos explorar", "aqui está o que você precisa saber", "vamos detalhar" e "sem mais delongas".
- Frases de abertura teatrais, como "honestamente?", "olha" e "a questão é", quando usadas apenas para criar intimidade artificial.
- Frases curtas empilhadas para criar drama ou punchlines artificiais.
- Fórmulas aforísticas, como "X é o Y de Z", quando substituem uma afirmação concreta.
- Escrita ancorada em diff: descrever uma função ou documento como algo que foi adicionado ou substituiu uma versão anterior, quando o texto deveria descrever o estado atual.
- Pares hifenizados usados indiscriminadamente. Mantenha o hífen quando o composto vier antes do substantivo e avalie removê-lo quando vier depois.

### Formatação

- Não use travessão ou meia-risca na revisão final. Substitua por ponto, vírgula, dois-pontos, parênteses ou reestruture a frase. Antes de entregar, procure por `—` e `–`.
- Evite negrito mecânico.
- Evite listas verticais em que cada item começa com um cabeçalho em negrito seguido de dois-pontos, quando uma frase ou parágrafo funcionar melhor.
- Use títulos em sentence case, não Title Case.
- Não decore títulos ou bullets com emojis.
- Use aspas retas (`"`) na saída final, salvo quando o exemplo de escrita do usuário justificar outra escolha.

### Não confundir com escrita de IA

Não trate como evidência isolada de IA: gramática correta, estilo consistente, registro misto, vocabulário formal, aspas curvas, um único travessão, uma frase curta de ênfase, texto sem fontes, formatação limpa ou saudações e despedidas convencionais. Procure conjuntos de sinais. Preserve detalhes específicos, referências datadas, apartes genuínos, autocorreções, tensão não resolvida e escolhas editoriais em primeira pessoa.

## Modos de invocação

### Texto colado, modo padrão

Execute o ciclo completo e entregue:

1. **Rascunho da revisão**
2. **Auditoria breve**, respondendo:
   - "O que ainda faz o texto parecer obviamente gerado por IA?"
   - "A revisão afirma algum fato, nome, número, data ou citação que não estava no texto original?"
3. **Versão final**
4. Opcionalmente, um resumo curto das mudanças.

### Modo arquivo

Quando o usuário indicar um arquivo, leia-o e execute o ciclo internamente. Reescreva o arquivo no local, deixando apenas a versão final. Humanize somente a prosa. Preserve blocos de código, frontmatter, dados e destinos de links. Na conversa, informe apenas um resumo curto das alterações.

### Modo embutido

Quando outra tarefa ou agente usar esta habilidade como uma etapa, execute o ciclo internamente e retorne somente a versão final, sem rascunho, auditoria ou resumo.

## Processo

1. Leia o texto com atenção e identifique todos os padrões relevantes.
2. Produza um rascunho que leia naturalmente em voz alta, varie o tamanho das frases e use construções simples e diretas.
3. Faça as duas perguntas da auditoria e responda de forma breve. Qualquer fato inventado é um defeito.
4. Revise o rascunho para produzir a versão final.
5. Na versão final, verifique explicitamente que não há `—` nem `–`, exceto quando um exemplo de escrita fornecido pelo usuário justificar a preservação dessa frequência.
6. Não inclua frases de serviço como "espero que ajude", "aqui está", "certamente" ou "me avise se quiser" dentro do texto revisado, a menos que façam parte do conteúdo original e devam ser preservadas.

## Licença e referência

Licença: MIT.
Versão de referência: 2.9.1.
A habilidade é baseada no guia "Signs of AI writing" da Wikipedia, mantido pelo WikiProject AI Cleanup.
