import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


main = Signal.map view Window.dimensions

view (w,h) = collage w h [forms]






-- This is where you add your shapes

forms = group []