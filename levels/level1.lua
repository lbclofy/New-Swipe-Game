local composer = require( "composer" )
local obs = require("objects.obstacles")
local po = require("objects.playobjects")
local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    

    local box2 = obs:newCircle(50)
    box2.x, box2.y = 100,200

    local box1 = obs:newBox(100,100)
    box1.x, box1.y = 150,400


    local pegField = obs:newPegField(200,400)
    for k, v in pairs(pegField) do
        pegField[k].x = pegField[k].x + 100
        pegField[k].y = pegField[k].y + 100
        sceneGroup:insert(pegField[k])
    end

    local polygon = obs:newPolygon({ 0,-37, 37,-10, 23,34, -23,34, -37,-10 })
    polygon.x, polygon.y = centerX-1,600

    local gameBall = po:newBall()
    gameBall.x, gameBall.y = 200, 50


    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene