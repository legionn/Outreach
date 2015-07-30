import Signal
import Window
import Graphics.Element exposing (..)
import Color exposing (..)
import Graphics.Collage exposing (..)

main = Signal.map view Window.dimensions

view (w,h) = collage w h [forms]

-- This is where you will put your shapes

forms = group []