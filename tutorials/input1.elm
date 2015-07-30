import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

forms = group
    [--Background
    circle 5000
        |> filled yellow
    --Mouth
    , circle 160
        |> filled black 
        |> move (0,100)
    , circle 152
        |> filled mouthred 
        |> move (0,100)   
    , rect 70 80
        |> filled black
        |> move (40,20)
        |> rotate (degrees 10)
    , rect 60 70
        |> filled white
        |> move (40,20)
        |> rotate (degrees 10)
    , rect 70 80
        |> filled black
        |> move (-50,20)
        |> rotate (degrees -10)
    , rect 60 70
        |> filled white
        |> move (-50,20)
        |> rotate (degrees -10)
    , oval 320 100
        |> filled black
        |> move (0, 90)
    , oval 320 100
        |> filled yellow
        |> move (0, 100)
    , rect 700 400
        |> filled yellow
        |> move (0,280)
        
    --Eye Right
    , circle 100
        |> filled black
        |> move (100,200)
    , circle 95
        |> filled white
        |> move (100,200)
    , circle 53
        |> filled black
        |> move (85,200)
    , circle 50
        |> filled lightblue
        |> move (85,200)
    , circle 35
        |> filled black
        |> move (85,200)
    --Eye Left
    , circle 100
        |> filled black
        |> move (-100,200)
    , circle 95
        |> filled white
        |> move (-100,200)
    , circle 53
        |> filled black
        |> move (-85,200)
    , circle 50
        |> filled lightblue
        |> move (-85,200)
    , circle 35
        |> filled black
        |> move (-85,200)    
    --Cheek Right
    , circle 40
        |> filled red
        |> move (170,120)
    , circle 35
        |> filled yellow
        |> move (170,120)
    , circle 25
        |> filled yellow
        |> move (160,100)
    , rect 7 45
         |> filled black
         |> move (160,70)
         |> rotate (degrees 45)
    , circle 5
         |> filled red
         |> move (160,140)
    , circle 5
         |> filled red
         |> move (160,115)
    , circle 5
         |> filled red
         |> move (185,125)
    --Cheek Left
    , circle 40
        |> filled red
        |> move (-170,120)
    , circle 35
        |> filled yellow
        |> move (-170,120)
    , circle 25
        |> filled yellow
        |> move (-160,100)
    , rect 7 45
         |> filled black
         |> move (-160,70)
         |> rotate (degrees -45)
    , circle 5
         |> filled red
         |> move (-160,140)
    , circle 5
         |> filled red
         |> move (-160,115)
    , circle 5
         |> filled red
         |> move (-185,125)  
    --Nose
    , oval 70 100
        |> filled black
        |> move (0,120)
    , oval 60 100
        |> filled yellow
        |> move (0,115)
    --Sponge
    , circle 50
        |> filled sponge
        |> move (300, 360)
    , circle 50
        |> filled sponge
        |> move (-270, 270)
    , circle 80
        |> filled sponge
        |> move (280,-30)
    , circle 40
        |> filled sponge
        |> move (-280,30)
    , circle 50
        |> filled sponge
        |> move (-150,-200)
    , circle 20
        |> filled sponge
        |> move (150,-200)]
        
lightblue : Color
lightblue = 
  rgba 0 204 255 1

clearGrey : Color
clearGrey =
  rgba 111 111 111 0.6

mouthred : Color
mouthred = 
  rgba 143 0 0 1

sponge : Color
sponge = 
  rgba 163 163 0 1

main =
  collage 700 700
    [ forms, testel
    ]
    
testel = filled red (circle 20)