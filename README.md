## Código Scilab Atualizado com Documentação

```scilab
// Otimização do Ângulo de Inclinação de Painéis Solares utilizando Algoritmo Genético
// Autor: Arthur, Caio e Miguel
// Data: 30/09/2024

clear;
clc;

// =============================
// Parâmetros do Problema
// =============================

// Tamanho da população
NPOP = 1000;

// Intervalo de ângulos de inclinação (em graus)
ANGULO_MIN = 15;    // Ângulo mínimo de inclinação
ANGULO_MAX = 60;    // Ângulo máximo de inclinação

// Eficiência inicial do painel solar
EFICIENCIA = 0.15;  // 15%

// Irradiância solar
IRRADIANCIA_DIRETA = 800;    // Irradiância direta em W/m²
IRRADIANCIA_DIFUSA = 200;    // Irradiância difusa em W/m²

// Albedo do solo (reflexividade)
ALBEDO = 0.2;  // Superfície de concreto tem albedo ~0.2

// Eficiência do sistema (considerando perdas nos componentes)
EFICIENCIA_SISTEMA = 0.90; // 90%

// Condições ambientais
TEMPERATURA_AMBIENTE = 35;    // Temperatura ambiente em °C
COEFICIENTE_TEMPERATURA = -0.005; // -0.5% por °C

// Degradação do painel ao longo do tempo
TAXA_DEGRAUACAO = 0.005; // 0.5% por ano
IDADE_PAINEIS = 5;        // Idade dos painéis em anos

// Fator de manutenção (sujeira e limpeza)
FATOR_MANUTENCAO = 0.95; // 5% de perda devido à sujeira

// Ângulo do sol constante (em graus)
ANGULO_SOL = 35;

// Correção do ângulo de incidência (em graus)
DELTA = 2;

// =============================
// Inicialização da População
// =============================

POPULACAO = [];
MELHOR_POPULACAO = 0;
MELHOR_CUSTO = -%inf; // Inicializa com valor muito baixo para garantir atualização

// Geração inicial da população com ângulos aleatórios dentro do intervalo
for i = 1:NPOP
    POPULACAO(i) = rand()*(ANGULO_MAX - ANGULO_MIN) + ANGULO_MIN;
end

// Vetor para armazenar o melhor custo por época (opcional para visualização)
MELHORES_CUSTOS = [];

// =============================
// Iterações do Algoritmo Genético
// =============================

for EPOCA = 1:1000
    CUSTO = []; // Vetor de fitness (produção de energia)
    
    // Cálculo do fitness para cada indivíduo na população
    for i = 1:NPOP
        ANGULO_INCLINACAO = POPULACAO(i);
        
        // Calcular o ângulo de incidência relativo
        ANGULO_INC = ANGULO_INCLINACAO - ANGULO_SOL;
        if ANGULO_INC < 0 then
            ANGULO_INC = -ANGULO_INC;
        end
        if ANGULO_INC > 90 then
            ANGULO_INC = 90;
        end
        
        // Aplicar a correção no ângulo de incidência
        ANGULO_INC_CORRIGIDO = ANGULO_INC + DELTA;
        if ANGULO_INC_CORRIGIDO < 0 then
            ANGULO_INC_CORRIGIDO = -ANGULO_INC_CORRIGIDO;
        end
        if ANGULO_INC_CORRIGIDO > 90 then
            ANGULO_INC_CORRIGIDO = 90;
        end
        
        // Converter o ângulo de incidência para radianos
        ANGULO_INC_RAD = ANGULO_INC_CORRIGIDO * %pi / 180;
        
        // Calcular a eficiência ajustada com base na temperatura e degradação
        EFICIENCIA_AJUSTADA = EFICIENCIA * (1 + COEFICIENTE_TEMPERATURA * (TEMPERATURA_AMBIENTE - 25)) * (1 - TAXA_DEGRAUACAO * IDADE_PAINEIS);
        
        // Ajustar a irradiância considerando a manutenção
        IRRADIANCIA_DIRETA_AJUSTADA = IRRADIANCIA_DIRETA * FATOR_MANUTENCAO;
        IRRADIANCIA_DIFUSA_AJUSTADA = IRRADIANCIA_DIFUSA * FATOR_MANUTENCAO;
        
        // Cálculo da energia produzida
        ENERGIA_DIRETA = IRRADIANCIA_DIRETA_AJUSTADA * cos(ANGULO_INC_RAD);
        ENERGIA_DIFUSA = IRRADIANCIA_DIFUSA_AJUSTADA * (1 + cos(ANGULO_INCLINACAO * %pi / 180)) / 2;
        ENERGIA_REFLETIDA = IRRADIANCIA_DIRETA_AJUSTADA * ALBEDO * cos(ANGULO_INC_RAD);
        
        // Energia total produzida pelo painel
        ENERGIA_TOTAL = (ENERGIA_DIRETA + ENERGIA_DIFUSA + ENERGIA_REFLETIDA) * EFICIENCIA_AJUSTADA * EFICIENCIA_SISTEMA;
        
        // Garantir que a energia não seja negativa
        if ENERGIA_TOTAL < 0 then
            ENERGIA_TOTAL = 0;
        end
        
        // Armazenar o fitness
        CUSTO(i) = ENERGIA_TOTAL;
    end
    
    // Atualização do melhor indivíduo encontrado na época
    for i = 1:NPOP
        if CUSTO(i) > MELHOR_CUSTO then
            MELHOR_POPULACAO = POPULACAO(i);
            MELHOR_CUSTO = CUSTO(i);
            disp("Época " + string(EPOCA) + ": Melhor Ângulo = " + string(MELHOR_POPULACAO) + "°, Energia = " + string(MELHOR_CUSTO) + " W/m²");
        end
    end
    
    // Armazenar o melhor custo para visualização (opcional)
    MELHORES_CUSTOS(EPOCA) = MELHOR_CUSTO;
    
    // =============================
    // Seleção por Torneio
    // =============================
    
    NOVA_POPULACAO_X = [];
    for i = 1:NPOP
        T1 = 0;
        T2 = 0;
        // Selecionar dois indivíduos aleatórios para o torneio
        while T1 == T2
            T1 = round(rand()*(NPOP - 1)) + 1;
            T2 = round(rand()*(NPOP - 1)) + 1;
        end
        // Selecionar o indivíduo com maior produção de energia
        if CUSTO(T1) > CUSTO(T2) then
            NOVA_POPULACAO_X(i) = POPULACAO(T1);
        else
            NOVA_POPULACAO_X(i) = POPULACAO(T2);
        end
    end
    
    NOVA_POPULACAO_Y = [];
    for i = 1:NPOP
        T1 = 0;
        T2 = 0;
        // Selecionar dois indivíduos aleatórios para o torneio
        while T1 == T2
            T1 = round(rand()*(NPOP - 1)) + 1;
            T2 = round(rand()*(NPOP - 1)) + 1;
        end
        // Selecionar o indivíduo com maior produção de energia
        if CUSTO(T1) > CUSTO(T2) then
            NOVA_POPULACAO_Y(i) = POPULACAO(T1);
        else
            NOVA_POPULACAO_Y(i) = POPULACAO(T2);
        end
    end
    
    // =============================
    // Crossover (Média Geométrica)
    // =============================
    
    NOVA_POPULACAO = [];
    for i = 1:NPOP
        NOVA_POPULACAO(i) = sqrt(NOVA_POPULACAO_Y(i) * NOVA_POPULACAO_X(i));
    end
    
    // =============================
    // Mutação (30% de chance)
    // =============================
    
    for i = 1:NPOP
        if rand() >= 0.7 then
            NOVA_POPULACAO(i) = rand()*(ANGULO_MAX - ANGULO_MIN) + ANGULO_MIN;
        end
    end
    
    // =============================
    // Atualização da População
    // =============================
    
    POPULACAO = NOVA_POPULACAO;
    POPULACAO(1) = MELHOR_POPULACAO; // Preservar o melhor indivíduo
end

// =============================
// Resultado Final
// =============================

disp("-------------------------------------------------");
disp("Ângulo de Inclinação Ótimo: " + string(MELHOR_POPULACAO) + " graus");
disp("Produção de Energia Máxima: " + string(MELHOR_CUSTO) + " W/m²");

// =============================
// Visualização da Evolução da Produção de Energia
// =============================

// Plotar a evolução da produção de energia
x = 1:1000;
y = MELHORES_CUSTOS;
plot(x, y);
xlabel("Época");
ylabel("Produção de Energia (W/m²)");
title("Evolução da Produção de Energia ao Longo das Épocas");
```

