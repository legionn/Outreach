import Graphics.Collage exposing (..)
import Window
import Signal
import Graphics.Element exposing (..)
import Color exposing (red)

main = Signal.map (\(w,h) -> collage w h [move (10, 10) (filled red (square 15))]) Window.dimensions