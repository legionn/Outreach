--------------------------------- IMPORTS -------------------------------------------
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Graphics.Input exposing (..)
import Time exposing (..)
import Signal exposing (..)
import Text exposing (..)
import Mouse
import Text exposing (..)

-- Main function (Signals)
main = Signal.map2 view (Signal.foldp step init (input)) (time) 

-- Time incrementer
time = foldp (\add total -> total + 1) 0 (fps 60)

type Update = Click ()

input = Signal.map Click (buttonClick.signal)

buttonClick = Signal.mailbox () 

prettyButton model =
    customButton (Signal.message buttonClick.address ())
        (collage 55 45 [defaultButton model |> scale 0.5 ])
        (collage 55 45 [hoverButton model |> scale 0.5])
        (collage 55 45 [clickButton model |> scale 0.5])
        
type alias Model = {gridState : GridState}
init = {gridState = ToggleOFF}

type GridState = ToggleON | ToggleOFF

clickT : Model -> Model
clickT m = {m | gridState <- click m.gridState}

click state = case state of
                ToggleON -> ToggleOFF
                ToggleOFF -> ToggleON

step mouse m = case mouse of Click x -> clickT m 

-- Animate function (takes time as an argument)
view model t =
  collage 600 500
    [ background
    , if model.gridState == ToggleON then cartesianPlane else blankForm
    , timeBox |> move (163,-165)
    , timer t |> move (130,-175)
    , timer2 t |> move (200,-175)
    , hive |> move (170,155) |> scale 1.6
    , mainTree
    , smallTree |> scale 1.1 |> move (-80,-192)
    , flower |> scale 1.7 |> move (-120,-200)
    , bee t |> move (pathMaker t)
    , buttonBox |> move (-255,215)
    , toForm (prettyButton model) |> move (-255,215)
    ]

-- Drawings (All the shapes are made here)--------------------------------------------
blankForm = filled red (circle 0)
buttonBox = group [filled black (rect 75 60), filled lightOrange (rect 73 58)]
timeBox = group [filled black (rect 150 140), filled lightOrange (rect 148 138)
                , text (bold (fromString "Ellapsed Time")) |> move (0,50) |> scale 1.3
                , text (bold (fromString "Seconds")) |> move (0,-50) |> scale 1.2]
timer t = group [clockShape, (text (bold (fromString (toString (floor (t/100)))))) |> scale 1.5 |> move (0,2)]
timer2 t = group [clockShape2, (text (bold (fromString (toString (t))))) |> scale 1.5 |> move (0,2)]

clockShape = group [ filled black (circle 30) 
    , filled yellow (circle 29)
    , filled black (circle 26)
    , filled (rgb 236 207 255) (circle 25)
    , filled black (rect 3 4) |> move (-13,28) |> rotate (degrees 25)
    , filled yellow (rect 2 3) |> move (-13,28) |> rotate (degrees 25)
    , filled black (oval 10 5) |> move (-14,31) |> rotate (degrees 25)
    , filled yellow (oval 8 3) |> move (-14,31) |> rotate (degrees 25)
    , filled black (rect 3 4) |> move (13,28) |> rotate (degrees -25)
    , filled yellow (rect 2 3) |> move (13,28) |> rotate (degrees -25)
    , filled black (oval 10 5) |> move (14,31) |> rotate (degrees -25)
    , filled yellow (oval 8 3) |> move (14,31) |> rotate (degrees -25)
    , filled black (rect 8 7) |> move (0,32)
    , filled yellow (rect 6 5) |> move (0,32)
    , filled black (oval 15 6) |> move (0,36)
    , filled yellow (oval 13 4) |> move (0,36)
    ]
clockShape2 = group [ filled black (circle 30) 
    , filled red (circle 29)
    , filled black (circle 26)
    , filled (rgb 236 207 255) (circle 25)
    , filled black (rect 3 4) |> move (-13,28) |> rotate (degrees 25)
    , filled red (rect 2 3) |> move (-13,28) |> rotate (degrees 25)
    , filled black (oval 10 5) |> move (-14,31) |> rotate (degrees 25)
    , filled red (oval 8 3) |> move (-14,31) |> rotate (degrees 25)
    , filled black (rect 3 4) |> move (13,28) |> rotate (degrees -25)
    , filled red (rect 2 3) |> move (13,28) |> rotate (degrees -25)
    , filled black (oval 10 5) |> move (14,31) |> rotate (degrees -25)
    , filled red (oval 8 3) |> move (14,31) |> rotate (degrees -25)
    , filled black (rect 8 7) |> move (0,32)
    , filled red (rect 6 5) |> move (0,32)
    , filled black (oval 15 6) |> move (0,36)
    , filled red (oval 13 4) |> move (0,36)
    ]
