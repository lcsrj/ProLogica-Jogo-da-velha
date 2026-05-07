:- use_module(library(readutil)).
:- dynamic posicao/3.

jogador(x).
jogador(o).

iniciar :-
    retractall(posicao(_, _, _)),
    nl,
    writeln('================================'),
    writeln('       JOGO DA VELHA PROLOG     '),
    writeln('================================'),
    writeln('Voce joga como X.'),
    writeln('A CPU joga como O.'),
    writeln('Digite somente numeros de 1 a 3.'),
    writeln('Exemplo correto:'),
    writeln('Linha: 1'),
    writeln('Coluna: 2'),
    nl,
    turno_usuario.

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
    ler_numero_valido('Linha: ', Linha),
    ler_numero_valido('Coluna: ', Coluna),
    (
        jogada_valida(Linha, Coluna) ->
            assertz(posicao(Linha, Coluna, x))
    ;
        writeln('Jogada invalida. Essa casa ja esta ocupada. Tente novamente.'),
        pedir_jogada_usuario
    ).

ler_numero_valido(Mensagem, Numero) :-
    repeat,
    write(Mensagem),
    read_line_to_string(user_input, Texto),
    normalizar_entrada(Texto, Limpo),
    (
        number_string(NumeroTemp, Limpo),
        between(1, 3, NumeroTemp) ->
            Numero = NumeroTemp,
            !
    ;
        writeln('Entrada invalida. Digite apenas 1, 2 ou 3.'),
        fail
    ).

normalizar_entrada(Texto, Limpo) :-
    split_string(Texto, " ", " \t\n\r", Partes),
    atomic_list_concat(Partes, '', Limpo).

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

escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(o, Linha, Coluna),
    !.

escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(x, Linha, Coluna),
    !.

escolher_jogada_cpu(2, 2) :-
    jogada_valida(2, 2),
    !.

escolher_jogada_cpu(Linha, Coluna) :-
    canto(Linha, Coluna),
    jogada_valida(Linha, Coluna),
    !.

escolher_jogada_cpu(Linha, Coluna) :-
    jogada_valida(Linha, Coluna),
    !.

canto(1, 1).
canto(1, 3).
canto(3, 1).
canto(3, 3).

jogada_valida(Linha, Coluna) :-
    between(1, 3, Linha),
    between(1, 3, Coluna),
    \+ posicao(Linha, Coluna, _).

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

vencedor(Jogador) :-
    jogador(Jogador),
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).

vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, Coluna, Jogador),
    posicao(2, Coluna, Jogador),
    posicao(3, Coluna, Jogador).

vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 1, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 3, Jogador).

vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 3, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 1, Jogador).

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

linha_quase_completa(Jogador, Linha, Coluna) :-
    findall(C, posicao(Linha, C, Jogador), Colunas),
    length(Colunas, 2),
    \+ member(Coluna, Colunas).

coluna_quase_completa(Jogador, Linha, Coluna) :-
    findall(L, posicao(L, Coluna, Jogador), Linhas),
    length(Linhas, 2),
    \+ member(Linha, Linhas).

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
