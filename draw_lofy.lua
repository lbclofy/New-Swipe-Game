local M = {}

local physics = require("physics")

local d1 = {}
local dSum1 = 0

local canDraw = false


local linePath = {}
local lineCount = 1
local lineCoords = {xOld = nil, yOld = nil}

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

local function drawLine( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if canDraw == true then
		if "began" == phase then

			event.isFocus = true	
			linePath[lineCount]=display.newCircle( event.x ,event.y,ballR)
			physics.addBody( linePath[lineCount], "static", { density=0, friction=0, bounce=0, radius=ballR} )
			linePath[lineCount].name="path"
			linePath[lineCount].dist = ballR*2
			lineCount = lineCount + 1
			lineCoords.xOld, lineCoords.yOld = event.x, event.y

		elseif "moved" == phase then

			linePath[lineCount]=display.newCircle( event.x ,event.y,ballR)
			physics.addBody( linePath[lineCount], "static", { density=0, friction=0, bounce=0, radius=ballR} )
			linePath[lineCount].name="path"
			linePath[lineCount].dist = ballR*2
			lineCount = lineCount + 1
			linePath[lineCount]=display.newLine(event.x, event.y, lineCoords.xOld, lineCoords.yOld) -- Make a new path line
			linePath[lineCount].strokeWidth=ballR*2
			linePath[lineCount].name="path"
			linePath[lineCount].dist = distanceBetween(event.x, event.y, lineCoords.xOld, lineCoords.yOld)

			local angle = angleBetween(0,0 ,lineCoords.xOld-event.x, lineCoords.yOld-event.y)
			angle=math.rad(angle)
			local rectShape={cos(angle)*ballR,sin(angle)*ballR ,-cos(angle)*ballR,-sin(angle)*ballR,lineCoords.xOld-event.x-cos(angle)*ballR, lineCoords.yOld-event.y-sin(angle)*ballR,lineCoords.xOld-event.x+cos(angle)*ballR, lineCoords.yOld-event.y+sin(angle)*ballR}

			physics.addBody( linePath[lineCount], "static", { density=0, friction=0, bounce=0, shape = rectShape} )
			lineCoords.xOld, lineCoords.yOld = event.x, event.y
			lineCount = lineCount + 1

		elseif "ended" == phase or "cancelled" == phase then
			event.isFocus = false		
			--display.remove(event)
			--event=nil

		end
	end

	return true
end

local function setupDraw()
	Runtime:addEventListener("touch", drawLine)
	canDraw = true
end
M.setupDraw = setupDraw

local function drawOn()
	canDraw = true
end
M.drawOn = drawOn

local function drawOff()
	canDraw = false
end
M.drawOff = drawOff

return M