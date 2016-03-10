local M = {}

local physics = require("physics")

local d1 = {}
local dSum1 = 0

local canDraw = false

local drawGroup


local linePath = {}
local lineCount = 1
local lineCoords = {xOld = nil, yOld = nil}

local function angleBetween(x1,y1,x2,y2)
		return math.ceil(math.atan2((y2-y1),(x2-x1))*180*math.pi^-1)+90
end

local function distanceBetween(x1,y1,x2,y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

local function drawLine( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	print("attempting to draw")

	if canDraw == true then
		if "began" == phase then

			event.isFocus = true	
			linePath[#linePath+1]=display.newCircle( event.x ,event.y,ballR)
			drawGroup:insert(linePath[lineCount])
			physics.addBody( linePath[#linePath], "static", { density=0, friction=0, bounce=0, radius=ballR} )
			linePath[lineCount].name="path"
			linePath[lineCount].dist = ballR*2
			lineCount = lineCount + 1
			lineCoords.xOld, lineCoords.yOld = event.x, event.y

		elseif "moved" == phase then

			linePath[#linePath+1]=display.newCircle( event.x ,event.y,ballR)
			drawGroup:insert(linePath[#linePath])
			physics.addBody( linePath[#linePath], "static", { density=0, friction=0, bounce=0, radius=ballR} )
			linePath[#linePath].name="path"
			linePath[#linePath].dist = ballR*2
			lineCount = lineCount + 1

		if lineCoords.xOld ~=nil then
			linePath[lineCount]=display.newLine(event.x, event.y, lineCoords.xOld, lineCoords.yOld)
			drawGroup:insert(linePath[lineCount]) -- Make a new path line
			linePath[lineCount].strokeWidth=ballR*2
			linePath[lineCount].name="path"
			linePath[lineCount].dist = distanceBetween(event.x, event.y, lineCoords.xOld, lineCoords.yOld)

			local angle = angleBetween(0,0 ,lineCoords.xOld-event.x, lineCoords.yOld-event.y)
			angle=math.rad(angle)
			local rectShape={
			math.cos(angle)*ballR,math.sin(angle)*ballR ,
			-math.cos(angle)*ballR,-math.sin(angle)*ballR,
			lineCoords.xOld-event.x-math.cos(angle)*ballR, lineCoords.yOld-event.y-math.sin(angle)*ballR,
			lineCoords.xOld-event.x+math.cos(angle)*ballR, lineCoords.yOld-event.y+math.sin(angle)*ballR}

			physics.addBody( linePath[lineCount], "static", { density=0, friction=0, bounce=0, shape = rectShape} )
		end
			lineCoords.xOld, lineCoords.yOld = event.x, event.y
			lineCount = lineCount + 1

		elseif "ended" == phase or "cancelled" == phase then
			event.isFocus = false	
			canDraw = false	

		end
	end

	return true
end

local function setupDraw(group)
	drawGroup = group
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