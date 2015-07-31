import Graphics.Collage exposing (..)
import Window
import Signal
import Graphics.Element exposing (..)
import Color exposing (red, blue)

main = Signal.map (\(w,h) -> collage w h [filled red (circle 15), filled blue (square 20)]) Window.dimensions