bee t = protoBee t |> scale 0.7 
protoBee t = group [ filled black (ngon 3 10) |> move (-37,-2)|> rotate (degrees 75)
            , filled black (rect 1 10) |> move (-5,-22) |> rotate (degrees -25)
            , filled black (rect 1 10) |> move (-8,-23) |> rotate (degrees -29)
            , filled black (rect 1 10) |> move (-17,-22) |> rotate (degrees -35)
            , filled black (rect 1 10) |> move (-20,-23) |> rotate (degrees -41) 
            , (outlined (solid black) (oval 50 30)) |> move (-10,20) |> rotate (degrees (-75 + 20*sin(t/(wingSpeed))))
            , filled wingColor (oval 50 30) |> move (-10,20) |> rotate (degrees (-75 + 20*sin(t/(wingSpeed))))
            , filled black (oval 81 46) 
            , filled yellow (oval 80 45)
            , filled black (oval 20 25) |> move (-30,0)
            , filled yellow (oval 20 32) |> move (-26,0)
            , filled black (oval 20 39) |> move (-20,0)
            , filled yellow (oval 20 42) |> move (-15,0)
            , filled black (oval 20 44) |> move (-7,0)
            , filled yellow (oval 20 45) |> move (-2,0)
            , filled black (oval 20 44) |> move (7,0)
            , filled yellow (oval 20 43) |> move (12,0)
            , (outlined (solid black) (oval 50 30)) |> move (-20,20) |> rotate (degrees (-45+ 20*sin(t/(wingSpeed))))
            , filled wingColor (oval 50 30) |> move (-20,20) |> rotate (degrees (-45+ 20*sin(t/(wingSpeed))))
            , filled black (oval 13 20) |> move (25,5) |> rotate (degrees 5)
            , filled white (oval 12 19) |> move (25,5) |> rotate (degrees 5)
            , filled black (oval 8 15) |> move (25,5) |> rotate (degrees 5)
            , filled white (oval 3 5) |> move (26,8) |> rotate (degrees 5)
            , smile |> scale 0.7 |> move (25,5)
            , filled black (rect 1 15) |> move (20,25) |> rotate (degrees -35)
            , filled black (rect 1 15) |> move (17,25) |> rotate (degrees -25)
            , filled black (circle 2) |> move (25,30)
            , filled black (circle 2) |> move (21,32)
            ]
wingColor = rgba 212 197 250 0.9    
    
background = group [ move (0,0) (filled lightBlue (rect 600 500))
                   , move (20,230) (filled yellow (circle 70))
                   , move (0,-250) (filled darkGreen (rect 600 50))
                   , move (-200,-225) (filled darkGreen (oval 1000 100))
                   ]
                   
mainTree = group [ filled black (oval 102 1102) |> move (300,0)
             , filled black (oval 362 21) |> move (200,200) |> rotate (degrees 2)
             , filled darkBrown (oval 100 1100) |> move (300,0)
             , filled black (oval 11 21) |> move (170,190)
             , filled darkBrown (oval 360 20) |> move (200,200) |> rotate (degrees 2)
             , filled darkBrown (oval 10 20) |> move (170,190)
             ]

flower = group [ filled black (rect 1 45)
    , filled black (oval 28.5 10.5) |> move (0,15) |> rotate (degrees 25)
    , filled yellow (oval 28 10) |> move (0,15) |> rotate (degrees 25)
    , filled black (oval 27.5 10.5) |> move (0,15) |> rotate (degrees 65)
    , filled yellow (oval 27 10) |> move (0,15) |> rotate (degrees 65)
    , filled black (oval 27.5 10.5) |> move (0,15) |> rotate (degrees -65)
    , filled yellow (oval 27 10) |> move (0,15) |> rotate (degrees -65)
    , filled black (oval 27.5 10.5) |> move (0,15) |> rotate (degrees -25)
    , filled yellow (oval 27 10) |> move (0,15) |> rotate (degrees -25)
    , filled black (circle 5) |> move (0,15)
    , filled brown (circle 4.7) |> move (0,15)
    ]
   
               
