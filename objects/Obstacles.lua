Obstacles = {}

local composer = require( "composer" )

function Obstacles:newBox( type, rotation)
	local boxRotate = rotation or 0
	local w,h

    if     type == 1 then w,h = ballR*6, ballR*6
    elseif type == 2 then w,h = ballR*6, ballR*6*phi
    elseif type == 3 then w,h = ballR, ballR*6*phi
    else                 print("blah")
    end


	--local boxGroup = display.newGroup()
	local box = display.newRect( 0, 0, w, h )
	box.rotation = boxRotate
	box:setFillColor(0,0,0)

	physics.addBody( box, "static", { density=1.0 , friction=0, bounce=1 } )

	return box
end

function Obstacles:newCircle(r)
	--local circleGroup = display.newGroup()
	local circle = display.newCircle( 0, 0, r )
	circle:setFillColor(0,0,0)

	physics.addBody( circle, "static", { density=1.0 , friction=0, bounce=1,  radius = r } )

	return circle
end

function Obstacles:newPolygon( vertices )

	local polygon = display.newPolygon( 0, 0, vertices )
	polygon:setFillColor(0,0,0)

	physics.addBody( polygon, "static", { density=1.0 , friction=0, bounce=1,  shape = vertices } )

	return polygon
end

function Obstacles:newBorder( w, h )

	--local boxGroup = display.newGroup()
	local border = display.newRect( 0, 0, w, h )
	border.rotation = boxRotate
	border:setFillColor(1,0,0)

	physics.addBody( border, "static", { density=1.0 , friction=0, bounce=1  } )
	border.isSensor = true



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

			physics.addBody( pegs[pegIndex], "static", { density=1.0 , friction=0, bounce=1,  radius = pegSize } )

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