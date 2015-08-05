import Graphics.Collage exposing (..)
import Window
import Signal
import Graphics.Element exposing (..)
import Color exposing (red)

main = Signal.map (\(w,h) -> collage w h [filled red (circle 20)]) Window.dimensions