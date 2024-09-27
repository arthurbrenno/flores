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
exec('rede_neural.sce', -1);
```

## Explicação
-1: É uma configuração especial que também executa o script no ambiente atual, mas com algumas diferenças sutis na forma como as variáveis são tratadas. No contexto específico do seu código, -1 é usado para garantir que todas as variáveis definidas no script sejam acessíveis no ambiente atual após a execução.
