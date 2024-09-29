clear;
clc;

// Parâmetros do problema
npop = 1000;            // Tamanho da população
rmin = 15;              // Ângulo mínimo de inclinação (graus)
rmax = 60;              // Ângulo máximo de inclinação (graus)
eta = 0.15;             // Eficiência do painel (15%)
I = 1000;               // Irradiância solar constante (W/m²)
angulo_sol = 35;        // Ângulo do sol constante (graus)

// Inicialização da população
pop = [];
bestpop = 0;
bestcusto = -%inf; // Inicializa com valor muito baixo para garantir atualização

for i = 1:npop
    pop(i) = rand()*(rmax - rmin) + rmin;
end

// Iterações do algoritmo genético
for epoca = 1:1000
    custo = []; // Vetor de fitness (produção de energia)
    
    // Cálculo do fitness para cada indivíduo
    for i = 1:npop
        angle_inclinacao = pop(i);
        // Calcular o ângulo de incidência relativo
        angulo_inc = angle_inclinacao - angulo_sol;
        
        // Garantir que o ângulo de incidência esteja entre 0° e 90°
        if angulo_inc < 0 then
            angulo_inc = -angulo_inc;
        end
        if angulo_inc > 90 then
            angulo_inc = 90;
        end
        
        // Converter para radianos
        angulo_inc_rad = angulo_inc * %pi / 180;
        
        // Cálculo da energia produzida
        Energy = I * cos(angulo_inc_rad) * eta;
        
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