local Paddle = require 'paddle'
local Ball = require 'ball'

local playerAction
local opponentAction

function love.load()
	love.window.setTitle("Poooooooooooooooooooooooooooooong!!!!!!")
	player = Paddle:new()
	opponent = Paddle:new{x = love.graphics.getWidth() - 35}
	ball = Ball:new{x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2}
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	if love.keyboard.isDown('a') then
		playerAction = 'up'
	elseif love.keyboard.isDown('z') then
		playerAction = 'down'
	end

	if love.keyboard.isDown('up') then
		opponentAction = 'up'
	elseif love.keyboard.isDown('down') then
		opponentAction = 'down'
	end

	updatePlayer(dt)
	updateOpponent(dt)

	ball:move(dt)

	if haveCollided(player, ball) or haveCollided(opponent, ball) then
		ball:bounce()
		ball:move(dt)
	end
end

function updatePlayer(dt)
	if playerAction == 'up' then
		player:moveUp(dt)
	elseif playerAction == 'down' then
		player:moveDown(dt)
	end

	playerAction = ""
end

function updateOpponent(dt)
	if opponentAction == 'up' then
		opponent:moveUp(dt)
	elseif opponentAction == 'down' then
		opponent:moveDown(dt)
	end

	opponentAction = ""
end

function love.draw()
	player:draw()
	opponent:draw()
	ball:draw()
end

function haveCollided(object1, object2)
	local a = object1:getBBox()
	local b = object2:getBBox()

	return (math.abs(a.x - b.x) * 2 < (a.width + b.width)) and(math.abs(a.y - b.y) * 2 < (a.height + b.height));
end