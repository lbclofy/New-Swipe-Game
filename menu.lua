local composer = require( "composer" )
local lm = require("ogt_levelmanager")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local menuScreens = {}
local swipeTrans
local centerObject
local currCenterObject = 0
local moved
local cancelTouch = false
local leftText = display.newText(  " ", _W*.2, _H*.9, font, 36 )
leftText:setFillColor(0,0,0)
local rightText = display.newText(  "LEVEL SELECT >", _W*.8, _H*.90, font, 36 )
rightText:setFillColor(0,0,0)

local function swipe( event, params )
    local body = event.target
    local phase = event.phase
    local stage = display.getCurrentStage()


    if cancelTouch == false then

        if "began" == phase then

            transition.cancel(swipeTrans)

        elseif "moved" == phase then

            local targetX = _W*.5 + (event.x-event.xStart)
            centerObject.x =  centerObject.x + (targetX -  centerObject.x)*.1

            local function canTouch()
                cancelTouch = false
            end


            if ( event.x>= event.xStart+_W*.4 ) then
        
                if currCenterObject ~= 0 then
                    transition.to( centerObject, {time =1000,  x =1.5*_W, transition = easing.outBack, onComplete = canTouch})
                    cancelTouch = true
                    currCenterObject = currCenterObject - 1
                    centerObject = menuScreens[currCenterObject]
                    transition.to( centerObject, {time =1000,  x=centerX, transition = easing.outBack })

                    local function listener()
                        transition.to( leftText, {time =400,  y=_H*.9, transition = easing.outBack })
                        transition.to( rightText, {time =500,  y=_H*.9, transition = easing.outBack })
                        leftText.text = menuScreens[currCenterObject].leftText
                        rightText.text = menuScreens[currCenterObject].rightText
                    end

                    transition.to( leftText, {time =500,  y=_H*1.05, transition = easing.outBack, onComplete = listener})
                    transition.to( rightText, {time =500,  y=_H*1.1, transition = easing.outBack })


                end
            elseif ( event.x<= event.xStart-_W*.4 ) then

                    if currCenterObject ~= 3 then
                    transition.to( centerObject, {time =1000,  x =1.5*-_W, transition = easing.outBack, onComplete = canTouch })
                    cancelTouch = true
                    currCenterObject = currCenterObject + 1
                    centerObject = menuScreens[currCenterObject]
                    transition.to( centerObject, {time =1000,  x=centerX, transition = easing.outBack })

                    local function listener()
                        transition.to( leftText, {time =400,  y=_H*.9, transition = easing.outBack })
                        transition.to( rightText, {time =500,  y=_H*.9, transition = easing.outBack })
                        leftText.text = menuScreens[currCenterObject].leftText
                        rightText.text = menuScreens[currCenterObject].rightText
                    end

                    transition.to( leftText, {time =500,  y=_H*1.05, transition = easing.outBack, onComplete = listener})
                    transition.to( rightText, {time =500,  y=_H*1.1, transition = easing.outBack })

                end
            end


        elseif "ended" == phase or "cancelled" == phase then

            local timeToCenter = (centerObject.x-centerX)/_W*2000
            if timeToCenter < 0 then
                timeToCenter = timeToCenter*-1
            end
            swipeTrans = transition.to( centerObject, {time =timeToCenter,  x =centerX, transition = easing.outBack })


        end

    end

    return true

end

local function createSettings(group)

end

-- "scene:create()"
function scene:create( event )
    
    local sceneGroup = self.view
    local background = display.newRect(sceneGroup, centerX,centerY, _W,_H)
    background:setFillColor(1,.5,0,.25)
    background:addEventListener("touch", swipe) -- CHANGE TO background

    local contNav = display.newGroup()
    contNav.x,contNav.y = centerX, centerY
    contNav.main = display.newCircle( contNav, 0,0, _W*.4)
    contNav.text = display.newText( contNav, "Continue", 0, 0, font, 36 )
    contNav.text:setFillColor(0,0,0)

    local function listener()
        lm.loadCurrLevel()
    end
    contNav:addEventListener("tap", listener)


    local levelSelNav = display.newGroup()
    levelSelNav.x,levelSelNav.y = centerX + _W, centerY
    levelSelNav.main = display.newCircle( levelSelNav , 0,0, _W*.4)
    levelSelNav.main:setFillColor(1,.5,.5,.25)
    levelSelNav.text = display.newText( levelSelNav , "Level Select", 0, 0, font, 36 )
    levelSelNav.text:setFillColor(0,0,0)
    lm.init(levelSelNav)

    local supportNav = display.newGroup()
    supportNav.x,supportNav.y = centerX + _W, centerY
    supportNav.main = display.newCircle( supportNav , 0,0, _W*.4)
    supportNav.main:setFillColor(1,.5,.5,.25)
    supportNav.text = display.newText( supportNav , "SUPPORT US", 0, 0, font, 36 )
    levelSelNav.text:setFillColor(0,0,0)

    local settingsNav = display.newGroup()
    settingsNav.x,settingsNav.y = centerX + _W, centerY
    settingsNav.main = display.newCircle( settingsNav , 0,0, _W*.4)
    settingsNav.main:setFillColor(0,1,0,.25)
    settingsNav.text = display.newText( settingsNav , "Settings", 0, 0, font, 36 )
    settingsNav.text:setFillColor(0,0,0)
    
    menuScreens[0] = contNav
    menuScreens[0].leftText = " "
    menuScreens[0].rightText = "LEVEL SELECT >"
    menuScreens[1] = levelSelNav
    menuScreens[1].leftText = "< CONTINUE "
    menuScreens[1].rightText = "SUPPORT US >"
    menuScreens[2] = supportNav
    menuScreens[2].leftText = "< LEVEL SELECT"
    menuScreens[2].rightText = "SETTINGS >"
    menuScreens[3] = settingsNav
    menuScreens[3].leftText = "< SUPPORT US"
    menuScreens[3].rightText = " "

    centerObject = contNav
    currCenterObject = 0

    sceneGroup:insert(contNav)
    sceneGroup:insert(levelSelNav)
    sceneGroup:insert(supportNav)
    sceneGroup:insert(settingsNav)
    sceneGroup:insert(leftText)
    sceneGroup:insert(rightText)
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

    --composer.removeAll()

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