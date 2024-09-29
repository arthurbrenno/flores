// Limpar variáveis e console
clear;
clc;

// Carregar dados a partir de um arquivo externo
// O arquivo 'data.csv' deve estar no mesmo diretório do script
data = csvRead('data.csv');

// Separar as variáveis de entrada (x) e saída (y)
x_data = data(:, 1);
y_data = data(:, 2);

// Parâmetros do Algoritmo Genético
npop = 100;    // Tamanho da população
nvars = 2;     // Número de variáveis (parâmetros a serem otimizados: a e b)
rmax = [10, 10];     // Valor máximo para inicialização das variáveis [a_max, b_max]
rmin = [-10, -10];   // Valor mínimo para inicialização das variáveis [a_min, b_min]
geracoes = 1000; // Número de gerações
taxa_mutacao = 0.05; // Taxa de mutação
taxa_crossover = 0.8; // Taxa de crossover
elitismo = %t;  // Flag para usar elitismo

// Função Fitness (Minimização do erro quadrático médio)
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

// Inicialização da População
pop = zeros(npop, nvars);
for i = 1:nvars
    pop(:, i) = rmin(i) + (rmax(i) - rmin(i)) * rand(npop, 1);
end

// Inicialização das Variáveis de Controle
melhor_individuo = [];
melhor_fitness = -%inf;

// Loop Principal do Algoritmo Genético
for geracao = 1:geracoes
    // Avaliação da Função Fitness
    fitness = calcular_fitness(pop, x_data, y_data);
    
    // Seleção por Torneio
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
    
    // Crossover (Recombinação)
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
    
    // Mutação
    for i = 1:npop
        if rand() < taxa_mutacao then
            // Mutar cada gene do indivíduo
            for j = 1:nvars
                nova_pop(i, j) = rmin(j) + (rmax(j) - rmin(j)) * rand();
            end
        end
    end
    
    // Avaliação da Nova População
    fitness_nova_pop = calcular_fitness(nova_pop, x_data, y_data);
    
    // Eletismo: Preservar o Melhor Indivíduo
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
    
    // Atualizar a População
    pop = nova_pop;
    fitness = fitness_nova_pop;
    
    // Exibir informações da geração atual
    if modulo(geracao, 100) == 0 then
        disp("Geração: " + string(geracao) + ", Melhor Fitness (Negativo do MSE): " + string(melhor_fitness));
    end
end

// Exibir o Melhor Resultado
disp("Melhor Individuo Encontrado (a, b):");
disp(melhor_individuo);
disp("Melhor Fitness (Negativo do MSE):");
disp(melhor_fitness);

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