---
name: superstack-pr-jira
description: How André's superstack-frontend team (SuperFrete) opens PRs and Jira cards — Bitbucket via bkt (not gh/GitHub), Jira project NSF with required custom fields, and the exact PR/card templates the team uses. Use whenever asked to commit+push+PR, or to create a Jira card, in the superstack-frontend repo (or any repo with a bitbucket.org remote under i9-internet).
---

# PRs and Jira cards for superstack-frontend (SuperFrete)

This repo (`i9-internet/superstack-frontend`) lives on **Bitbucket**, not
GitHub. Never use `gh` here — use the `bkt` CLI (Bitbucket CLI), available in
the nix dev shell / PATH already (`which bkt`). Auth is already set up
(`bkt auth status` to confirm).

## Repo facts

- Remote: `git@bitbucket.org:i9-internet/superstack-frontend.git`
- Base branch for PRs: `main`
- Commit message convention: `type(scope): descrição em português [NSF-XXX]`
  (types seen: `feat`, `fix`, `chore`, `ci`). Ticket ref in `[]` at the end,
  not a prefix.
- Branch naming seen in the wild: `feat/NSF-XXX-slug`, `fix/NSF-XXX-slug`,
  `ci/NSF-XXX-slug`. Feature branches usually fork from `origin/main`.

## Opening a PR (`bkt pr create`)

```bash
bkt pr create \
  --title "TYPE - NSF-XXX - Descrição curta em português" \
  --target main \
  --description "$(cat pr-body.md)"
```

- `TYPE` prefix seen: `FEAT`, `FIX`, `CHORE`, `CI-CD`. Match the Jira card's
  spirit (new capability → FEAT, etc).
- Title is `TYPE - NSF-XXX - Descrição`, always with a linked Jira key.
- Write the description to a scratch file first (heredoc-through-`$(cat …)`
  keeps Markdown/emoji intact); `--description`/`-b` takes a string, no
  `--body-file` flag exists.
- `bkt pr view <number>` to read back an existing PR (useful for finding the
  team's current template before writing a new one — templates drift, always
  check a couple of recent PRs with `bkt pr list --state merged --limit 5`
  before assuming the shape below is still current).

### PR body template (checkboxes render as `\[x\]` / `\[ \]` in bkt's markdown)

```markdown
# Checklist

\[x\] O PR foi preenchido seguindo a [documentação](https://superfrete.atlassian.net/wiki/spaces/SUPERFRETE/pages/1336311866/Abrindo+um+PR)?
\[x\] As mudanças foram testadas no ambiente local
\[ \] O [fluxo Short-QA](https://superfrete.atlassian.net/wiki/spaces/SUPERFRETE/pages/2455044116/Short-QA) foi executado com sucesso
\[x\] Não houve quebra nas emissões básicas ou no cálculo de estorno
\[ \] Evidências foram coletadas e anexadas no Card
\[x\] As documentações foram atualizadas ou criadas
\[x\] Testes unitários/memória e de integração cobrem as mudanças
\[ \] O [Checklist de Entrega](https://superfrete.atlassian.net/wiki/spaces/SUPERFRETE/pages/2373124151/Checklist+da+En) foi preenchido

# Descrição

[link do card Jira]

Prosa explicando o quê e por quê. O time escreve em primeira pessoa do
plural/impessoal, prosa densa (não bullet soup), com 2-4 "decisões que valem
a leitura" destacadas em **negrito** quando há trade-offs não óbvios.

# Dependências

Outras branches/PRs que isso empilha, flags que precisam existir em cada
ambiente antes do merge, ou "Nenhuma".

# Bugs conhecidos

Gaps conhecidos e não resolvidos neste PR, ou "Nenhum identificado."

# Proposta de alteração

\[X\] `caminho/do/arquivo.ts`: o que mudou e por quê, uma linha por arquivo/grupo;
\[X\] outro arquivo: ...

# Tipos de mudança

\[ \] CI-CD
\[ \] Refactor
\[ \] Hot fix
\[ \] Bug fix
\[X\] New feature
\[ \] Breaking change

# Como deve ser testado

\[X\] Testes automatizados que já rodaram (com contagem);
\[ \] Passos manuais que faltam (ex: "no ambiente real, logado, repetir X").
```

## Creating a Jira card

Project key: **NSF** (cloudId: `superfrete.atlassian.net`). Use the
`mcp__atlassian__*` tools, not a CLI.

### Two required custom fields that `createJiraIssue` will reject without

Every issue create call fails with `Bad Request` unless you also pass:

```json
{
  "customfield_12942": { "id": "13058" },  // Divisão Estratégica(RGT) = "Run - 60%"
  "customfield_13428": { "id": "13607" }   // Quarter — pick the CURRENT quarter's id
}
```

- `customfield_12942` (Divisão Estratégica/RGT) options: `13058` = Run - 60%,
  `13059` = Grow - 30%, `13060` = BigBets - 10%. Sustaining/extension work on
  an existing feature is almost always **Run**; only pick Grow/BigBets if the
  user says this is new-initiative work.
- `customfield_13428` (Quarter) options are `YYYY - QN` — call
  `getJiraIssueTypeMetaWithFields` (or just try a create and read the
  `allowedValues` in the error) to get the current list of ids, since new
  quarters get added over time. Pick the id matching the actual current date.
- Sanity-check both by reading an existing sibling issue first:
  `getJiraIssue` with `fields: ["customfield_12942","customfield_13428"]`.

### Issue type and hierarchy

- Feature-level work: issue type **"História - Novos Produtos"**.
- Bugs found during dev on a story: **"Bug in Dev - Novos Produtos"** (a
  subtask type, `parent` = the story).
- Sustaining-team bugs not tied to a story: **"Bug - Sustentação"**.
- Set `parent` to the right level: a new capability on an existing feature
  usually becomes a sibling story under the same **Épico**, not a subtask —
  check the existing feature's story (search
  `project = NSF AND text ~ "<feature keyword>"`) to find its epic/parent
  chain before creating.
- Labels: `CoreTech` is common for CoreTech-owned work; product-story cards
  under a feature epic often carry no label at all — match the sibling
  card's labels, don't guess.

### Card description template (matches the PR's "Descrição" register, same emoji headers)

```markdown
### 📂 Contexto

O que existe hoje e por que isso não basta.

### 🎯 Objetivo

Uma frase: o que este card entrega.

### 📌 Escopo

* Bullet list, um item por peça de trabalho concreta.

### 🚫 Fora de escopo

* O que explicitamente NÃO está incluído, e por quê (evita scope creep e
  registra decisões conscientes de não fazer algo agora).

### 🔀 Cenários

**Nome curto do cenário**

* Dado que ...
* Quando ...
* Então ...

(Gherkin-style, sem tags @, um bloco por cenário relevante.)

### ✅ Critérios de aceite

* Lista objetiva e verificável.

### 📝 Observações

Relação com outros cards, decisões a confirmar, contexto que não cabe em
nenhuma seção acima.
```

## Verify the template before reusing it blindly

Both templates above were captured from real PRs/cards in August 2026
(`bkt pr view 195`, Jira `NSF-553`/`NSF-189`). Team conventions drift —
before opening a new PR/card, skim 1-2 recent ones (`bkt pr list --state
merged --limit 5` then `bkt pr view <n>`; `searchJiraIssuesUsingJql` for a
sibling card) to confirm the shape hasn't changed, rather than trusting this
file verbatim forever.
