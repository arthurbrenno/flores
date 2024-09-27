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

## Explicação Completa

### Sumário

- [Introdução](#introdução)
- [Descrição Geral do Algoritmo](#descrição-geral-do-algoritmo)
- [Estrutura do Código](#estrutura-do-código)
  - [1. Preparação do Ambiente](#1-preparação-do-ambiente)
  - [2. Carregamento dos Dados](#2-carregamento-dos-dados)
  - [3. Definição dos Parâmetros da Rede Neural](#3-definição-dos-parâmetros-da-rede-neural)
  - [4. Inicialização dos Pesos](#4-inicialização-dos-pesos)
  - [5. Treinamento da Rede Neural](#5-treinamento-da-rede-neural)
    - [5.1. Forward Pass](#51-forward-pass)
    - [5.2. Cálculo dos Erros e Deltas](#52-cálculo-dos-erros-e-deltas)
    - [5.3. Backpropagation e Atualização dos Pesos](#53-backpropagation-e-atualização-dos-pesos)
  - [6. Teste da Rede Neural](#6-teste-da-rede-neural)
- [Detalhes do Algoritmo](#detalhes-do-algoritmo)
  - [A. Forward Pass Detalhado](#a-forward-pass-detalhado)
  - [B. Backpropagation Detalhado](#b-backpropagation-detalhado)
- [Considerações Finais](#considerações-finais)

---

### Introdução

Este documento fornece uma explicação completa do código de uma rede neural feedforward com duas camadas ocultas implementada em Scilab. O objetivo é permitir que você compreenda cada parte do código e como o algoritmo de treinamento (backpropagation) funciona em detalhes.

---

### Descrição Geral do Algoritmo

A rede neural implementada é uma rede feedforward com:

- **Uma camada de entrada**
- **Duas camadas ocultas**
- **Uma camada de saída**

O treinamento da rede é realizado usando o algoritmo de **backpropagation**, que ajusta os pesos da rede para minimizar o erro entre a saída prevista e o alvo desejado.

---

### Estrutura do Código

#### 1. Preparação do Ambiente

```scilab
// Limpar variáveis e console
clear;
clc;
```

- **`clear;`**: Remove todas as variáveis do ambiente de trabalho.
- **`clc;`**: Limpa a janela de comando.

#### 2. Carregamento dos Dados

```scilab
// Carregar dados a partir de um arquivo externo
dados = csvRead('dados.csv');
```

- **`csvRead('dados.csv');`**: Lê os dados do arquivo `dados.csv` e armazena na variável `dados`.
- **Formato esperado do arquivo `dados.csv`:**
  - A primeira coluna é o **bias** (`-1`).
  - As colunas seguintes são as **features** (entradas).
  - A última coluna é o **alvo** (saída desejada).

#### 3. Definição dos Parâmetros da Rede Neural

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
- **`nnp`**: Número de neurônios na camada oculta 1. Calculado automaticamente.
- **`nns`**: Número de neurônios na camada oculta 2. Calculado automaticamente.
- **`nos`**: Número de saídas. Aqui, está definido como 1.
- **`n`**: Taxa de aprendizagem usada na atualização dos pesos.

#### 4. Inicialização dos Pesos

```scilab
// Inicialização dos pesos para cada camada com valores aleatórios
wp = rand(nep, nnp); // Pesos entre a entrada e a camada oculta 1
ws = rand(nnp + 1, nns); // Pesos entre a camada oculta 1 e a camada oculta 2 (+1 para o bias)
wo = rand(nns + 1, nos); // Pesos entre a camada oculta 2 e a saída (+1 para o bias)
```

- **`wp`**: Matriz de pesos entre a camada de entrada e a camada oculta 1.
- **`ws`**: Matriz de pesos entre a camada oculta 1 e a camada oculta 2.
- **`wo`**: Matriz de pesos entre a camada oculta 2 e a camada de saída.

As dimensões das matrizes são definidas com base nos números de neurônios em cada camada.

#### 5. Treinamento da Rede Neural

##### 5.1. Forward Pass

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

##### 5.2. Cálculo dos Erros e Deltas

```scilab
// Cálculo dos deltas (erros)
Do = tg - yo; // Erro na saída
Ds = ( yod .* Do )' * wo(2:end, :)'; // Erro na camada oculta 2
Dp = ( y2d .* Ds' ) * ws(2:end, :)'; // Erro na camada oculta 1
```

- **`Do`**: Diferença entre o alvo e a saída prevista.
- **`Ds`**: Delta da camada oculta 2, calculado propagando o erro para trás.
- **`Dp`**: Delta da camada oculta 1, calculado propagando o erro para trás.

##### 5.3. Backpropagation e Atualização dos Pesos

```scilab
// Atualização dos pesos
// Camada de saída
wod = [ -1 y2 ]' * ( n * yod .* Do ); // Cálculo da variação dos pesos
wo = wo + wod; // Atualização dos pesos

// Camada oculta 2
wsd = [ -1 y1 ]' * ( n * Ds' .* y2d' ); // Cálculo da variação dos pesos
ws = ws + wsd; // Atualização dos pesos

// Camada oculta 1
wpd = x' * ( n * Dp .* y1d ); // Cálculo da variação dos pesos
wp = wp + wpd; // Atualização dos pesos
```

- Os pesos são atualizados subindo o gradiente, ajustando-se para minimizar o erro.

#### 6. Teste da Rede Neural

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
    printf("Entrada: %s, Saída prevista: %.2f, Alvo: %.2f\n", string(x(2:$)), yo, tg);
end
```

- O código realiza um **forward pass** para cada amostra e exibe a saída prevista junto com o alvo desejado.

---

### Detalhes do Algoritmo

#### A. Forward Pass Detalhado

1. **Entrada para Camada Oculta 1:**

   - **Cálculo:** `y1 = x * wp`
     - `x`: Vetor de entrada `[1 x nep]`.
     - `wp`: Matriz de pesos `[nep x nnp]`.
     - `y1`: Resultado `[1 x nnp]`.

   - **Aplicação da Função de Ativação Sigmoide:**
     - `y1 = 1 ./ (1 + exp(-y1))`

2. **Camada Oculta 1 para Camada Oculta 2:**

   - **Adição do Bias:** `[ -1 y1 ]`
     - Adiciona o bias à saída da camada oculta 1.
     - Resultado: Vetor `[1 x (nnp + 1)]`.

   - **Cálculo:** `y2 = [ -1 y1 ] * ws`
     - `ws`: Matriz de pesos `[ (nnp + 1) x nns ]`.
     - `y2`: Resultado `[1 x nns]`.

   - **Aplicação da Função de Ativação Sigmoide:**
     - `y2 = 1 ./ (1 + exp(-y2))`

3. **Camada Oculta 2 para Saída:**

   - **Adição do Bias:** `[ -1 y2 ]`
     - Adiciona o bias à saída da camada oculta 2.
     - Resultado: Vetor `[1 x (nns + 1)]`.

   - **Cálculo:** `yo = [ -1 y2 ] * wo`
     - `wo`: Matriz de pesos `[ (nns + 1) x nos ]`.
     - `yo`: Resultado `[1 x nos]`.

   - **Aplicação da Função de Ativação Sigmoide:**
     - `yo = 1 ./ (1 + exp(-yo))`

#### B. Backpropagation Detalhado

1. **Erro na Saída:**

   - **Cálculo do Erro:** `Do = tg - yo`

2. **Cálculo do Delta da Camada de Saída:**

   - **Derivada da Função de Ativação:** `yod = yo .* (1 - yo)`
   - **Delta da Saída:** `delta_o = yod .* Do`

3. **Propagação do Erro para Camada Oculta 2:**

   - **Cálculo:** `Ds = delta_o * wo(2:end, :)'`
     - `wo(2:end, :)`: Pesos sem o bias.
     - `Ds`: Delta da camada oculta 2.

   - **Derivada da Função de Ativação:** `y2d = y2 .* (1 - y2)`
   - **Delta da Camada Oculta 2:** `delta_s = Ds .* y2d`

4. **Propagação do Erro para Camada Oculta 1:**

   - **Cálculo:** `Dp = delta_s * ws(2:end, :)'`
     - `ws(2:end, :)`: Pesos sem o bias.
     - `Dp`: Delta da camada oculta 1.

   - **Derivada da Função de Ativação:** `y1d = y1 .* (1 - y1)`
   - **Delta da Camada Oculta 1:** `delta_p = Dp .* y1d`

5. **Atualização dos Pesos:**

   - **Camada de Saída:**
     - `wo = wo + [ -1 y2 ]' * ( n * delta_o )`

   - **Camada Oculta 2:**
     - `ws = ws + [ -1 y1 ]' * ( n * delta_s )`

   - **Camada Oculta 1:**
     - `wp = wp + x' * ( n * delta_p )`

---

### Considerações Finais

Este código implementa uma rede neural feedforward com backpropagation, automatizando a definição dos parâmetros com base nos dados fornecidos. Com essa abordagem, você pode utilizar o mesmo código para diferentes conjuntos de dados, desde que mantenha o formato esperado.

Para obter melhores resultados, é importante:

- **Normalizar os dados de entrada**, especialmente se eles estiverem em diferentes escalas.
- **Ajustar a taxa de aprendizagem** (`n`) conforme necessário.
- **Experimentar com o número de neurônios** nas camadas ocultas para encontrar a configuração ideal para o seu problema.

---

## Explicação Resumida

### Descrição Geral

O código implementa uma rede neural feedforward com duas camadas ocultas em Scilab, capaz de ajustar automaticamente seus parâmetros com base nos dados fornecidos. O treinamento é realizado usando o algoritmo de backpropagation.

### Funcionamento do Código

1. **Preparação do Ambiente:**
   - Limpa as variáveis e o console.

2. **Carregamento dos Dados:**
   - Lê os dados do arquivo `dados.csv`.
   - Espera que o bias (`-1`) esteja incluído nos dados.

3. **Definição Automática dos Parâmetros:**
   - Calcula o número de amostras (`na`), entradas (`nep`), e colunas (`nc`) a partir dos dados.
   - Define o número de neurônios nas camadas ocultas (`nnp`, `nns`) com base em fórmulas que dependem de `nep`.
   - Define a taxa de aprendizagem (`n`).

4. **Inicialização dos Pesos:**
   - Inicializa os pesos das camadas (`wp`, `ws`, `wo`) com valores aleatórios.

5. **Treinamento da Rede:**
   - Para cada época e amostra:
     - Realiza o **forward pass** através das camadas, aplicando a função de ativação sigmoide.
     - Calcula o erro entre a saída prevista e o alvo.
     - Propaga o erro para trás (**backpropagation**), calculando os deltas.
     - Atualiza os pesos das camadas com base nos deltas e na taxa de aprendizagem.

6. **Teste da Rede:**
   - Após o treinamento, testa a rede com os dados de entrada.
   - Exibe a saída prevista e o alvo para cada amostra.

### Como Utilizar com Seus Próprios Dados

- **Formato dos Dados:**
  - O arquivo `dados.csv` deve incluir o bias na primeira coluna, seguido pelas features e pelo alvo na última coluna.

- **Automatização:**
  - O código ajusta automaticamente o número de entradas e as dimensões das matrizes com base nos dados.
  - Você só precisa fornecer o arquivo de dados no formato correto.

### Observações

- **Bias Incluído nos Dados:**
  - Certifique-se de incluir o bias (`-1`) nos dados para evitar duplicação.

- **Ajuste de Parâmetros:**
  - Você pode ajustar a taxa de aprendizagem (`n`) e as fórmulas que definem o número de neurônios nas camadas ocultas conforme necessário.

- **Normalização dos Dados:**
  - Recomenda-se normalizar os dados de entrada para melhorar o desempenho da rede.

---

# Código Refatorado

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
        Ds = ( yod .* Do )' * wo(2:end, :)'; // [nos x 1] * [nos x nns] = [nns x 1]
        Dp = ( y2d .* Ds' ) * ws(2:end, :)'; // [1 x nns] * [nns x nnp] = [1 x nnp]

        // Atualização dos pesos
        // Camada de saída
        wod = [ -1 y2 ]' * ( n * yod .* Do ); // [ (nns + 1) x 1 ] * [1 x nos] = [ (nns + 1) x nos ]
        wo = wo + wod;

        // Camada oculta 2
        wsd = [ -1 y1 ]' * ( n * Ds' .* y2d' ); // [ (nnp + 1) x 1 ] * [1 x nns ] = [ (nnp + 1) x nns ]
        ws = ws + wsd;

        // Camada oculta 1
        wpd = x' * ( n * Dp .* y1d ); // [ nep x 1 ] * [1 x nnp ] = [ nep x nnp ]
        wp = wp + wpd;
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
    printf("Entrada: %s, Saída prevista: %.2f, Alvo: %.2f\n", string(x(2:$)), yo, tg);
end
```