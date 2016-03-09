local M = {}

display.setStatusBar( display.HiddenStatusBar )
system.setIdleTimer( enabled )




-- for calculations
_G.pi = math.pi
_G.sin = math.sin
_G.cos = math.cos
_G.atan2 = math.atan2
_G.mRand = math.random

-- for screensize
_G.centerX = display.contentCenterX
_G.centerY = display.contentCenterY
_G._W = display.contentWidth
_G._H = display.contentHeight


_G.ballR = _W/70

_G.topLeft = {
	x = (display.contentWidth - display.viewableContentWidth) / 2, 
	y = (display.contentHeight - display.viewableContentHeight) / 2}
	
_G.bottomRight = {
	x = topLeft.x + display.viewableContentWidth, 
	y = topLeft.y + display.viewableContentHeight}
	
_G.brickVelocity = 
					{	25,160, --1
						30,130, --3
						35,112, --5
						40,97, --7
						45,89, --9
						50,79,	--11
						55,71,	--13
						60,67,	--15
						65,61,	--17
						70,57,	--19
						75,53,	--21
						80,49,	--23
						85,46,	--25
						90,41,	--27
						95,40,	--29
						100,39,	--31
						110,35,	--33
						120,33,	--35
						130,29,	--37
						140,27,	--39
						150,25,	--41
						160,49,	--43
						170,46,	--45
						180,43,	--37
						190,40,	--39
						200,38,	--41
						220,35,	--43
						240,32,	--45
						260,30,	--47
						280,28,	--49
						300,25,	--51
						320,24,	--53
						340,23,	--55
						360,21,	--57
						380,20,	--59
						400,19,	--61
						425,	-------FIll LATER
						450,
						475,
						500,
						550,
						600,
						675,
						775,	}



local function distanceBetween(x1,y1,x2,y2)
	
		local X = x1-x2
		local Y = y1-y2
		local d=(X*X+Y*Y)^(.5)
		return d
end
M.distanceBetween = distanceBetween

local function angleBetween(x1,y1,x2,y2)

		local angle = math.ceil(atan2((y2-y1),(x2-x1))*180*pi^-1)+90
		return angle
end
M.angleBetween = angleBetween

local function midPoint(x1,y1,x2,y2)
	
		local array = {}
		local X = (x1+x2)/2
		local Y = (y1+y2)/2
		return X,Y
end
M.midPoint = midPoint

local function angleBetweenVector(xf,yf,xm,ym,xl,yl)
	local vector1X = xf - xm
	local vector1Y = yf - ym
	local vector2X = xm - xl
	local vector2Y = ym - yl
	local vector1 = (vector1X*vector1X + vector1Y*vector1Y)^(.5)
	local vector2 = (vector2X*vector2X + vector2Y*vector2Y)^(.5)
end
M.angleBetweenVector = angleBetweenVector


return M