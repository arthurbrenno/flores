# Análise Detalhada de um Algoritmo Genético em Scilab

Este documento fornece uma análise detalhada de um código Scilab que implementa um algoritmo genético. Abordaremos cada linha do código, explicando o significado das variáveis e operações, descreveremos o fluxo geral do algoritmo genético e apresentaremos o embasamento matemático necessário para a compreensão completa do funcionamento do código.

## Sumário

1. [Introdução](#introdução)
2. [Descrição Geral do Algoritmo Genético](#descrição-geral-do-algoritmo-genético)
3. [Análise Linha por Linha do Código](#análise-linha-por-linha-do-código)
4. [Embasamento Matemático](#embasamento-matemático)
    - [Inicialização da População](#inicialização-da-população)
    - [Função de Custo (Fitness Function)](#função-de-custo-fitness-function)
    - [Seleção por Torneio](#seleção-por-torneio)
    - [Crossover](#crossover)
    - [Mutação](#mutação)
    - [Elitismo](#elitismo)
5. [Conclusão](#conclusão)

---

## Introdução

O algoritmo genético é uma técnica de otimização inspirada nos processos de seleção natural e genética. Ele é amplamente utilizado para resolver problemas complexos onde métodos tradicionais podem ser ineficazes. Este documento analisa um código Scilab que implementa um algoritmo genético para otimizar uma função de custo específica.

---

## Descrição Geral do Algoritmo Genético

O algoritmo genético implementado no código realiza as seguintes etapas principais:

1. **Inicialização**: Cria uma população inicial de indivíduos (soluções potenciais) com valores aleatórios dentro de um intervalo especificado.
2. **Avaliação (Fitness)**: Calcula o custo (ou fitness) de cada indivíduo na população.
3. **Seleção**: Utiliza o método de seleção por torneio para escolher indivíduos para reprodução.
4. **Crossover**: Combina pares de indivíduos selecionados para produzir novos indivíduos (descendentes).
5. **Mutação**: Aplica mutações aleatórias aos descendentes para introduzir diversidade genética.
6. **Elitismo**: Preserva o melhor indivíduo encontrado até o momento para garantir a melhoria contínua da população.
7. **Repetição**: Repete as etapas de avaliação, seleção, crossover e mutação por um número definido de épocas.

---

## Análise Linha por Linha do Código

A seguir, apresentamos uma análise detalhada de cada parte do código Scilab fornecido.

### Inicialização do Ambiente

```scilab
clear;
clc;
```

- `clear;`: Remove todas as variáveis do ambiente de trabalho, garantindo que nenhuma variável residual interfira na execução do script.
- `clc;`: Limpa a janela de comandos, proporcionando um ambiente limpo para a execução do código.

### Definição dos Parâmetros Iniciais

```scilab
npop = 1000;
pop = [];
rmin = 0;
rmax = 10;
bestpop = 0;
bestcusto = 0;
```

- `npop = 1000;`: Define o tamanho da população, ou seja, o número de indivíduos em cada geração.
- `pop = [];`: Inicializa um vetor vazio para armazenar a população.
- `rmin = 0;` e `rmax = 10;`: Definem o intervalo [0, 10] dentro do qual os indivíduos serão inicialmente gerados.
- `bestpop = 0;` e `bestcusto = 0;`: Inicializam variáveis para armazenar o melhor indivíduo (`bestpop`) e seu custo associado (`bestcusto`).

### Geração da População Inicial

```scilab
for i = 1:npop
    pop(i) = rand() * (rmax - rmin) + rmin;
end
```

- Este loop `for` gera `npop` indivíduos aleatórios.
- `rand()` gera um número aleatório uniforme entre 0 e 1.
- `rand() * (rmax - rmin) + rmin` escala o número aleatório para o intervalo [0, 10].
- Cada valor gerado é armazenado no vetor `pop` na posição `i`.

### Ciclo Principal do Algoritmo Genético

```scilab
for epoca = 1:1000
    custo = [];
    for i = 1:npop
        custo(i) = pop(i)/2 * (1 - 2 * %pi * pop(i));
    end
```

- O algoritmo executa 1000 épocas (`for epoca = 1:1000`).
- `custo = [];`: Inicializa um vetor vazio para armazenar o custo de cada indivíduo na geração atual.
- O segundo loop `for` calcula o custo para cada indivíduo na população:
    - `custo(i) = pop(i)/2 * (1 - 2 * %pi * pop(i));`: Define a função de custo para cada indivíduo. A função específica utilizada aqui é \( \text{custo}(x) = \frac{x}{2} (1 - 2\pi x) \).

### Atualização do Melhor Indivíduo

```scilab
    for i = 1:npop
        if custo(i) > bestcusto then
            bestpop = pop(i);
            bestcusto = custo(i);
            altura = (1 - 2 * %pi * bestpop) / (2 * %pi * bestpop);
            disp(bestpop);
            disp(altura);
            disp(bestcusto);
        end
    end
```

- Este loop percorre todos os indivíduos para identificar e atualizar o melhor indivíduo encontrado até o momento.
- `if custo(i) > bestcusto then`: Verifica se o custo do indivíduo atual é melhor (maior) que o melhor custo registrado.
- Se for melhor:
    - `bestpop = pop(i);`: Atualiza o melhor indivíduo.
    - `bestcusto = custo(i);`: Atualiza o melhor custo.
    - `altura = (1 - 2 * %pi * bestpop) / (2 * %pi * bestpop);`: Calcula uma variável derivada chamada `altura` baseada no melhor indivíduo.
    - `disp(bestpop);`, `disp(altura);`, `disp(bestcusto);`: Exibe os valores do melhor indivíduo, `altura` e seu custo na janela de comandos.

### Seleção por Torneio

#### Seleção para `newpopx`

```scilab
    // Torneio
    newpopx = [];
    for i = 1:npop
        t1 = 0;
        t2 = 0;
        while t1 == t2
            t1 = round(rand() * (npop - 1)) + 1;
            t2 = round(rand() * (npop - 1)) + 1;
        end
        if pop(t1) > pop(t2) then
            newpopx(i) = pop(t1);
        else
            newpopx(i) = pop(t2);
        end
    end
```

- `newpopx = [];`: Inicializa um vetor vazio para armazenar os indivíduos selecionados para crossover na dimensão x.
- O loop `for` seleciona `npop` indivíduos usando seleção por torneio:
    - Inicializa `t1` e `t2` como 0.
    - O `while t1 == t2` garante que dois indivíduos distintos sejam selecionados.
    - `t1` e `t2` são índices aleatórios da população.
    - Compara os valores de `pop(t1)` e `pop(t2)`.
    - O maior valor entre os dois é selecionado e armazenado em `newpopx(i)`.

#### Seleção para `newpopy`

```scilab
    newpopy = [];
    for i = 1:npop
        t1 = 0;
        t2 = 0;
        while t1 == t2
            t1 = round(rand() * (npop - 1)) + 1;
            t2 = round(rand() * (npop - 1)) + 1;
        end
        if pop(t1) > pop(t2) then
            newpopy(i) = pop(t1);
        else
            newpopy(i) = pop(t2);
        end
    end
```

- Similar ao bloco anterior, mas para a dimensão y.
- `newpopy = [];`: Inicializa um vetor vazio para armazenar os indivíduos selecionados para crossover na dimensão y.
- O processo de seleção é idêntico ao de `newpopx`.

### Crossover

```scab
    // Crossover
    newpop = [];
    for i = 1:npop
        newpop(i) = sqrt(newpopy(i) * newpopx(i));
    end
```

- `newpop = [];`: Inicializa um vetor vazio para armazenar os novos indivíduos após o crossover.
- O loop `for` aplica a operação de crossover:
    - `newpop(i) = sqrt(newpopy(i) * newpopx(i));`: Calcula a raiz quadrada do produto dos valores selecionados para x e y, combinando-os para formar um novo indivíduo. Este método representa uma combinação geométrica dos pais.

### Mutação

```scilab
    // Mutação
    for i = 1:npop
        if rand() >= 0.7 then
            newpop(i) = rand() * (rmax - rmin) + rmin;
        end
    end
```

- Este loop percorre todos os novos indivíduos para aplicar mutações aleatórias.
- `if rand() >= 0.7 then`: Com uma probabilidade de 30% (já que `rand()` >= 0.7 ocorre aproximadamente 30% das vezes), o indivíduo sofre mutação.
- `newpop(i) = rand() * (rmax - rmin) + rmin;`: O indivíduo é substituído por um novo valor aleatório dentro do intervalo [0, 10].

### Atualização da População

```scab
    //
    pop = newpop;
    pop(1) = bestpop;
end
```

- `pop = newpop;`: Atualiza a população com os novos indivíduos gerados após seleção, crossover e mutação.
- `pop(1) = bestpop;`: Preserva o melhor indivíduo encontrado até o momento, assegurando que não seja perdido nas gerações subsequentes (elitismo).

---

## Embasamento Matemático

Para compreender completamente o funcionamento do algoritmo genético apresentado, é essencial entender os fundamentos matemáticos que sustentam cada etapa.

### Inicialização da População

A população inicial é composta por `npop` indivíduos, cada um representado por um valor real dentro do intervalo [0, 10]. Matemáticamente, cada indivíduo \( x_i \) é gerado a partir de uma distribuição uniforme:

\[
x_i = r_{\text{min}} + (r_{\text{max}} - r_{\text{min}}) \cdot \text{rand}()
\]

onde \( \text{rand()} \) é uma variável aleatória uniformemente distribuída em [0, 1].

### Função de Custo (Fitness Function)

A função de custo utilizada é:

\[
\text{custo}(x) = \frac{x}{2} \left(1 - 2\pi x\right)
\]

Esta função determina a aptidão de cada indivíduo, onde indivíduos com maior valor de custo são considerados mais aptos.

### Seleção por Torneio

A seleção por torneio envolve comparar dois indivíduos aleatórios e selecionar o melhor deles para a próxima geração. Formalmente:

Para cada seleção:

1. Escolha dois indivíduos \( x_{t1} \) e \( x_{t2} \) aleatoriamente.
2. Se \( x_{t1} > x_{t2} \), selecione \( x_{t1} \); caso contrário, selecione \( x_{t2} \).

Esta estratégia favorece a seleção de indivíduos mais aptos, aumentando a probabilidade de propagação de características benéficas.

### Crossover

O crossover combina dois indivíduos selecionados para produzir um novo indivíduo. No código, o crossover é realizado calculando a raiz quadrada do produto dos pais:

\[
x_{\text{novo}} = \sqrt{x_{\text{pai}_1} \cdot x_{\text{pai}_2}}
\]

Este método de crossover geométrico incentiva a combinação de características dos pais de forma não linear.

### Mutação

A mutação introduz diversidade genética na população, evitando a convergência prematura para soluções subótimas. No código, com uma probabilidade de 30%, um indivíduo é substituído por um novo valor aleatório dentro do intervalo [0, 10]:

\[
x_{\text{mutado}} = r_{\text{min}} + (r_{\text{max}} - r_{\text{min}}) \cdot \text{rand}()
\]

### Elitismo

O elitismo garante que o melhor indivíduo de cada geração seja preservado na população subsequente. Isso assegura que a solução ótima encontrada até o momento não seja perdida devido a operações de crossover ou mutação.

Matematicamente, se \( x_{\text{melhor}} \) é o melhor indivíduo da geração atual, então:

\[
x_{\text{nova população}}[1] = x_{\text{melhor}}
\]

---

## Conclusão

O código Scilab analisado implementa um algoritmo genético completo, incluindo inicialização da população, avaliação de aptidão, seleção por torneio, crossover, mutação e elitismo. A função de custo específica define a aptidão dos indivíduos, guiando o processo de otimização. A combinação de seleção seletiva, operações genéticas e preservação do melhor indivíduo assegura a convergência do algoritmo para soluções cada vez melhores ao longo das épocas. Compreender os fundamentos matemáticos por trás de cada etapa é crucial para adaptar e otimizar o algoritmo para diferentes problemas e funções de custo.