---

## README.md

```markdown
# Otimização do Ângulo de Inclinação de Painéis Solares com Algoritmo Genético

## Introdução

Este projeto utiliza um **Algoritmo Genético** para determinar o **ângulo de inclinação ideal** de painéis solares, visando maximizar a produção de energia. O algoritmo considera diversos fatores que influenciam a eficiência dos painéis solares, proporcionando uma solução mais precisa e realista.

## Fundamentação Matemática

### Produção de Energia de Painéis Solares

A produção de energia (`Energia`) de um painel solar depende de vários fatores, incluindo:

1. **Irradiância Solar**: A quantidade de energia solar que atinge a superfície do painel, dividida em:
   - **Irradiância Direta (`I_direta`)**: Luz solar direta.
   - **Irradiância Difusa (`I_difusa`)**: Luz solar espalhada pela atmosfera.

2. **Ângulo de Incidência (`θ_inc`)**: Diferença entre o ângulo de inclinação do painel (`θ_inclinação`) e o ângulo do sol (`θ_sol`).

3. **Eficiência do Painel (`η`)**: Proporção da energia solar convertida em energia elétrica.

4. **Eficiência do Sistema (`η_sistema`)**: Considera perdas em componentes como inversores e cabos.

5. **Albedo (`α`)**: Refletividade do solo ou superfícies próximas, que pode refletir luz adicional para os painéis.

6. **Temperatura Ambiente (`T`)**: A eficiência do painel diminui com o aumento da temperatura.

7. **Degradação (`δ`)**: Redução da eficiência do painel ao longo do tempo.

8. **Fator de Manutenção (`FM`)**: Considera perdas de irradiância devido à sujeira e manutenção.

### Fórmula da Produção de Energia

A produção total de energia (`Energia_total`) é calculada pela soma das contribuições da irradiância direta, difusa e refletida, ajustadas pela eficiência e eficiência do sistema:

\[
\text{Energia\_total} = (\text{Energia\_direta} + \text{Energia\_difusa} + \text{Energia\_refletida}) \times \eta_{\text{ajustada}} \times \eta_{\text{sistema}}
\]

Onde:

\[
\eta_{\text{ajustada}} = \eta \times (1 + \text{Coeficiente\_Temperatura} \times (T - 25)) \times (1 - \delta \times \text{Idade\_Painéis})
\]

\[
\text{Energia\_direta} = I_{\text{direta\_ajustada}} \times \cos(\theta_{\text{inc\_rad}})
\]

\[
\text{Energia\_difusa} = I_{\text{difusa\_ajustada}} \times \frac{1 + \cos(\theta_{\text{inclinação}} \times \pi / 180)}{2}
\]

\[
\text{Energia\_refletida} = I_{\text{direta\_ajustada}} \times \alpha \times \cos(\theta_{\text{inc\_rad}})
\]

## Estrutura do Código

### Variáveis Principais

- **NPOP**: Tamanho da população no algoritmo genético.
- **ANGULO_MIN**: Ângulo mínimo de inclinação dos painéis solares (em graus).
- **ANGULO_MAX**: Ângulo máximo de inclinação dos painéis solares (em graus).
- **EFICIENCIA**: Eficiência inicial do painel solar.
- **IRRADIANCIA_DIRETA**: Irradiância solar direta (W/m²).
- **IRRADIANCIA_DIFUSA**: Irradiância solar difusa (W/m²).
- **ALBEDO**: Reflexividade do solo ou superfícies próximas.
- **EFICIENCIA_SISTEMA**: Eficiência global do sistema, considerando perdas.
- **TEMPERATURA_AMBIENTE**: Temperatura ambiente (°C).
- **COEFICIENTE_TEMPERATURA**: Variação da eficiência por grau Celsius.
- **TAXA_DEGRAUACAO**: Taxa de degradação anual da eficiência do painel.
- **IDADE_PAINEIS**: Idade dos painéis solares (anos).
- **FATOR_MANUTENCAO**: Fator que considera perdas devido à sujeira e manutenção.
- **ANGULO_SOL**: Ângulo constante do sol (em graus).
- **DELTA**: Correção do ângulo de incidência (em graus).

### Passo a Passo do Algoritmo

1. **Inicialização da População**:
   - Gera uma população inicial com `NPOP` indivíduos, onde cada indivíduo representa um ângulo de inclinação aleatório entre `ANGULO_MIN` e `ANGULO_MAX`.

2. **Avaliação do Fitness**:
   - Para cada indivíduo, calcula a produção total de energia (`Energia_total`) considerando os fatores mencionados na fundamentação matemática.

3. **Atualização do Melhor Indivíduo**:
   - Identifica e atualiza o melhor indivíduo (ângulo de inclinação) encontrado até o momento com a maior produção de energia.

4. **Seleção por Torneio**:
   - Realiza a seleção de indivíduos para a reprodução através de torneios, onde dois indivíduos são comparados e o de maior fitness é selecionado.

5. **Crossover**:
   - Aplica o operador de crossover utilizando a média geométrica dos pares selecionados para gerar novos indivíduos.

6. **Mutação**:
   - Aplica mutação com uma taxa de 30%, substituindo alguns indivíduos por novos ângulos aleatórios para manter a diversidade genética.

7. **Atualização da População**:
   - Atualiza a população com os novos indivíduos gerados e preserva o melhor indivíduo encontrado.

8. **Repetição**:
   - Repete os passos de avaliação, seleção, crossover e mutação por 1000 épocas.

9. **Resultados**:
   - Exibe o ângulo de inclinação ótimo encontrado e a produção de energia máxima correspondente.
   - Plota a evolução da produção de energia ao longo das épocas.

## Como Executar o Código

1. **Pré-requisitos**:
   - **Scilab** instalado em sua máquina. Você pode baixá-lo em [scilab.org](https://www.scilab.org/download/latest).

2. **Passos para Execução**:
   - Abra o Scilab.
   - Crie um novo arquivo e copie o código fornecido acima para o editor do Scilab.
   - Salve o arquivo com a extensão `.sce`, por exemplo, `otimizacao_painel_solar.sce`.
   - Execute o script pressionando **F5** ou utilizando o comando `exec('otimizacao_painel_solar.sce', -1);` na linha de comando do Scilab.

3. **Interpretação dos Resultados**:
   - **Console**: Durante a execução, o console exibirá o melhor ângulo de inclinação e a produção de energia correspondente em cada época onde um novo melhor foi encontrado.
   - **Gráfico**: Ao final da execução, será exibido um gráfico mostrando a evolução da produção de energia ao longo das 1000 épocas, permitindo visualizar como o algoritmo converge para a solução ótima.

## Ajustes e Melhorias Possíveis

Para aumentar ainda mais a precisão do cálculo da produção de energia, você pode considerar as seguintes melhorias:

1. **Dados Reais de Irradiância**:
   - Utilizar dados históricos ou em tempo real de irradiância solar para ajustar `IRRADIANCIA_DIRETA` e `IRRADIANCIA_DIFUSA`.

2. **Modelagem Astronômica do Ângulo do Sol**:
   - Incorporar cálculos mais precisos da posição do sol com base em data, hora e localização geográfica para determinar `ANGULO_SOL` dinamicamente.

3. **Inclinação Dinâmica e Rastreamento Solar**:
   - Implementar sistemas de rastreamento solar que ajustam o ângulo de inclinação ao longo do dia para maximizar a incidência solar.

4. **Consideração de Sombreamento**:
   - Incluir fatores que considerem sombras de árvores, edifícios ou outros obstáculos que possam reduzir a irradiância no painel.

5. **Eficiência Variável com a Temperatura**:
   - Medir a temperatura real dos painéis e ajustar `EFICIENCIA_AJUSTADA` de forma dinâmica.

6. **Parâmetros Multiobjetivo**:
   - Além de maximizar a produção de energia, otimizar outros objetivos como minimizar custos ou maximizar a vida útil dos painéis.

## Conclusão

Este projeto demonstra como um Algoritmo Genético pode ser eficaz na otimização do ângulo de inclinação de painéis solares, considerando diversos fatores que influenciam a produção de energia. Ao ajustar e aprimorar os parâmetros e modelos utilizados, é possível obter resultados cada vez mais precisos e adaptados às condições reais de operação dos painéis solares.

Se tiver dúvidas ou sugestões, sinta-se à vontade para contribuir!

```

