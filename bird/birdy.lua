Birdy = {}

function Birdy:new(w, h)
	local rw = w * 0.035
	local rh = h * 0.05
	obj = {
		color = {100, 200, 20},
		size  = {rw, rh},
		x = w * .25,
		y = h * .5
	}

	self.__index = self
	return setmetatable(obj, self)
end

function Birdy:getBox()
	return {
		x = self.x,
		y = self.y,
		w = self.size[1],
		h = self.size[2]
	}
end

function Birdy:fall(dt)
	local h = love.graphics.getHeight()
	if self.y < h then
		self.y = self.y + 30 * dt
	end
end

function Birdy:flap()
	if self.y > 0 then
		self.y = self.y - 30.0
	end
end

function Birdy:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.rectangle('fill', self.x, self.y, unpack(self.size))
end

return Birdy
