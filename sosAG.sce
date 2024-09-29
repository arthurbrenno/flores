clear;
clc;

// Parâmetros do problema
npop = 1000;              // Tamanho da população
rmin = 15;                // Ângulo mínimo de inclinação (graus)
rmax = 60;                // Ângulo máximo de inclinação (graus)
eta = 0.15;               // Eficiência do painel (15%)
I_direct = 800;           // Irradiância direta em W/m²
I_diffuse = 200;          // Irradiância difusa em W/m²
albedo = 0.2;             // Reflexividade do solo
system_efficiency = 0.90; // Eficiência do sistema (90%)
temperature = 35;         // Temperatura ambiente em °C
temp_coefficient = -0.005;// -0.5% por °C
degradation_rate = 0.005; // 0.5% por ano
age = 5;                  // Idade do painel em anos
maintenance_factor = 0.95;// 5% de perda devido à sujeira
theta_sun = 35;           // Ângulo do sol constante (graus)
delta = 2;                // Correção do ângulo de incidência (graus)

// Inicialização da população
pop = [];
bestpop = 0;
bestcusto = -%inf; // Inicializa com valor muito baixo para garantir atualização

for i = 1:npop
    pop(i) = rand()*(rmax - rmin) + rmin;
end

// Inicializar vetor para armazenar o melhor custo por época (opcional para visualização)
melhores_custos = [];

// Iterações do algoritmo genético
for epoca = 1:1000
    custo = []; // Vetor de fitness (produção de energia)
    
    // Cálculo do fitness para cada indivíduo
    for i = 1:npop
        angle_inclinacao = pop(i);
        
        // Calcular o ângulo de incidência relativo e corrigido
        angulo_inc = angle_inclinacao - theta_sun;
        if angulo_inc < 0 then
            angulo_inc = -angulo_inc;
        end
        if angulo_inc > 90 then
            angulo_inc = 90;
        end
        angulo_inc_corrigido = angulo_inc + delta;
        if angulo_inc_corrigido < 0 then
            angulo_inc_corrigido = -angulo_inc_corrigido;
        end
        if angulo_inc_corrigido > 90 then
            angulo_inc_corrigido = 90;
        end
        
        // Converter para radianos
        angulo_inc_rad = angulo_inc_corrigido * %pi / 180;
        
        // Calcular a eficiência ajustada com temperatura e degradação
        eta_ajustada = eta * (1 + temp_coefficient * (temperature - 25)) * (1 - degradation_rate * age);
        
        // Calcular a irradiância ajustada com manutenção
        I_direct_ajustado = I_direct * maintenance_factor;
        I_diffuse_ajustado = I_diffuse * maintenance_factor;
        
        // Cálculo da energia produzida
        Energy_direct = I_direct_ajustado * cos(angulo_inc_rad);
        Energy_diffuse = I_diffuse_ajustado * (1 + cos(angle_inclinacao * %pi / 180)) / 2;
        Energy_reflected = I_direct_ajustado * albedo * cos(angulo_inc_rad);
        Energy = (Energy_direct + Energy_diffuse + Energy_reflected) * eta_ajustada * system_efficiency;
        
        // Garantir que a energia não seja negativa
        if Energy < 0 then
            Energy = 0;
        end
        
        custo(i) = Energy;
    end
    
    // Atualização do melhor indivíduo encontrado
    for i = 1:npop
        if custo(i) > bestcusto then
            bestpop = pop(i);
            bestcusto = custo(i);
            disp("Época " + string(epoca) + ": Melhor Ângulo = " + string(bestpop) + "°, Energia = " + string(bestcusto) + " W/m²");
        end
    end
    
    // Armazenar o melhor custo para visualização (opcional)
    melhores_custos(epoca) = bestcusto;
    
    // Seleção por Torneio
    newpopx = [];
    for i = 1:npop
        t1 = 0;
        t2 = 0;
        while t1 == t2
            t1 = round(rand()*(npop - 1)) + 1;
            t2 = round(rand()*(npop - 1)) + 1;     
        end
        if custo(t1) > custo(t2) then
            newpopx(i) = pop(t1);
        else
            newpopx(i) = pop(t2); 
        end 
    end
    
    newpopy = [];
    for i = 1:npop
        t1 = 0;
        t2 = 0;
        while t1 == t2
            t1 = round(rand()*(npop - 1)) + 1;
            t2 = round(rand()*(npop - 1)) + 1;     
        end
        if custo(t1) > custo(t2) then
            newpopy(i) = pop(t1);
        else
            newpopy(i) = pop(t2); 
        end 
    end
    
    // Crossover (Média Geométrica)
    newpop = [];
    for i = 1:npop
        newpop(i) = sqrt(newpopy(i) * newpopx(i));
    end
    
    // Mutação (30% de chance de mutação)
    for i = 1:npop
        if rand() >= 0.7 then
            newpop(i) = rand()*(rmax - rmin) + rmin;
        end
    end
    
    // Atualização da população e preservação do melhor indivíduo
    pop = newpop;
    pop(1) = bestpop;
end

// Resultado Final
disp("-------------------------------------------------");
disp("Ângulo de Inclinação Ótimo: " + string(bestpop) + " graus");
disp("Produção de Energia Máxima: " + string(bestcusto) + " W/m²");

// Visualização opcional da evolução da produção de energia
// Plotar a evolução da produção de energia
x = 1:1000;
y = melhores_custos;
plot(x, y);
xlabel("Época");
ylabel("Produção de Energia (W/m²)");
title("Evolução da Produção de Energia ao Longo das Épocas");