smallTree = group [move (-190,0) (filled darkBrown (rect 40 140))
             , move (-200,90) (filled darkGreen (circle 40)) 
             , move (-160,120) (filled darkGreen (circle 40))
             , move (-200,150) (filled darkGreen (circle 45)) 
             ] 
             
hive = group [ filled black (oval 16 21) |> move (0,-21)
             , filled hiveColor (oval 15 20) |> move (0,-21)
             , filled black (oval 26 21) |> move (0,-18)
             , filled hiveColor (oval 25 20) |> move (0,-18)
             , filled black (oval 36 21) |> move (0,-14)
             , filled hiveColor (oval 35 20) |> move (0,-14)
             , filled black (oval 46 21) |> move (0,-7)
             , filled hiveColor (oval 45 20) |> move (0,-7)
             , filled black (oval 51 21) 
             , filled hiveColor (oval 50 20) 
             , filled black (oval 41 21) |> move (0,7)
             , filled hiveColor (oval 40 20) |> move (0,7)
             , filled black (oval 31 16) |> move (0,12)
             , filled hiveColor (oval 30 15) |> move (0,12)
             , filled black (oval 8 5) |> move (0,-15)
             ]
hiveColor = rgba 230 146 50 1

smile = group [ move (-5,-20) (filled black (oval 16 5)) |> rotate (degrees -15)
              , move (-5, -19) (filled yellow (oval 16 5)) |> rotate (degrees -15)
              , move (-13,-19) (filled black (rect 1 5)) |> rotate (degrees -30) 
              ]
gridOnText = group [text (bold (fromString "Grid")) |> scale 2 |> move (0,20)
                   , text (bold (fromString "ON")) |> scale 2 |> move (0,-10)]
gridOffText = group [text (bold (fromString "Grid")) |> scale 2 |> move (0,20)
                   , text (bold (fromString "OFF")) |> scale 2 |> move (0,-10)]
