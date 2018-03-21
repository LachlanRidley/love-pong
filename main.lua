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
	require("lovebird").update()

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

	if haveCollided(player, ball) then
		bounce(player, ball, false, dt)
		ball:move(dt)
	end

	if haveCollided(opponent, ball) then
		bounce(opponent, ball, true, dt)
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

function bounce(paddle, ball, reverse, dt)
	local diff = ball.y - paddle.y
	local newAngle = 180 * (diff / paddle.height)

	if reverse then
		newAngle = newAngle + 180
	end

	ball:bounce(newAngle, dt) 
end

function haveCollided(object1, object2)
	local a = object1:getBBox()
	local b = object2:getBBox()

	return (math.abs(a.x - b.x) * 2 < (a.width + b.width)) and (math.abs(a.y - b.y) * 2 < (a.height + b.height));
end

function love.conf(t)
	t.console = true
end