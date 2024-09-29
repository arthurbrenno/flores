// Otimização do Ângulo de Inclinação de Painéis Solares utilizando Algoritmo Genético
// Autor: [Seu Nome]
// Data: [Data Atual]

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
