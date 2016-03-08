PlayObjects = {}

function PlayObjects:newBall( )

	local ballGroup = display.newGroup()
	ballGroup.type = "gameBall"
	local ball = display.newCircle( ballGroup, 0, 0, ballR )
	ball:setFillColor(0,0,0)

	physics.addBody( ballGroup, { density=1.0 , friction=0.5, bounce=0.6, radius = ballR } )

	return ballGroup
end

function PlayObjects:newGoal()
	local goalGroup = display.newGroup()
	local goal = display.newCircle( goalGroup, 0, 0, ballR*2.5 )
	goal:setFillColor(1,0,0)

	physics.addBody( goalGroup, "static", { density=1.0 , friction=0.5, bounce=0.3, radius = r } )
	goalGroup.isSensor = true

	return goalGroup
end


return PlayObjects