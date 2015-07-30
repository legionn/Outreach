import Signal
import Window
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)

main = Signal.map view Window.dimensions

view (w,h) = collage w h [filled red <| circle 20]