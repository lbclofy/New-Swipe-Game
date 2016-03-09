UIElements = {}

local composer = require( "composer" )
local widget = require( "widget" )
local drawUI = require("draw")

function UIElements:newStart( )

	local start = display.newText( "Start", 0, 0, native.systemFont, 16 )
	start:setFillColor(0,0,0)

	

	local function startGame( self, event )
	    physics.start()
	    return true
	end 
	start.touch = startGame
	start:addEventListener( "touch", start )

	return start
end

function UIElements:newMenu( )

	local menu = display.newText( "Menu", 0, 0, native.systemFont, 16 )
	menu:setFillColor(0,0,0)

	local function gotoMenu( self, event )
	    composer.gotoScene( "menu" )
	    return true
	end 
	menu.touch = gotoMenu
	menu:addEventListener( "touch", menu )

	return menu
end



function UIElements:newScroll( group, botY)
	local endY =  botY or _H

	-- ScrollView listener
	local function scrollListener( event )

    	local phase = event.phase
    	if ( phase == "began" ) then --print( "Scroll view was touched" )
    	elseif ( phase == "moved" ) then --print( "Scroll view was moved" )
   		elseif ( phase == "ended" ) then --print( "Scroll view was released" )
  	    end

    -- In the event a scroll limit is reached...
	    if ( event.limitReached ) then
	        if ( event.direction == "up" ) then print( "Reached bottom limit" )
	        elseif ( event.direction == "down" ) then print( "Reached top limit" )
	        elseif ( event.direction == "left" ) then print( "Reached right limit" )
	        elseif ( event.direction == "right" ) then print( "Reached left limit" )
	        end
	    end

	    return true
	end

	-- Create the widget
	local scrollView = widget.newScrollView(
	    {
	        top = 0,
	        left = 0,
	        width = _W,
	        height = _H,
	        scrollWidth = _W,
	        scrollHeight = endY,
	        listener = scrollListener,
	        horizontalScrollDisabled = true,
	    }
	)
	scrollView:insert( group )

	return scrollView
end

function UIElements:newDraw( )

	local draw = display.newText( "Draw", 0, 0, native.systemFont, 16 )
	draw:setFillColor(0,0,0)

	local function onObjectTap( event )
	end 
	draw.tap = onObjectTap
draw:addEventListener( "tap", object )

	return draw
end





return UIElements