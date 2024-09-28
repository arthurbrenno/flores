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
exec('ag.sce', -1);
```

## **3. Explicação Detalhada do Código e do Algoritmo**

### **Introdução**

Este documento fornece uma explicação completa do código de um algoritmo genético (AG) implementado em Scilab. O objetivo do AG é encontrar os melhores valores para os parâmetros `a` e `b` de uma função linear `y = a * x + b` que melhor ajusta os dados fornecidos no arquivo `data.csv`. O critério de ajuste é minimizar o erro quadrático médio (MSE) entre os valores previstos pelo modelo e os valores reais dos dados.

### **Descrição Geral do Algoritmo Genético**

Um **Algoritmo Genético** é uma técnica de otimização inspirada nos princípios da evolução natural e seleção natural. Ele utiliza processos como seleção, crossover (recombinação) e mutação para evoluir uma população de indivíduos candidatos a soluções ótimas.

**Componentes Principais:**

1. **População Inicial**: Conjunto de possíveis soluções (indivíduos), cada um com um conjunto de parâmetros (genes).
2. **Função Fitness**: Mede a qualidade de cada indivíduo em resolver o problema.
3. **Seleção**: Escolhe indivíduos para reprodução com base em sua aptidão (fitness).
4. **Crossover (Recombinação)**: Combina partes de dois indivíduos para criar descendentes.
5. **Mutação**: Introduz variações aleatórias nos indivíduos para manter a diversidade genética.
6. **Eletismo**: Preserva os melhores indivíduos entre gerações para garantir que as melhores soluções não sejam perdidas.

### **Estrutura do Código**

#### **1. Preparação do Ambiente**

```scilab
// Limpar variáveis e console
clear;
clc;
```

- **`clear;`**: Remove todas as variáveis do ambiente de trabalho.
- **`clc;`**: Limpa a janela de comando.

#### **2. Carregamento dos Dados**

```scilab
// Carregar dados a partir de um arquivo externo
data = csvRead('data.csv');

// Separar as variáveis de entrada (x) e saída (y)
x_data = data(:, 1);
y_data = data(:, 2);
```

- **`csvRead('data.csv');`**: Lê os dados do arquivo `data.csv` e armazena na variável `data`.
- **`x_data`**: Vetor com os valores de entrada `x`.
- **`y_data`**: Vetor com os valores de saída `y`.

**Formato do Arquivo `data.csv`:**

O arquivo deve conter duas colunas separadas por vírgula:

- **Primeira coluna**: Valores de `x`.
- **Segunda coluna**: Valores correspondentes de `y`.

#### **3. Definição dos Parâmetros do Algoritmo Genético**

```scilab
npop = 100;    // Tamanho da população
nvars = 2;     // Número de variáveis (parâmetros a serem otimizados: a e b)
rmax = [10, 10];     // Valor máximo para inicialização das variáveis [a_max, b_max]
rmin = [-10, -10];   // Valor mínimo para inicialização das variáveis [a_min, b_min]
geracoes = 1000; // Número de gerações
taxa_mutacao = 0.05; // Taxa de mutação
taxa_crossover = 0.8; // Taxa de crossover
elitismo = %t;  // Flag para usar elitismo
```

- **`npop`**: Número de indivíduos na população.
- **`nvars`**: Número de variáveis (genes) em cada indivíduo. Neste caso, 2 (parâmetros `a` e `b`).
- **`rmax`** e **`rmin`**: Limites máximos e mínimos para a inicialização dos parâmetros `a` e `b`.
- **`geracoes`**: Número total de gerações que o algoritmo irá executar.
- **`taxa_mutacao`**: Probabilidade de mutação de um indivíduo.
- **`taxa_crossover`**: Probabilidade de crossover entre dois indivíduos.
- **`elitismo`**: Se verdadeiro (`%t`), preserva o melhor indivíduo a cada geração.

#### **4. Definição da Função Fitness**

```scilab
function fitness = calcular_fitness(pop, x_data, y_data)
    npop = size(pop, 1);
    fitness = zeros(npop, 1);
    for i = 1:npop
        a = pop(i, 1);
        b = pop(i, 2);
        y_pred = a * x_data + b;
        erro = y_data - y_pred;
        mse = mean(erro.^2);
        fitness(i) = -mse; // Negativo porque o AG maximiza a função fitness
    end
