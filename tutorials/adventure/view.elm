module View (graphView, playView) where

import Model exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (..)
import Color exposing (..)
import Maybe exposing (withDefault)
import Text exposing (fromString)


graphView : (Int, Int) -> GameState -> Element
graphView (w,h) gameState = collage w h [drawAll gameState.places]


drawPlaces : List Place -> Form 
drawPlaces places = group (map (drawPlace places) places)

drawLines : List Place -> Form
drawLines places = 
    group (map ((\(MyPlace name l _ _ _ _) -> (group (map (drawLine places name) l)))) places)



drawAll : List Place -> Form
drawAll places = group [drawPlaces places, drawLines places]

drawPlace : List Place -> Place -> Form
drawPlace places place = 
    let
        (x,y) = getXY place places (360 // (length places) |> toFloat)
        name = place |> (getPlaceName >> getLocation >> show >> toForm >> scale 2)
        keyGot = place |> (\(MyPlace _ _ _ _ _ k) -> (show >> toForm >> (moveY (-30))) k)
        keyNeeded = place |> (\(MyPlace _ _ _ _ k _) -> (show >> toForm >> (moveY (-50))) k)

        mycircle = filled red (circle 80)
    in
        move (x,y) <| group [mycircle, name, keyGot, keyNeeded]

drawLine : List Place -> PlaceName -> PlaceName -> Form
drawLine places place1 place2 =
  let 
    theta = 360 // (length places) |> toFloat
    place1Name = getFullPlace place1 places
    place2Name = getFullPlace place2 places 
  in 
    traced (solid green) (segment (getXY place1Name places theta) (getXY place2Name places theta))

getPlaceName : Place -> PlaceName
getPlaceName (MyPlace name _ _ _ _ _) = name

getIndexOf : Place -> List Place -> Float
getIndexOf place places =
    let
        helper e (x::xs) n =
            if
            | e == x -> toFloat n
            | otherwise -> 
                if
                | length xs > 0 -> helper e xs (n + 1)
                | otherwise -> (toFloat (-1))
    in
        helper place places 0

getXY : Place -> List Place -> Float -> (Float, Float)
getXY place places theta = 
  let 
    radius = 250
    angle = (getIndexOf place places) * (theta)
  in (radius * sin (degrees angle), radius * cos (degrees angle))

getLocation : PlaceName -> Location
getLocation (MyPlaceName name) = name


-- Play view
playView : (Int, Int) -> GameState -> Element
playView (w,h) gameState =
  let 
     (MyPlace name options message picture _ _) = getFullPlace gameState.curPlace gameState.places
     topElement = flow down [drawName name (w,h), drawImage picture (w,h), drawMessage message (w,h)]
     bottomElement = flow down [drawKeys gameState.keys (w,h), drawOptions options (w,h) gameState]
  in
    flow down [topElement, bottomElement]

getFullPlace : PlaceName -> List Place -> Place
getFullPlace placeName places = 
    let 
        getCurPlaceHelper placeName nthPlace =
            let 
                getCurPlaceHelper2 placeName (MyPlace name _ _ _ _ _) = 
                placeName == name
            in
                getCurPlaceHelper2 placeName nthPlace
        defaultPlace = MyPlace NoPlaceName [NoPlaceName, NoPlaceName] NoMessage NoImage NoKey NoKey

    in
        if (Maybe.map (getCurPlaceHelper placeName) (List.head places)) |> (withDefault False)
        then (List.head places) |> (withDefault defaultPlace)
        else (Maybe.map (getFullPlace placeName) (tail places)) |> (withDefault defaultPlace)


drawName : PlaceName -> (Int,Int) -> Element
drawName name (w,h) = 
  let 
    render a = collage (w) (h//8) [scale 4 <| toForm (show a)]
  in
    case name of
      NoPlaceName -> render NoPlaceName
      MyPlaceName placeName -> Graphics.Element.color blue <| render placeName

drawImage : Image -> (Int,Int) -> Element
drawImage picture (w,h) =
  let 
    render = fittedImage (w) (5*h//8)
    defaultPath = "http://upload.wikimedia.org/wikipedia/en/f/f0/A_Place_to_Call_Home_title_card.png"
  in
    case picture of 
      NoImage -> render defaultPath
      MyImage path -> render path

drawMessage : Message -> (Int,Int) -> Element
drawMessage message (w,h) =
  let
    cllg = collage (w) (h//8)
  in
    case message of
      NoMessage -> cllg [toForm (show NoMessage)] 
      MyMessage string -> Graphics.Element.color yellow <| leftAligned (fromString string)

drawOptions : (List PlaceName) -> (Int,Int) -> GameState -> Element
drawOptions options (w,h) gameState =
  let
    cllg a = collage ((5*w//6)//((length options))) (h//16) [toForm (show a)]
    optionsName = Graphics.Element.color orange <| collage (w//6) (h//16) [text (fromString "Options:")]
    renderOptions place =
      let 
        pullNeededKey (MyPlace _ _ _ _ k _) = k
        placeKey = pullNeededKey (getFullPlace place gameState.places)
        isRed = (not (placeKey `member` gameState.keys)) && (not (placeKey == NoKey))
      in
        case place of 
          NoPlaceName -> collage ((5*w//6)//((length options))) (h//16) [text (fromString "Nowhere to go")]
          MyPlaceName name -> if isRed then (Graphics.Element.color red <| cllg name) else (Graphics.Element.color grey <| cllg name)
  in
     flow right (optionsName :: (List.map renderOptions options))


drawKeys : (List Key) -> (Int,Int) -> Element
drawKeys keys (w,h) =
  let
    cllg a = Graphics.Element.color grey <| collage ((5*w//6)//((length keys))) (h//16) [toForm (show a)]
    keyName = Graphics.Element.color green <| collage (w//6) (h//16) [text (fromString "Keys:")]
    renderKey k = 
      case k of 
        NoKey -> cllg NoKey
        MyKey name -> cllg name
  in
     flow right (keyName :: (List.map renderKey keys))
    
    
