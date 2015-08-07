module Model (..) where


type Place = MyPlace PlaceName (List PlaceName) Message Image Key Key

type alias GameState = {
                         places : List Place
                        ,curPlace : PlaceName
                        ,keys : List Key
                       }

type PlaceName = MyPlaceName Location
               | NoPlaceName   

type Key =     MyKey KeyType
             | NoKey


type Message = MyMessage String
             | NoMessage

type Image = MyImage String
           | NoImage

---------------------------------------- THIS IS WHERE YOU CAN ADD KEYS AND LOCATIONS                       
type KeyType = Wood
             | Bone
             | Diamond
             | Gold 
             | Siver
             
type Location = BSB
              | ITB
              | ETB
              | TSH
              | MUSC

-- User Input 
type alias UserInput = Int