module Exercicios where

import           Control.Monad.State
import           Data.Maybe          (isJust)

data Produto =
  Produto
    { nome  :: String
    , preco :: Int
    }
  deriving (Show, Eq)

data Loja =
  Loja
    { caixa   :: Int
    , estoque :: [Produto]
    }
  deriving (Show, Eq)

vender :: String -> Int -> State Loja Int
vender nomeProduto valor = state realizaVenda
  where
    realizaVenda :: Loja -> (Int, Loja)
    realizaVenda lj
      | valor <= caixa lj =
        ( valor
        , Loja (caixa lj - valor) ((Produto nomeProduto valor) : estoque lj))
      | otherwise = (0, lj)

comprar :: String -> State Loja (Maybe Produto)
comprar nomeProduto = state realizaCompra
  where
    realizaCompra :: Loja -> (Maybe Produto, Loja)
    realizaCompra lj =
      case findAndRemoveProduto $ estoque lj of
        Nothing -> (Nothing, lj)
        Just (p, novoEstoque) -> (Just p, Loja novoCaixa novoEstoque)
          where novoCaixa = caixa lj + preco p
    findAndRemoveProduto :: [Produto] -> Maybe (Produto, [Produto])
    findAndRemoveProduto ps = go ps []
      where
        go [] _ = Nothing
        go (x:xs) acc
          | nome x == nomeProduto = Just (x, reverse acc ++ xs)
          | otherwise = go xs (x : acc)

type Cliente = State Loja Bool

vendeEspada :: Cliente
vendeEspada = do
  valorVendido <- vender "Espada" 10
  return $ valorVendido > 0

compraEscudo :: Cliente
compraEscudo = do
  maybeProduto <- comprar "Escudo"
  return $ isJust maybeProduto

-- I'm Commander Shepard, and This Is My Favorite Store on the Citadel
shepard :: Cliente
shepard = do
  valorEspada <- vender "Espada" 10
  valorEscudo <- vender "Escudo" 5
  return $ valorEspada + valorEscudo > 0

-- TODO:
frisk :: Cliente
frisk = undefined

loneWanderer :: Cliente
loneWanderer = undefined

dragonborn :: Cliente
dragonborn = undefined

geralt :: Cliente
geralt = undefined
