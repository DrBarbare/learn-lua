local function orientation(delta)
	local ori = nil
	-- Straight
	if     delta.x == 0 and delta.y > 0 then ori = 'S'
	elseif delta.x == 0 and delta.y < 0 then ori = 'N'
	elseif delta.y == 0 and delta.x > 0 then ori = 'E'
	elseif delta.y == 0 and delta.x < 0 then ori = 'W'

	-- Diagonal
	elseif delta.y > 0 and delta.x < 0 then ori = 'SW'
	elseif delta.y > 0 and delta.x > 0 then ori = 'SE'
	elseif delta.y < 0 and delta.x < 0 then ori = 'NW'
	elseif delta.y < 0 and delta.x > 0 then ori = 'NE'
	end
	return ori
end

local permutation = {
	-- Straight
	['E'] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	['N'] = { 7, 4, 1, 8, 5, 2, 9, 6, 3 },
	['W'] = { 9, 8, 7, 6, 5, 4, 3, 2, 1 },
	['S'] = { 3, 6, 9, 2, 5, 8, 1, 4, 7 },
	-- Diagonal
	['SE'] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }, --NE
	['NE'] = { 7, 4, 1, 8, 5, 2, 9, 6, 3 }, --SE
	['NW'] = { 9, 8, 7, 6, 5, 4, 3, 2, 1 }, --SW
	['SW'] = { 3, 6, 9, 2, 5, 8, 1, 4, 7 }  --NW
}

-- List of orientation OUT of the box
local neighborDelta = {
	{x=-1,y=-1 }, -- NW
	{x= 0,y=-1 }, -- N
	{x= 1,y=-1 }, -- NE
	{x=-1,y= 0 }, -- W
	{x= 0,y= 0 }, -- Center
	{x= 1,y= 0 }, -- E
	{x=-1,y= 1 }, -- SW
	{x= 0,y= 1 }, -- S
	{x= 1,y= 1 }, -- SE
}

-- List of orientations IN the box
local deltas = {
	-- Straight
	['N'] = {x= 0,y=-1 },
	['S'] = {x= 0,y= 1 },
	['E'] = {x= 1,y= 0 },
	['W'] = {x=-1,y= 0 },
	-- Diagonal
	['NE'] = {x= 1,y=-1 },
	['NW'] = {x=-1,y=-1 },
	['SE'] = {x= 1,y= 1 },
	['SW'] = {x=-1,y= 1 }
}

local function isGoal(cdt, tgt)
	return cdt.x == tgt.x and cdt.y == tgt.y
end

local function nextPointExpanded(current, delta)
	local nxt = {
		pos = {
			x = current.pos.x + delta.x,
			y = current.pos.y + delta.y
		},
		parent = current
	}
	return nxt
end

local function forcedNeighbor(pathable, current, ori, tgtPos)
	local orilen = string.len(ori) -- Straight has one letter, diagonal has 2

	local permu  = permutation[ori]
	local pathableNeightbor = function(index)
		local c = nextPointExpanded(current, neighborDelta[permu[index]]).pos
		return pathable(c.x, c.y)
	end

	-- Diagonal case
	-- \ 2 3
	-- 4 X 6
	-- 7 8 9
	if orilen == 2 then
		if not pathableNeightbor(2) or not pathableNeightbor(4) then
			return current
		elseif jump(pathable, current, deltas[ string.sub(ori, 1, 1) ], tgtPos)
			or jump(pathable, current, deltas[ string.sub(ori, 2, 2) ], tgtPos) then
			return current
		else
			return nil
		end


	-- Straight case
	-- 1 2 3
	-- - X 6
	-- 7 8 9
	else
		if not pathableNeightbor(2) or not pathableNeightbor(8) then return current
		else return nil
		end
	end
end

jump = function(pathable, current, delta, tgtPos)
	local nxt = nextPointExpanded(current, delta)

	if not pathable(nxt.pos.x, nxt.pos.y) then return nil end
	if isGoal(nxt.pos, tgtPos) then return nxt end

	-- Retrive orientation
	local ori = orientation(delta)
	return forcedNeighbor(pathable, nxt, ori, tgtPos)
	       or jump(pathable, nxt, delta, tgtPos)	
end

return jump
