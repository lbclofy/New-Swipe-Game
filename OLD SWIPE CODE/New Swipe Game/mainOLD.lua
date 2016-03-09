
display.setStatusBar (display.HiddenStatusBar)
local physics = require( "physics" )

local controls = require ( "gameUI" )

physics.start()
--physics.setDrawMode ( "hybrid" )	 -- Uncomment if you want to see all the physics bodies
physics.setGravity(0,0) -- We set the gravity to (0,0) in order to simulate an air hockey table
physics.setDrawMode("hybrid")


-- Display settings (determine the bounding box of the visible playing screen)
local topLeft = { x = (display.contentWidth - display.viewableContentWidth) / 2, y = (display.contentHeight - display.viewableContentHeight) / 2}
local bottomRight = { x = topLeft.x + display.viewableContentWidth, y = topLeft.y + display.viewableContentHeight}



	---------my variables
local _W = display.contentWidth
local _H = display.contentHeight
local centerX = display.contentWidth*.5
local centerY = display.contentHeight*.5
local mR = math.random
local mF = math.floor
local ballR = _W/70

local transitionTime=4000
local titleScreenGroup = {}
local makeMarker
local buildLevel
local deleteMarker
local marker
local endMarker
local markerText
local endMarkerText
local markerText
local button
local markerH = _H/4
local markerW = _W/5
local deleteEnd
local statusText
local introStart
local arrow
local pi = math.pi
local sin = math.sin
local cos = math.cos
local atan2 = math.atan2
local onTap
local ran = false
local arrowPointer

local puck
local puckRadius = _W/40
local puckAvalLocation = {bottom="bottom", middle="middle", top="top"}
local puckDamping = {angular = 1, linear = 0} -- Linear damping determines how fast the puck slows down 
local puckInitialCoords = {x = topLeft.x + (display.viewableContentWidth / 2), y = topLeft.y + (display.viewableContentHeight / 2) }
local puckPhysicsProp = {density=1, friction=.2, bounce=1, radius=puckRadius}

local wallCollisionFilter = { categoryBits = 4, maskBits = 16 } 
local wallPhysicsProp = {density=1, friction=.5, bounce=.8, filter=wallCollisionFilter}
local floorCollisionFilter = { categoryBits = 8, maskBits = 48 } 
local floorPhysicsProp = {density=1, friction=.5, bounce=.8, filter=floorCollisionFilter}
local puckCollisionFilter = { categoryBits = 16, maskBits = 63 } 
local puckPhysicsProp = {density=1, friction=.2, bounce=1, radius=puckRadius, filter=puckCollisionFilter}
local brickCollisionFilter = { categoryBits = 32, maskBits = 28 } 
local puckHit



local brickR = _W/20
local W_LEN = 8
local bricks = display.newGroup()
local brick
local theta1 = math.pi/3
local theta2 = 2*math.pi/3
local theta3 = math.pi
local theta4 = 4*math.pi/3
local theta5 = 5*math.pi/3
local odd = 0
local hexShape = { math.cos(0)*brickR, math.sin(0)*brickR, math.cos(theta1)*brickR, math.sin(theta1)*brickR, math.cos(theta2)*brickR, math.sin(theta2)*brickR ,math.cos(theta3)*brickR,math.sin(theta3)*brickR, math.cos(theta4)*brickR, math.sin(theta4)*brickR, math.cos(theta5)*brickR, math.sin(theta5)*brickR }
local brickVelocity = 20
local brick

local showCountDown
local countDownTimer




local options = 
{
    --parent = textGroup,
    text = " Touch Anywhere and Hold to Start ",     
    x = 0,
    y = 0,
    width = _W*8/10,     --required for multi-line and alignment
    font = "Nova Thin Extended",  
    fontSize = _W/8,
    align = "center"  --new alignment parameter
}

statusText = display.newText( options  )
statusText:setTextColor( 1 )

