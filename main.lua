local Paddle = require 'paddle'
local Ball = require 'ball'

local vector = require "hump.vector"

local player_action
local opponent_action

local state
local selected_menu_item = 0

local player_score = 0
local opponent_score = 0

function love.load()
	state = "menu"
	love.window.setTitle("Poooooooooooooooooooooooooooooong!!!!!!")
	-- startPong()
end

function startPong()
	player = Paddle:new()
	opponent = Paddle:new{x = love.graphics.getWidth() - 35}
	
	resetBall()
end

function resetBall()
	offset = math.pi * -0.25
	if love.math.random() > 0.5 then
		offset = math.pi * 0.75
	end

	ball = Ball:new{
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		velocity = vector.fromPolar(offset + math.pi * (love.math.random() * 0.5), 200)
	}
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)
	if state == "menu" then
		if love.keyboard.isDown('up') then
			selected_menu_item = selected_menu_item - 1
			if selected_menu_item < 0 then selected_menu_item = 0 end
		elseif love.keyboard.isDown('down') then
			selected_menu_item = selected_menu_item + 1
			if selected_menu_item > 1 then selected_menu_item = 1 end
		elseif love.keyboard.isDown('return') then
			if selected_menu_item == 0 then
				state = "game"
				startPong()
			elseif selected_menu_item == 1 then
				love.event.quit()
			end
		end
	elseif state == "game" then
		updateGame(dt)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)

	if state == "menu" then
		local font = love.graphics.newFont(14)
		love.graphics.setFont(font)

		love.graphics.setColor(1,1,1)
		love.graphics.print("Poooooooooooooooooooooooooooooong!!!!!!", 10, 20)

		if (selected_menu_item == 0) then
			love.graphics.setColor(0,1,0)
		else
			love.graphics.setColor(1,1,1)
		end

		love.graphics.print("Play", 10, 40)

		if (selected_menu_item == 1) then
			love.graphics.setColor(0,1,0)
		else
			love.graphics.setColor(1,1,1)
		end

		love.graphics.print("Quit", 10, 60)
	elseif state == "game" then
		drawGame()
	end
end

function updateGame(dt)
	if love.keyboard.isDown('up') then
		player_action = 'up'
	elseif love.keyboard.isDown('down') then
		player_action = 'down'
	end

	-- check if AI player needs to move
	if math.abs(ball.velocity:angleTo(vector(1,0))) < (math.pi * 0.5) then
		if opponent.y < ball.y then
			opponent_action = 'down'
		else
			opponent_action = 'up'
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
		opponent_score = opponent_score + 1

		if opponent_score >= 3 then
			love.window.showMessageBox("Poooooooooooooooooooooooooooooong", "You lose!", "info", true)
			state = "menu"
		end
	end

	-- check if ball has hit opponents's edge
	if ball.x > love.graphics.getWidth() then
		resetBall()
		player_score = player_score + 1

		if player_score >= 3 then
			love.window.showMessageBox("Poooooooooooooooooooooooooooooong", "You win!", "info", true)
			state = "menu"
		end
	end
end

function updatePlayer(dt)
	if player_action == 'up' then
		player:moveUp(dt)
	elseif player_action == 'down' then
		player:moveDown(dt)
	end

	player_action = ""
end

function updateOpponent(dt)
	if opponent_action == 'up' then
		opponent:moveUp(dt)
	elseif opponent_action == 'down' then
		opponent:moveDown(dt)
	end

	opponent_action = ""
end

function drawGame()
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