---

## Explicações Adicionais

### Considerações sobre o Código

1. **Eficiência Ajustada (`EFICIENCIA_AJUSTADA`)**:
   - **Temperatura**: A eficiência dos painéis solares diminui com o aumento da temperatura ambiente. O coeficiente de temperatura (`COEFICIENTE_TEMPERATURA`) representa essa variação.
   - **Degradação**: Ao longo do tempo, a eficiência dos painéis solares também diminui devido à degradação física dos materiais.

2. **Irradiância Ajustada**:
   - **Manutenção**: A limpeza dos painéis influencia diretamente na quantidade de luz solar que atinge sua superfície. O fator de manutenção (`FATOR_MANUTENCAO`) ajusta a irradiância para refletir perdas devido à sujeira.

3. **Albedo**:
   - **Reflexividade do Solo**: Superfícies refletivas próximas podem aumentar a irradiância indireta no painel, aumentando a produção de energia.

4. **Correção do Ângulo de Incidência (`DELTA`)**:
   - Pequenas correções podem ser aplicadas para ajustar o ângulo de incidência e refletir possíveis imperfeições na instalação ou na medição dos ângulos.

5. **Preservação do Melhor Indivíduo**:
   - Garantir que o melhor indivíduo encontrado até o momento seja mantido na população evita que o algoritmo perca soluções ótimas durante a evolução.

### Personalização

- **Parâmetros Ambientais**: Ajuste os valores de `IRRADIANCIA_DIRETA`, `IRRADIANCIA_DIFUSA`, `TEMPERATURA_AMBIENTE`, entre outros, de acordo com as condições reais da localização onde os painéis solares estão instalados.
- **Taxas de Mutação e Crossover**: Dependendo da diversidade da população e da rapidez com que o algoritmo converge, você pode ajustar as taxas de mutação e os métodos de crossover para melhorar a performance.
- **Número de Épocas e População**: Para problemas mais complexos ou para obter resultados mais precisos, considere aumentar o número de épocas (`EPOCA`) ou o tamanho da população (`NPOP`), balanceando com o tempo de computação disponível.

### Visualização dos Resultados

O gráfico gerado ao final da execução do código permite visualizar como a produção de energia evolui ao longo das épocas, oferecendo insights sobre a convergência do algoritmo e a eficácia da otimização.

---
