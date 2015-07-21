import Graphics.Element exposing (..)
import Time
import Window
import Keyboard
import Graphics.Collage exposing (..)
import List exposing (..)
import String exposing (..)
import Color exposing (..)
import Maybe
import Array
import Text exposing (..)

--------------------- IGNORE THE CODE ABOVE THIS LINE -----------------------------

{-
  1. Welcome to the maze game! You are playing as the orange circle by default.
  An orange circle isn't that fun for a character, but you can change that.
  See if you can change the defaultPlayer to be batman or rabbit (These characters
  are built in for you).
-}

player : Form 
player = defaultPlayer


{-
  2. Your goal is to get to the end of the maze (which is the yellow square).
  Right now, you have no clear path to the end. Find a way to get to the end
  of the maze by changing the values in the mazeBoard list below
-}

gameBoard = [
               [g,g,g,g,g,b,b,g,g,y]
              ,[g,g,b,b,g,g,g,g,b,b]
              ,[b,r,b,b,b,g,b,g,b,b]
              ,[b,g,b,b,b,b,b,g,b,b]
              ,[g,g,b,b,b,b,b,g,b,b]
              ,[g,b,b,b,g,r,g,g,b,b]
              ,[g,g,g,b,g,b,b,g,b,b]
              ,[g,b,g,g,g,b,r,g,b,b]
              ,[g,b,g,b,b,b,g,b,b,b]
              ,[g,b,g,g,g,g,g,b,b,b]
            ]       

{-
  3. Once you have gotten to the end of the maze, what happens? It would be
  awesome if there was something to tell you that you won right? Modify the 
  code below to make an awesome winning image

  Examples of forms are: 
  1) filled red (circle 50) <---- This is a red circle
  2) text (fromString "Hello World!") <----- This is text

-}

winImage : Form
winImage = blankForm

{-
  4. Now it's time to add a challenge to the game! Enable health (in the variable below)
  Now you will have to complete the game before the health runs out. If health runs out,
  you will not be able to move and have to recompile the game. By default, you will not
  have enough health to complete the game. Find a way to get to the finish with health
  on.

  Hint: A Bool value can be either True or False

-}

healthEnabled : Bool
healthEnabled = False

{-
  5. Good job! You've gotten very far, so now it is time for a different adventure!.
  Once you enable the key below, you the game will change so that you must pick up
  the key (which is an orange circle) before getting to the finish.

  What's going on now? You can't get to the finish with this much health, and changing
  the board won't give you enough.

  Now, stop ignoring the code below the line, and see if you can change something to
  allow you to get the key and still be able to get to the finish.
-}



keyEnabled : Bool
keyEnabled = False





----------------------- IGNORE THE CODE BELOW THIS LINE -----------------------------

-- Globals / Helpers / Types

winSize = 500
winDimension = 10
blockSize = winSize / winDimension


ithFromListHelper2 n l = Maybe.withDefault 0 (Array.get n (Array.fromList l))
ithFromListHelper1 n l = Maybe.withDefault [0] (head (drop n l))
ithFromList x y l = ithFromListHelper2 x (ithFromListHelper1 y l)

mazeBoard = List.map (List.map mazeBoardHelper) gameBoard
mazeBoardHelper c = if | c == green -> 1 | c == blue -> 0 | c == red -> 2 | c == yellow -> 3

-- User Input

type alias UserInput = {x : Int, y : Int}

userInput : Signal UserInput
userInput = Keyboard.arrows

-- Game Model

type alias Character = {x : Int, y : Int}
type alias Board = List (List (Int))
type alias Health = {isEnabled : Bool, healthAmount : Int}
type alias Key = {isEnabled : Bool, hasKey : Bool, x : Int, y : Int}

type alias GameState = 
              {
                character : Character
               ,maze : Board
               ,hasWon: Bool
               ,health : Health
               ,key : Key
              }


