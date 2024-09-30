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

## Referências

ANDREWS, R. W.; PEARCE, J. M. The Effect of Spectral Albedo on Amorphous Silicon and Crystalline Silicon Solar Photovoltaic Device Performance. *Solar Energy*, v. 91, p. 233-241, 2013.

DUFFIE, J. A.; BECKMAN, W. A. *Solar Engineering of Thermal Processes*. 4th ed. Hoboken: John Wiley & Sons, 2013.

GILMAN, P.; DOUGLAS, S.; JAMES, T. *Modeling Solar Power Plant Performance for Weather Conditions*. Golden: National Renewable Energy Laboratory (NREL), 2018.

LUNA, J. A.; SILVA, R. N.; FIGUEIRA, M. R. Análise de Sistemas Fotovoltaicos: Eficiência e Perdas. *Revista Brasileira de Energias Renováveis*, v. 9, n. 1, p. 45-58, 2021.

MA, T.; YANG, H.; LU, L. Feasibility Study and Economic Analysis of Solar Photovoltaic Systems in Hong Kong. *Energy*, v. 52, p. 181-187, 2013.

TIBERIO, E. R. Análise de Eficiência de Painéis Solares com Algoritmos Genéticos. *Journal of Energy Studies*, v. 33, n. 2, p. 102-115, 2019.

## Conclusão

Este projeto demonstra como um Algoritmo Genético pode ser eficaz na otimização do ângulo de inclinação de painéis solares, considerando diversos fatores que influenciam a produção de energia. Ao ajustar e aprimorar os parâmetros e modelos utilizados, é possível obter resultados cada vez mais precisos e adaptados às condições reais de operação dos painéis solares.

Se tiver dúvidas ou sugestões, sinta-se à vontade para contribuir!
