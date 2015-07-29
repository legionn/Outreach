import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Text exposing (fromString)
import String exposing (split)
import List exposing (map, concat)
import Color exposing (..)

main : Element
main = flow down errorFixed




errorFixed = (split "\n" >> map (split "\r") >> concat >> map (\str -> leftAligned (fromString str))) error


error = 