defaultGame : GameState
defaultGame = {
                 character = {x = 1, y = 3}
                ,maze = List.reverse mazeBoard
                ,hasWon = False
                ,health = {isEnabled = False, healthAmount = 14}
                ,key = {isEnabled = keyEnabled, hasKey = False, x = 0, y = 0}
              }

            
-- Update

stepGame : UserInput -> GameState -> GameState
stepGame userInput gameState =
  let 
      hasWon = getHasWon userInput gameState
      healthAmount = getHealthAmount userInput gameState
      key = getKey userInput gameState
  in
    if canUpdate userInput gameState
      then {
             character = {x = gameState.character.x + userInput.x , y = gameState.character.y + userInput.y}
            ,maze = gameState.maze
            ,hasWon = hasWon
            ,health = {isEnabled = healthEnabled, healthAmount = healthAmount}
            ,key = key
           } 
    else gameState

getHasWon : UserInput -> GameState -> Bool
getHasWon userInput gameState = 
               if ithFromList (userInput.x + gameState.character.x) (userInput.y + gameState.character.y) gameState.maze == 3
               then if gameState.key.isEnabled
                    then if gameState.key.hasKey
                         then True
                         else False
                    else True
               else False

getHealthAmount : UserInput -> GameState -> Int
getHealthAmount userInput gameState = 
  if
  | healthEnabled && canUpdate userInput gameState -> gameState.health.healthAmount - 1
  | otherwise -> gameState.health.healthAmount

getKey : UserInput -> GameState -> Key
getKey userInput gameState =
  let 
      newKey = {isEnabled = True, hasKey = True, x = gameState.key.x, y = gameState.key.y}
  in
    if gameState.key.isEnabled
    then
        if
          gameState.character.x == gameState.key.x &&
          gameState.character.y == gameState.key.y
        then newKey
        else gameState.key
    else gameState.key

canUpdate : UserInput -> GameState -> Bool
canUpdate userInput gameState = 
  if 
    noCollision userInput gameState &&
    inBounds userInput gameState &&
    healthValid gameState &&
    not gameState.hasWon &&
    onlyOneKeyDown userInput
  then True
  else False

noCollision : UserInput -> GameState -> Bool
noCollision userInput gameState =
    let 
      val = ithFromList (userInput.x + gameState.character.x) (userInput.y + gameState.character.y) gameState.maze
    in
      if (val == 1
         && (abs(userInput.x) + abs(userInput.y) < 2))
         || val == 3
      then True
      else False
      
      
inBounds : UserInput -> GameState -> Bool
inBounds userInput gameState = 
  if (userInput.x + gameState.character.x < winDimension && userInput.x + gameState.character.x >= 0)
  then if (userInput.y + gameState.character.y < winDimension && userInput.y + gameState.character.y >= 0)
       then True
       else False
  else False

healthValid : GameState -> Bool
healthValid gameState = if
  | gameState.health.isEnabled -> if gameState.health.healthAmount > 0 then True else False
  | otherwise -> True
  
onlyOneKeyDown : UserInput -> Bool
onlyOneKeyDown userInput = 
  let
    a = abs(userInput.x)
    b = abs(userInput.y)
  in
    if 
    | abs(a) + abs(b) == 1 -> True
    | otherwise -> False



-- Display

display : (Int,Int) -> GameState -> Element
display (w,h) gameState = 
    collage w h
    [ move (-250, -250) 
      (
         if 
         | gameState.hasWon     -> winImage
         | not gameState.hasWon -> group 
                                    [
                                      drawMaze gameState.maze 0
                                    , drawHealth gameState
                                    , drawKey gameState
                                    , drawPlayer gameState
                                    ]
      )
    ]

drawMaze : List (List (Int)) -> Int -> Form
drawMaze (l2h :: l2r) y =
  if y < winDimension - 1
  then group [drawMaze1 l2h 0 y, drawMaze l2r (y + 1)]
  else drawMaze1 l2h 0 y

drawMaze1 (l1h :: l1r) x y = 
  if l1r == []
  then drawMaze2 l1h x y
  else group [drawMaze2 l1h x y, drawMaze1 l1r (x + 1) y]

