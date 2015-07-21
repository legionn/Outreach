import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Mouse
import Window
import Text exposing (..)
main = Signal.map2 layout Mouse.position Window.dimensions 
layout (x, y) (width, height) = 
     let (xCentered, yCentered) = 
     (toFloat x - toFloat width/2, toFloat height/2 - toFloat y)
     in collage width height
                [ eye |> move (xCentered,yCentered)
                , text <| bold <| fromString 
                       <| "Window Dimensions: " ++ (toString (width, height))
                , (text <| bold <| fromString <| "Mouse Position: " ++ (toString (x,y))) 
                  |> move (0,-20) 
                ]
eye = group [ (filled darkBrown (circle 13))  
            , (filled black (circle 10)) 
            , move (-4,4) (filled white (circle 3)) 
            ]
stopX (x,y)  = (if | x > 100    -> 100
                   | otherwise -> x       
               , y)
stopY (x,y)  = (x,
               if | y < -200    -> -200
                  | otherwise -> y
               )
broccoli (x,y)  = (if | x > 100   -> 100
                      | x < -100    -> -100
                      | otherwise -> x
                   , y)
doubleSpeedX (x,y) = (2*x, y)
distance (x1,y1) (x2,y2) = sqrt((x1 - x2)^2 + (y1 - y2)^2)
