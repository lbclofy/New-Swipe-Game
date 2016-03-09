GameBall = {}

local function onLocalCollision( self, event )
    print( event.target )        --the first object in the collision
    print( event.other )         --the second object in the collision
    print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    print( event.otherElement )  --the element (number) of the second object which was hit in the collision
end


function GameBall:newGameBall( )
	local group = display.newGroup()
	local shadowSnapshot = display.newSnapshot( ballR*1.5*2, ballR*1.5*2 )
	local rect = display.newCircle( group, 0, 0, ballR )
	rect:setFillColor( 1,1,1)
	local shadowRect = display.newCircle( shadowSnapshot.group, 0, 0, ballR*1.02 )
	shadowRect:setFillColor( 0,0,0)
	shadowSnapshot.fill.effect = "filter.blurGaussian"
	shadowSnapshot.fill.effect.horizontal.blurSize = shadowBlur
	shadowSnapshot.fill.effect.vertical.blurSize = shadowBlur
	physics.addBody( group, { density=3.0, friction=0.5, bounce=0.3 , radius = ballR} )

	group.collision = onLocalCollision
	group:addEventListener( "collision", group )

	group:insert(shadowSnapshot)
	rect:toFront()
	return group
end

return GameBall
