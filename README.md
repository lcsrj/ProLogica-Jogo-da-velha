# Jogo da Velha em Prolog

Projeto final de **Programação Lógica** desenvolvido em **Prolog**, usando o jogo da velha como domínio lógico.

Neste projeto, o jogador humano joga como **X** e a CPU joga como **O**. O jogo é interativo pelo terminal e utiliza fatos, regras, inferência lógica, unificação e backtracking para controlar as jogadas e determinar o vencedor.

---

## Objetivo

Desenvolver um jogo baseado em programação lógica, no qual o comportamento seja representado por fatos e regras.

O objetivo principal é demonstrar o paradigma declarativo do Prolog: em vez de escrever um passo a passo imperativo, o programa declara relações lógicas e o Prolog deduz as respostas a partir dessas regras.

---

## Tema

**Jogo da Velha interativo com CPU**

- Jogador humano: `x`
- CPU: `o`
- Tabuleiro: 3 linhas por 3 colunas
- Entrada do jogador: linha e coluna
- Saída: tabuleiro atualizado, jogada da CPU e resultado da partida

---

## Tecnologias utilizadas

- Prolog
- SWI-Prolog
- Terminal ou console do SWI-Prolog

---

## Estrutura do projeto

```text
ProLogica-Jogo-da-velha/
│
├── jogo_da_velha.pl
└── README.md
```

### `jogo_da_velha.pl`

Arquivo principal do jogo. Contém:

- fatos dinâmicos das jogadas;
- regras de vitória;
- regras de empate;
- validação das jogadas;
- exibição do tabuleiro;
- lógica da CPU;
- interação com o usuário.

### `README.md`

Arquivo de documentação do projeto, contendo explicação, relatório, exemplos de uso e instruções para execução.

---

## Como executar o projeto

### 1. Instale o SWI-Prolog

Baixe e instale o SWI-Prolog pelo site oficial:

```text
https://www.swi-prolog.org/
```

### 2. Baixe o arquivo do projeto

Certifique-se de ter o arquivo:

```text
jogo_da_velha.pl
```

Por exemplo, ele pode estar na pasta:

```text
C:/Users/User/Downloads/jogo_da_velha.pl
```

### 3. Abra o SWI-Prolog

Ao abrir, aparecerá algo parecido com:

```prolog
1 ?-
```

### 4. Carregue o arquivo

Digite:

```prolog
consult(['c:/Users/User/Downloads/jogo_da_velha.pl']).
```

Depois pressione **Enter**.

Se estiver correto, o Prolog responderá:

```prolog
true.
```

Isso significa que o arquivo foi carregado com sucesso.

### 5. Inicie o jogo

Digite:

```prolog
iniciar.
```

Depois pressione **Enter**.

O jogo será iniciado no terminal.

---

## Como jogar

O jogador humano sempre joga como **X**.

A CPU sempre joga como **O**.

O tabuleiro usa linhas e colunas numeradas de 1 a 3:

```text
    1   2   3
  +---+---+---+
1 |   |   |   |
  +---+---+---+
2 |   |   |   |
  +---+---+---+
3 |   |   |   |
  +---+---+---+
```

Quando aparecer:

```text
Linha:
```

Digite apenas o número da linha, por exemplo:

```text
1
```

Depois aparecerá:

```text
Coluna:
```

Digite apenas o número da coluna, por exemplo:

```text
2
```

Não coloque ponto final quando o jogo pedir linha e coluna.

---

## Exemplo de partida

```text
Sua vez!
Linha: 1
Coluna: 1
```

Depois disso, o jogo registra sua jogada como `x`.

Em seguida, a CPU joga automaticamente:

```text
Vez da CPU...
CPU jogou na linha 2, coluna 2.
```

O tabuleiro é exibido novamente e a partida continua até vitória ou empate.

---

## Como as jogadas funcionam

Cada jogada é armazenada como um fato Prolog no formato:

```prolog
posicao(Linha, Coluna, Jogador).
```

Exemplo:

```prolog
posicao(1, 1, x).
```

Esse fato significa que o jogador `x` ocupou a linha 1 e coluna 1.

Outro exemplo:

```prolog
posicao(2, 2, o).
```

Esse fato significa que a CPU, representada por `o`, ocupou a linha 2 e coluna 2.

Durante o jogo, esses fatos são adicionados dinamicamente com `assertz/1`.

Exemplo:

```prolog
assertz(posicao(Linha, Coluna, x))
```

Isso adiciona uma nova jogada do jogador humano à base de conhecimento do Prolog.

---

## Como o vencedor é determinado

