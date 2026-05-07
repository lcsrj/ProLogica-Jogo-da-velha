:- use_module(library(readutil)).
:- dynamic posicao/3.

% ==================================================
% JOGO DA VELHA INTERATIVO EM PROLOG
% Jogador humano = x
% CPU = o
% ==================================================

jogador(x).
jogador(o).

% --------------------------------------------------
% Iniciar jogo
% --------------------------------------------------

iniciar :-
    retractall(posicao(_, _, _)),
    nl,
    writeln('================================'),
    writeln('       JOGO DA VELHA PROLOG     '),
    writeln('================================'),
    writeln('Voce joga como X.'),
    writeln('A CPU joga como O.'),
    writeln('Digite linha e coluna de 1 a 3.'),
    writeln('Exemplo: linha 1, coluna 2.'),
    nl,
    turno_usuario.

% --------------------------------------------------
% Turno do usuario
% --------------------------------------------------

turno_usuario :-
    mostrar_tabuleiro,
    (
        fim_de_jogo
    ;
        writeln('Sua vez!'),
        pedir_jogada_usuario,
        mostrar_tabuleiro,
        (
            fim_de_jogo
        ;
            turno_cpu
        )
    ).

pedir_jogada_usuario :-
    ler_numero('Linha: ', Linha),
    ler_numero('Coluna: ', Coluna),
    (
        jogada_valida(Linha, Coluna) ->
            assertz(posicao(Linha, Coluna, x))
    ;
        writeln('Jogada invalida. Tente novamente.'),
        pedir_jogada_usuario
    ).

ler_numero(Mensagem, Numero) :-
    write(Mensagem),
    read_line_to_string(user_input, Texto),
    (
        number_string(Numero, Texto),
        between(1, 3, Numero)
    ;
        writeln('Digite apenas numeros de 1 a 3.'),
        fail
    ).

% --------------------------------------------------
% Turno da CPU
% --------------------------------------------------

turno_cpu :-
    writeln('Vez da CPU...'),
    escolher_jogada_cpu(Linha, Coluna),
    assertz(posicao(Linha, Coluna, o)),
    format('CPU jogou na linha ~w, coluna ~w.~n', [Linha, Coluna]),
    (
        fim_de_jogo
    ;
        turno_usuario
    ).

% Prioridade 1: CPU vence se puder
escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(o, Linha, Coluna),
    !.

% Prioridade 2: CPU bloqueia o jogador X
escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(x, Linha, Coluna),
    !.

% Prioridade 3: CPU escolhe o centro
escolher_jogada_cpu(2, 2) :-
    jogada_valida(2, 2),
    !.

% Prioridade 4: CPU escolhe um canto
escolher_jogada_cpu(Linha, Coluna) :-
    canto(Linha, Coluna),
    jogada_valida(Linha, Coluna),
    !.

% Prioridade 5: CPU escolhe qualquer casa livre
escolher_jogada_cpu(Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    !.

canto(1, 1).
canto(1, 3).
canto(3, 1).
canto(3, 3).

% --------------------------------------------------
% Validacao de jogada
% --------------------------------------------------

jogada_valida(Linha, Coluna) :-
    between(1, 3, Linha),
    between(1, 3, Coluna),
    \+ posicao(Linha, Coluna, _).

% --------------------------------------------------
% Mostrar tabuleiro
% --------------------------------------------------

mostrar_tabuleiro :-
    nl,
    writeln('    1   2   3'),
    writeln('  +---+---+---+'),
    mostrar_linha(1),
    writeln('  +---+---+---+'),
    mostrar_linha(2),
    writeln('  +---+---+---+'),
    mostrar_linha(3),
    writeln('  +---+---+---+'),
    nl.

mostrar_linha(Linha) :-
    valor_casa(Linha, 1, A),
    valor_casa(Linha, 2, B),
    valor_casa(Linha, 3, C),
    format('~w | ~w | ~w | ~w |~n', [Linha, A, B, C]).

valor_casa(Linha, Coluna, Valor) :-
    posicao(Linha, Coluna, Valor),
    !.

valor_casa(_, _, ' ').

% --------------------------------------------------
% Regras de vitoria
% --------------------------------------------------

% Vitoria por linha
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).

% Vitoria por coluna
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, Coluna, Jogador),
    posicao(2, Coluna, Jogador),
    posicao(3, Coluna, Jogador).

% Vitoria pela diagonal principal
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 1, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 3, Jogador).

% Vitoria pela diagonal secundaria
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 3, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 1, Jogador).

% --------------------------------------------------
% Empate e fim de jogo
% --------------------------------------------------

empate :-
    \+ vencedor(x),
    \+ vencedor(o),
    forall(
        (between(1, 3, Linha), between(1, 3, Coluna)),
        posicao(Linha, Coluna, _)
    ).

fim_de_jogo :-
    vencedor(x),
    writeln('Parabens! Voce venceu!'),
    !.

fim_de_jogo :-
    vencedor(o),
    writeln('A CPU venceu!'),
    !.

fim_de_jogo :-
    empate,
    writeln('Fim de jogo! Deu empate!'),
    !.

% --------------------------------------------------
% Regras para CPU analisar vitoria ou bloqueio
% --------------------------------------------------

pode_vencer(Jogador, Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    linha_quase_completa(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    coluna_quase_completa(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    diagonal_principal_quase(Jogador, Linha, Coluna).

pode_vencer(Jogador, Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    diagonal_secundaria_quase(Jogador, Linha, Coluna).

% --------------------------------------------------
% Linha quase completa
% --------------------------------------------------

linha_quase_completa(Jogador, Linha, Coluna) :-
    findall(C, posicao(Linha, C, Jogador), Colunas),
    length(Colunas, 2),
    \+ member(Coluna, Colunas).

% --------------------------------------------------
% Coluna quase completa
% --------------------------------------------------

coluna_quase_completa(Jogador, Linha, Coluna) :-
    findall(L, posicao(L, Coluna, Jogador), Linhas),
    length(Linhas, 2),
    \+ member(Linha, Linhas).

% --------------------------------------------------
% Diagonal principal quase completa
% Casas: (1,1), (2,2), (3,3)
% --------------------------------------------------

diagonal_principal_quase(Jogador, Linha, Coluna) :-
    Linha = Coluna,
    findall((L, C),
        (
            member((L, C), [(1,1), (2,2), (3,3)]),
            posicao(L, C, Jogador)
        ),
        Casas
    ),
    length(Casas, 2),
    \+ member((Linha, Coluna), Casas).

% --------------------------------------------------
% Diagonal secundaria quase completa
% Casas: (1,3), (2,2), (3,1)
% --------------------------------------------------

diagonal_secundaria_quase(Jogador, Linha, Coluna) :-
    Linha + Coluna =:= 4,
    findall((L, C),
        (
            member((L, C), [(1,3), (2,2), (3,1)]),
            posicao(L, C, Jogador)
        ),
        Casas
    ),
    length(Casas, 2),
    \+ member((Linha, Coluna), Casas).
