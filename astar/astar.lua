AStar = {}

-- Norm1
local function heuristic(myPos, tgtPos)
	local dx = math.abs(tgtPos.x - myPos.x)
	local dy = math.abs(tgtPos.y - myPos.y)
	local norm1 = dx + dy
	-- octile heuristic (Linf), better for 6 movement
	return norm1 + (math.sqrt(2) - 2) * math.min(dx, dy)
	-- Manathan heuristic (L1), better if only 4 movement
	-- return norm1
end

local function score(currentNode, pos, tgtPos)
	local candidateNode = {}
	candidateNode.pos = pos
	dx = pos.x - currentNode.pos.x
	dy = pos.y - currentNode.pos.y
	candidateNode.G = currentNode.G + math.sqrt(dx * dx + dy * dy)
	candidateNode.H = heuristic(pos, tgtPos)
	candidateNode.F = candidateNode.G + candidateNode.H
	return candidateNode
end

local function isGoal(cdt, tgt)
	return cdt.x == tgt.x and cdt.y == tgt.y
end

local function alreadyClosed(array, pos)
	local answer = false
	for _, node in ipairs(array) do
		if node.pos.x == pos.x and node.pos.y == pos.y then
			answer = true
			break
		end
	end
	return answer
end

local function pathable(map, x, y)
	return map[y] and map[y][x] and map[y][x] == 1
end

function AStar.findPath(map, myPos, tgtPos)
	local currentNode = { pos = myPos, G = 0, H = heuristic(myPos, tgtPos), F = 0, key = myPos.x .. ":" .. myPos.y}
	closed = {}
	opened = {currentNode}
	reachableGoal = pathable(map, tgtPos.x, tgtPos.y)
	while reachableGoal and currentNode and not isGoal(currentNode.pos, tgtPos) do
		-- Step 1 add neighbors
		for row = -1, 1, 1 do
			for col = -1, 1, 1 do
				pos = { x = currentNode.pos.x + col, y = currentNode.pos.y + row }
				local idx = pos.x .. ':' .. pos.y
				if  not (col == 0 and row == 0)
					and pathable(map, pos.x, pos.y)
					and not closed[idx]
					and not opened[idx]
				then
					scoredNode = score(currentNode, pos, tgtPos)
					scoredNode.parent = currentNode

					-- insert if nil
					opened[idx] = scoredNode
				end
			end
		end

		-- Step 2 grab best score neighbor
		for key, node in pairs(opened) do
			if not min or node.F <= min.F then
				min = node
				min.key = key
			end
		end

		-- Step 3 iterate on neighbor
		if not closed[currentNode.key] then
			closed[currentNode.key] = currentNode
		end

		foundPath = currentNode
		currentNode = min
		if min then
			opened[min.key] = nil
			min = nil
		end
	end

	return foundPath, closed, opened
	
end

return AStar
