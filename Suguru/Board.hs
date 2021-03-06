module Suguru.Board where

import Suguru.Utils (Matrix, Position, getNeighbors, setAt, getAt)
import Data.Maybe (mapMaybe)

-- ========================================================================== --
--                                    Tipos                                   --
-- ========================================================================== --

-- | Implementação do tabuleiro, como uma matriz de células
type Board = Matrix Cell

-- | Uma célula, com o identificador do bloco e o seu valor
--  "-1" significa valor desconhecido
data Cell = Cell String (Maybe Int) deriving (Eq)

-- Implementa o tipo Show
instance Show Cell where
  show (Cell block Nothing) = show (block ++ "_")
  show (Cell block (Just value)) = show (block ++ show value)

-- ========================================================================== --
--                                   Funções                                  --
-- ========================================================================== --

-- | Gera uma célula a partir de uma string
parseCell :: String -> Cell
parseCell s = cellFromTuple (a, tail b) where (a, b) = span (/= '-') s

-- | Gera uma célula a partir de uma tupla
cellFromTuple :: (String, String) -> Cell
cellFromTuple (block, value)
  | value /= "_" = Cell block (Just (read value :: Int))
  | otherwise = Cell block Nothing

-- | Gera o tabuleiro a partir de uma lista de strings
--  String a string, para cada palavra separada por espaço cria-se uma célula.
boardFromText :: [String] -> Board
boardFromText [] = error "Não foi possível ler o tabuleiro"
boardFromText s = map (\x -> [parseCell c | c <- words x]) s

-- | Retorna verdadeiro se identificador do bloco é igual a string
isBlock :: String -> Cell -> Bool
isBlock query (Cell block _) = block == query

-- | Retorna o bloco (grupo de células) com base em um identificador
getBlock :: Board -> String -> Maybe [Cell]
getBlock m block = case filter (isBlock block) (concat m) of
  [] -> Nothing
  n -> Just n

-- | O valor da célula de entrada
getCellValue :: Cell -> Maybe Int
getCellValue (Cell _ v) = v

-- | O valor dos vizinhos
getNeighborValues :: Board -> Position -> [Int]
getNeighborValues b p = mapMaybe getCellValue (getNeighbors b p)

-- | Escreve no tabuleiro
writeBoard :: Board -> Position -> Maybe Int -> Maybe Board
writeBoard b p v = getBlockFromPos b p >>= (\block -> setAt b p (Cell block v))

-- | Retorna o valor de uma celula com base na sua posicao
getValueFromPos :: Board -> Position -> Maybe Int
getValueFromPos board pos = getAt board pos >>= (\(Cell _ v) -> v)

-- | Retorna string com o bloco de uma celula
getBlockFromPos :: Board -> Position -> Maybe String
getBlockFromPos board pos = getAt board pos >>= (\(Cell b _) -> Just b)