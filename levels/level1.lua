local composer = require( "composer" )
local physics = require ( "physics" )
local obs = require("objects.obstacles")
local po = require("objects.playobjects")
local ui = require("objects.uielements")
local lvls = require("levels.levels")
--local drawUI = require("draw_lofy")
local drawUI = require("draw")


local scene = composer.newScene()
physics.setDrawMode("hybrid")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------

local isPlaying = false
local gameBall

local function gameLoop()
    print("x:" .. gameBall.x .. "y:" .. gameBall.y)
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local scrollGroup = display.newGroup()
    local goalY = _H*1.2

    physics.start()




--drawUI.setupDraw(scrollGroup)


    local leftBorder = obs:newBorder(10, _H)
    leftBorder.x, leftBorder.y = 0, centerY
    sceneGroup:insert(leftBorder)

    local rightBorder = obs:newBorder(10, _H)
    rightBorder.x, rightBorder.y = _W, centerY
    sceneGroup:insert(rightBorder)

    local botBorder = obs:newBorder(_W, 10)
    botBorder.x, botBorder.y = centerX, goalY
    scrollGroup:insert(botBorder)


--[[
    local box2 = obs:newCircle(50)
    box2.x, box2.y = 100,200
    scrollGroup:insert(box2)

    local box1 = obs:newBox(100,100)
    box1.x, box1.y = 150,400
    scrollGroup:insert(box1)

    


    local pegField = obs:newPegField(400,800)
    for k, v in pairs(pegField) do
        pegField[k].x = pegField[k].x + 100
        pegField[k].y = pegField[k].y + 100
        scrollGroup:insert(pegField[k])
    end

    local polygon = obs:newPolygon({ 0,-37, 37,-10, 23,34, -23,34, -37,-10 })
    polygon.x, polygon.y = 10,600
    scrollGroup:insert(polygon)]]

    gameBall = po:newBall()
    gameBall.x, gameBall.y = centerX, _H*.02
    gameBall:applyForce( math.random(-1, 1), math.random(-1, 1), gameBall.x, gameBall.y )
    scrollGroup:insert(gameBall)


    local gameGoal = po:newGoal()
    gameGoal.x, gameGoal.y = centerX, goalY
    scrollGroup:insert(gameGoal)

    for k, v in pairs(lvls.levels[1]) do
        if k <=3 then
            print("Making Star @ x: " .. lvls.levels[1][k][1] .. " y: " .. lvls.levels[1][k][2])
            local star = po:newStar()
            star.x, star.y = lvls.levels[1][k][1], lvls.levels[1][k][2]
            scrollGroup:insert(star)
        else
            if (lvls.levels[1][k][1] == 1) then

            else
                print(lvls.levels[1][i][1])
            end
        end
    end
   -- bg:setScrollWidth(_W*.5)

    sceneGroup:insert(scrollGroup)

    local bg = ui:newScroll( scrollGroup,goalY)
    sceneGroup:insert(bg)


    local start = ui:newStart()
    start.x, start.y = _W*.1, _H*.05
    sceneGroup:insert(start)

    local menu = ui:newMenu()
    menu.x, menu.y = _W*.8, _H*.05
    sceneGroup:insert(menu)
    local draw = ui:newDraw(bg)
    draw.x, draw.y = _W*.25, _H*.05
    sceneGroup:insert(draw)

    
    --bg:setIsLocked( true ) 
    

    local canvas = drawUI.newCanvas({group = scrollGroup,  scrollView = bg})
    sceneGroup:insert(canvas)
   -- drawUI.drawOff()

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        physics.pause()
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then

     --   Runtime:addEventListener("enterFrame", gameLoop)

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

    --    Runtime:removeEventListener("enterFrame", gameLoop)
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