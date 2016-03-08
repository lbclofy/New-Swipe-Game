PlayObjects = {}

local composer = require( "composer" )

function PlayObjects:newBall( )

	local ball = display.newCircle(  0, 0, ballR )
	ball:setFillColor(0,0,0)
	ball.type = "ball"

	physics.addBody( ball, { density=1.0 , friction=0.5, bounce=0.6, radius = ballR } )


	return ball
end

function PlayObjects:newStar( )


	local vertices = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }

	local star = display.newPolygon( 0, 0, vertices )
	star:setFillColor(0,0,0)
	star.type = "star"

	physics.addBody( star, "static", { density=1.0 , friction=0.5, bounce=0.6, radius = ballR } )
	star.isSensor = true


	return star
end

function PlayObjects:newGoal()
	local goalRadius = ballR*2.5
	local goal = display.newCircle( 0, 0, goalRadius )
	goal:setFillColor(1,0,0)
	goal.type = "goal"

	physics.addBody( goal, "static", { density=1.0 , friction=0.5, bounce=0.3, radius = goalRadius } )
	goal.isSensor = true

	local function onLocalCollision( self, event )
    	print( event.target )        --the first object in the collision
    	print( event.other )         --the second object in the collision
    	print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    	print( event.otherElement )  --the element (number) of the second object which was hit in the collision
  		composer.gotoScene( "levels.levelintermission" )
    	physics.pause()
	end
	goal.collision = onLocalCollision
	goal:addEventListener( "collision", goal )

	return goal
end


return PlayObjects