-- Stuff for our program
import Model exposing (..)
import Step exposing (..)
import View exposing (..)

-- Libraries needed
import Keyboard
import Window
import Graphics.Element exposing (Element)

---------------------------------------- THIS IS WHERE YOU ADD PLACES TO YOUR GAME
defaultGame : GameState
defaultGame = {
                        places = [
                                                            -- This must be at the beginning of every place
                                                                                        MyPlace 
                                                                                                                    -- This is the name of the place
                                                                                                                                                (MyPlaceName ETB)
                                                                                                                                                                            -- These are the places you can go to
                                                                                                                                                                                                        [MyPlaceName ITB, MyPlaceName BSB]
                                                                                                                                                                                                                                    -- This is the text in the description
                                                                                                                                                                                                                                                                                       (MyMessage "At the graduate level, the Department offers Master of Applied Science, Master of Engineering and Ph.D. programmes in Software Engineering, and Master of Science and Ph.D. programmes in Computer Science") --
                                                                                                                                                                                                                                                                                                                                                                                                                                                     -- This is the URL of the image in the location
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    (MyImage "http://wbooth.mcmaster.ca/images/etb.jpg")
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                -- This is the Key you need to go to this location
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            NoKey
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        -- This is the key you will pick up at this location
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    NoKey
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                           ,-- ONLY THE FIRST PLACE IS EXPLAINED
                                                      
                            MyPlace
                                                        (MyPlaceName ITB)
                                                                                    [MyPlaceName ETB, MyPlaceName BSB]
                                                                                                                (MyMessage "The Department of Computing and Software offers undergraduate programs in Software Engineering, including one of the first accredited undergraduate software engineering programmes in Canada, Software Engineering (Game Design), the Mechatronics Engineering program, Computer Science, and Business Informatics")
                                                                                                                                                                                                                                  (MyImage "http://www.cas.mcmaster.ca/~oplab/SONAD/img/buildingScaled.jpg")
                                                                                                                                                                                                                                                              (MyKey Wood)
                                                                                                                                                                                                                                                                                          (MyKey Diamond)
                                                                                                                                                                                                                                                                                                                      
                           ,
                                                      
                            MyPlace
                                                        (MyPlaceName BSB)
                                                                                    [MyPlaceName ITB, MyPlaceName ETB]
                                                                                                                (MyMessage "Consistently ranked as one of the top research universities in Canada and one of the country’s most innovative, McMaster believes in creating an innovative and stimulating learning environment where students can prepare themselves to excel, both at the university and beyond. Science is a research-focused student-centred Faculty at the heart of McMaster University")
                                                                                                                                                                                                                                                                                                                                                                 (MyImage "http://ppims.mcmaster.ca/construction/med/60_BSB_15.jpg")
                                                                                                                                                                                                                                                                                                                                                                                             NoKey
                                                                                                                                                                                                                                                                                                                                                                                                                         (MyKey Wood)
                                                                                                                                                                                                                                                                                                                                                                                                                                                  ]
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,curPlace = MyPlaceName ETB
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,keys = []
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            }

userInput : Signal UserInput -- 1: 49, 2: 50, 3: 51, 4: 52
userInput = Keyboard.presses


-- Putting it all together 
gameState : Signal GameState
gameState =
            Signal.foldp step defaultGame userInput


main : Signal Element
main =
            Signal.map2 playView Window.dimensions gameState
