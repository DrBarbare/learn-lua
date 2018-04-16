require('astar')
-- Level
map=
{
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0},
	{0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0},
	{0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

-- Defaults position
cursor = { pos = { x = 2, y = 2} }
target = { pos = { x = 10, y = 10 } }


local function mapGen(width, height)
	map = {}
	for row = 1, height do
		map[row] = {}
		for col = 1, width do
			map[row][col] = love.math.random(0, 1)
		end
	end
end

function love.load()
	mapGen(100, 100)
end


function love.update()
	foundPath, closed, opened = AStar.findPath(map, cursor.pos, target.pos)
end

function love.draw()
	local edge=5
	for row = 1, #map do
		for col =1,#map[row] do
			if map[row][col] == 0 then
				love.graphics.setColor(160, 40, 80)
			elseif map[row][col] == 1 then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(0, 0, 0)
			end

			love.graphics.rectangle('fill', col*edge, row*edge, edge, edge)
		end
	end
	if closed then
		for _, node in pairs(closed) do
			love.graphics.setColor(160, 160, 0)
			love.graphics.rectangle('fill', node.pos.x * edge, node.pos.y * edge, edge, edge)
		end
	end
	if opened then
		for _, node in pairs(opened) do
			love.graphics.setColor(200, 200, 0)
			love.graphics.rectangle('fill', node.pos.x * edge, node.pos.y * edge, edge, edge)
		end
	end
	if foundPath then
		while foundPath.parent do
			love.graphics.setColor(200, 100, 0)
			love.graphics.rectangle('fill', foundPath.pos.x * edge, foundPath.pos.y * edge, edge, edge)
			foundPath = foundPath.parent
		end
	end
	if target.pos then
		love.graphics.setColor(60, 60, 160)
		love.graphics.rectangle('fill', target.pos.x * edge, target.pos.y * edge, edge, edge)
	end
	love.graphics.setColor(60, 160, 60)
	love.graphics.rectangle('fill', cursor.pos.x * edge, cursor.pos.y * edge, edge, edge)

	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), edge * (#map[1] + 2), 10)
end

function love.keypressed(key)
	if key == 'w' then cursor.pos.y = cursor.pos.y - 1
	elseif key == 's' then cursor.pos.y = cursor.pos.y + 1
	elseif key == 'a' then cursor.pos.x = cursor.pos.x - 1
	elseif key == 'd' then cursor.pos.x = cursor.pos.x + 1
	elseif key == 'space' then
		target.pos.x = cursor.pos.x
		target.pos.y = cursor.pos.y
	elseif key == 'q' or key == 'escape' then
		love.event.quit()
	end
end
