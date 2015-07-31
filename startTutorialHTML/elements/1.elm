import Graphics.Collage exposing (..)
import Window
import Signal
import Graphics.Element exposing (..)

main = Signal.map (\(w,h) -> collage w h [(show >> toForm) <| circle 20]) Window.dimensions