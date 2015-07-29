import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Text exposing (fromString)
import String exposing (split)
import List exposing (map, concat)
import Color exposing (..)

main : Element
main = flow down errorFixed




errorFixed = (split "\n" >> map (split "\r") >> concat >> map (\str -> leftAligned (fromString str))) error


error = """Error in /Users/JB/Desktop/OutreachSite/views/compile/default/input.elm:

Type mismatch between the following types on line 10, column 3 to 13:

        Signal.Signal a

        Graphics.Element.Element

    It is related to the following expression:

        Signal.map


"""