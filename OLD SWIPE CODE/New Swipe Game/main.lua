
-- for screensize
_G.centerX = display.contentCenterX
_G.centerY = display.contentCenterY
_G._W = display.contentWidth
_G._H = display.contentHeight

_G.pi = math.pi
_G.sin = math.sin
_G.cos = math.cos
_G.atan2 = math.atan2

_G.font = native.systemFontBold


_G.ballR = _H*.01


_G.green = 	{	R = 076/255,	G = 175/255,	B = 080/255}

_G.shadowBlur = _W*.005


local physics = require("physics")
physics.start()

local composer = require( "composer" )
composer.gotoScene("menu")

--physics.setDrawMode("hybrid")


--[[
--local drawLine  = require("draw")


--drawLine.setupDraw()
--drawLine.drawOff()


local eraseButton=display.newCircle( 50,50, ballR*2)

local function erase()
	for i = 1, #linePath do

		display.remove(linePath[i])
		linePath[i] = nil

	end
	lineCount = 1

	return true
end

eraseButton:addEventListener("tap", erase)

local arguments =
{
	{ x=100, y=60, w=100, h=100, r=10, red=255/255, green=0/255, blue=128/255 },
}



local function eraseLine( event )
	local t = event.target

	-- Print info about the event. For actual production code, you should
	-- not call this function because it wastes CPU resources.

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )

		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

local function onLocalPreCollision( self, event )
    print( event.target )        --the first object in the collision
    print( event.other )         --the second object in the collision
    print(event.x)
    print(event.y)
end


local function onLocalCollision( self, event )
    print( event.target )        
    print( event.other )       

    display.remove(event.other)

end


-- Iterate through arguments array and create rounded rects (vector objects) for each item
for _,item in ipairs( arguments ) do
	local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
	button:setFillColor( item.red, item.green, item.blue )
	button.strokeWidth = 6
	button:setStrokeColor( 200,200,200,255 )
	physics.addBody( button, "dynamic", { density=0, friction=0, bounce=0} )
	button.gravityScale = 0
	button.isSensor = true
	button.collision = onLocalCollision
	button:addEventListener( "collision", button )
	button:addEventListener( "touch", eraseLine )
end



]]