endfunction
```

- **Objetivo da Função Fitness**: Avaliar o quão bem um conjunto de parâmetros `(a, b)` ajusta os dados.
- **Cálculo do Erro Quadrático Médio (MSE)**:
  - `erro = y_data - y_pred`: Calcula o erro entre os valores reais e previstos.
  - `mse = mean(erro.^2)`: Calcula o MSE.
- **Fitness**:
  - `fitness(i) = -mse`: O fitness é o negativo do MSE porque o AG é configurado para maximizar a função fitness. Ao usar o negativo, estamos efetivamente minimizando o MSE.

#### **5. Inicialização da População**

```scilab
pop = zeros(npop, nvars);
for i = 1:nvars
    pop(:, i) = rmin(i) + (rmax(i) - rmin(i)) * rand(npop, 1);
end
```

- **Inicialização Aleatória**:
  - Para cada variável (`a` e `b`), gera valores aleatórios entre `rmin` e `rmax`.
  - `pop` é uma matriz de dimensão `[npop x nvars]`.

#### **6. Inicialização das Variáveis de Controle**

```scilab
melhor_individuo = [];
melhor_fitness = -%inf;
```

- **`melhor_individuo`**: Armazena o melhor conjunto de parâmetros `(a, b)` encontrado.
- **`melhor_fitness`**: Armazena o melhor valor de fitness (maior valor, já que estamos maximizando).

#### **7. Loop Principal do Algoritmo Genético**

```scilab
for geracao = 1:geracoes
    // ...
end
```

- Executa o algoritmo genético pelo número de gerações definido.

##### **7.1. Avaliação da Função Fitness**

```scilab
fitness = calcular_fitness(pop, x_data, y_data);
```

- Avalia o fitness de cada indivíduo na população atual.

##### **7.2. Seleção por Torneio**

```scilab
nova_pop = zeros(npop, nvars);
for i = 1:npop
    // Selecionar dois indivíduos aleatoriamente
    indices = grand(1, 2, 'uin', 1, npop);
    individuo1 = pop(indices(1), :);
    individuo2 = pop(indices(2), :);
    fitness1 = fitness(indices(1));
    fitness2 = fitness(indices(2));
    
    // Selecionar o melhor dos dois
    if fitness1 > fitness2 then
        nova_pop(i, :) = individuo1;
    else
        nova_pop(i, :) = individuo2;
    end
end
```

- **Processo**:
  - Para cada posição na nova população, dois indivíduos são selecionados aleatoriamente.
  - O indivíduo com melhor fitness é escolhido para a nova população.
  
##### **7.3. Crossover (Recombinação)**

```scilab
for i = 1:2:npop - 1
    if rand() < taxa_crossover then
        // Realizar crossover entre nova_pop(i) e nova_pop(i+1)
        alpha = rand();
        filho1 = alpha * nova_pop(i, :) + (1 - alpha) * nova_pop(i+1, :);
        filho2 = alpha * nova_pop(i+1, :) + (1 - alpha) * nova_pop(i, :);
        nova_pop(i, :) = filho1;
        nova_pop(i+1, :) = filho2;
    end
end
```

- **Crossover Aritmético**:
  - Combina os genes dos pais usando um fator `alpha` aleatório entre 0 e 1.
  - Gera dois novos indivíduos (filhos) como combinações lineares dos pais.
- **Condição**:
  - O crossover ocorre com probabilidade definida por `taxa_crossover`.

##### **7.4. Mutação**

```scilab
for i = 1:npop
    if rand() < taxa_mutacao then
        // Mutar cada gene do indivíduo
        for j = 1:nvars
            nova_pop(i, j) = rmin(j) + (rmax(j) - rmin(j)) * rand();
        end
    end
