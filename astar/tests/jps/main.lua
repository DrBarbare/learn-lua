require '../jps'

function testHorizontal()
	local map={
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 },
		{ 1, 1, 1, 1, 1, 1 }
	}

	local pathable = function(x, y)
		local answer = false
		if not map then
--			print "No Map"
		elseif not map[y] then
--			print("No Row #" .. y .. "/" .. #map)
		elseif not map[y][x] then
--			print("No col #" .. x .. "/" .. #map[y])
		elseif map[y][x] == 1 then
			answer = true
		else
--			print("Not a pathable value: " .. map[y][x])
		end
		return answer
	end

	local check = function(src, tgt, delta)
		print("Testing: " .. src.x .. "x" .. src.y .. " -> " .. tgt.x .. "x" .. tgt.y .. " [" .. delta.x .. "x" .. delta.y .. "]")
		local result = jump(pathable, src, delta, tgt)
		--if result then
		--	print("Result: " .. result.pos.x .. "x" .. result.pos.y .. " expected " .. tgt.x .. "x" .. tgt.y)
		--else
		--	print ("No result")
		--end
		assert(result and result.pos.x == tgt.x  and result.pos.y == tgt.y)
	end
	-- Horizontal
	check({ x = 2, y = 3 }, { x = 5, y = 3 }, { x = 1,  y = 0 }) -- l -> r
	check({ x = 5, y = 3 }, { x = 2, y = 3 }, { x =-1,  y = 0 }) -- l <- r
	-- Vertical
	check({ x = 3, y = 1 }, { x = 3, y = 5 }, { x = 0,  y = 1 }) -- t -> d
	check({ x = 3, y = 5 }, { x = 3, y = 1 }, { x = 0,  y =-1 }) -- t <- d

end

function love.keypressed(key)
	love.event.quit()
end

function love.load()
	testHorizontal()
end


function love.draw()
	love.graphics.print("Hello", 50, 10)
end
