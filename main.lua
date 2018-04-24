local Paddle = require 'paddle'
local Ball = require 'ball'

local vector = require "hump.vector"

local playerAction
local opponentAction

local player_score = 0
local opponent_score = 0

function love.load()
	love.window.setTitle("Poooooooooooooooooooooooooooooong!!!!!!")
	player = Paddle:new()
	opponent = Paddle:new{x = love.graphics.getWidth() - 35}
	
	resetBall()
end

function resetBall()
	ball = Ball:new{
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		velocity = vector.fromPolar(math.pi * (love.math.random() * 2), 200)
	}
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	love.graphics.setBackgroundColor(0,0,0)

	if love.keyboard.isDown('up') then
		playerAction = 'up'
	elseif love.keyboard.isDown('down') then
		playerAction = 'down'
	end

	-- check if AI player needs to move
	if math.abs(ball.velocity:angleTo(vector(1,0))) < (math.pi * 0.5) then
		if opponent.y < ball.y then
			opponentAction = 'down'
		else
			opponentAction = 'up'
		end
	end

	-- reload when press r
	if love.keyboard.isDown('r') then
		love.load()
	end

	-- update paddles
	updatePlayer(dt)
	updateOpponent(dt)

	ball:move(dt)

	-- check collisions between player and ball
	if haveCollided(player, ball) 
		and math.abs(ball.velocity:angleTo(vector.fromPolar(math.pi * 1.5,10))) < math.pi * 0.5 then
		
		ball:bounceOnLeftEdge(ball.velocity, dt)
	end

	-- check collisions between opponent and ball	
	if haveCollided(opponent, ball) 
		and math.abs(ball.velocity:angleTo(vector.fromPolar(math.pi * 0.5,10))) < math.pi * 0.5 then
		
		ball:bounceOnRightEdge(ball.velocity, dt)
	end

	-- bounce ball off top edge
	if ball.y - ball.radius < 0 then
		ball:bounceOnTopEdge(ball.velocity, dt)
	end

	-- bounce ball off bottom edge
	if ball.y + ball.radius > love.graphics.getHeight() then
		ball:bounceOnBottomEdge(ball.velocity, dt)
	end

	-- check if ball has hit player's edge
	if ball.x < 0 then
		resetBall()
		
		-- add point to opponent score
		opponent_score = opponent_score + 1
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
	-- print score
	local text = tostring(player_score) .. " - " .. tostring(opponent_score)
	local font = love.graphics.newFont(20)
	local text_width = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print(text, love.graphics.getWidth() / 2 - text_width / 2, 10 )

	player:draw()
	opponent:draw()
	ball:draw()
end

function haveCollided(object1, object2)
	local a = object1:getBBox()
	local b = object2:getBBox()

	return (math.abs(a.x - b.x) * 2 < (a.width + b.width))
		   and (math.abs(a.y - b.y) * 2 < (a.height + b.height));
end

function love.conf(t)
	t.console = true
end