% Trabalho Final - Programacao Logica
% Tema: Jogo da Velha baseado em fatos e regras
%
% Este programa modela o Jogo da Velha de forma declarativa.
% O estado do tabuleiro e representado por fatos, e as conclusoes
% sobre vencedor, empate, casas vazias e melhores jogadas sao obtidas
% por regras logicas, unificacao e backtracking.

% ------------------------------------------------------------
% FATOS DO DOMINIO
% ------------------------------------------------------------
% jogador(Simbolo).
% Define os jogadores validos.

jogador(x).
jogador(o).

% posicao(Linha, Coluna, Conteudo).
% Conteudo pode ser x, o ou vazio.
% Linhas e colunas variam de 1 a 3.

posicao(1, 1, x).
posicao(1, 2, x).
posicao(1, 3, x).

posicao(2, 1, o).
posicao(2, 2, o).
posicao(2, 3, vazio).

posicao(3, 1, vazio).
posicao(3, 2, vazio).
posicao(3, 3, vazio).

% ------------------------------------------------------------
% REGRAS BASICAS
% ------------------------------------------------------------

casa_valida(Linha, Coluna) :-
    between(1, 3, Linha),
    between(1, 3, Coluna).

casa_vazia(Linha, Coluna) :-
    posicao(Linha, Coluna, vazio).

casa_ocupada(Linha, Coluna, Jogador) :-
    jogador(Jogador),
    posicao(Linha, Coluna, Jogador).

% ------------------------------------------------------------
% REGRAS DE VITORIA
% ------------------------------------------------------------

% Vitoria por linha.
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).

% Vitoria por coluna.
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, Coluna, Jogador),
    posicao(2, Coluna, Jogador),
    posicao(3, Coluna, Jogador).

% Vitoria pela diagonal principal.
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 1, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 3, Jogador).

% Vitoria pela diagonal secundaria.
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 3, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 1, Jogador).

% ------------------------------------------------------------
% ESTADO DO JOGO
% ------------------------------------------------------------

existe_casa_vazia :-
    posicao(_, _, vazio).

jogo_em_andamento :-
    \+ vencedor(x),
    \+ vencedor(o),
    existe_casa_vazia.

empate :-
    \+ vencedor(x),
    \+ vencedor(o),
    \+ existe_casa_vazia.

fim_de_jogo :-
    vencedor(_).

fim_de_jogo :-
    empate.

% ------------------------------------------------------------
% REGRAS NAO TRIVIAIS DE INFERENCIA
% ------------------------------------------------------------
% A regra pode_vencer/3 infere se o jogador pode ganhar colocando
% sua peca em uma casa vazia especifica.

pode_vencer(Jogador, Linha, Coluna) :-
    jogador(Jogador),
    casa_vazia(Linha, Coluna),
    completa_linha(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogador(Jogador),
    casa_vazia(Linha, Coluna),
    completa_coluna(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogador(Jogador),
    casa_vazia(Linha, Coluna),
    completa_diagonal_principal(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogador(Jogador),
    casa_vazia(Linha, Coluna),
    completa_diagonal_secundaria(Jogador, Linha, Coluna).

% Duas pecas do mesmo jogador na mesma linha, com a terceira casa vazia.
completa_linha(Jogador, Linha, ColunaVazia) :-
    casa_vazia(Linha, ColunaVazia),
    casa_ocupada(Linha, Coluna1, Jogador),
    casa_ocupada(Linha, Coluna2, Jogador),
    Coluna1 \= Coluna2,
    Coluna1 \= ColunaVazia,
    Coluna2 \= ColunaVazia.

% Duas pecas do mesmo jogador na mesma coluna, com a terceira casa vazia.
completa_coluna(Jogador, LinhaVazia, Coluna) :-
    casa_vazia(LinhaVazia, Coluna),
    casa_ocupada(Linha1, Coluna, Jogador),
    casa_ocupada(Linha2, Coluna, Jogador),
    Linha1 \= Linha2,
    Linha1 \= LinhaVazia,
    Linha2 \= LinhaVazia.

% Diagonal principal: (1,1), (2,2), (3,3).
completa_diagonal_principal(Jogador, Linha, Coluna) :-
    casa_vazia(Linha, Coluna),
    Linha =:= Coluna,
    casa_ocupada(Linha1, Coluna1, Jogador),
    casa_ocupada(Linha2, Coluna2, Jogador),
    Linha1 =:= Coluna1,
    Linha2 =:= Coluna2,
    Linha1 \= Linha2,
    Linha1 \= Linha,
    Linha2 \= Linha.

% Diagonal secundaria: (1,3), (2,2), (3,1).
completa_diagonal_secundaria(Jogador, Linha, Coluna) :-
    casa_vazia(Linha, Coluna),
    Linha + Coluna =:= 4,
    casa_ocupada(Linha1, Coluna1, Jogador),
    casa_ocupada(Linha2, Coluna2, Jogador),
    Linha1 + Coluna1 =:= 4,
    Linha2 + Coluna2 =:= 4,
    Linha1 \= Linha2,
    Linha1 \= Linha,
    Linha2 \= Linha.

% Melhor jogada simples:
% 1. Se houver uma jogada de vitoria, ela e sugerida.
% 2. Caso contrario, qualquer casa vazia e uma jogada possivel.
melhor_jogada(Jogador, Linha, Coluna) :-
    pode_vencer(Jogador, Linha, Coluna).

melhor_jogada(Jogador, Linha, Coluna) :-
    jogador(Jogador),
    \+ pode_vencer(Jogador, _, _),
    casa_vazia(Linha, Coluna).