statusText.x = _W/2
statusText.y = _H/4

local isStart = "touch"

local function angleBetween(x1,y1,x2,y2)

		local angle = math.ceil(atan2((y2-y1),(x2-x1))*180*pi^-1)+90
		return angle
end

local function distanceBetween(x1,y1,x2,y2)
	
		local X = x1-x2
		local Y = y1-y2
		local d=(X*X+Y*Y)^(.5)
		return d
end


local function makeEnd()
	
	endMarker = display.newRoundedRect( _W*9/10, _H*4/5, markerW , markerH , 20 )
	endMarker:setFillColor(  1,0,0 )
	physics.addBody( endMarker,  { density=0, friction=0, bounce=0 } )
	endMarker.isSensor = true
	
  
	--endMarker.name = "end"

end

local function deleteEnd()
	if endMarker~=nil then
		endMarker:removeSelf()
		endMarker= nil
	end
end 






local function makeMarker()
	
	marker = display.newRoundedRect( _W/10, _H*4/5, markerW , markerH , 20 )
	marker:setFillColor(  0,0,1 )
	marker.alpha = .5
	

	physics.addBody( marker,  { density=0, friction=0, bounce=0 } )
	marker.isSensor = true
	marker:addEventListener( "touch", onTap )
	--marker.name = "start"
	
end

local function deleteMarker()
	if marker~=nil then
		marker:removeEventListener( "touch", onTap )
		display.remove(marker)
		marker:removeSelf()
		marker= nil
	end
end 








local function placePuck(location)
	if puck ==nil then
	
	
	
	
	puck = display.newCircle( 0, 0, puckRadius )
	puck.x = puckInitialCoords.x
	puck.y = puckInitialCoords.y
	physics.addBody(puck, "dynamic", puckPhysicsProp)
	puck.name = "puck"
	puck.isBullet=true

	puck.linearDamping = puckDamping.linear
	puck.angularDamping = puckDamping.angular

	if location == puckAvalLocation.top then
		puck.y = topLeft.y + ((display.viewableContentHeight / 5) * 2)
	elseif location == puckAvalLocation.bottom then
		puck.y = topLeft.y + ((display.viewableContentHeight / 5) * 3)
	end

	puck.isBullet = true 

	puck:setLinearVelocity( 0, 100 )
	
	end
	
	local wall
	wallThickness = _W/200
	-- Left wall
	wall = display.newRect( topLeft.x, display.viewableContentHeight/2, wallThickness, display.viewableContentHeight )
	wall:setFillColor(266,266,266)
	wallBody = physics.addBody( wall,"static", wallPhysicsProp)
	wall.name = "wall"
	
	-- Right wall
	wall = display.newRect( bottomRight.x, display.viewableContentHeight/2, wallThickness, display.viewableContentHeight )
	wall:setFillColor(266,266,266)--wallColor.r, wallColor.g, wallColor.b, wallColor.a)
	physics.addBody( wall, "static", wallPhysicsProp )
	wall.name = "wall"

	-- The wall thickness for the bottom and top walls have to be slightly bigger in order to account for the height of the graphics

	-- Bottom wall
	wall = display.newRect( display.viewableContentWidth/2, _H, _W, wallThickness)
	wall:setFillColor(266,266,266)
	physics.addBody( wall, "static", floorPhysicsProp )
	wall.name = "floor"
	
	-- Slightly modifying the thickness for the top wall
	
	-- Top wall
	wall = display.newRect( display.viewableContentWidth/2, 0, _W , wallThickness)
	wall:setFillColor(266,266,266)
	physics.addBody( wall, "static", wallPhysicsProp )
	wall.name = "ceiling"
	
end

local function arrowPointer(x1,y1)
	
	local angle = angleBetween(_W/2,_H/2,x1,y1)
	arrow.rotation = angle - 110
	arrow.alpha = 1

	local size = distanceBetween(_W/2,_H/2,x1,y1)
	local xScale = 357/434.68*size --+200
	local yScale = 248/434.68*size --+200
	arrow.width = xScale
	arrow.height = yScale
	