O vencedor é determinado por regras lógicas.

O jogo da velha possui 8 possibilidades de vitória:

- 3 linhas;
- 3 colunas;
- 2 diagonais.

### Vitória por linha

```prolog
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).
```

Essa regra significa:

> Um jogador vence se existir uma linha em que as três colunas estejam ocupadas por ele.

Exemplo:

```text
x | x | x
```

Nesse caso, o jogador `x` venceu por linha.

### Vitória por coluna

```prolog
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, Coluna, Jogador),
    posicao(2, Coluna, Jogador),
    posicao(3, Coluna, Jogador).
```

Essa regra significa:

> Um jogador vence se existir uma coluna em que as três linhas estejam ocupadas por ele.

Exemplo:

```text
x
x
x
```

### Vitória pela diagonal principal

```prolog
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 1, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 3, Jogador).
```

Essa regra verifica a diagonal principal:

```text
x |   |
  | x |
  |   | x
```

### Vitória pela diagonal secundária

```prolog
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(1, 3, Jogador),
    posicao(2, 2, Jogador),
    posicao(3, 1, Jogador).
```

Essa regra verifica a diagonal secundária:

```text
  |   | x
  | x |
x |   |
```

---

## Como a CPU joga

A CPU segue uma ordem de prioridade lógica:

1. Se puder vencer, joga para vencer.
2. Se o jogador humano estiver quase vencendo, bloqueia.
3. Se o centro estiver livre, joga no centro.
4. Se algum canto estiver livre, joga no canto.
5. Se nenhuma das opções anteriores for possível, escolhe qualquer casa vazia.

A regra principal da CPU é:

```prolog
escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(o, Linha, Coluna),
    !.
```

Ela significa que, se a CPU conseguir vencer em uma jogada, essa jogada será escolhida.

Depois vem a regra de bloqueio:

```prolog
escolher_jogada_cpu(Linha, Coluna) :-
    pode_vencer(x, Linha, Coluna),
    !.
```

Essa regra verifica se o jogador `x` está próximo de vencer. Se estiver, a CPU ocupa a posição para impedir a vitória.

---

## Consultas úteis para testar

Depois de carregar o arquivo, além de jogar com `iniciar.`, também é possível testar consultas diretamente no Prolog.

### Verificar vencedor

```prolog
vencedor(Jogador).
```

Se houver vencedor, o Prolog retorna algo como:

```prolog
Jogador = x.
```

ou:

```prolog
Jogador = o.
```

### Verificar se o jogo empatou

```prolog
empate.
```

Resultado possível:

```prolog
true.
```

ou:

```prolog
false.
```

### Verificar uma jogada válida

```prolog
jogada_valida(1, 1).
```

Se a casa estiver livre, retorna:

```prolog
true.
```

Se estiver ocupada, retorna:

```prolog
false.
```

### Verificar se alguém pode vencer

```prolog
pode_vencer(x, Linha, Coluna).
```

Essa consulta mostra se o jogador `x` possui alguma jogada que levaria à vitória.

Também pode ser testada para a CPU:

```prolog
pode_vencer(o, Linha, Coluna).
```

---

## Conceitos de programação lógica usados

### Fatos

Fatos representam verdades sobre o domínio.

Exemplo:

```prolog
jogador(x).
jogador(o).
```

Esses fatos dizem que `x` e `o` são jogadores válidos.

### Regras

Regras representam condições lógicas.

Exemplo:

```prolog
vencedor(Jogador) :-
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).
```

Essa regra diz que um jogador vence se ocupar três posições da mesma linha.

### Variáveis

Variáveis começam com letra maiúscula.

Exemplos:

```prolog
Jogador
Linha
Coluna
```

Na consulta:

```prolog
vencedor(Jogador).
```

O Prolog tenta descobrir qual valor pode substituir `Jogador`.

### Unificação

Unificação é o processo de combinar uma variável com um valor que torna uma regra verdadeira.

Exemplo:

```prolog
vencedor(Jogador).
```

Se o jogador `x` venceu, o Prolog retorna:

```prolog
Jogador = x.
```

Isso significa que a variável `Jogador` foi unificada com o valor `x`.

### Backtracking

Backtracking é a busca automática por outras soluções possíveis.

Exemplo:

```prolog
jogada_valida(Linha, Coluna).
```

O Prolog pode encontrar várias casas livres. Ao pressionar `;`, ele procura a próxima solução.

---

# Relatório

## Introdução

Este trabalho apresenta o desenvolvimento de um jogo da velha utilizando a linguagem Prolog. O projeto foi criado para demonstrar o uso do paradigma declarativo da programação lógica, no qual o programador descreve fatos e regras, e o sistema realiza inferências a partir dessas informações.

