module Step (step) where

import Model exposing (..)
import Maybe exposing (withDefault)
import List exposing (..)

step : UserInput -> GameState -> GameState
step userInput gameState =
    let 
        newPlace = updatePlaceName userInput gameState
        newKey = updateKey userInput gameState
    in 
        if canUpdate userInput gameState
        then {gameState | curPlace <- newPlace, keys <- newKey}
        else gameState


updatePlaceName : UserInput -> GameState -> PlaceName
updatePlaceName userInput gameState =
    let 
        fullPlace = getFullPlace gameState.curPlace gameState.places -- Get the full current place
        getOtherList (MyPlace _ l _ _ _ _) = l -- Get the list of other places from current place
        newPlaceName = getIthPlaceName (userInput - 49) (getOtherList fullPlace) -- Get the user inputted PlaceName from the list
    in
        newPlaceName

updatePlace : UserInput -> GameState -> Place -- Returns the user inputted place
updatePlace userInput gameState = 
    getFullPlace (updatePlaceName userInput gameState) gameState.places -- Get the full new place from new Place name

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

getIthPlaceName : Int -> List PlaceName -> PlaceName
getIthPlaceName i l = Maybe.withDefault NoPlaceName (head (drop i l))

updateKey : UserInput -> GameState -> List Key
updateKey userInput gameState = 
    let 
        pullKey (MyPlace _ _ _ _ _ k) = k
        newPlace = updatePlace userInput gameState
        newKey = pullKey newPlace
        
    in
        case newKey of
            NoKey -> gameState.keys
            MyKey name -> (if (MyKey name) `member` gameState.keys then gameState.keys else (MyKey name) :: gameState.keys)

canUpdate : UserInput -> GameState -> Bool
canUpdate userInput gameState = 
    if inputIsValid userInput -- Input is numbers 1-4
    && inputInList userInput gameState -- List is smaller than input number
    && keyValid userInput gameState -- The player should have the required key (if a key is required)
    then True
    else False

inputIsValid : UserInput -> Bool
inputIsValid userInput = 
    let possibleInputs = [49,50,51,52]
    in member userInput possibleInputs


inputInList : UserInput -> GameState -> Bool
inputInList userInput gameState = 
  let getLSize (MyPlace _ l _ _ _ _) = length l
  in (userInput - 48) <= ((getFullPlace gameState.curPlace gameState.places) |> getLSize)


keyValid : UserInput -> GameState -> Bool
keyValid userInput gameState =
    let 
        getReqKey (MyPlace _ _ _ _ k _) = k
        newPlace = updatePlace userInput gameState
        newKey = getReqKey newPlace
    in
        case newKey of
            NoKey -> True
            MyKey name -> member (MyKey name) gameState.keys