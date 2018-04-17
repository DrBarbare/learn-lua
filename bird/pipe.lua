Pipe = {}

function Pipe:new(width, height, arg_u)
	-- Find the percentage to dig the hole
	local base = height * 0.2 + 10
	local top = height * 0.8 - 10
	local ran = love.math.random(base, top)
	local u = ran / height
	print(height .. " " .. base .. " " .. top .. " " .. ran .. " " .. u)
	if arg_u then
		u = arg_u
	end
	print("W: " .. width .. ", H: " .. height .. ", u: " .. u)

	-- Create a dummy object, and populate it later
	obj = {
		color = {20, 20, 150},
		x = width,        -- Where the columns start appearing
		w = width  * .06, -- The (constant) width of the columns
		up_bounds = {     -- Dimension of the upper beam:
			y = 0,        --  Where does it start
			h = 0         --  How long it is
		},
		low_bounds = {    -- Dimension of the lower beam:
			y = 0,        --  Where does it start
			h = 0         --  How long it is
		},
		hole_pos = u
	}

	-- Polulates
	Pipe.resize(obj, width, height)

	self.__index = self
	return setmetatable(obj, self)
end

function Pipe:resize(width, height)
	-- Take half of the screen height
	local gh_top = height * (1 - self.hole_pos)
	local gh_bot = height * self.hole_pos

	-- Compute the size of the hole
	local oh = height * 0.2

	-- Compute how much of the half beams to cut down
	local up_oh = oh * self.hole_pos
	local dw_oh = oh * (1 - self.hole_pos)

	-- Compute the beams new height
	local upper_height = gh_top - up_oh
	local lower_height = gh_bot - dw_oh

	self.up_bounds.h = upper_height
	self.low_bounds.y = upper_height + oh
	self.low_bounds.h = lower_height
end

function Pipe:inBeamColumn(x)
	return x > self.x and x < self.x + self.w
end

function Pipe:inTopBeam(x, y)
	return self.up_bounds.y < y and y < self.up_bounds.y + self.up_bounds.h
	       and self:inBeamColumn(x)
end

function Pipe:inBotBeam(x, y)
	return self.low_bounds.y < y and y < self.low_bounds.y + self.low_bounds.h
	       and self:inBeamColumn(x)
end

function Pipe:colision(b)
	local answer = false
	if b.getBox then
		local box = b:getBox() -- x, y, w, h
		local points = {{box.x, box.y},
		                {box.x + box.w, box.y},
		                {box.x, box.y + box.h},
		                {box.x + box.w, box.y + box.h}}
		for i = 1, #points do
			if self:inTopBeam(unpack(points[i])) or self:inBotBeam(unpack(points[i])) then
				answer = true
				break
			end
		end
	else
		print("This bird has no 'getBox' function")
	end
	return answer
end

function Pipe:move(dt)
	self.x = self.x - 60 * dt
	return self.x
end

function Pipe:draw()
	love.graphics.setColor(unpack(self.color))

	-- Upper pipe
	love.graphics.rectangle('fill',
	                        self.x, self.up_bounds.y,
	                        self.w, self.up_bounds.h)

	love.graphics.setColor(200, 100, 100)
	-- Lower pipe
	love.graphics.rectangle('fill',
	                        self.x, self.low_bounds.y,
	                        self.w, self.low_bounds.h)
end

return Pipe
