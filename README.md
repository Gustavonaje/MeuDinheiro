# Meu dinheiro

Controle de gastos, metas, cartões, parcelamentos e quem me deve.
Uma página só, sem servidor próprio. Abre sem internet e, quando você
liga a nuvem, o que lança no celular aparece no computador e vice‑versa.

---

## 1. Criar a tabela no Supabase

No projeto do Supabase: **SQL Editor → New query**, cole o conteúdo de
[`supabase.sql`](supabase.sql) e clique em **Run**.

Isso cria a tabela `meu_dinheiro_estado` e tranca o acesso: cada conta
só enxerga a própria linha. Nada que já existe no projeto é alterado.

Em seguida, em **Authentication → Sign In / Providers → Email**, decida
se quer confirmação por e‑mail. Desligando **Confirm email**, a conta é
criada e já entra na hora — é o caminho mais curto para um app de uso
pessoal.

## 2. Preencher o `config.js`

Em **Project Settings → API**, copie:

| No Supabase        | No `config.js` |
| ------------------ | -------------- |
| Project URL        | `url`          |
| Chave `anon public`| `anon`         |

```js
window.NUVEM_CONFIG = {
  url:    "https://xxxxxxxxxxxx.supabase.co",
  anon:   "eyJhbGciOiJI...",
  tabela: "meu_dinheiro_estado"
};
```

A chave `anon public` é feita para ficar visível — ela sozinha não abre
nada. Quem protege os dados é o login somado às regras criadas no passo 1.
A chave **`service_role` nunca entra aqui**; essa abre tudo.

Deixando os campos em branco, o app funciona normalmente, só que os dados
ficam guardados apenas naquele aparelho. Dá também para preencher pela
própria interface, em **Ajustes → Nuvem**, sem mexer no arquivo.

## 3. Publicar no GitHub

Crie um repositório e suba o conteúdo desta pasta na raiz (não a pasta
inteira — os arquivos soltos: `index.html`, `config.js`, `sw.js`,
`manifest.webmanifest`, `icons/`, …).

Depois, em **Settings → Pages**:

- **Source**: Deploy from a branch
- **Branch**: `main` · pasta `/ (root)`

Um ou dois minutos depois o endereço fica de pé:

```
https://SEU-USUARIO.github.io/NOME-DO-REPO/
```

> O GitHub Pages gratuito só funciona em repositório público. Como aqui
> só mora o código — nenhum dado financeiro — isso não é problema. Os
> lançamentos ficam no seu aparelho e na sua conta do Supabase.

## 4. Instalar no celular

Abra o endereço no Chrome do celular → menu **⋮** → **Adicionar à tela
inicial**. No iPhone, Safari → **Compartilhar** → **Adicionar à Tela de
Início**.

Instalado, abre em tela cheia pelo ícone, sem barra de endereço, e
continua funcionando sem internet.

## 5. Levar os dados que você já tem

**Faça isso antes de ligar a nuvem.** O navegador guarda os dados por
endereço: o que está no arquivo aberto do seu computador (`file://…`) e o
que está no `github.io` são dois cofres diferentes, e um não enxerga o
outro.

1. Abra o arquivo antigo como você vem usando → **Ajustes → Cópia de
   segurança → Baixar**.
2. Abra o endereço novo → **Ajustes → Cópia de segurança → Restaurar** →
   escolha o `.json`.
3. Só então ligue a nuvem. O primeiro aparelho sobe tudo.

## 6. Entrar na nuvem

No app: **Ajustes → Nuvem e outros aparelhos → Criar conta**. Use o mesmo
e‑mail e senha em todos os aparelhos. O primeiro aparelho sobe o que já
tem; os seguintes baixam.

---

## Como a sincronização se comporta

- **O aparelho manda primeiro.** O app abre lendo o que está guardado
  localmente, então nunca fica esperando internet. A nuvem entra depois.
- **Toda gravação sobe sozinha**, alguns segundos depois do último toque.
- **Sem internet, nada se perde**: fica marcado como pendente e sobe quando
  a conexão voltar.
- **Cada gravação carrega um número de versão.** Se outro aparelho gravou
  antes, o envio é recusado em vez de atropelar — o app avisa, mostra os
  dois lados (quantos lançamentos, de qual aparelho, de quando) e você
  escolhe. O lado descartado é baixado em arquivo antes de qualquer coisa.
- **Nada é aplicado enquanto um formulário está aberto.** O que chegou
  espera você fechar.

Vale saber: a unidade de sincronização é o conjunto inteiro, não o
lançamento. Dois aparelhos lançando coisas diferentes *ao mesmo tempo*
resultam em uma escolha, não em uma mistura. Para uso pessoal — um
celular e um computador, um de cada vez — isso quase nunca aparece, e é
o desenho que garante que as contas do app nunca fiquem pela metade.

## Onde cada coisa mora

| | |
| --- | --- |
| Lançamentos, contas, metas | `localStorage` do aparelho **e** uma linha no Supabase |
| E‑mail, token de acesso, nome do aparelho | só no aparelho |
| Chave `anon` e endereço do projeto | `config.js`, público |

## Atualizar o app depois

Suba o `index.html` novo (e o `sw.js`, que carrega o número da versão).
Quem já tem instalado recebe na próxima vez que abrir com internet.
O `config.js` não é sobrescrito pela build — suas chaves continuam lá.

## Cópia de segurança

**Ajustes → Cópia de segurança → Baixar** gera um `.json` com tudo.
Vale guardar um de vez em quando, mesmo com a nuvem ligada: protege
contra engano seu, não só contra pane.
