require 'jps'

function testSimple()
	local map={
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 }
	}

	local pathable = function(x, y)
		return map and y <= #map and map[y]
		       and x <= #map[y] and map[y][x] and map[y][x] == 1
	end

	local check = function(src, tgt, delta)
		-- print("Testing: " .. src.x .. "x" .. src.y .. " -> " .. tgt.x .. "x" .. tgt.y .. " [" .. delta.x .. "x" .. delta.y .. "]")
		local result = jump(pathable, src, delta, tgt)
		assert(result and result.pos.x == tgt.x  and result.pos.y == tgt.y)
	end
	print ">>> Horizontal"
	check({ x = 2, y = 3 }, { x = 5, y = 3 }, { x = 1,  y = 0 }) -- l -> r
	check({ x = 5, y = 3 }, { x = 2, y = 3 }, { x =-1,  y = 0 }) -- l <- r
	print ">>> Vertical"
	check({ x = 3, y = 1 }, { x = 3, y = 5 }, { x = 0,  y = 1 }) -- t -> d
	check({ x = 3, y = 5 }, { x = 3, y = 1 }, { x = 0,  y =-1 }) -- t <- d

	print ">>> Diagonal"
	check({ x = 2, y = 1 }, { x = 5, y = 4 }, { x = 1,  y = 1 }) -- tl -> br
	check({ x = 5, y = 4 }, { x = 2, y = 1 }, { x =-1,  y =-1 }) -- br -> tl
	check({ x = 5, y = 1 }, { x = 2, y = 4 }, { x =-1,  y = 1 }) -- tr -> bl
	check({ x = 2, y = 4 }, { x = 5, y = 1 }, { x = 1,  y =-1 }) -- bl -> tr

end

function testSimpleWithStop()
	local map={
		{ 1, 1, 1, 1, 1, },
		{ 1, 1, 1, 1, 1, },
		{ 1, 1, 0, 1, 1, },
		{ 1, 1, 1, 1, 1, },
		{ 1, 1, 1, 1, 1, }
	}

	local pathable = function(x, y)
		return map and y <= #map and map[y]
		       and x <= #map[y] and map[y][x] and map[y][x] == 1
	end

	local check = function(src, tgt, delta, expectedPos)
		print("Testing: " .. src.x .. "x" .. src.y .. " -> " .. tgt.x .. "x" .. tgt.y .. " [" .. delta.x .. "x" .. delta.y .. "]")
		local result = jump(pathable, src, delta, tgt)
		if result then
			print("Result {" .. result.pos.x .. "x" .. result.pos.y .. "}")
		else
			print("No result")
		end
		assert(result and result.pos.x == expectedPos.x  and result.pos.y == expectedPos.y)
	end
	print ">>> Horizontal"
	--check({ x = 2, y = 3 }, { x = 5, y = 3 }, { x = 1,  y = 0 }, { x = 3, y = 2 }) -- l -> r
	check({ x = 2, y = 2 }, { x = 5, y = 2 }, { x = 1,  y = 0 }, { x = 4, y = 3 }) -- l -> r
	check({ x = 2, y = 4 }, { x = 5, y = 4 }, { x = 1,  y = 0 }, { x = 4, y = 3 }) -- l -> r
	--check({ x = 5, y = 3 }, { x = 2, y = 3 }, { x =-1,  y = 0 }) -- l <- r
	check({ x = 5, y = 2 }, { x = 2, y = 2 }, { x =-1,  y = 0 }, { x = 2, y = 3 }) -- l <- r
	check({ x = 5, y = 4 }, { x = 2, y = 4 }, { x =-1,  y = 0 }, { x = 2, y = 3 }) -- l <- r
	print ">>> Vertical"
	--check({ x = 3, y = 1 }, { x = 3, y = 5 }, { x = 0,  y = 1 }) -- t -> d
	check({ x = 2, y = 2 }, { x = 2, y = 4 }, { x = 0,  y = 1 }, { x = 3, y = 4 }) -- l -> r
	check({ x = 4, y = 2 }, { x = 4, y = 4 }, { x = 0,  y = 1 }, { x = 3, y = 4 }) -- l -> r
	--check({ x = 3, y = 5 }, { x = 3, y = 1 }, { x = 0,  y =-1 }) -- t <- d
	check({ x = 2, y = 4 }, { x = 2, y = 2 }, { x = 0,  y =-1 }, { x = 3, y = 2 }) -- l <- r
	check({ x = 4, y = 4 }, { x = 4, y = 2 }, { x = 0,  y =-1 }, { x = 3, y = 2 }) -- l <- r

	print ">>> Diagonal"
	check({ x = 1, y = 2 }, { x = 4, y = 5 }, { x = 1,  y = 1 }, { x = 4, y = 3 })
	check({ x = 4, y = 5 }, { x = 1, y = 2 }, { x =-1,  y =-1 }, { x = 3, y = 2 })
	check({ x = 2, y = 1 }, { x = 5, y = 4 }, { x = 1,  y = 1 }, { x = 3, y = 4 })
	check({ x = 5, y = 4 }, { x = 2, y = 1 }, { x =-1,  y =-1 }, { x = 2, y = 3 })

	check({ x = 2, y = 5 }, { x = 5, y = 2 }, { x = 1,  y =-1 }, { x = 3, y = 2 })
	check({ x = 5, y = 2 }, { x = 2, y = 5 }, { x =-1,  y = 1 }, { x = 2, y = 3 })

	check({ x = 1, y = 4 }, { x = 4, y = 1 }, { x = 1,  y =-1 }, { x = 4, y = 3 })
	check({ x = 4, y = 1 }, { x = 1, y = 4 }, { x =-1,  y = 1 }, { x = 3, y = 4 })
	--check({ x = 2, y = 1 }, { x = 5, y = 4 }, { x = 1,  y = 1 }) -- tl -> br
	--check({ x = 5, y = 4 }, { x = 2, y = 1 }, { x =-1,  y =-1 }) -- br -> tl
	--check({ x = 5, y = 1 }, { x = 2, y = 4 }, { x =-1,  y = 1 }) -- tr -> bl
	--check({ x = 2, y = 4 }, { x = 5, y = 1 }, { x = 1,  y =-1 }) -- bl -> tr

end

function love.keypressed(key)
	love.event.quit()
end

function love.load()
	print("=========================================\n >>>>>>>>> Simple test \n ==============================================")
	testSimple()
	print("=========================================\n >>>>>>>>> Simple test With stop \n ==============================================")
	testSimpleWithStop()
end


function love.draw()
	love.graphics.print("Hello", 50, 10)
end
