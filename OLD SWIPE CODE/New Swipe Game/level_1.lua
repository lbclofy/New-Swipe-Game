local composer = require( "composer" )

local obstacles = require("obstacles")
local goal = require("goal")
local ball = require("gameball")
local draw = require("draw")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local tutorialGroup

local function setUpObstacles(group)
  --  local obstacle = obstacles:newBlock(300,300)
   -- obstacle.x, obstacle.y = centerX, centerY
   -- group:insert(obstacle)


   local goal = goal:newGoal()
   goal.x, goal.y = centerX, _H*.9

end

local function startGame()
    print("START PLAYING")
    physics.start()
    display.remove(tutorialGroup)
end

local function setUpTutorial(group)
    local shadow = display.newRect(group, centerX,centerY, _W,_H)
    shadow:setFillColor(0,0,0,.5)

    local shadowSnapshot = display.newSnapshot(  300, 300 )
    local shadowRect = display.newCircle( shadowSnapshot.group, 0, 0, _W*.15 )
    shadowRect:setFillColor( 1,1,1)
    shadowSnapshot.fill.effect = "filter.blurGaussian"
    shadowSnapshot.fill.effect.horizontal.blurSize = shadowBlur*5
    shadowSnapshot.fill.effect.vertical.blurSize = shadowBlur*5

    shadowSnapshot.x, shadowSnapshot.y = centerX, centerY
    group:insert(shadowSnapshot)

    

end



-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    physics.pause()

    

    local background = display.newRect(sceneGroup, centerX,centerY, _W,_H)
    background:setFillColor(1,1,1,.95)
   
   setUpObstacles(sceneGroup)
--NEED TO MAKE INTO ITS OWN THING
  -- gameBall = display.newCircle( ballR)
 --  physics.addBody(gameBall, { density=1.0, friction=0.3, bounce=0.2, radius = ballR})
    local gameBall = ball:newGameBall()
    gameBall.x, gameBall.y = centerX,0

    local function listener()
        startGame()
    end

    tutorialGroup = display.newGroup()
    setUpTutorial(tutorialGroup)
    local buttonSize =  _W*.05
    local vertices = { buttonSize*math.cos(math.rad(0)),buttonSize*math.sin(math.rad(0)), 
        buttonSize*math.cos(math.rad(240)),buttonSize*math.sin(math.rad(240)), 
        buttonSize*math.cos(math.rad(120)),buttonSize*math.sin(math.rad(120)) }

    local startButton = display.newGroup()
    startButton.x,startButton.y = _W*.1 + buttonSize*.25, _W*.1
    startButton.main = display.newPolygon( startButton, 0, 0, vertices )
    startButton.main:setFillColor(.05,.05,.05*.05)

    startButton:addEventListener("tap", listener)

    draw.setupDraw()

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