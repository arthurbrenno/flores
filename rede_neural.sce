// Limpar variáveis e console
clear;
clc;

// Carregar dados a partir de um arquivo externo
// O arquivo 'dados.csv' deve estar no mesmo diretório do script
// e ter o seguinte formato:
// -1,feature1,feature2,target
dados = csvRead('dados.csv');

// Definição dos parâmetros da rede neural
nnp = 3; // Número de neurônios na camada oculta 1
nns = 3; // Número de neurônios na camada oculta 2
nep = 3; // Número de entradas (incluindo o bias)
nes = nnp + 1; // Número de entradas na camada oculta 2 (incluindo bias)
na = size(dados, 1); // Número de amostras
n = 0.6; // Taxa de aprendizagem

// Inicialização dos pesos para cada camada com valores aleatórios
wp = rand(nep, nnp); // [3x3]
ws = rand(nes, nns); // [4x3]
wo = rand(nns + 1, 1); // [4x1]

// Verificação das dimensões iniciais
disp("Dimensões Iniciais:");
disp("wp: " + string(size(wp))); // Deve mostrar [3, 3]
disp("ws: " + string(size(ws))); // Deve mostrar [4, 3]
disp("wo: " + string(size(wo))); // Deve mostrar [4, 1]

// Treinamento da rede neural
for epoca = 1:100000
    for am = 1:na
        // Extração das entradas e do alvo
        x = dados(am, 1:3); // [1x3] - Inclui o bias
        tg = dados(am, 4); // Alvo
        
        // Camada oculta 1
        y1 = x * wp; // [1x3] * [3x3] = [1x3]
        y1 = 1 ./ (1 + exp(-y1)); // Função sigmoide
        y1d = 1 - y1.^2; // Derivada da função sigmoide
        
        // Camada oculta 2
        y2 = [ -1 y1 ] * ws; // [1x4] * [4x3] = [1x3]
        y2 = 1 ./ (1 + exp(-y2)); // Função sigmoide
        y2d = 1 - y2.^2; // Derivada da função sigmoide
        
        // Camada de saída
        yo = [ -1 y2 ] * wo; // [1x4] * [4x1] = [1x1]
        yo = 1 / (1 + exp(-yo)); // Função sigmoide
        yod = 1 - yo^2; // Derivada da função sigmoide
        
        // Cálculo dos deltas (erros)
        Do = tg - yo; // [1x1]
        Ds = Do * wo(2:nns + 1)'; // [1x1] * [3x1]' = [1x3]
        Dp = Ds * wp'; // [1x3] * [3x3] = [1x3]
        
        // Verificação das dimensões antes da operação .*
        disp("Dimensão de y1d:");
        disp(size(y1d)); // Deve mostrar [1, 3]
        
        disp("Dimensão de Dp:");
        disp(size(Dp)); // Deve mostrar [1, 3]
        
        // Atualização dos pesos
        // Camada de saída
        wod = n * yod * Do * [ -1 y2 ]; // [1x1] * [1x1] * [1x4] = [1x4]
        wo = wo + wod'; // [4x1] + [4x1] = [4x1]
        
        // Camada oculta 2
        wsd = [ -1 y1 ]' * ( n * y2d .* Ds ); // [4x1] * [1x3] = [4x3]
        ws = ws + wsd;
        
        // Camada oculta 1
        wpd = x' * ( n * y1d .* Dp ); // [3x1] * [1x3] = [3x3]
        wp = wp + wpd;
        
        // Exibir a saída atual (opcional)
        // disp(yo);
    end
    
    // (Opcional) Exibir progresso a cada 10000 épocas
    if modulo(epoca, 10000) == 0 then
        disp("Época: " + string(epoca));
    end
end

// Teste da rede neural com os dados de entrada
for am = 1:na
    x = dados(am, 1:3); // [1x3] - Inclui o bias
    tg = dados(am, 4); // Alvo
    
    // Forward pass
    y1 = x * wp; // [1x3] * [3x3] = [1x3]
    y1 = 1 ./ (1 + exp(-y1));
    
    y2 = [ -1 y1 ] * ws; // [1x4] * [4x3] = [1x3]
    y2 = 1 ./ (1 + exp(-y2));
    
    yo = [ -1 y2 ] * wo; // [1x4] * [4x1] = [1x1]
    yo = 1 / (1 + exp(-yo));
    
    // Exibir a saída prevista e o alvo
    printf("Entrada: %d %d, Saída prevista: %.2f, Alvo: %d\n", x(2), x(3), yo, tg);
end
