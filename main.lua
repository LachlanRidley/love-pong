local Paddle = require 'paddle'

local playerAction 

function love.load()
	player = Paddle:new()
end

function love.keypressed(key, unicode)
	if key == 'up' then
		playerAction = 'up'
	elseif key == 'down' then
		playerAction = 'down'
	end
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	else
		playerAction = ''
	end
end

function love.update(dt)
	if playerAction == 'up' then
		player:moveUp(dt)
	elseif playerAction == 'down' then
		player:moveDown(dt)
	end
end

function love.draw()
	player:draw()
end