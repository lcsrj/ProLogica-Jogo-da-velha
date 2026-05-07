
# Jogo da Velha em Prolog

Projeto desenvolvido para a disciplina de **Programação Lógica**, com o objetivo de representar o **Jogo da Velha** utilizando o paradigma declarativo da linguagem Prolog.

Neste projeto, o estado do jogo é descrito por meio de **fatos**, e as decisões do sistema são obtidas por meio de **regras lógicas**, sem uso de controle imperativo explícito, como laços ou estruturas tradicionais de decisão.

---

## Objetivo do projeto

O objetivo deste trabalho é demonstrar como um jogo simples pode ser modelado utilizando programação lógica.

O programa permite realizar consultas sobre o estado do tabuleiro, identificar vencedores, verificar casas vazias, detectar empate, saber se o jogo está em andamento e sugerir jogadas possíveis com base nas regras declaradas.

---

## Tema escolhido

O tema escolhido foi o **Jogo da Velha**.

O jogo possui um tabuleiro 3x3, no qual dois jogadores, representados pelos símbolos `x` e `o`, alternam jogadas até que um deles consiga formar uma sequência de três símbolos iguais em uma linha, coluna ou diagonal.

---

## Tecnologias utilizadas

- Prolog
- SWI-Prolog
- Paradigma de Programação Lógica

---

## Estrutura do projeto

```text
jogo_da_velha_prolog/
│
├── jogo_da_velha.pl
├── README.md
└── apresentacao_jogo_da_velha.pdf
```

### Descrição dos arquivos

| Arquivo | Descrição |
|---|---|
| `jogo_da_velha.pl` | Código-fonte do jogo em Prolog |
| `README.md` | Relatório completo e explicação do projeto |
| `apresentacao_jogo_da_velha.pdf` | Slides de apresentação do projeto |

---

## Como executar o projeto

### 1. Instalar o SWI-Prolog

Para executar o projeto, é necessário ter o **SWI-Prolog** instalado no computador.

Site oficial:

```text
https://www.swi-prolog.org/
```

---

### 2. Abrir o arquivo no SWI-Prolog

Abra o terminal na pasta do projeto e execute:

```bash
swipl jogo_da_velha.pl
```

Outra opção é abrir o SWI-Prolog e carregar o arquivo com o comando:

```prolog
?- [jogo_da_velha].
```

---

## Modelagem do domínio

O domínio do jogo foi modelado por meio de fatos que representam as posições do tabuleiro.

A estrutura principal utilizada foi:

```prolog
posicao(Linha, Coluna, Jogador).
```

Exemplo:

```prolog
posicao(1, 1, x).
posicao(1, 2, x).
posicao(1, 3, x).
```

Esses fatos indicam que o jogador `x` ocupa as três posições da primeira linha.

Também foram definidos os jogadores válidos:

```prolog
jogador(x).
jogador(o).
```

E as casas vazias foram representadas da seguinte forma:

```prolog
posicao(3, 1, vazio).
posicao(3, 2, vazio).
posicao(3, 3, vazio).
```

---

## Regras principais

### Verificação de jogador válido

```prolog
jogador(x).
jogador(o).
```

Define quais símbolos representam jogadores válidos no jogo.

---

### Verificação de casa vazia

```prolog
casa_vazia(L, C) :-
    posicao(L, C, vazio).
```

Essa regra verifica se uma posição do tabuleiro está vazia.

---

### Verificação de casa ocupada

```prolog
casa_ocupada(L, C) :-
    posicao(L, C, J),
    jogador(J).
```

Essa regra verifica se uma determinada posição está ocupada por um jogador válido.

---

### Vitória por linha

```prolog
vencedor(J) :-
    jogador(J),
    posicao(L, 1, J),
    posicao(L, 2, J),
    posicao(L, 3, J).
```

Essa regra identifica se algum jogador venceu ocupando as três colunas de uma mesma linha.

---

### Vitória por coluna

```prolog
vencedor(J) :-
    jogador(J),
    posicao(1, C, J),
    posicao(2, C, J),
    posicao(3, C, J).
```

Essa regra identifica se algum jogador venceu ocupando as três linhas de uma mesma coluna.

---

