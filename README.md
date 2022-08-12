# Semana 09

## Conteúdo

| Tópico               | Material de Estudo                                                      | Playlist                                                                 |
| -------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Avaliação Preguiçosa | https://haskell.pesquisa.ufabc.edu.br/haskell/12.laziness    | https://www.youtube.com/playlist?list=PLYItvall0TqJwLa9rY-bT_B9-EmtaiPT0 |
| Haskell Paralelo     | https://haskell.pesquisa.ufabc.edu.br/haskell/13.paralelismo | https://www.youtube.com/playlist?list=PLYItvall0TqJ1jteUbGOHfBycg5NM9thq |

## Exercícios (10 pontos)

**⚠️ A princípio o seu código não irá compilar. Comece escrevendo o _boilerplate_ de todas as instâncias pedidas, mesmo que com `undefined` por enquanto. Lembrando que se o código não compilar em qualquer ponto, a lista inteira será zerada.**

Estamos simulando um sistema de comércio em um RPG, e queremos simular lojas e clientes.

Considere os tipos `Produto` e `Loja`, fornecidos na implementação. Um `Produto` contém apenas um `nome` e um `preco`, enquanto uma `Loja` possui o seu `estoque` (uma lista de `Produto`s) e um `caixa`, representando quanto dinheiro aquela loja tem.

Considere ainda as funções `comprar` e `vender`:

`comprar` representa o interesse de um cliente comprar um `Produto`. A função recebe o nome do produto que o cliente deseja, e retorna a ação da loja.
- Se o `Produto` estiver em estoque: removemos o produto do `estoque`, aumentamos o `caixa` da loja, e entregamos o produto para o cliente no formato `Just Produto`
- Caso contrário: a loja fica intacta, e retornamos `Nothing`

`vender` representa o interesse de um cliente em vender um `Produto`. Recebemos o nome do produto e o valor que o cliente quer por ele.
- Se a loja tiver dinheiro o suficiente para pagar pelo produto: ele é adicionado ao estoque, descontamos o dinheiro do caixa e "entregamos" o dinheiro ao cliente (representado por retornar o `Int` com o valor que ele pediu)
- Caso contrário, a loja fica intacta, e retornamos `0` (representando o número de moedas que entregamos ao cliente)

Usando a Monad `State`, queremos especificar o comportamento de vários clientes, e retornar se saiu satisfeito da loja ou não, potencialmente modificando a `Loja`.
Em outras palavras, `type Cliente = State Loja Bool`.
Por exemplo, suponha que temos um cliente que quer simplesmente vender uma espada por 10 moedas:

```hs
vendeEspada :: Cliente
vendeEspada = do
    valorVendido <- vender "Espada" 10
    return $ valorVendido > 0
```

Ou um cliente que tenta comprar um escudo

```hs
compraEscudo :: Cliente
compraEscudo = do
    maybeProduto <- comprar "Escudo"
    return $ isJust maybeProduto
```
Poderíamos simular esses clientes com:

```hs
> runState vendeEspada (Loja 100 [Produto "Escudo" 15])
(True,Loja {caixa = 90, estoque = [Produto {nome = "Espada", preco = 15},Produto {nome = "Escudo", preco = 15}]})
-- cliente satisfeito, o produto entrou em estoque, e a loja reduziu seu caixa em 10 moedas

> runState compraEscudo (Loja 100 [Produto "Escudo" 15])
(True,Loja {caixa = 115, estoque = []}) 
-- cliente satisfeito, o produto saiu do estoque, e a loja aumentou seu caixa em 15 moedas

> runState vendeEspada (Loja 5 [Produto "Escudo" 15])
(False,Loja {caixa = 5, estoque = [Produto {nome = "Escudo", preco = 15}]})
-- cliente insatisfeito, pois a loja não tinha dinheiro para comprar a espada

> runState compraEscudo (Loja 100 [Produto "Arco" 10])
(False,Loja {caixa = 100, estoque = [Produto {nome = "Arco", preco = 10}]})
-- cliente insatisfeito, pois a loja não vendia escudos
```

Vamos a um exemplo um pouco mais complexo. Considere o cliente `shepard`, que tenta vender uma `"Espada"` por 10 moedas e um `"Escudo"` por 5, e sai satisfeito se vender qualquer um dos dois. 
Note que, mesmo que ele não consiga vender a Espada, ele ainda deve tentar vender o escudo. Poderíamos implementá-lo assim:

```hs
-- I'm Commander Shepard, and This Is My Favorite Store on the Citadel
shepard :: Cliente
shepard = do
  valorEspada <- vender "Espada" 10
  valorEscudo <- vender "Escudo" 5
  return $ valorEspada + valorEscudo > 0

> runState shepard (Loja 20 [])
(True,Loja {caixa = 0, estoque = [Produto {nome = "Escudo", preco = 10},Produto {nome = "Espada", preco = 10}]})

> runState shepard (Loja 10 [])
(True,Loja {caixa = 0, estoque = [Produto {nome = "Espada", preco = 10}]})

> runState shepard (Loja 4 [])
(False,Loja {caixa = 4, estoque = []})
```

1. Implemente o cliente `frisk` que tenta vender uma `"Espada"` por 10 moedas e um `"Escudo"` por 5, e só sai satisfeito se vender os dois. Note que, mesmo que ele não consiga vender a Espada, ele ainda deve tentar vender o escudo (mesmo que isso signifique que isso não mude se ele sairá insatisfeito)
2. Implemente o cliente `loneWanderer` que tenta vender uma `"Espada"` por 10 moedas. Se for bem sucedido, tenta comprar um `"Escudo"`. Ele sai satisfeito se conseguir sair de lá com o Escudo.
3. Implemente o cliente `dragonborn` que tenta vender o máximo de `"Queijo"`s que conseguir, por 3 moedas cada. Ele sairá satisfeito de qualquer forma, independente de quantos queijos vender.
4. Implemente o cliente `geralt` que tenta vender 10 `"Espada"`s por 15 moedas cada. Se ele conseguir vender ao menos 6 espadas, ele deve tentar comprar um `"Escudo"`. Ele sai satisfeito se conseguir sair de lá com o Escudo.
# Orientações


> **🧙 It's dangerous to go alone! Take this.**
> 
> Para outros exemplos, consulte também os *parsers* fornecidos na biblioteca

- Se o código não compilar em qualquer ponto, a lista inteira será zerada. Substitua exercícios incompletos por `undefined` antes de submeter.
- ☢️ **Não altere** sob hipótese alguma o `Spec.hs` ou o `Eval.hs`, nem faça uso de bibliotecas externas. Esses arquivos, bem como todos os `.yaml` e `.cabal`, serão substituídos pelos originais na correção.
