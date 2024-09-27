## Explicação do Código e do Modelo Utilizado

### Introdução

Este projeto implementa uma rede neural artificial multicamadas (Multilayer Perceptron - MLP) em Scilab para resolver um problema de classificação binária. O objetivo é treinar a rede para classificar corretamente entradas com base em dados relacionados a sistemas de informação, especificamente detecção de emails de phishing.

### Dados Utilizados

Os dados representam características de emails e se eles são phishing ou não:

- **Feature 1 (Possui Anexo):** Indica se o email possui um anexo (0 para não, 1 para sim).
- **Feature 2 (Clicou em Link):** Indica se o usuário clicou em um link no email (0 para não, 1 para sim).
- **Alvo (Email Phishing):** Indica se o email é phishing (0 para não, 1 para sim).

O conjunto de dados (`dados.csv`) é o seguinte:

```
-1,0,0,0
-1,0,1,1
-1,1,0,1
-1,1,1,0
```

O `-1` é utilizado como termo de bias na rede neural.

### Estrutura da Rede Neural

A rede neural implementada possui:

- **Camada de Entrada:** 2 neurônios correspondentes às duas features.
- **Camada Oculta 1:** 3 neurônios.
- **Camada Oculta 2:** 3 neurônios.
- **Camada de Saída:** 1 neurônio para a classificação binária.

### Funcionamento do Código

1. **Inicialização:**
   - Limpa as variáveis e o console.
   - Carrega os dados a partir de um arquivo externo (`dados.csv`).
   - Define os parâmetros da rede (número de neurônios, taxa de aprendizagem, etc.).
   - Inicializa os pesos das conexões com valores aleatórios.

2. **Treinamento:**
   - O treinamento ocorre em um loop por um número definido de épocas (100.000).
   - Para cada amostra nos dados:
     - **Forward Pass:**
       - Calcula a ativação dos neurônios na primeira camada oculta utilizando a função sigmoide.
       - Calcula a ativação dos neurônios na segunda camada oculta.
       - Calcula a saída final da rede.
     - **Backward Pass (Backpropagation):**
       - Calcula o erro (delta) na saída.
       - Propaga o erro para trás através das camadas ocultas.
       - Atualiza os pesos das conexões utilizando o gradiente do erro e a taxa de aprendizagem.

3. **Teste:**
   - Após o treinamento, o código testa a rede neural utilizando as mesmas amostras de treinamento.
   - Exibe as entradas, a saída prevista pela rede e o alvo real.

### Baseamento Matemático

- **Função de Ativação:** Utiliza a função sigmoide para introduzir não-linearidade:

  \[
  y = \frac{1}{1 + e^{-x}}
  \]

- **Derivada da Função de Ativação:** Necessária para o cálculo do gradiente durante o backpropagation.

  \[
  y' = y \times (1 - y)
  \]

- **Atualização dos Pesos:** Baseada na regra delta generalizada:

  \[
  w_{\text{novo}} = w_{\text{antigo}} + \eta \times \delta \times x
  \]

  Onde:
  - \( w \) é o peso da conexão.
  - \( \eta \) é a taxa de aprendizagem.
  - \( \delta \) é o erro local.
  - \( x \) é a entrada para o neurônio.

### Comentários sobre o Código

- **Leitura de Dados Externos:** O código foi modificado para ler os dados a partir de um arquivo externo (`dados.csv`) utilizando a função `csvRead`.
- **Manutenção do Estilo Original:** O estilo de codificação original foi mantido, incluindo a estrutura dos loops e a nomenclatura das variáveis.
- **Comentários Adicionados:** Foram adicionados comentários para facilitar o entendimento de cada parte do código.
- **Exibição dos Resultados:** Ao final do treinamento, o código exibe as previsões da rede neural para cada amostra de entrada, comparando com o alvo real.

### Considerações Finais

A rede neural conseguiu aprender a relação não-linear entre as entradas e o alvo, demonstrando a capacidade de MLPs em resolver problemas complexos. A utilização de dados relacionados a sistemas de informação, como a detecção de emails de phishing, exemplifica a aplicação prática de redes neurais nessa área.
