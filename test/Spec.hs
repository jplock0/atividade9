import           Control.Monad.State
import           Exercicios
import           Test.Tasty
import           Test.Tasty.HUnit

main :: IO ()
main = do
  defaultMain tests

tests, test01, test02, test03, test04 :: TestTree
tests = (testGroup "Semana 9" [test01, test02, test03, test04])

test01 =
  testGroup
    "Ex01 - runState frisk"
    [ testCase "Loja 20 []" $
      runState frisk (Loja 20 []) @?=
      ( True
      , Loja
          { caixa = 5
          , estoque =
              [ Produto {nome = "Escudo", preco = 5}
              , Produto {nome = "Espada", preco = 10}
              ]
          })
    , testCase "Loja 10 []" $
      runState frisk (Loja 10 []) @?=
      ( False
      , Loja {caixa = 0, estoque = [Produto {nome = "Espada", preco = 10}]})
    , testCase "Loja 4 []" $
      runState frisk (Loja 4 []) @?= (False, Loja {caixa = 4, estoque = []})
    ]

test02 =
  testGroup
    "Ex02 - runState loneWanderer"
    [ testCase "Loja 0 []" $
      runState loneWanderer (Loja 0 []) @?=
      (False, Loja {caixa = 0, estoque = []})
    , testCase "Loja 10 []" $
      runState loneWanderer (Loja 10 []) @?=
      ( False
      , Loja {caixa = 0, estoque = [Produto {nome = "Espada", preco = 10}]})
    , testCase "Loja 100 []" $
      runState loneWanderer (Loja 100 []) @?=
      ( False
      , Loja {caixa = 90, estoque = [Produto {nome = "Espada", preco = 10}]})
    , testCase "Loja 15 [Escudo]" $
      runState loneWanderer (Loja 15 [Produto "Escudo" 15]) @?=
      ( True
      , Loja {caixa = 20, estoque = [Produto {nome = "Espada", preco = 10}]})
    , testCase "Loja 0 [Escudo]" $
      runState loneWanderer (Loja 0 [Produto "Escudo" 15]) @?=
      ( False
      , Loja {caixa = 0, estoque = [Produto {nome = "Escudo", preco = 15}]})
    ]

test03 =
  testGroup
    "Ex03 - runState dragonborn"
    [ testCase "Loja 0 []" $
      runState dragonborn (Loja 0 []) @?= (True, Loja {caixa = 0, estoque = []})
    , testCase "Loja 3 []" $
      runState dragonborn (Loja 3 []) @?=
      (True, Loja {caixa = 0, estoque = [Produto {nome = "Queijo", preco = 3}]})
    , testCase "Loja 30 []" $
      runState dragonborn (Loja 30 []) @?=
      (True, Loja {caixa = 0, estoque = replicate 10 (Produto "Queijo" 3)})
    , testCase "Loja 300 []" $
      runState dragonborn (Loja 300 []) @?=
      (True, Loja {caixa = 0, estoque = replicate 100 (Produto "Queijo" 3)})
    , testCase "Loja 302 []" $
      runState dragonborn (Loja 302 []) @?=
      (True, Loja {caixa = 2, estoque = replicate 100 (Produto "Queijo" 3)})
    , testCase "Loja 3 [Escudo]" $
      runState dragonborn (Loja 14 [Produto "Escudo" 12]) @?=
      ( True
      , Loja
          { caixa = 2
          , estoque =
              [ Produto {nome = "Queijo", preco = 3}
              , Produto {nome = "Queijo", preco = 3}
              , Produto {nome = "Queijo", preco = 3}
              , Produto {nome = "Queijo", preco = 3}
              , Produto {nome = "Escudo", preco = 12}
              ]
          })
    ]

test04 =
  testGroup
    "Ex04 - runState geralt"
    [ testCase "Loja 0 []" $
      runState geralt (Loja 0 []) @?= (False, Loja {caixa = 0, estoque = []})
    , testCase "Loja 15 []" $
      runState geralt (Loja 15 []) @?=
      ( False
      , Loja {caixa = 0, estoque = [Produto {nome = "Espada", preco = 15}]})
    , testCase "Loja 300 []" $
      runState geralt (Loja 300 []) @?=
      (False, Loja {caixa = 150, estoque = replicate 10 (Produto "Espada" 15)})
    , testCase "Loja 85 [Escudo]" $
      runState geralt (Loja 85 [Produto "Escudo" 15]) @?=
      ( False
      , Loja
          { caixa = 10
          , estoque =
              [ Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Escudo", preco = 15}
              ]
          })
    , testCase "Loja 90 [Escudo]" $
      runState geralt (Loja 90 [Produto "Escudo" 15]) @?=
      ( True
      , Loja
          { caixa = 15
          , estoque =
              [ Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              ]
          })
    , testCase "Loja 500 [Escudo]" $
      runState geralt (Loja 500 [Produto "Escudo" 15]) @?=
      ( True
      , Loja
          { caixa = 365
          , estoque =
              [ Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              , Produto {nome = "Espada", preco = 15}
              ]
          })
    ]
