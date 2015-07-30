import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Window
import Signal


main = Signal.map view Window.dimensions

view (w,h) = collage w h [forms]

-- ADD SHAPES BELOW

forms = group []