defaultButton model = group [ filled (rgb 0 210 0) (rect 100 80)
    , filled (rgb 0 225 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,40) 
    , filled (rgb 0 180 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,-40) |> rotate (degrees 180) 
    , filled (rgb 0 235 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (-50,0) |> rotate (degrees 90) 
    , filled (rgb 0 170 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (50,0) |> rotate (degrees -90) 
    , if model.gridState == ToggleON then gridOnText else gridOffText
    ]
hoverButton model = group [ filled (rgb 0 195 0) (rect 100 80)
    , if model.gridState == ToggleON then gridOnText else gridOffText
    , filled (rgb 0 225 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,40) 
    , filled (rgb 0 180 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,-40) |> rotate (degrees 180) 
    , filled (rgb 0 235 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (-50,0) |> rotate (degrees 90) 
    , filled (rgb 0 170 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (50,0) |> rotate (degrees -90) 
    ]
clickButton model = group [ filled (rgb 0 210 0) (rect 100 80)
    , if model.gridState == ToggleON then gridOnText else gridOffText
    , filled (rgb 0 175 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,40) 
    , filled (rgb 0 230 0) (polygon [(-55,5),(-50,0),(50,0),(55,5)]) |> move (0,-40) |> rotate (degrees 180) 
    , filled (rgb 0 170 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (-50,0) |> rotate (degrees 90) 
    , filled (rgb 0 240 0) (polygon [(-45,5),(-40,0),(40,0),(45,5)]) |> move (50,0) |> rotate (degrees -90) 
    ]
    
cartesianPlane = group
    [    
     move (0,0) (filled lightBlack (rect 2 700)) |> rotate (degrees 90 )    
    , move (0,0) (filled lightBlack (rect 2 700))
       -- black cartesian arrows --
    , move (0, 255) (filled lightBlack (ngon 3 5)) |> rotate (degrees 90 )
    , move (0, -255) (filled lightBlack (ngon 3 5)) |> rotate (degrees 270 )
    , move (255, 0) (filled lightBlack (ngon 3 5))
    , move (-255, 0) (filled lightBlack (ngon 3 5))  |> rotate (degrees 180 )
       -- grey grid lines --
    , move (50,0) (filled clearGrey (rect 2 700))
    , move (100,0) (filled clearGrey (rect 2 700))
    , move (150,0) (filled clearGrey (rect 2 700))
    , move (200,0) (filled clearGrey (rect 2 700))
    , move (250,0) (filled clearGrey (rect 2 700))
    , move (300,0) (filled clearGrey (rect 2 700))
    , move (350,0) (filled clearGrey (rect 2 700))
    , move (-50,0) (filled clearGrey (rect 2 700))
    , move (-100,0) (filled clearGrey (rect 2 700))
    , move (-150,0) (filled clearGrey (rect 2 700))
    , move (-200,0) (filled clearGrey (rect 2 700))
    , move (-250,0) (filled clearGrey (rect 2 700))
    , move (-300,0) (filled clearGrey (rect 2 700))
    , move (-350,0) (filled clearGrey (rect 2 700))
    , move (0,50) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,100) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,150) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,200) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )    
    , move (0,250) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,300) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,350) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-50) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-100) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-150) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-200) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )    
    , move (0,-250) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-300) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
    , move (0,-350) (filled clearGrey (rect 2 700)) |> rotate (degrees 90 )
         -- black co-ordinate ticks --
    , move (50,0) (filled black (rect 2 6))
    , move (100,0) (filled black (rect 2 6))
    , move (150,0) (filled black (rect 2 6))
    , move (200,0) (filled black (rect 2 6))
    , move (250,0) (filled black (rect 2 6))
    , move (300,0) (filled black (rect 2 6))
    , move (350,0) (filled black (rect 2 6))
    , move (-50,0) (filled black (rect 2 6))
    , move (-100,0) (filled black (rect 2 6))
    , move (-150,0) (filled black (rect 2 6))
    , move (-200,0) (filled black (rect 2 6))
    , move (-250,0) (filled black (rect 2 6))
    , move (-300,0) (filled black (rect 2 6))
    , move (-350,0) (filled black (rect 2 6))
    , move (0,50) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,100) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,150) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,200) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,250) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,300) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,350) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-50) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-100) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-150) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-200) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-250) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-300) (filled black (rect 2 6)) |> rotate (degrees 90 )
    , move (0,-350) (filled black (rect 2 6)) |> rotate (degrees 90 )
          -- numbers on the plane, x axis --
    , text (fromString "0")
    , text (fromString "50") |> move (50,-20)    
    , text (fromString "100") |> move (100,-20)       
    , text (fromString "150") |> move (150,-20)        
    , text (fromString "200") |> move (200,-20)  
    , text (fromString "250") |> move (250,-20)       
    , text (fromString "300") |> move (300,-20)        
    , text (fromString "350") |> move (350,-20)   
    , text (fromString "-50") |> move (-50,-20)  
    , text (fromString "-100") |> move (-100,-20)  
    , text (fromString "-150") |> move (-150,-20)  
    , text (fromString "-200") |> move (-200,-20)
    , text (fromString "-250") |> move (-250,-20)  
    , text (fromString "-300") |> move (-300,-20)  
    , text (fromString "-350") |> move (-350,-20)  
          -- numbers on the plane, y axis --
    , text (fromString "50") |> move (20,50)    
    , text (fromString "100") |> move (20,100)        
    , text (fromString "150") |> move (20,150)        
    , text (fromString "200") |> move (20,200)
    , text (fromString "250") |> move (20,250)        
    , text (fromString "300") |> move (20,300)        
    , text (fromString "350") |> move (20,350)  
    , text (fromString "-50") |> move (20,-50)   
    , text (fromString "-100") |> move (20,-100)   
    , text (fromString "-150") |> move (20,-150)   
    , text (fromString "-200") |> move (20,-200)
    , text (fromString "-250") |> move (20,-250)   
    , text (fromString "-300") |> move (20,-300)   
    , text (fromString "-350") |> move (20,-350)
    
    ]
 
lightBlack = rgba 0 0 0 0.6
clearGrey = rgba 111 111 111 0.3
--------------------------------------------------------------------------------------

-- This is the function that holds the coordinates and path of the bee!
-- You will modify this function gradually by going through the tutorial!

pathMaker t = if | t < 100   -> (-210,140) 
                 | otherwise -> (0,0) 
 
-- This is the wing flapping speed of the bee
-- The smaller the number, the faster the wings animate
-- If the wingSpeed is 0, they will not move at all! Make sure to stay above 0!

wingSpeed = 5