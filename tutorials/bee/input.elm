-- This is the function that holds the coordinates and path of the bee!
-- You will modify this function gradually by going through the tutorial!

pathMaker t = if | t < 100   -> (-210,140) 
                 | otherwise -> (0,0) 
 
-- This is the wing flapping speed of the bee
-- The smaller the number, the faster the wings animate
-- If the wingSpeed is 0, they will not move at all! Make sure to stay above 0!

wingSpeed = 5