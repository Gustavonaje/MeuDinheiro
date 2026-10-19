/* ---------------------------------------------------------------
   Ligação com o Supabase.

   Preencha os dois campos abaixo com os dados do seu projeto
   (painel do Supabase -> Project Settings -> API) e salve.

   A chave "anon public" pode ficar aqui à vista: ela sozinha não
   abre nada. Quem protege os dados é o login, somado às regras de
   acesso criadas pelo arquivo supabase.sql.

   Deixando em branco, o app funciona normalmente, só que os dados
   ficam guardados apenas neste aparelho.
   --------------------------------------------------------------- */
window.NUVEM_CONFIG = {
  url:    "https://widnalbffoapchvbujjn.supabase.co",
  anon:   "sb_publishable_yJgR0vjYRX-zLTJuBcKaHw_tXeQ0-nP",
  tabela: "meu_dinheiro_estado"
};
