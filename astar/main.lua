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

function norm1(myPos, tgtPos)
	return math.abs(tgtPos.x - myPos.x) + math.abs(tgtPos.y - myPos.y)
end

function score(currentNode, pos, tgtPos)
	local candidateNode = {}
	candidateNode.pos = pos
	dx = pos.x - currentNode.pos.x
	dy = pos.y - currentNode.pos.y
	candidateNode.G = currentNode.G + math.sqrt(dx * dx + dy * dy)
	candidateNode.H = norm1(pos, tgtPos)
	candidateNode.F = candidateNode.G + candidateNode.H
	return candidateNode
end

function isGoal(cdt, tgt)
	return cdt.x == tgt.x and cdt.y == tgt.y
end

function alreadyClosed(array, pos)
	local answer = false
	for _, node in ipairs(array) do
		if node.pos.x == pos.x and node.pos.y == pos.y then
			answer = true
			break
		end
	end
	return answer
end

function astar(myPos, tgtPos)
	local currentNode = { pos = myPos, G = 0, H = norm1(myPos, tgtPos), F = 0 }
	closed = {}
	opened = {}

	while currentNode and not isGoal(currentNode.pos, tgtPos) do
		-- Step 1 add neighbors
		for row = -1, 1, 1 do
			for col = -1, 1, 1 do
				pos = { x = currentNode.pos.x + col, y = currentNode.pos.y + row }
				if (col == 0 and row == 0) then
				elseif map[pos.y] and map[pos.y][pos.x] and map[pos.y][pos.x] == 1
					and not alreadyClosed(closed, pos)
				then
					scoredNode = score(currentNode, pos, tgtPos)
					scoredNode.parent = currentNode
					table.insert(opened, scoredNode)
				end
			end
		end

		-- Step 2 grab best score neighbor
		for index, node in ipairs(opened) do
			if min == nil or node.F <= min.F then
				min = node
				selectedIndex = index
			end
		end

		-- Step 3 iterate on neighbor
		table.insert(closed, currentNode)
		currentNode = min or nil
		foundPath = currentNode
		min = nil
		table.remove(opened, selectedIndex)
	end
	
end

function love.update()
	astar(cursor.pos, target.pos)
end

function love.draw()
	local edge=20
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
		for _, node in ipairs(closed) do
			love.graphics.setColor(160, 160, 0)
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