### Vitória pelas diagonais

```prolog
vencedor(J) :-
    jogador(J),
    posicao(1, 1, J),
    posicao(2, 2, J),
    posicao(3, 3, J).
```

```prolog
vencedor(J) :-
    jogador(J),
    posicao(1, 3, J),
    posicao(2, 2, J),
    posicao(3, 1, J).
```

Essas regras verificam vitória pela diagonal principal e pela diagonal secundária.

---

### Verificação de empate

```prolog
empate :-
    \+ vencedor(x),
    \+ vencedor(o),
    \+ existe_casa_vazia.
```

O empate ocorre quando não existe vencedor e também não existem casas vazias no tabuleiro.

---

### Verificação de fim de jogo

```prolog
fim_de_jogo :-
    vencedor(_).

fim_de_jogo :-
    empate.
```

O jogo termina quando existe um vencedor ou quando ocorre empate.

---

### Sugestão de jogada

```prolog
melhor_jogada(J, L, C) :-
    pode_vencer(J, L, C).

melhor_jogada(J, L, C) :-
    jogador(J),
    casa_vazia(L, C).
```

Essa regra tenta encontrar uma jogada que permita ao jogador vencer. Caso não exista vitória imediata, ela retorna casas vazias disponíveis.

---

## Exemplos de consultas

### Consultar o vencedor

```prolog
?- vencedor(J).
```

Resultado esperado:

```prolog
J = x.
```

Neste caso, o Prolog encontra que o jogador `x` venceu, pois ocupa as três casas da primeira linha.

---

### Verificar se o jogador X venceu

```prolog
?- vencedor(x).
```

Resultado esperado:

```prolog
true.
```

---

### Verificar se o jogador O venceu

```prolog
?- vencedor(o).
```

Resultado esperado:

```prolog
false.
```

---

### Consultar casas vazias

```prolog
?- casa_vazia(L, C).
```

Resultado esperado:

```prolog
L = 3,
C = 1 ;

L = 3,
C = 2 ;

L = 3,
C = 3.
```

Essa consulta demonstra o uso de **backtracking**, pois o Prolog retorna todas as posições que satisfazem a regra `casa_vazia`.

---

### Verificar se o jogo acabou

```prolog
?- fim_de_jogo.
```

Resultado esperado:

```prolog
true.
```

Como existe um vencedor, o jogo é considerado finalizado.

---

### Verificar se o jogo ainda está em andamento

```prolog
?- jogo_em_andamento.
```

Resultado esperado:

```prolog
false.
```

O jogo não está em andamento porque já existe um vencedor.

---

### Consultar possíveis jogadas

```prolog
?- melhor_jogada(o, L, C).
```

Resultado possível:

```prolog
L = 3,
C = 1 ;

L = 3,
C = 2 ;

L = 3,
C = 3.
```

Como o jogador `o` não possui vitória imediata nesse estado do tabuleiro, o sistema retorna casas vazias disponíveis.

---

## Conceitos de programação lógica utilizados

### Fatos

Fatos representam informações verdadeiras dentro do programa.

Exemplo:

```prolog
posicao(1, 1, x).
```

Esse fato informa que a posição da linha 1 e coluna 1 está ocupada pelo jogador `x`.

---

### Regras

Regras definem relações lógicas entre os fatos.

Exemplo:

```prolog
casa_vazia(L, C) :-
    posicao(L, C, vazio).
```

Essa regra afirma que uma casa está vazia se existir uma posição correspondente marcada como `vazio`.

---

### Variáveis

Variáveis são usadas para representar valores desconhecidos que o Prolog tenta descobrir.

Exemplo:

```prolog
?- vencedor(J).
```

Nesse caso, `J` é uma variável. O Prolog procura qual jogador satisfaz a regra de vitória.

---

### Unificação

A unificação é o processo pelo qual o Prolog tenta combinar uma consulta com os fatos e regras existentes.

Exemplo:

```prolog
?- vencedor(J).
```

Se o Prolog encontra que `x` satisfaz as regras de vitória, ele unifica a variável `J` com o valor `x`:

```prolog
J = x.
```

---

### Backtracking

Backtracking é o mecanismo usado pelo Prolog para procurar múltiplas soluções para uma consulta.