end
```

- **Processo**:
  - Com probabilidade definida por `taxa_mutacao`, um indivíduo é selecionado para mutação.
  - Cada gene (parâmetro `a` ou `b`) do indivíduo é substituído por um novo valor aleatório dentro dos limites.

##### **7.5. Avaliação da Nova População**

```scilab
fitness_nova_pop = calcular_fitness(nova_pop, x_data, y_data);
```

- Avalia o fitness dos indivíduos na nova população após crossover e mutação.

##### **7.6. Eletismo**

```scilab
if elitismo then
    [fitness_total, idx] = max(fitness_nova_pop);
    if fitness_total > melhor_fitness then
        melhor_fitness = fitness_total;
        melhor_individuo = nova_pop(idx, :);
    end
    // Substituir o pior indivíduo pela melhor solução encontrada
    [fitness_min, idx_min] = min(fitness_nova_pop);
    nova_pop(idx_min, :) = melhor_individuo;
    fitness_nova_pop(idx_min) = melhor_fitness;
end
```

- **Objetivo**: Garantir que o melhor indivíduo encontrado não seja perdido.
- **Processo**:
  - Se o melhor indivíduo da nova população tem fitness melhor que `melhor_fitness`, atualiza `melhor_individuo` e `melhor_fitness`.
  - Substitui o pior indivíduo da nova população pelo `melhor_individuo`.

##### **7.7. Atualização da População**

```scilab
pop = nova_pop;
fitness = fitness_nova_pop;
```

- Atualiza a população atual com a nova população para a próxima geração.

##### **7.8. Exibição de Informações**

```scilab
if modulo(geracao, 100) == 0 then
    disp("Geração: " + string(geracao) + ", Melhor Fitness (Negativo do MSE): " + string(melhor_fitness));
end
```

- A cada 100 gerações, exibe informações sobre a geração atual e o melhor fitness.

#### **8. Exibição do Melhor Resultado**

```scilab
disp("Melhor Individuo Encontrado (a, b):");
disp(melhor_individuo);
disp("Melhor Fitness (Negativo do MSE):");
disp(melhor_fitness);
```

- Após a execução do algoritmo, exibe o melhor conjunto de parâmetros `(a, b)` encontrado e seu fitness.

#### **9. Visualização do Ajuste**

```scilab
// Plotar o ajuste dos dados
a_otimo = melhor_individuo(1);
b_otimo = melhor_individuo(2);
y_pred_otimo = a_otimo * x_data + b_otimo;