drawMaze2 e x y = 
  let
    c = if 
        | e == 1 -> green
        | e == 0 -> blue
        | e == 3 -> yellow
        | otherwise -> red
  in
    move (x * blockSize, y * blockSize) (filled c (rect blockSize blockSize))
    
drawHealth : GameState -> Form
drawHealth gameState = 
  let 
    healthItems = move (250,250) (group [move (-26, 253) (text (Text.color red (fromString " HEALTH ")))
                    , move (-25, 243) (outlined (solid black) (rect 500 30))
                    , move (-25,-25) (outlined (solid black) (rect 501 501))
                    , move (-26,238) (filled red (rect (Basics.toFloat (25 * gameState.health.healthAmount)) 10))
                    ])
    gameOver = scale 3 <| move (220, 550) (text (Text.color black (fromString " GAME OVER")))
  in
    if
    | healthEnabled -> (if
                       | gameState.health.healthAmount == 0 -> group [healthItems, gameOver]
                       | otherwise -> healthItems)
    | otherwise -> blankForm
  
drawKey : GameState -> Form
drawKey gameState = 
  if gameState.key.isEnabled && not gameState.key.hasKey
  then move ((Basics.toFloat gameState.key.x) * blockSize, (Basics.toFloat gameState.key.y) * blockSize) (keyShape)
  else blankForm

drawPlayer : GameState -> Form
drawPlayer {character, maze} = move ((Basics.toFloat character.x) * blockSize, (Basics.toFloat character.y) * blockSize) (player)


g = green
b = blue
r = red
y = yellow


blankForm = filled black (circle 0)
defaultPlayer = filled orange (circle (blockSize / 2))
batman = scale 0.3 (group
    [ move (0,0) (filled red (circle 80))
    , move (0,0) (filled lightRed (circle 70))
    , move (0,0) (filled black (circle 50))
    , move (0,0) (filled skinColor (circle 50)) |> scale 0.9
    , move (0,-4) (filled black (polygon [(-10,0),(0,-5),(10,0),(3,10),(-3,10)])) |> scale 5
    , move (29,35) (filled black (ngon 3 30)) |> rotate (degrees 70)
    , move (-29,35) (filled black (ngon 3 30)) |> rotate (degrees 110)
    , move (25,0) (filled white (oval 40 20)) |> rotate (degrees 30)
    , move (25,8) (filled black (rect 45 15)) |> rotate (degrees 20)
    , move (-25,0) (filled white (oval 40 20)) |> rotate (degrees 150)
    , move (-25,8) (filled black (rect 45 15)) |> rotate (degrees 160)
    , move (0,-35) (filled black (rect 20 2))
    , move (-12,-36) (filled black (rect 5 2)) |> rotate (degrees 20)
    , move (12,-36) (filled black (rect 5 2)) |> rotate (degrees 160) ])

