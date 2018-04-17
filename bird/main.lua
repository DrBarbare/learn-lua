require('birdy')
require('pipe')

function getWinMode()
	return {
	         love.graphics.getWidth(),
	         love.graphics.getHeight()
	       }
end

-- Initialize the body
function love.load()
	score = 0
	originalMode = getWinMode()

	-- White background
	love.graphics.setBackgroundColor(255, 255, 255, 255)
	birdy = Birdy:new(unpack(originalMode))
	pipes = { Pipe:new(originalMode[1], originalMode[2], 0.5) }
end

-- Events!
function love.keypressed(key)
	if key == 'space' or key == ' ' then
		birdy:flap()
	elseif key == 'q' or key == 'escape' then
		love.event.quit()
	end
end

-- We can control the resize
function love.resize(width, height)
	for p = 1, #pipes do
		pipes[p]:resize(originalMode[1], height)
	end
end

-- Game state update
function love.update(dt)
	birdy:fall(dt)

	for p = #pipes, 1, -1 do
		if pipes[p]:move(dt) < 0 then
			score = score + 1
			table.remove(pipes, p)
		elseif pipes[p]:colision(birdy) then
			score = score - 1
			table.remove(pipes, p)
		elseif pipes[p].x > love.graphics.getWidth() * 0.66 and  pipes[p].x < love.graphics.getWidth() * 0.66 + 30*dt then
			table.insert(pipes, Pipe:new(originalMode[1], love.graphics.getHeight()))
		end
	end
end

-- Drawing operations once stuff is handled
function love.draw()
	love.graphics.print("Score: " .. score, 20, 10)
	birdy:draw()
	for p = 1, #pipes do
		if pipes[p] then
			pipes[p]:draw()
		end
	end
end