end






local countDownText = display.newText( "",0, 0, native.systemFont, _H * 0.5 )
countDownText:setTextColor( 131, 255, 131 )-- Define text color
--countDownText:setReferencePoint( display.TopLeftReferencePoint )-- Define text position reference
 
-- Set the text position at center
countDownText.x = ((_W * 0.5) - (countDownText.contentWidth * 0.5))
countDownText.y = ((_H * 0.5) - (countDownText.contentHeight * 0.5))
 
-- Define count down number
local countDownNum = 3
 
-- Define function to show countdown numbers
local showCountDown = function()
 
-- Condition to show and hide countdown
	if countDownNum == 0 then
		brick:removeSelf()
		countDownText:removeSelf()-- Remove countdown text
 	  	 puckAction = "hit"	
 
	else-- Condition to display countdown numbers
			countDownText.text = countDownNum
	end
	
		countDownNum = countDownNum - 1
end
 





local function gameLoop()
	

	
	
end


function buildLevel(level)


	local vy


				if (level == 1) then
					brick = display.newPolygon( 0,0 , hexShape )
					brick:setFillColor( 1, 1, 0)
					brick.name = 'brick'
				
					brick.x = _W/2
				
					brick.y = _H/2
				
				
				
					physics.addBody(brick, "static", {density = 1, friction = 0, bounce = 1.2, filter=brickCollisionFilter, shape=hexShape})
					bricks.insert(bricks, brick)

				
				elseif (level == 0) then
					brick = display.newPolygon( 0,0 , hexShape )
					brick:setFillColor( 0, 0, 0 )
					brick.name = 'badbrick'
					
					brick.x = _W/2
				
					brick.y = _H/2
					
					physics.addBody(brick, "static" ,{density = 1, friction = .5, bounce = 2, filter=brickCollisionFilter, shape=hexShape})
					bricks.insert(bricks, brick)
					
				end
			

end


local function onPreCollision(event)
	local name1 = event.object1.name
	local name2 = event.object2.name 
	
	if puckHit == "puckHit" then
		
		if isStart == "puckMid" then
			if name1 == "head" or name2 == "head" then
				if name1 == "puck" or name2 == "puck" then
				puckAction = "hit"
				end
			end
		end
		
		if isStart == "puckEnd" then
			if name1 == "path" or name2 == "path" then
				if name1 == "puck" or name2 == "puck" then
					puckAction = "hit"	
				end
			end
		end
		
		if isStart == "brickStart" then
			if name1 == "brick" or name2 == "brick" then
				
				if name1 == "puck" or name2 == "puck" then
					puckAction = "hit"	
					if name1 == "brick" then
						event.object1:removeSelf()
					end
					if name2 == "brick"  then
						event.object2:removeSelf()
					end
					
				end
			end
		end
		if isStart == "brickEnd" then
			if name1 == "badbrick" or name2 == "badbrick" then
				
				if name1 == "puck" or name2 == "puck" then
					
					if name1 == "badbrick"  then
						countDownNum = 3
						 countDownText.text = countDownNum
						timer.performWithDelay( transitionTime/2, showCountDown, 4 )
					end
					if name2 == "badbrick" then
						countDownNum = 3
						 countDownText.text = countDownNum
						timer.performWithDelay( transitionTime/2, showCountDown, 4 )
					end
					
				end
			end
		end
	
	end
	

	
	
	
end

local function createScene()

	makeArrow()
	arrow.alpha = 0
	titleScreenGroup = display.newGroup()
	gameUI.main({length = _W/3})
	isStart = "puckStart"
	Runtime:addEventListener("enterFrame", gameLoop)
	Runtime:addEventListener( "preCollision", onPreCollision )

end









createScene()
		
	
					
		
		
		
		

		
	