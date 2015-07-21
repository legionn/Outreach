import Color exposing (..)
import Graphics.Collage exposing (..)

main = collage 300 300 
       [ (heart) ]

heart = group [ move (0,0) (filled red (ngon 4 50))
                  , move (20,20) (filled red (circle 36))
                  , move (-20,20) (filled red (circle 36))] 