clf;
plot(x_data, y_data, 'o', x_data, y_pred_otimo, '-r');
xlabel('x');
ylabel('y');
title('Ajuste Linear usando AG');
legend('Dados', 'Ajuste AG');
```

- **Objetivo**: Visualizar o ajuste da reta encontrada pelo AG aos dados.
- **Processo**:
  - Calcula os valores previstos `y_pred_otimo` usando os parâmetros `a_otimo` e `b_otimo`.
  - Plota os dados reais e a reta de ajuste.

---

### **Explicação Matemática Passo a Passo**

#### **1. Representação dos Indivíduos**

- Cada indivíduo é representado por um vetor de parâmetros `[a, b]`.
- **Dimensão do Problema**: `nvars = 2`.

#### **2. Função Fitness**

- **Objetivo**: Minimizar o erro quadrático médio (MSE) entre os valores previstos pelo modelo linear `y = a * x + b` e os valores reais dos dados.
- **Cálculo do Fitness**:
  - `y_pred = a * x_data + b`
  - `erro = y_data - y_pred`
  - `mse = (1/N) * Σ(erro_i^2)`, onde `N` é o número de dados.
  - **Fitness**: `fitness = -mse`
    - O negativo é usado porque o algoritmo genético maximiza a função fitness, então ao usar o negativo do MSE, estamos efetivamente minimizando o MSE.

#### **3. Seleção por Torneio**

- **Processo**:
  - Selecionar aleatoriamente dois indivíduos da população.
  - O indivíduo com melhor fitness é selecionado para a nova população.
- **Justificativa**:
  - A seleção por torneio é simples e eficiente, garantindo que indivíduos mais aptos tenham maior probabilidade de serem selecionados.

#### **4. Crossover (Recombinação)**

- **Método Utilizado**: Crossover Aritmético.
- **Fórmulas**:
  - `filho1 = α * pai1 + (1 - α) * pai2`
  - `filho2 = α * pai2 + (1 - α) * pai1`
  - Onde `α ∈ [0, 1]` é um número aleatório.
- **Objetivo**:
  - Combinar características dos pais para gerar descendentes potencialmente mais aptos.

#### **5. Mutação**

- **Processo**:
  - Com uma certa probabilidade, um indivíduo é selecionado para mutação.
  - Cada gene (`a` ou `b`) do indivíduo é substituído por um novo valor aleatório dentro dos limites.
- **Objetivo**:
  - Introduzir diversidade genética na população para evitar convergência prematura.

#### **6. Eletismo**

- **Processo**:
  - Preserva o melhor indivíduo encontrado até o momento.
  - Substitui o pior indivíduo da nova população pelo melhor indivíduo.
- **Objetivo**:
  - Garantir que a solução ótima não seja perdida ao longo das gerações.

#### **7. Convergência do Algoritmo**

- O algoritmo continua por um número fixo de gerações (`geracoes`).
- A convergência é observada quando não há melhorias significativas no fitness ao longo das gerações.

---

### **Como Executar o Código**

1. **Preparar o Ambiente**:
   - Certifique-se de que o Scilab está instalado no seu computador.

2. **Criar o Arquivo de Dados (`data.csv`)**:
   - Crie um arquivo chamado `data.csv` no mesmo diretório do script.
   - Copie e cole os dados fornecidos na seção do arquivo de dados.

3. **Criar o Arquivo do Código**:
   - Copie o código do algoritmo genético e salve em um arquivo chamado `algoritmo_genetico.sce` no mesmo diretório.

4. **Executar o Código**:
   - Abra o Scilab.
   - Navegue até o diretório onde o arquivo `algoritmo_genetico.sce` está salvo.
     ```scilab
     cd('caminho/para/o/diretorio');
     ```
   - Execute o script:
     ```scilab
     exec('algoritmo_genetico.sce', -1);
     ```

5. **Analisar os Resultados**:
   - O código exibirá o melhor conjunto de parâmetros `(a, b)` encontrado e o valor do fitness (negativo do MSE).
   - Um gráfico será exibido mostrando os dados e a reta de ajuste encontrada pelo AG.

---

## **4. Explicação Resumida**

### **Objetivo do Código**

- Utilizar um algoritmo genético para encontrar os melhores valores dos parâmetros `a` e `b` de uma função linear `y = a * x + b` que melhor ajusta os dados fornecidos.
- O critério de otimização é minimizar o erro quadrático médio (MSE) entre os valores previstos e os reais.

### **Fluxo do Algoritmo Genético**

1. **Inicialização**:
   - Gerar uma população inicial de indivíduos (soluções) com valores aleatórios para `a` e `b`.

2. **Avaliação**:
   - Calcular o fitness (negativo do MSE) de cada indivíduo em relação aos dados.

3. **Seleção**:
   - Utilizar seleção por torneio para escolher indivíduos para a reprodução.

4. **Crossover**:
   - Realizar recombinação entre pares de indivíduos selecionados para gerar novos indivíduos (descendentes).

5. **Mutação**:
   - Introduzir variações aleatórias nos indivíduos para manter a diversidade genética.

6. **Eletismo**:
   - Preservar o melhor indivíduo encontrado até o momento, garantindo que não seja perdido.

7. **Iteração**:
   - Repetir os passos de 2 a 6 por um número definido de gerações.

8. **Resultado**:
   - Após todas as gerações, exibir o melhor conjunto de parâmetros `(a, b)` encontrado e o ajuste visual no gráfico.

### **Considerações Finais**

- **Personalização**:
  - Os parâmetros do AG (tamanho da população, taxas de crossover e mutação, número de gerações) podem ser ajustados para melhorar o desempenho.
  - O código pode ser adaptado para outros modelos ou funções de ajuste.

- **Limitações**:
  - Algoritmos genéticos podem ser computacionalmente intensivos.
  - Não garantem encontrar a solução ótima global, mas fornecem uma boa aproximação.

- **Extensões**:
  - Implementar outros métodos de seleção (por exemplo, roleta).
  - Experimentar diferentes métodos de crossover e mutação.
  - Adaptar o algoritmo para problemas com mais variáveis (por exemplo, ajuste polinomial).

---