No jogo implementado, o usuário joga como `x` e a CPU joga como `o`. A partida acontece de forma interativa no terminal, com o usuário informando linha e coluna para realizar suas jogadas.

## Descrição do jogo

O jogo da velha é um jogo de tabuleiro para dois jogadores. O tabuleiro é formado por 3 linhas e 3 colunas. Cada jogador, em sua vez, escolhe uma posição vazia para marcar seu símbolo.

Neste projeto:

- o jogador humano utiliza `x`;
- a CPU utiliza `o`;
- o jogador informa linha e coluna;
- a CPU escolhe sua jogada automaticamente;
- o jogo termina quando alguém vence ou quando ocorre empate.

Um jogador vence quando consegue formar três símbolos iguais em uma linha, coluna ou diagonal.

## Modelagem do conhecimento

O conhecimento do jogo foi modelado por meio de fatos e regras.

Os jogadores são representados pelos fatos:

```prolog
jogador(x).
jogador(o).
```

As jogadas são representadas pelo predicado dinâmico:

```prolog
posicao(Linha, Coluna, Jogador).
```

Esse predicado representa o estado atual do tabuleiro.

Por exemplo:

```prolog
posicao(1, 1, x).
```

indica que o jogador `x` marcou a linha 1 e coluna 1.

Como as jogadas mudam durante a execução, o predicado `posicao/3` foi declarado como dinâmico:

```prolog
:- dynamic posicao/3.
```

Isso permite adicionar e remover fatos durante a execução do jogo.

## Regras principais

As principais regras do projeto são:

- `vencedor/1`: verifica se algum jogador venceu;
- `empate/0`: verifica se o jogo terminou empatado;
- `fim_de_jogo/0`: verifica se a partida acabou;
- `jogada_valida/2`: verifica se uma posição pode ser ocupada;
- `pode_vencer/3`: verifica se existe uma jogada de vitória;
- `escolher_jogada_cpu/2`: define a jogada da CPU.

A regra `vencedor/1` é uma das mais importantes, pois determina se um jogador possui uma sequência vencedora.

Exemplo de vitória por linha:

```prolog
vencedor(Jogador) :-
    jogador(Jogador),
    posicao(Linha, 1, Jogador),
    posicao(Linha, 2, Jogador),
    posicao(Linha, 3, Jogador).
```

Essa regra declara que um jogador vence quando ocupa as três colunas de uma mesma linha.

## Exemplos de consultas com resultados obtidos

### Consulta 1

```prolog
vencedor(Jogador).
```

Resultado possível:

```prolog
Jogador = x.
```

Esse resultado indica que o jogador `x` venceu a partida.

### Consulta 2

```prolog
vencedor(o).
```

Resultado possível:

```prolog
true.
```

Esse resultado indica que a CPU venceu.

### Consulta 3

```prolog
empate.
```

Resultado possível:

```prolog
true.
```

Esse resultado indica que todas as casas foram preenchidas e nenhum jogador venceu.

### Consulta 4

```prolog
jogada_valida(2, 2).
```

Resultado possível:

```prolog
true.
```

Esse resultado indica que a posição linha 2, coluna 2 está livre.

### Consulta 5

```prolog
pode_vencer(x, Linha, Coluna).
```

Resultado possível:

```prolog
Linha = 1,
Coluna = 3.
```

Esse resultado indica que o jogador `x` poderia vencer jogando na linha 1, coluna 3.

## Paradigma declarativo

O projeto evidencia o paradigma declarativo porque o código não descreve apenas uma sequência de comandos. Em vez disso, ele declara fatos sobre o jogo e regras que definem quando uma situação é verdadeira.

A partir dessas declarações, o Prolog consegue responder consultas como:

```prolog
vencedor(Jogador).
```

O sistema procura automaticamente valores para as variáveis que satisfaçam as regras. Assim, o resultado surge por inferência lógica.

## Conclusão

O projeto demonstra a aplicação da programação lógica no desenvolvimento de um jogo da velha interativo. O domínio foi modelado por fatos, as regras representam as condições de vitória e empate, e as consultas demonstram inferência lógica.

A implementação também utiliza variáveis, unificação e backtracking, conceitos fundamentais do Prolog. Além disso, a CPU utiliza regras para escolher suas jogadas, priorizando vitória, bloqueio e posições estratégicas.

Dessa forma, o trabalho atende ao objetivo de evidenciar o paradigma declarativo da programação lógica por meio de um jogo funcional e interativo.
