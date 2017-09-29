Paddle = {
	x = 20,
	y = 300,
	width = 15,
	height = 120,
	speed = 80
}

function Paddle:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function Paddle:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:moveUp(dt)
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

function Paddle:getBBox()
	return {
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height
	}
end

return Paddle