# Projeto de Algoritmos em Scilab

Este repositório contém implementações de dois algoritmos fundamentais em Inteligência Artificial e Otimização: **Backpropagation** para redes neurais e **Algoritmo Genético (AG)** para otimização. Cada algoritmo está organizado em seu próprio diretório, contendo o código-fonte, arquivos de dados fictícios e documentação detalhada.

## Estrutura do Diretório

```
├── Redes Neurais e Backpropagation/
│   ├── rede_neural.sce
│   ├── dados.csv
│   └── README.md
│
├── Algoritmos Geneticos/
│   ├── ag.sce
│   ├── data.csv
│   └── README.md
│
└── README.md
```

## Descrição dos Diretórios

### 1. Redes Neurais e Backpropagation

Este diretório contém a implementação do algoritmo de **Backpropagation** para treinar uma rede neural feedforward com duas camadas ocultas.

- **`rede_neural.sce`**: Script Scilab que implementa a rede neural e o algoritmo de treinamento Backpropagation.
- **`dados.csv`**: Arquivo CSV com dados fictícios utilizados para treinar e testar a rede neural.
- **`README.md`**: Este arquivo específico para o diretório Backpropagation, fornecendo uma visão geral e instruções de uso.

### 2. Algoritmos Geneticos

Este diretório contém a implementação de um **Algoritmo Genético (AG)** para otimização de parâmetros em um modelo linear.

- **`ag.sce`**: Script Scilab que implementa o algoritmo genético para otimizar os parâmetros `a` e `b` de uma função linear `y = a * x + b`.
- **`data.csv`**: Arquivo CSV com dados fictícios utilizados pelo algoritmo genético para encontrar os melhores parâmetros.
- **`README.md`**: Este arquivo específico para o diretório AlgoritmoGenetico, fornecendo uma visão geral e instruções de uso.

## Como Utilizar

### Requisitos

- **Scilab**: Certifique-se de ter o Scilab instalado em seu computador. Você pode baixá-lo [aqui](https://www.scilab.org/download/latest).

### Executando o Backpropagation
O script irá treinar a rede neural usando os dados fornecidos em `dados.csv`. Após o treinamento, será exibido o ajuste da rede neural aos dados através de um gráfico e os valores das saídas previstas versus os alvos.

### Executando o Algoritmo Genético
O algoritmo genético irá otimizar os parâmetros `a` e `b` para minimizar o erro quadrático médio (MSE) entre os valores previstos e os valores reais dos dados em `data.csv`. Após a execução, será exibido o melhor conjunto de parâmetros encontrados e um gráfico mostrando o ajuste linear aos dados.

## Documentação

Cada diretório contém documentações detalhadas.

Para uma compreensão completa, recomenda-se ler os arquivos de documentação dentro de cada diretório.

## Contribuições

Contribuições são bem-vindas! Se você deseja melhorar os scripts, adicionar novos algoritmos ou corrigir erros, sinta-se à vontade para abrir uma issue ou enviar um pull request. (Ou até mesmo subir pra master :D)

## Referências

- **Goodfellow, I., Bengio, Y., & Courville, A. (2016).** Deep Learning. MIT Press.
- **Haykin, S. (1999).** Neural Networks: A Comprehensive Foundation. Prentice Hall.
- **Bishop, C. M. (1995).** Neural Networks for Pattern Recognition. Oxford University Press.
- **Holland, J. H. (1992).** Adaptation in Natural and Artificial Systems. MIT Press.

## Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---
