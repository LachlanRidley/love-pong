local Paddle = require 'paddle'
local Ball = require 'ball'

local playerAction

function love.load()
	player = Paddle:new()
	ball = Ball:new()
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

	ball:move(dt)

	if haveCollided(player, ball) then
		ball:bounce()
	end
end

function love.draw()
	player:draw()
	ball:draw()
end

function haveCollided(object1, object2)
	local a = object1:getBBox()
	local b = object2:getBBox()

	return (math.abs(a.x - b.x) * 2 < (a.width + b.width)) and(math.abs(a.y - b.y) * 2 < (a.height + b.height));
end