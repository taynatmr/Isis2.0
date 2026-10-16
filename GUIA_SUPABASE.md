# ISIS 2.0 — Guia para ligar o Supabase

Com isso, cada pessoa cria uma conta (e-mail + senha) e **tudo o que preencher fica salvo nessa conta**, inclusive anexos. Ao entrar em outro celular/computador com o mesmo e-mail, tudo aparece. O app também continua guardando uma cópia no aparelho.

## 1. Criar o projeto (grátis)
1. Acesse https://supabase.com → **Start your project** → entre com GitHub/e-mail.
2. **New project** → dê um nome (ex.: `isis`), crie uma senha do banco (guarde) e escolha a região **South America (São Paulo)**.
3. Aguarde ~2 minutos até o projeto ficar pronto.

## 2. Criar as tabelas e a segurança
1. Menu **SQL Editor** → **New query**.
2. Abra o arquivo `supabase_setup.sql`, copie tudo, cole e clique em **Run**. Deve aparecer "Success".
   - Isso cria a tabela `user_data`, o bucket privado `anexos` e as regras para que **cada pessoa veja somente os próprios dados**.

## 3. Configurar o login
Menu **Authentication → Providers → Email** (já vem ligado):
- **Confirm email**: ligado = a pessoa precisa clicar no link do e-mail ao criar a conta (mais seguro). Desligado = entra na hora (mais simples para testar).
- ⚠️ O envio de e-mail padrão do Supabase é limitado (poucos e-mails por hora). Para divulgar para muitas pessoas, configure um SMTP próprio em **Authentication → Emails → SMTP Settings** (ex.: Resend, Brevo, Gmail com senha de app) — ou deixe "Confirm email" desligado.

Menu **Authentication → URL Configuration**:
- **Site URL**: o endereço onde o app ficará hospedado (ex.: `https://isis.seudominio.com`).
- **Redirect URLs**: adicione o mesmo endereço (para o link de "esqueci minha senha" e de confirmação funcionarem).

## 4. Colocar as chaves no app
1. Menu **Project Settings → API**.
2. Copie a **Project URL** e a chave **anon public**.
3. Abra o `index.html` em um editor de texto, procure por `COLE_AQUI` (fica no bloco "SUPABASE") e substitua:
```js
const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
const SUPABASE_ANON_KEY = 'eyJ...sua chave anon public...';
```
> A chave **anon public** pode ficar no app — quem protege os dados são as regras (RLS) do passo 2. **Nunca** coloque a chave `service_role`.

## 5. Hospedar o app (precisa de endereço https)
Suba a pasta (`index.html`, `manifest.webmanifest`, `sw.js`, ícones) em qualquer hospedagem estática gratuita: **Netlify** (arrastar a pasta em app.netlify.com/drop), **Vercel**, **Cloudflare Pages** ou **GitHub Pages**. Depois coloque o endereço no passo 3 (Site URL).

## 6. Testar
1. Abra o endereço → **Criar conta** → entre → informe como quer ser chamado(a).
2. Cadastre algo, abra o app em outro aparelho/aba anônima com o mesmo e-mail e confira.
3. No Supabase, **Table Editor → user_data** mostra uma linha por pessoa.

## Dúvidas comuns
- **"E-mail ou senha incorretos"**: confira se a conta foi confirmada por e-mail (se "Confirm email" estiver ligado).
- **Esqueci a senha**: na tela de entrada, "Esqueci minha senha" envia um link para criar outra.
- **Sem internet**: o app continua funcionando e envia tudo quando a conexão voltar (aparece um aviso se houver falha).
- **Backup extra**: em *Backup & Armazenamento* cada pessoa pode baixar um arquivo .json dos próprios dados.