Exemplo:

```prolog
?- casa_vazia(L, C).
```

O Prolog retorna a primeira casa vazia. Ao pedir mais respostas, ele continua procurando outras posições que também satisfaçam a regra.

---

## Relatório do projeto

### Introdução

Este trabalho apresenta a construção de um Jogo da Velha utilizando a linguagem Prolog. A proposta é demonstrar o funcionamento do paradigma de programação lógica, no qual o programa é construído a partir de fatos e regras.

Em vez de descrever passo a passo como o jogo deve ser executado, o programa declara informações sobre o tabuleiro e define regras para que o próprio interpretador Prolog realize inferências.

---

### Descrição do jogo

O Jogo da Velha é um jogo de estratégia simples para dois jogadores. O tabuleiro é formado por três linhas e três colunas. Cada jogador escolhe um símbolo, normalmente `x` ou `o`, e o objetivo é formar uma sequência de três símbolos iguais.

A vitória pode ocorrer em uma linha, coluna ou diagonal. Caso todas as casas sejam preenchidas sem que nenhum jogador vença, o jogo termina empatado.

---

### Modelagem do conhecimento

O conhecimento do jogo foi modelado através de fatos que indicam o conteúdo de cada posição do tabuleiro.

Cada posição possui três informações:

1. Linha;
2. Coluna;
3. Conteúdo da casa.

Exemplo:

```prolog
posicao(2, 2, o).
```

Esse fato representa que a posição localizada na linha 2 e coluna 2 está ocupada pelo jogador `o`.

Além disso, foram criadas regras para identificar casas vazias, casas ocupadas, vencedores, empate, fim de jogo e jogadas possíveis.

---

### Regras principais

As principais regras do projeto são:

| Regra | Função |
|---|---|
| `casa_vazia(L, C)` | Verifica se uma casa está vazia |
| `casa_ocupada(L, C)` | Verifica se uma casa está ocupada |
| `vencedor(J)` | Verifica se um jogador venceu |
| `empate` | Verifica se houve empate |
| `jogo_em_andamento` | Verifica se o jogo ainda continua |
| `fim_de_jogo` | Verifica se o jogo terminou |
| `pode_vencer(J, L, C)` | Verifica se um jogador pode vencer em uma jogada |
| `melhor_jogada(J, L, C)` | Sugere uma jogada possível |

Essas regras permitem que o Prolog responda consultas sobre o estado do jogo utilizando inferência lógica.

---

### Exemplos de consultas com resultados obtidos

Consulta:

```prolog
?- vencedor(J).
```

Resultado:

```prolog
J = x.
```

Consulta:

```prolog
?- casa_vazia(L, C).
```

Resultado:

```prolog
L = 3,
C = 1 ;
L = 3,
C = 2 ;
L = 3,
C = 3.
```

Consulta:

```prolog
?- fim_de_jogo.
```

Resultado:

```prolog
true.
```

Consulta:

```prolog
?- jogo_em_andamento.
```

Resultado:

```prolog
false.
```

---

### Paradigma declarativo

O projeto evidencia o paradigma declarativo porque o programa não define uma sequência de comandos para encontrar o vencedor. Em vez disso, ele declara fatos sobre o estado do tabuleiro e regras que representam as condições do jogo.

A partir dessas declarações, o Prolog utiliza inferência lógica para responder às consultas. Por exemplo, ao consultar `vencedor(J)`, o sistema procura automaticamente um valor para `J` que satisfaça alguma das regras de vitória.

Dessa forma, o comportamento do jogo emerge das relações lógicas definidas no programa.

---

### Conclusão

O projeto demonstrou como o Jogo da Velha pode ser representado utilizando programação lógica em Prolog. Através de fatos e regras, foi possível modelar o tabuleiro, identificar vencedores, verificar estados do jogo e consultar jogadas possíveis.

O uso de variáveis, unificação e backtracking permite que o Prolog encontre respostas automaticamente, reforçando o caráter declarativo da solução.

Portanto, o trabalho atende aos requisitos propostos, mostrando de forma clara como a lógica pode ser usada para representar e analisar um jogo baseado em regras.

---

## Autor

Lucas Costa e Silva

