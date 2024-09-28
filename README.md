## Como rodar
1. Abra o console na área de trabalho
2. Clone o repositório:
```bash
git clone https://github.com/arthurbrenno/flores.git
```

3. Abra o Scilab
4. Vá em:
```bash
Arquivo -> Browse for new -> Diretório do projeto
```
5. Digite no scilab (comandos):
```scilab
exec('rede_neural.sce', -1);
```

## Explicação da execução
-1: É uma configuração especial que também executa o script no ambiente atual, mas com algumas diferenças sutis na forma como as variáveis são tratadas. No contexto específico do seu código, -1 é usado para garantir que todas as variáveis definidas no script sejam acessíveis no ambiente atual após a execução.


# Explicação do Código e do Algoritmo

# Implementação de uma Rede Neural Feedforward com Algoritmo de Backpropagation em Scilab

## Sumário

- [Introdução](#introdução)
- [Descrição Geral do Algoritmo](#descrição-geral-do-algoritmo)
- [Código Completo](#código-completo)
- [Explicação Detalhada do Código e do Algoritmo](#explicação-detalhada-do-código-e-do-algoritmo)
  - [1. Preparação do Ambiente](#1-preparação-do-ambiente)
  - [2. Carregamento dos Dados](#2-carregamento-dos-dados)
  - [3. Definição dos Parâmetros da Rede Neural](#3-definição-dos-parâmetros-da-rede-neural)
  - [4. Inicialização dos Pesos](#4-inicialização-dos-pesos)
  - [5. Treinamento da Rede Neural](#5-treinamento-da-rede-neural)
    - [5.1. Forward Pass (Propagação para Frente)](#51-forward-pass-propagação-para-frente)
    - [5.2. Backpropagation (Retropropagação do Erro)](#52-backpropagation-retropropagação-do-erro)
    - [5.3. Atualização dos Pesos](#53-atualização-dos-pesos)
  - [6. Teste da Rede Neural](#6-teste-da-rede-neural)
- [Explicação Matemática Passo a Passo](#explicação-matemática-passo-a-passo)
  - [A. Forward Pass Detalhado](#a-forward-pass-detalhado)
  - [B. Backpropagation Detalhado](#b-backpropagation-detalhado)
  - [C. Atualização dos Pesos Detalhada](#c-atualização-dos-pesos-detalhada)
- [Considerações Finais](#considerações-finais)
- [Referências](#referências)

---

## Introdução

Este documento apresenta a implementação de uma **rede neural feedforward** com duas camadas ocultas em **Scilab**, utilizando o algoritmo de **Backpropagation** para o treinamento. O objetivo é fornecer um entendimento completo do código e do algoritmo, incluindo explicações matemáticas detalhadas e passo a passo.

---

## Descrição Geral do Algoritmo

A rede neural implementada é composta por:

- **Uma camada de entrada**
- **Duas camadas ocultas**
- **Uma camada de saída**

O algoritmo de **Backpropagation** é utilizado para treinar a rede, ajustando os pesos para minimizar o erro entre a saída prevista e o alvo desejado.

---

## Código Completo

```scilab
// Limpar variáveis e console
clear;
clc;

// Carregar dados a partir de um arquivo externo
dados = csvRead('dados.csv');

// Determinar o número de entradas e saídas automaticamente
na = size(dados, 1); // Número de amostras
nc = size(dados, 2); // Número de colunas no arquivo de dados

// Como o bias está incluído nos dados, o número de entradas é:
nep = nc - 1; // Número de entradas (incluindo o bias)

// Definir o número de neurônios nas camadas ocultas
nnp = floor((nep + 1) * 1.5); // Exemplo: 1.5 vezes o número de entradas
nns = floor(nnp * 0.8); // Exemplo: 80% do número de neurônios da camada oculta 1

// Número de saídas (assumindo 1 saída)
nos = 1;

// Taxa de aprendizagem
n = 0.6;

// Inicialização dos pesos para cada camada com valores aleatórios
wp = rand(nep, nnp); // Pesos entre a entrada e a camada oculta 1
ws = rand(nnp + 1, nns); // Pesos entre a camada oculta 1 e a camada oculta 2 (+1 para o bias)
wo = rand(nns + 1, nos); // Pesos entre a camada oculta 2 e a saída (+1 para o bias)

// Verificação das dimensões iniciais
disp("Dimensões Iniciais:");
disp("wp: " + string(size(wp))); // Dimensões de wp
disp("ws: " + string(size(ws))); // Dimensões de ws
disp("wo: " + string(size(wo))); // Dimensões de wo

// Treinamento da rede neural
max_epocas = 100000; // Número máximo de épocas
for epoca = 1:max_epocas
    for am = 1:na
        // Extração das entradas e do alvo
        x = dados(am, 1:nep); // Entradas (incluindo o bias)
        tg = dados(am, nc); // Alvo (última coluna)

        // Camada oculta 1
        y1 = x * wp; // [1 x nep] * [nep x nnp] = [1 x nnp]
        y1 = 1 ./ (1 + exp(-y1)); // Função sigmoide
        y1d = y1 .* (1 - y1); // Derivada da função sigmoide

        // Camada oculta 2
        y2 = [ -1 y1 ] * ws; // [1 x (nnp + 1)] * [ (nnp + 1) x nns ] = [1 x nns]
        y2 = 1 ./ (1 + exp(-y2)); // Função sigmoide
        y2d = y2 .* (1 - y2); // Derivada da função sigmoide

        // Camada de saída
        yo = [ -1 y2 ] * wo; // [1 x (nns + 1)] * [ (nns + 1) x nos ] = [1 x nos]
        yo = 1 ./ (1 + exp(-yo)); // Função sigmoide
        yod = yo .* (1 - yo); // Derivada da função sigmoide

        // Cálculo dos deltas (erros)
        Do = tg - yo; // [1 x nos]
        delta_o = yod .* Do; // Delta da saída

        // Backpropagation
        Ds = delta_o * wo(2:end, :)'; // [1 x nos] * [nos x nns] = [1 x nns]
        delta_s = Ds .* y2d; // Delta da camada oculta 2

        Dp = delta_s * ws(2:end, :)'; // [1 x nns] * [nns x nnp] = [1 x nnp]
        delta_p = Dp .* y1d; // Delta da camada oculta 1

        // Atualização dos pesos
        // Camada de saída
        wo = wo + [ -1 y2 ]' * ( n * delta_o ); // [ (nns + 1) x 1 ] * [1 x nos] = [ (nns + 1) x nos ]

        // Camada oculta 2
        ws = ws + [ -1 y1 ]' * ( n * delta_s ); // [ (nnp + 1) x 1 ] * [1 x nns ] = [ (nnp + 1) x nns ]

        // Camada oculta 1
        wp = wp + x' * ( n * delta_p ); // [ nep x 1 ] * [1 x nnp ] = [ nep x nnp ]
    end

    // (Opcional) Exibir progresso a cada 10000 épocas
    if modulo(epoca, 10000) == 0 then
        disp("Época: " + string(epoca));
    end
end

// Teste da rede neural com os dados de entrada
for am = 1:na
    x = dados(am, 1:nep); // Entradas (incluindo o bias)
    tg = dados(am, nc); // Alvo (última coluna)

    // Forward pass
    y1 = x * wp;
    y1 = 1 ./ (1 + exp(-y1));

    y2 = [ -1 y1 ] * ws;
    y2 = 1 ./ (1 + exp(-y2));

    yo = [ -1 y2 ] * wo;
    yo = 1 ./ (1 + exp(-yo));

    // Exibir a saída prevista e o alvo
    printf("Entrada: %s, Saída prevista: %.4f, Alvo: %.4f\n", string(x(2:$)), yo, tg);
end
```

---

## Explicação Detalhada do Código e do Algoritmo

### 1. Preparação do Ambiente

```scilab
// Limpar variáveis e console
clear;
clc;
```

- **`clear;`**: Remove todas as variáveis do ambiente de trabalho para evitar conflitos.
- **`clc;`**: Limpa a janela de comando para uma visualização limpa.

### 2. Carregamento dos Dados

```scilab
// Carregar dados a partir de um arquivo externo
dados = csvRead('dados.csv');
```

- **`csvRead('dados.csv');`**: Lê os dados do arquivo `dados.csv` e armazena na variável `dados`.
- **Formato esperado do arquivo `dados.csv`:**
  - **Primeira coluna:** Bias (`-1`).
  - **Colunas seguintes:** Features (entradas).
  - **Última coluna:** Alvo (saída desejada).

### 3. Definição dos Parâmetros da Rede Neural

```scilab
// Determinar o número de entradas e saídas automaticamente
na = size(dados, 1); // Número de amostras
nc = size(dados, 2); // Número de colunas no arquivo de dados

// Como o bias está incluído nos dados, o número de entradas é:
nep = nc - 1; // Número de entradas (incluindo o bias)

// Definir o número de neurônios nas camadas ocultas
nnp = floor((nep + 1) * 1.5); // Número de neurônios na camada oculta 1
nns = floor(nnp * 0.8); // Número de neurônios na camada oculta 2

// Número de saídas
nos = 1; // Assumindo uma única saída

// Taxa de aprendizagem
n = 0.6;
```

- **`na`**: Número de amostras nos dados.
- **`nc`**: Número de colunas nos dados.
- **`nep`**: Número de entradas, incluindo o bias.
- **`nnp`**: Número de neurônios na camada oculta 1. Calculado como 1.5 vezes o número de entradas mais 1.
- **`nns`**: Número de neurônios na camada oculta 2. Calculado como 80% do número de neurônios da camada oculta 1.
- **`nos`**: Número de saídas. Aqui, está definido como 1.
- **`n`**: Taxa de aprendizagem utilizada na atualização dos pesos.

### 4. Inicialização dos Pesos

```scilab
// Inicialização dos pesos para cada camada com valores aleatórios
wp = rand(nep, nnp); // Pesos entre a entrada e a camada oculta 1
ws = rand(nnp + 1, nns); // Pesos entre a camada oculta 1 e a camada oculta 2 (+1 para o bias)
wo = rand(nns + 1, nos); // Pesos entre a camada oculta 2 e a saída (+1 para o bias)
```

- **`wp`**: Matriz de pesos entre a camada de entrada e a camada oculta 1.
- **`ws`**: Matriz de pesos entre a camada oculta 1 e a camada oculta 2.
- **`wo`**: Matriz de pesos entre a camada oculta 2 e a camada de saída.
- **Observação sobre o Bias:** O `+1` nas dimensões de `ws` e `wo` é para acomodar o bias adicional nas camadas ocultas.

### 5. Treinamento da Rede Neural

#### 5.1. Forward Pass (Propagação para Frente)

Para cada amostra, a rede processa os dados da entrada até a saída:

```scilab
// Extração das entradas e do alvo
x = dados(am, 1:nep); // Entradas (incluindo o bias)
tg = dados(am, nc); // Alvo (última coluna)

// Camada oculta 1
y1 = x * wp; // Multiplicação das entradas pelos pesos da primeira camada oculta
y1 = 1 ./ (1 + exp(-y1)); // Aplicação da função de ativação sigmoide
y1d = y1 .* (1 - y1); // Cálculo da derivada da sigmoide

// Camada oculta 2
y2 = [ -1 y1 ] * ws; // Adição do bias e multiplicação pelos pesos da segunda camada oculta
y2 = 1 ./ (1 + exp(-y2)); // Aplicação da função de ativação sigmoide
y2d = y2 .* (1 - y2); // Cálculo da derivada da sigmoide

// Camada de saída
yo = [ -1 y2 ] * wo; // Adição do bias e multiplicação pelos pesos da camada de saída
yo = 1 ./ (1 + exp(-yo)); // Aplicação da função de ativação sigmoide
yod = yo .* (1 - yo); // Cálculo da derivada da sigmoide
```

- **Camada Oculta 1:**
  - **Entrada:** `x` (incluindo o bias).
  - **Processamento:** Multiplicação por `wp` e aplicação da função de ativação.
- **Camada Oculta 2:**
  - **Entrada:** Saída da camada oculta 1 com bias adicionado.
  - **Processamento:** Multiplicação por `ws` e aplicação da função de ativação.
- **Camada de Saída:**
  - **Entrada:** Saída da camada oculta 2 com bias adicionado.
  - **Processamento:** Multiplicação por `wo` e aplicação da função de ativação.
  
#### 5.2. Backpropagation (Retropropagação do Erro)

```scilab
// Cálculo dos deltas (erros)
Do = tg - yo; // Erro na saída
delta_o = yod .* Do; // Delta da saída

// Backpropagation
Ds = delta_o * wo(2:end, :)'; // Propagação do erro para a camada oculta 2
delta_s = Ds .* y2d; // Delta da camada oculta 2

Dp = delta_s * ws(2:end, :)'; // Propagação do erro para a camada oculta 1
delta_p = Dp .* y1d; // Delta da camada oculta 1
```

- **Erro na Saída (`Do`):** Diferença entre o alvo e a saída prevista.
- **Delta da Saída (`delta_o`):** Produto do erro pela derivada da função de ativação.
- **Propagação do Erro:**
  - **Para a Camada Oculta 2:** Usando os pesos `wo` (sem o bias) e o delta da saída.
  - **Para a Camada Oculta 1:** Usando os pesos `ws` (sem o bias) e o delta da camada oculta 2.
  
#### 5.3. Atualização dos Pesos

```scilab
// Atualização dos pesos
// Camada de saída
wo = wo + [ -1 y2 ]' * ( n * delta_o ); // Atualização dos pesos da camada de saída

// Camada oculta 2
ws = ws + [ -1 y1 ]' * ( n * delta_s ); // Atualização dos pesos da camada oculta 2

// Camada oculta 1
wp = wp + x' * ( n * delta_p ); // Atualização dos pesos da camada oculta 1
```

- Os pesos são atualizados subindo o gradiente, ajustando-se para minimizar o erro.
- **Taxa de Aprendizagem (`n`):** Controla o tamanho dos passos na direção do gradiente.

### 6. Teste da Rede Neural

Após o treinamento, a rede é testada com os mesmos dados:

```scilab
for am = 1:na
    x = dados(am, 1:nep); // Entradas (incluindo o bias)
    tg = dados(am, nc); // Alvo (última coluna)

    // Forward pass
    y1 = x * wp;
    y1 = 1 ./ (1 + exp(-y1));

    y2 = [ -1 y1 ] * ws;
    y2 = 1 ./ (1 + exp(-y2));

    yo = [ -1 y2 ] * wo;
    yo = 1 ./ (1 + exp(-yo));

    // Exibir a saída prevista e o alvo
    printf("Entrada: %s, Saída prevista: %.4f, Alvo: %.4f\n", string(x(2:$)), yo, tg);
end
```

- **Forward Pass:** Realiza novamente a propagação para frente para cada amostra.
- **Exibição dos Resultados:** Mostra as entradas (excluindo o bias), a saída prevista e o alvo.

---

## Explicação Matemática Passo a Passo

### A. Forward Pass Detalhado

1. **Camada de Entrada para Camada Oculta 1**

   - **Entrada:** Vetor `x` com dimensão `[1 x nep]`.
   - **Pesos:** Matriz `wp` com dimensão `[nep x nnp]`.
   - **Processamento:**
     - **Produto Linear:** `z1 = x * wp` resulta em um vetor `[1 x nnp]`.
     - **Função de Ativação (Sigmoide):** `y1 = σ(z1)`, onde `σ(z) = 1 / (1 + e^{-z})`.

2. **Camada Oculta 1 para Camada Oculta 2**

   - **Entrada:** Saída `y1` com dimensão `[1 x nnp]`.
   - **Adição do Bias:** `[ -1 y1 ]` resulta em `[1 x (nnp + 1)]`.
   - **Pesos:** Matriz `ws` com dimensão `[ (nnp + 1) x nns ]`.
   - **Processamento:**
     - **Produto Linear:** `z2 = [ -1 y1 ] * ws` resulta em `[1 x nns]`.
     - **Função de Ativação (Sigmoide):** `y2 = σ(z2)`.

3. **Camada Oculta 2 para Camada de Saída**

   - **Entrada:** Saída `y2` com dimensão `[1 x nns]`.
   - **Adição do Bias:** `[ -1 y2 ]` resulta em `[1 x (nns + 1)]`.
   - **Pesos:** Matriz `wo` com dimensão `[ (nns + 1) x nos ]`.
   - **Processamento:**
     - **Produto Linear:** `z3 = [ -1 y2 ] * wo` resulta em `[1 x nos]`.
     - **Função de Ativação (Sigmoide):** `yo = σ(z3)`.

### B. Backpropagation Detalhado

1. **Erro na Saída**

   - **Erro:** `Do = tg - yo`, onde `tg` é o alvo e `yo` é a saída prevista.
   - **Delta da Saída:** `delta_o = yod .* Do`, onde `yod = yo .* (1 - yo)` é a derivada da função sigmoide aplicada à saída.

2. **Propagação do Erro para a Camada Oculta 2**

   - **Pesos da Camada de Saída (Sem Bias):** `wo_sem_bias = wo(2:end, :)` com dimensão `[nns x nos]`.
   - **Cálculo do Erro:** `Ds = delta_o * wo_sem_bias'` resulta em `[1 x nns]`.
   - **Delta da Camada Oculta 2:** `delta_s = Ds .* y2d`, onde `y2d = y2 .* (1 - y2)`.

3. **Propagação do Erro para a Camada Oculta 1**

   - **Pesos da Camada Oculta 2 (Sem Bias):** `ws_sem_bias = ws(2:end, :)` com dimensão `[nnp x nns]`.
   - **Cálculo do Erro:** `Dp = delta_s * ws_sem_bias'` resulta em `[1 x nnp]`.
   - **Delta da Camada Oculta 1:** `delta_p = Dp .* y1d`, onde `y1d = y1 .* (1 - y1)`.

### C. Atualização dos Pesos Detalhada

1. **Camada de Saída**

   - **Gradiente dos Pesos:** `∇wo = [ -1 y2 ]' * ( n * delta_o )`
     - Dimensões:
       - `[ -1 y2 ]'` é `[ (nns + 1) x 1 ]`.
       - `delta_o` é `[1 x nos]`.
       - Resultado: `[ (nns + 1) x nos ]`.
   - **Atualização dos Pesos:** `wo = wo + ∇wo`

2. **Camada Oculta 2**

   - **Gradiente dos Pesos:** `∇ws = [ -1 y1 ]' * ( n * delta_s )`
     - Dimensões:
       - `[ -1 y1 ]'` é `[ (nnp + 1) x 1 ]`.
       - `delta_s` é `[1 x nns]`.
       - Resultado: `[ (nnp + 1) x nns ]`.
   - **Atualização dos Pesos:** `ws = ws + ∇ws`

3. **Camada Oculta 1**

   - **Gradiente dos Pesos:** `∇wp = x' * ( n * delta_p )`
     - Dimensões:
       - `x'` é `[ nep x 1 ]`.
       - `delta_p` é `[1 x nnp]`.
       - Resultado: `[ nep x nnp ]`.
   - **Atualização dos Pesos:** `wp = wp + ∇wp`

---

## Considerações Finais

Este documento apresentou a implementação detalhada de uma rede neural feedforward com duas camadas ocultas em Scilab, utilizando o algoritmo de Backpropagation para o treinamento. O código foi explicado em detalhes, incluindo as etapas matemáticas do forward pass, backpropagation e atualização dos pesos.

**Dicas para Melhorias e Ajustes:**

- **Normalização dos Dados:** É recomendável normalizar os dados de entrada para melhorar o desempenho da rede.
- **Ajuste da Taxa de Aprendizagem:** A taxa de aprendizagem (`n`) pode ser ajustada conforme necessário. Valores muito altos podem causar instabilidade, enquanto valores muito baixos podem tornar o treinamento muito lento.
- **Número de Neurônios nas Camadas Ocultas:** Experimente ajustar o número de neurônios nas camadas ocultas (`nnp`, `nns`) para encontrar a configuração que melhor se adapta ao seu problema específico.
- **Funções de Ativação Alternativas:** Embora a função sigmoide seja utilizada neste exemplo, outras funções de ativação (como ReLU, tanh) podem ser testadas para verificar se melhoram o desempenho.

---

## Referências

- **Goodfellow, I., Bengio, Y., & Courville, A. (2016).** Deep Learning. MIT Press.
- **Haykin, S. (1999).** Neural Networks: A Comprehensive Foundation. Prentice Hall.
- **Bishop, C. M. (1995).** Neural Networks for Pattern Recognition. Oxford University Press.

---
