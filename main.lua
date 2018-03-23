local Paddle = require 'paddle'
local Ball = require 'ball'

local vector = require "hump.vector"

local playerAction
local opponentAction

function love.load()
	love.window.setTitle("Poooooooooooooooooooooooooooooong!!!!!!")
	player = Paddle:new()
	opponent = Paddle:new{x = love.graphics.getWidth() - 35}
	
	ball = Ball:new{
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		velocity = vector.fromPolar(math.pi * (love.math.random() * 2), 100)
	}
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

	if love.keyboard.isDown('r') then
		love.load()
	end

	updatePlayer(dt)
	updateOpponent(dt)

	ball:move(dt)

	if haveCollided(player, ball) 
		and ball.velocity:angleTo(vector.fromPolar(math.pi * 1.5,10)) < math.abs(math.pi * 0.5) then
		
		ball:bounceOnLeftEdge(ball.velocity, dt)
	end

	if haveCollided(opponent, ball) 
		and ball.velocity:angleTo(vector.fromPolar(math.pi * 0.5,10)) < math.abs(math.pi * 0.5) then
		
		ball:bounceOnRightEdge(ball.velocity, dt)
	end

	if ball.y - ball.radius < 0 then
		ball:bounceOnTopEdge(ball.velocity, dt)
	end

	if ball.y + ball.radius > love.graphics.getHeight() then
		ball:bounceOnBottomEdge(ball.velocity, dt)
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

	return (math.abs(a.x - b.x) * 2 < (a.width + b.width)) and (math.abs(a.y - b.y) * 2 < (a.height + b.height));
end

function love.conf(t)
	t.console = true
end