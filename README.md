# EscapeFromCurry

**Disciplina**: FGA0210 - PARADIGMAS DE PROGRAMAÇÃO - T01 <br>
**Nro do Grupo**: 02<br>
**Paradigma**: Funcional<br>

## Alunos
|Matrícula | Aluno |
| -- | -- |
| 20/0013181 | Adne Moretti Moreira |
| 20/0057227 | Caio Vitor Carneiro de Oliveira |
| 19/0085819 | Cícero Barrozo Fernandes Filho |
| 19/0026758 | Deivid Alves de Carvalho |
| 19/0045817 | Gabriel Costa de Oliveira |
| 20/0018205 | Gabriel Moretti de Souza |
| 20/0019015 | Guilherme Puida Moreira |
| 20/0067923 | João Henrique Marques Calzavara |
| 20/2023903 | Lucas Lopes Rocha |

## Sobre 
[//]: # (Descreva o seu projeto em linhas gerais.)
[//]: # (Use referências, links, que permitam conhecer um pouco mais sobre o projeto.)
[//]: # (Capriche nessa seção, pois ela é a primeira a ser lida pelos interessados no projeto.)

&emsp;&emsp;Neste projeto, propomos a criação de um jogo de labirinto usando linguagem funcional para a disciplina de Paradigmas de Software. O jogo apresenta um jogador (caracter) e um monstro, onde o objetivo é alcançar a saída antes de ser capturado pelo monstro. Adotando o paradigma funcional, focaremos em funções puras para a movimentação do jogador e estratégias do monstro, além de utilizar o algoritmo de busca em largura (BFS) para encontrar a posição que o monstro deve se mover. A estrutura bidimensional do labirinto, representada por um grafo, será manipulada de forma imutável, promovendo legibilidade, facilidade de testes e prevenção de efeitos colaterais. Ao aplicar esses conceitos, buscamos destacar a eficácia e a elegância da programação funcional na construção de jogos, consolidando o aprendizado em paradigmas de software.

## Screenshots
Adicione 2 ou mais screenshots do projeto em termos de interface e/ou funcionamento.

## Instalação 
**Linguagens**: Haskell<br>
**Tecnologias**: GHCI, Cabal e Stack <br>
Descreva os pré-requisitos para rodar o seu projeto e os comandos necessários.
Insira um manual ou um script para auxiliar ainda mais.
Gifs animados e outras ilustrações são bem-vindos!

## Uso 
Explique como usar seu projeto.
Procure ilustrar em passos, com apoio de telas do software, seja com base na interface gráfica, seja com base no terminal.
Nessa seção, deve-se revelar de forma clara sobre o funcionamento do software.


1. Clone o repositório:

```bash
git clone https://github.com/UnBParadigmas2023-2/2023.2_G2_Funcional
```

2. Execute

```bash
stack build && stack exec EscapeFromCurry-exe
```

Após rodar os comandos de build e execução do projeto, arbirá uma janela com o labirinto, para mexer o jogador, que é o ícone verda, basta movimentar pelas setas do teclado. O objetivo do jogo é alcançar o Goal, que está representado por uma terceira cor. Divirta-se! 

## Vídeo
Adicione 1 ou mais vídeos com a execução do projeto.
Procure: 
(i) Introduzir o projeto;
(ii) Mostrar passo a passo o código, explicando-o, e deixando claro o que é de terceiros, e o que é contribuição real da equipe;
(iii) Apresentar particularidades do Paradigma, da Linguagem, e das Tecnologias, e
(iV) Apresentar lições aprendidas, contribuições, pendências, e ideias para trabalhos futuros.
OBS: TODOS DEVEM PARTICIPAR, CONFERINDO PONTOS DE VISTA.
TEMPO: +/- 15min

## Participações
Apresente, brevemente, como cada membro do grupo contribuiu para o projeto.
|Nome do Membro | Contribuição | Significância da Contribuição para o Projeto (Excelente/Boa/Regular/Ruim/Nula) |
| -- | -- | -- |
| Adne Moretti Moreira | Módulo do monstro e auxílio na integração entre os módulos. | Excelente |
| Caio Vitor Carneiro de Oliveira | Módulo de criação de parede no Gloss e ajuda na integração final. | Excelente |
| Cícero Barrozo Fernandes Filho | Funções de validação da movimentação do player e ajuda nas integrações finais. | Excelente |
| Deivid Alves de Carvalho | --- | Excelente |
| Gabriel Costa de Oliveira | --- | Excelente |
| Gabriel Moretti de Souza | Início do Types.hs, movimentação do player e integrações finais. | Excelente |
| Guilherme Puida Moreira | --- | Excelente |
| João Henrique Marques Calzavara | Módulos Time e Message, integrações finais e README. | Excelente |
| Lucas Lopes Rocha | Módulos Time e Message, integrações finais e README. | Excelente |

## Outros 

### Lições Aprendidas
Insira aqui as Lições Aprendidas durante o processo

### Percepções
Insira aqui as Percepções durante o processo

### Contribuições e Fragilidades
Insira aqui as Contribuições e Fragilidades durante o processo

### Trabalhos Futuros
Insira aqui as Trabalhos Futuros durante o processo

## Fontes
> Downloads.  Disponível em: <https://www.haskell.org/downloads/>. Acesso em: 21 set. 2023.

> CONTRIBUTORS, S. The Haskell Tool Stack.  Disponível em: <https://docs.haskellstack.org/en/stable/>. Acesso em: 21 set. 2023.

> gloss: Painless 2D vector graphics, animations and simulations..  Disponível em: <https://hackage.haskell.org/package/gloss>. Acesso em: 21 set. 2023.




