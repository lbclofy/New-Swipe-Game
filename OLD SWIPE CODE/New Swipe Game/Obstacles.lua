Obstacles = {}

function Obstacles:newBlock( w, h, rotation)
	local group = display.newGroup()
	local shadowSnapshot = display.newSnapshot( 200, 200 )
	local rect = display.newRect( group, 0, 0, w, h )
	rect:setFillColor( 1,1,1 )
	local shadowRect = display.newRect( shadowSnapshot.group, 0, 0, w*1.02, h*1.02)--, 4 )
	shadowRect:setFillColor( 0,0,0,.25)
	shadowSnapshot.fill.effect = "filter.blurGaussian"
	shadowSnapshot.fill.effect.horizontal.blurSize = shadowBlur
	shadowSnapshot.fill.effect.vertical.blurSize = shadowBlur
	physics.addBody( group, "static", { density=3.0, friction=0.5, bounce=0.3 } )

	group:insert(shadowSnapshot)
	rect:toFront()
	return group
end

return Obstacles
