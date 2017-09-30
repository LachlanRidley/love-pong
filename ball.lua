Ball = {
	x = 300,
	y = 300,
	radius = 10,
	speed = 160,
	direction = -1
}

function Ball:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Ball:draw()
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:move(dt)
	self.x = self.x + self.direction * (self.speed * dt)
end

function Ball:bounce()
	self.direction = self.direction * -1
end

function Ball:getBBox()
	return {
		x = self.x - self.radius,
		y = self.y - self.radius,
		width = self.radius * 2,
		height = self.radius * 2
	}
end

--[[function Paddle:moveUp(dt)
	self.y = self.y - (self.speed * dt)
	self:checkLimits();
end

function Paddle:moveDown(dt)
	self.y = self.y + (self.speed * dt)
	self:checkLimits();
end

function Paddle:checkLimits()
	local windowHeight = love.graphics.getHeight()
	if self.y < 0 then
		self.y = 0
	elseif (self.y + self.height) > windowHeight then
		self.y = windowHeight - self.height
	end
end
--]]
return Ball