rabbit =
      let
          ear1 = move (-23,88) (group [ (filled black (oval 27 72)) |> rotate (degrees 25)
                , (filled white (oval 25 70)) |> rotate (degrees 25)
                , (filled darkGrey (oval 15 55)) |> rotate (degrees 25)])
          ear2 = move (18,88) (group [ (filled black (oval 27 72)) |> rotate (degrees -20)
                , (filled white (oval 25 70)) |> rotate (degrees -20)
                , (filled darkGrey (oval 15 55)) |> rotate (degrees -20)])
      in
         scale 0.6 <| group [
         -- Ears
          ear1
        , ear2
        --
        , move (-14,-22) (filled black (oval 10 20)) |> rotate (degrees -60)
        , move (-14,-22) (filled white (oval 8 18)) |> rotate (degrees -60)
        , move (3,-25) (filled black (oval 10 20)) |> rotate (degrees -50)
        , move (3,-25) (filled white (oval 8 18)) |> rotate (degrees -50)
        -- Body
        , move (0,3) (filled black (oval 42 52))
        , move (0,3) (filled white (oval 40 50))
        -- Hands
        , move (7,0) (filled black (oval 7 15)) |> rotate (degrees -30)
        , move (7,0) (filled white (oval 5 13)) |> rotate (degrees -30)
        , move (-7,0) (filled black (oval 7 15)) |> rotate (degrees 40)
        , move (-7,0) (filled white (oval 5 13)) |> rotate (degrees 40)
        , move (-12,5) (filled white (ngon 4 6)) |> rotate (degrees 0)
        , move (11,6) (filled white (ngon 4 6)) |> rotate (degrees 20)
        -- Ears
        --, move (-20,90) (filled black (oval 27 72)) |> rotate (degrees 25)
        --, move (15,90) (filled black (oval 27 72)) |> rotate (degrees -20)
        --, move (-20,90) (filled white (oval 25 70)) |> rotate (degrees 25)
        --, move (15,90) (filled white (oval 25 70)) |> rotate (degrees -20)
        --, move (-20,90) (filled darkGrey (oval 15 55)) |> rotate (degrees 25) 
        --, move (15,90) (filled darkGrey (oval 15 55)) |> rotate (degrees -20)
        -- Face
        , move (0,55) (filled white (circle 30))
        , move (0,55) (filled black (circle 31))
        , move (0,55) (filled white (circle 30))
        , move (0,30) (filled black (oval 60 24))
        , move (0,30) (filled white (oval 58 22)) 
        -- Eyes
        , move (-13,55) (filled black (oval 15 35)) 
        , move (13,55) (filled black (oval 15 35))
        , move (-13,55) (filled white (oval 13 32))
        , move (13,55) (filled white (oval 13 32))      
        -- Pupils
        , move (-13,55) (filled black (oval 9 27)) 
        , move (13,55) (filled black (oval 9 27))
        , move (-13,60) (filled white (circle 2.5))
        , move (13,60) (filled white (circle 2.5))
        , move (-14,55) (filled white (circle 1.5))
        , move (12,55) (filled white (circle 1.5))
        , move (0,35) (filled white (rect 45 20))
        , move (-13,45) (filled black (rect 11 1))
        , move (13,45) (filled black (rect 11 1))      
        -- Teeth
        , move (-3,25) (filled black (rect 7 23))
        , move (3,25) (filled black (rect 7 23))
        , move (-3,25) (filled white (rect 5 21))
        , move (3,25) (filled white (rect 5 21))      
        -- Mouth
        , move (-5,30) (filled black (circle 5))
        , move (5,30) (filled black (circle 5))
        , move (-5,30) (filled white (circle 4))
        , move (5,30) (filled white (circle 4))
        , move (0,34) (filled white (rect 20 6))      
        -- Nose
        , move (0,36) (filled black (ngon 3 6)) |> rotate (degrees 30)
        , move (0,39) (filled black (oval 13 4)) |> scale 0.6
        , move (3,35) (filled black (oval 13 4)) |> rotate (degrees 62) |> scale 0.6
        , move (-3,35) (filled black (oval 13 4)) |> rotate (degrees 118) |> scale 0.6
        , move (-2,35) (filled white (oval 8 2)) |> rotate (degrees 118) |> scale 0.6
        
      ]

keyShape = group [ filled black (oval 20 10)
    , filled yellow (oval 19 9)
    , filled black (oval 10 5)
    , filled green (oval 9 4)
    , (filled black (rect 10 5)) |> move (-5,-10)
    , (filled black (rect 10 5)) |> move (-5,-17)
    , (filled yellow (rect 9 4)) |> move (-5,-10)
    , (filled yellow (rect 9 4)) |> move (-5,-17)
    , (filled black (rect 5 15)) |> move (0,-12)
    , (filled yellow (rect 4 14)) |> move (0,-12)
    ] |> move (0,5)
    
skinColor = hsl 0.17 1 0.74

-- Putting it all together

gameState : Signal GameState
gameState =
    Signal.foldp stepGame defaultGame userInput


main : Signal Element
main =
    Signal.map2 display Window.dimensions gameState
