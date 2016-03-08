Obstacles = {}

function Obstacles:newBox( w, h, rotation)
	local boxRotate = rotation or 0

	--local boxGroup = display.newGroup()
	local box = display.newRect( 0, 0, w, h )
	box.rotation = boxRotate
	box:setFillColor(0,0,0)

	physics.addBody( box, "static", { density=1.0 , friction=0.5, bounce=0.3 } )

	return box
end

function Obstacles:newCircle(r)
	--local circleGroup = display.newGroup()
	local circle = display.newCircle( 0, 0, r )
	circle:setFillColor(0,0,0)

	physics.addBody( circle, "static", { density=1.0 , friction=0.5, bounce=0.3, radius = r } )

	return circle
end

function Obstacles:newPolygon( vertices )

	local polygon = display.newPolygon( 0, 0, vertices )
	polygon:setFillColor(0,0,0)

	physics.addBody( polygon, "static", { density=1.0 , friction=0.5, bounce=0.3, shape = vertices } )

	return polygon
end

function Obstacles:newBorder( w, h )

	--local boxGroup = display.newGroup()
	local border = display.newRect( 0, 0, w, h )
	border.rotation = boxRotate
	border:setFillColor(1,0,0)

	physics.addBody( border, "static", { density=1.0 , friction=0.5, bounce=0.3 } )

	local function onLocalCollision( self, event )
		
    	physics.pause()
	end
	border.collision = onLocalCollision
	border:addEventListener( "collision", border )

	return border
end

function Obstacles:newPegField(w, h, rotation)

	local pegSize = _H*.005
	local pegSpace = ballR*4
	local pegs = {}
	
	for i = 1, math.floor(h/pegSpace) do

		for j = 1, math.floor(w/pegSpace) do
			local pegIndex = i * math.floor(w/pegSpace) + j

			pegs[pegIndex] = display.newCircle( 0, 0, pegSize )

			pegs[pegIndex]:setFillColor(0,0,0)

			physics.addBody( pegs[pegIndex], "static", { density=1.0 , friction=0.5, bounce=0.3, radius = pegSize } )

			if (i%2 == 1) then
				pegs[pegIndex].x = j*pegSpace
			else
				pegs[pegIndex].x = j*pegSpace + .5*pegSpace
			end
			pegs[pegIndex].y = i*pegSpace

		end
	end

	return pegs
end

return Obstacles